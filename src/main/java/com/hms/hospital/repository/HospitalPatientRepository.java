package com.hms.hospital.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.hospital.entity.HospitalPatient;

public interface HospitalPatientRepository extends JpaRepository<HospitalPatient, Long> {

    boolean existsByPatientCode(String patientCode);

    Optional<HospitalPatient> findByPatientCode(String patientCode);

    Optional<HospitalPatient> findTopByPatientCodeStartingWithOrderByPatientCodeDesc(String prefix);
}
