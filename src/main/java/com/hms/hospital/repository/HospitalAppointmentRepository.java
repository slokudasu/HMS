package com.hms.hospital.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.hospital.entity.HospitalAppointment;

public interface HospitalAppointmentRepository extends JpaRepository<HospitalAppointment, Long> {

    List<HospitalAppointment> findAllByOrderByAppointmentDateTimeAsc();

    long countByStatus(String status);

    long countByAppointmentDateTimeBetween(LocalDateTime startInclusive, LocalDateTime endExclusive);
}
