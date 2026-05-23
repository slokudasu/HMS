package com.hms.hospital.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.hospital.entity.HospitalDoctor;

public interface HospitalDoctorRepository extends JpaRepository<HospitalDoctor, Long> {
}
