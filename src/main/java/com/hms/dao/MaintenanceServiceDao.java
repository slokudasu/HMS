package com.hms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.Maintenance;

public interface MaintenanceServiceDao extends JpaRepository<Maintenance,Long>{
	public List<Maintenance> findByMemberId(Long memberId);
	public List<Maintenance> findByMemberIdAndYear(Long memberId, String year);


}
