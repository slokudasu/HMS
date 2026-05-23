package com.hms.serviceImpl;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hms.dao.MaintenanceExcelServiceDao;
import com.hms.dao.MaintenanceServiceDao;
import com.hms.entity.Maintenance;
import com.hms.service.MaintenanceService;

@Service
public class MaintenceServiceImpl implements MaintenanceService{
	
	@Autowired
	MaintenanceServiceDao dao;
	
	@Autowired
	MaintenanceExcelServiceDao maintenanceExcelServiceDao;

	@Override
	public Maintenance save(Maintenance maintenance) {		
		maintenance.setCreationDateTime(Date.valueOf(LocalDate.now()));
		return dao.save(maintenance);
		
	}

	@Override
	public List<Maintenance> fetch() {		
		return dao.findAll();
	}

	@Override
	public String delete(Long id) {
		dao.deleteById(id);		
		return "Member Deleted Successfully";
	}

	@Override
	public Optional<Maintenance> edit(Long id) {
		return dao.findById(id);
	}

	@Override
	public List<Maintenance> findByMemberId(Long memberId) {
		return dao.findByMemberId(memberId);
	}

	@Override
	public List<Maintenance> findByMemberIdAndYear(Long memberId, String year) {
		return dao.findByMemberIdAndYear(memberId ,  year);
	}

	

	

}
