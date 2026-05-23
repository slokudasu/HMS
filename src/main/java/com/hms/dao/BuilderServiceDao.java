package com.hms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.Builder;

public interface BuilderServiceDao extends JpaRepository<Builder,Long>{
	public List<Builder> findByStatus(String status);

}
