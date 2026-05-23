package com.hms.service;

import java.util.List;
import java.util.Optional;

import com.hms.entity.Maintenance;

public interface MaintenanceService {
	public Maintenance save(Maintenance member);
	public List<Maintenance> fetch();
	public String delete(Long id);
	public Optional<Maintenance> edit(Long id);
	public List<Maintenance> findByMemberId(Long memberId);
	public List<Maintenance> findByMemberIdAndYear(Long memberId, String year);

	

}
