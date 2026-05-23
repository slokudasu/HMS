package com.hms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.GayatriMaintenance;

public interface GayatriMaintenanceRepo extends JpaRepository<GayatriMaintenance,Long>{
	public List<GayatriMaintenance> findByMemberId(Long memberId);
	public List<GayatriMaintenance> findByMemberIdAndYear(Long memberId, String year);


}
