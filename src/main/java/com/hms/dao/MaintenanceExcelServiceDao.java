package com.hms.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import com.hms.entity.Maintenance;

public interface MaintenanceExcelServiceDao 
extends JpaRepository<Maintenance, Long>, JpaSpecificationExecutor<Maintenance> {
}
