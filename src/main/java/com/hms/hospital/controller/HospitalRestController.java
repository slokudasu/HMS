package com.hms.hospital.controller;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import com.hms.hospital.entity.HospitalAppointment;
import com.hms.hospital.entity.HospitalDoctor;
import com.hms.hospital.entity.HospitalPatient;
import com.hms.hospital.repository.HospitalAppointmentRepository;
import com.hms.hospital.repository.HospitalDoctorRepository;
import com.hms.hospital.repository.HospitalPatientRepository;

@RestController
@RequestMapping("/api/hospital")
public class HospitalRestController {

    private static final DateTimeFormatter INPUT_DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
    private static final DateTimeFormatter INPUT_DATE_FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE;
    private static final Set<String> VALID_STATUSES = Set.of(
            HospitalAppointment.STATUS_SCHEDULED,
            HospitalAppointment.STATUS_COMPLETED,
            HospitalAppointment.STATUS_CANCELLED);

    @Autowired
    private HospitalDoctorRepository doctorRepository;

    @Autowired
    private HospitalPatientRepository patientRepository;

    @Autowired
    private HospitalAppointmentRepository appointmentRepository;

    @GetMapping("/dashboard")
    public DashboardResponse dashboard() {
        LocalDate today = LocalDate.now();
        LocalDateTime dayStart = today.atStartOfDay();
        LocalDateTime dayEnd = dayStart.plusDays(1);

        return new DashboardResponse(
                doctorRepository.count(),
                patientRepository.count(),
                appointmentRepository.countByAppointmentDateTimeBetween(dayStart, dayEnd),
                appointmentRepository.countByStatus(HospitalAppointment.STATUS_SCHEDULED));
    }

    @GetMapping("/doctors")
    public List<HospitalDoctor> doctors() {
        return doctorRepository.findAll(Sort.by(Sort.Direction.ASC, "name"));
    }

    @PostMapping("/doctors")
    public HospitalDoctor createDoctor(@RequestBody DoctorRequest request) {
        String name = requiredText(request.getName(), "Doctor name is required");
        String specialization = requiredText(request.getSpecialization(), "Specialization is required");

        HospitalDoctor doctor = new HospitalDoctor();
        doctor.setName(name);
        doctor.setSpecialization(specialization);
        doctor.setPhone(trimToNull(request.getPhone()));
        doctor.setAvailability(trimToNull(request.getAvailability()));
        doctor.setConsultationFee(normalizeFee(request.getConsultationFee()));
        return doctorRepository.save(doctor);
    }

    @GetMapping("/patients")
    public List<HospitalPatient> patients() {
        return patientRepository.findAll(Sort.by(Sort.Direction.DESC, "createdAt"));
    }

    @PostMapping("/patients")
    public HospitalPatient createPatient(@RequestBody PatientRequest request) {
        HospitalPatient patient = new HospitalPatient();
        applyPatientRequest(patient, request);
        return patientRepository.save(patient);
    }

    @PutMapping("/patients/{id}")
    public HospitalPatient updatePatient(@PathVariable Long id, @RequestBody PatientRequest request) {
        HospitalPatient patient = patientRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Patient not found"));
        applyPatientRequest(patient, request);
        return patientRepository.save(patient);
    }

    @DeleteMapping("/patients/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deletePatient(@PathVariable Long id) {
        HospitalPatient patient = patientRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Patient not found"));

        long appointmentCount = appointmentRepository.countByPatientId(id);
        if (appointmentCount > 0) {
            throw new ResponseStatusException(
                    HttpStatus.CONFLICT,
                    "Cannot delete patient with existing appointments");
        }
        patientRepository.delete(patient);
    }

    @GetMapping("/appointments")
    public List<AppointmentResponse> appointments() {
        List<HospitalAppointment> appointments = appointmentRepository.findAllByOrderByAppointmentDateTimeAsc();
        Map<Long, String> doctorNames = doctorRepository.findAll().stream()
                .collect(Collectors.toMap(HospitalDoctor::getId, HospitalDoctor::getName));
        Map<Long, String> patientNames = patientRepository.findAll().stream()
                .collect(Collectors.toMap(HospitalPatient::getId, HospitalPatient::getName));

        return appointments.stream()
                .map(appointment -> new AppointmentResponse(
                        appointment.getId(),
                        appointment.getPatientId(),
                        patientNames.getOrDefault(appointment.getPatientId(), "Unknown Patient"),
                        appointment.getDoctorId(),
                        doctorNames.getOrDefault(appointment.getDoctorId(), "Unknown Doctor"),
                        appointment.getAppointmentDateTime(),
                        appointment.getReason(),
                        appointment.getStatus()))
                .collect(Collectors.toList());
    }

