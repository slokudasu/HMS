package com.hms.dao;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.Year;

public interface YearRepo extends JpaRepository<Year,Long>{
	
}
