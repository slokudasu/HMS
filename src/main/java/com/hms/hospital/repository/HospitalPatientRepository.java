package com.hms.hospital.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.hospital.entity.HospitalPatient;

public interface HospitalPatientRepository extends JpaRepository<HospitalPatient, Long> {
}