    @PostMapping("/appointments")
    public AppointmentResponse createAppointment(@RequestBody AppointmentRequest request) {
        Long patientId = request.getPatientId();
        Long doctorId = request.getDoctorId();

        if (patientId == null || !patientRepository.existsById(patientId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Select a valid patient");
        }
        if (doctorId == null || !doctorRepository.existsById(doctorId)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Select a valid doctor");
        }

        LocalDateTime appointmentDateTime = parseAppointmentDateTime(request.getAppointmentDateTime());
        if (appointmentDateTime.isBefore(LocalDateTime.now().minusMinutes(1))) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment time must be in the future");
        }

        HospitalAppointment appointment = new HospitalAppointment();
        appointment.setPatientId(patientId);
        appointment.setDoctorId(doctorId);
        appointment.setAppointmentDateTime(appointmentDateTime);
        appointment.setReason(trimToNull(request.getReason()));
        appointment.setStatus(HospitalAppointment.STATUS_SCHEDULED);

        HospitalAppointment saved = appointmentRepository.save(appointment);
        String patientName = patientRepository.findById(patientId).map(HospitalPatient::getName).orElse("Unknown Patient");
        String doctorName = doctorRepository.findById(doctorId).map(HospitalDoctor::getName).orElse("Unknown Doctor");
        return new AppointmentResponse(
                saved.getId(),
                saved.getPatientId(),
                patientName,
                saved.getDoctorId(),
                doctorName,
                saved.getAppointmentDateTime(),
                saved.getReason(),
                saved.getStatus());
    }

    @PutMapping("/appointments/{id}/status")
    public AppointmentResponse updateAppointmentStatus(@PathVariable Long id, @RequestBody StatusRequest request) {
        HospitalAppointment appointment = appointmentRepository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Appointment not found"));

        String normalizedStatus = normalizeStatus(request.getStatus());
        appointment.setStatus(normalizedStatus);
        HospitalAppointment saved = appointmentRepository.save(appointment);

        String patientName = patientRepository.findById(saved.getPatientId())
                .map(HospitalPatient::getName)
                .orElse("Unknown Patient");
        String doctorName = doctorRepository.findById(saved.getDoctorId())
                .map(HospitalDoctor::getName)
                .orElse("Unknown Doctor");

        return new AppointmentResponse(
                saved.getId(),
                saved.getPatientId(),
                patientName,
                saved.getDoctorId(),
                doctorName,
                saved.getAppointmentDateTime(),
                saved.getReason(),
                saved.getStatus());
    }

    private BigDecimal normalizeFee(BigDecimal fee) {
        if (fee == null) {
            return null;
        }
        if (fee.signum() < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Consultation fee cannot be negative");
        }
        return fee;
    }

    private void applyPatientRequest(HospitalPatient patient, PatientRequest request) {
        String name = requiredText(request.getName(), "Patient name is required");
        String gender = normalizeGender(request.getGender());
        LocalDate dob = parsePatientDob(request.getDob());
        Integer age = resolveAge(request.getAge(), dob);

        patient.setPatientCode(resolvePatientCode(request.getPatientCode(), patient.getPatientCode(), patient.getId()));
        patient.setName(name);
        patient.setGender(gender);
        patient.setDob(dob);
        patient.setAge(age);
        patient.setPhone(trimToNull(firstNonBlank(request.getMobile(), request.getPhone())));
        patient.setAddress(trimToNull(request.getAddress()));
        patient.setBloodGroup(trimToNull(request.getBloodGroup()));
    }

    private LocalDate parsePatientDob(String dob) {
        if (!StringUtils.hasText(dob)) {
            return null;
        }
        try {
            return LocalDate.parse(dob.trim(), INPUT_DATE_FORMATTER);
        } catch (DateTimeParseException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "DOB must be in yyyy-MM-dd format");
        }
    }

    private Integer resolveAge(Integer age, LocalDate dob) {
        if (dob != null) {
            int calculated = Period.between(dob, LocalDate.now()).getYears();
            if (calculated < 0) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "DOB cannot be in the future");
            }
            return calculated;
        }

        if (age == null || age <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Age must be greater than zero");
        }
        return age;
    }

    private String resolvePatientCode(String requestedCode, String existingCode, Long currentPatientId) {
        String candidate = trimToNull(requestedCode);
        if (candidate == null) {
            candidate = trimToNull(existingCode);
        }
        if (candidate == null) {
            candidate = generatePatientCode();
        }

        String normalized = candidate.toUpperCase();
        Optional<HospitalPatient> existing = patientRepository.findByPatientCode(normalized);
        if (existing.isPresent()) {
            Long existingId = existing.get().getId();
            if (currentPatientId == null || !currentPatientId.equals(existingId)) {
                throw new ResponseStatusException(HttpStatus.CONFLICT, "Patient code already exists");
            }
        }
        return normalized;
    }

    private String generatePatientCode() {
        String prefix = "PAT-" + LocalDate.now().format(DateTimeFormatter.BASIC_ISO_DATE) + "-";
        Optional<HospitalPatient> latest = patientRepository.findTopByPatientCodeStartingWithOrderByPatientCodeDesc(prefix);
        int sequence = 1;
        if (latest.isPresent() && StringUtils.hasText(latest.get().getPatientCode())) {
            String currentCode = latest.get().getPatientCode().trim();
            if (currentCode.startsWith(prefix)) {
                try {
                    sequence = Integer.parseInt(currentCode.substring(prefix.length())) + 1;
                } catch (NumberFormatException ignored) {
                    sequence = 1;
                }
            }
        }
        return prefix + String.format("%03d", sequence);
    }

    private String normalizeGender(String gender) {
        String normalized = requiredText(gender, "Gender is required").toUpperCase();
        if (!"MALE".equals(normalized) && !"FEMALE".equals(normalized) && !"OTHER".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Gender must be MALE, FEMALE, or OTHER");
        }
        return normalized;
    }

    private String normalizeStatus(String status) {
        String normalized = requiredText(status, "Status is required").toUpperCase();
        if (!VALID_STATUSES.contains(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid appointment status");
        }
        return normalized;
    }

    private LocalDateTime parseAppointmentDateTime(String dateTimeText) {
        if (!StringUtils.hasText(dateTimeText)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Appointment date and time is required");
        }
        String value = dateTimeText.trim();
        try {
            return LocalDateTime.parse(value, INPUT_DATE_TIME_FORMATTER);
        } catch (DateTimeParseException ignored) {
            try {
                return LocalDateTime.parse(value);
            } catch (DateTimeParseException ex) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid appointment date/time");
            }
        }
    }

    private String requiredText(String value, String message) {
        if (!StringUtils.hasText(value)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, message);
        }
        return value.trim();
    }

    private String trimToNull(String value) {
        if (!StringUtils.hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private String firstNonBlank(String primary, String fallback) {
        String value = trimToNull(primary);
        if (value != null) {
            return value;
        }
        return trimToNull(fallback);
    }

    public record DashboardResponse(
            long totalDoctors,
            long totalPatients,
            long todayAppointments,
            long scheduledAppointments) {
    }

    public record AppointmentResponse(
            Long id,
            Long patientId,
            String patientName,
            Long doctorId,
            String doctorName,
            LocalDateTime appointmentDateTime,
            String reason,
            String status) {
    }

    public static class DoctorRequest {
        private String name;
        private String specialization;
        private String phone;
        private String availability;
        private BigDecimal consultationFee;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getSpecialization() {
            return specialization;
        }

        public void setSpecialization(String specialization) {
            this.specialization = specialization;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getAvailability() {
            return availability;
        }

        public void setAvailability(String availability) {
            this.availability = availability;
        }

        public BigDecimal getConsultationFee() {
            return consultationFee;
        }

        public void setConsultationFee(BigDecimal consultationFee) {
            this.consultationFee = consultationFee;
        }
    }

    public static class PatientRequest {
        private String patientCode;
        private String name;
        private String gender;
        private String dob;
        private Integer age;
        private String mobile;
        private String phone;
        private String address;
        private String bloodGroup;

        public String getPatientCode() {
            return patientCode;
        }

        public void setPatientCode(String patientCode) {
            this.patientCode = patientCode;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public String getDob() {
            return dob;
        }

        public void setDob(String dob) {
            this.dob = dob;
        }

        public Integer getAge() {
            return age;
        }

        public void setAge(Integer age) {
            this.age = age;
        }

        public String getMobile() {
            return mobile;
        }

        public void setMobile(String mobile) {
            this.mobile = mobile;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public String getBloodGroup() {
            return bloodGroup;
        }

        public void setBloodGroup(String bloodGroup) {
            this.bloodGroup = bloodGroup;
        }
    }

    public static class AppointmentRequest {
        private Long patientId;
        private Long doctorId;
        private String appointmentDateTime;
        private String reason;

        public Long getPatientId() {
            return patientId;
        }

        public void setPatientId(Long patientId) {
            this.patientId = patientId;
        }

        public Long getDoctorId() {
            return doctorId;
        }

        public void setDoctorId(Long doctorId) {
            this.doctorId = doctorId;
        }

        public String getAppointmentDateTime() {
            return appointmentDateTime;
        }

        public void setAppointmentDateTime(String appointmentDateTime) {
            this.appointmentDateTime = appointmentDateTime;
        }

        public String getReason() {
            return reason;
        }

        public void setReason(String reason) {
            this.reason = reason;
        }
    }

    public static class StatusRequest {
        private String status;

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }
}
