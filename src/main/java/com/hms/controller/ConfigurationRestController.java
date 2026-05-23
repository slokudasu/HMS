package com.hms.controller;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dao.GayatriMaintenanceRepo;
import com.hms.dao.YearRepo;
import com.hms.entity.GayatriMaintenance;
import com.hms.entity.Member;
import com.hms.entity.Year;
import com.hms.service.MemberService;

@RestController
@RequestMapping("/configutaion")
@CrossOrigin

public class ConfigurationRestController {
	
	
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	GayatriMaintenanceRepo gayatriMaintenanceRepo;
	
	@Autowired
	YearRepo yearRepo;
	

	@GetMapping("/year/{year}")
	public Year save(@PathVariable String year) {
		List<Member> members= memberService.fetchMembers();
		members.stream().forEach(member -> {
			GayatriMaintenance maintenance = new GayatriMaintenance();
			maintenance.setJanuary(0);
			maintenance.setFebruary(0);
			maintenance.setMarch(0);
			maintenance.setApril(0);
			maintenance.setMay(0);
			maintenance.setJune(0);
			maintenance.setJuly(0);
			maintenance.setAugust(0);
			maintenance.setSeptember(0);
			maintenance.setOctober(0);
			maintenance.setNovember(0);
			maintenance.setDecember(0);
			maintenance.setYear(year);
			maintenance.setCreationDateTime(Date.valueOf(LocalDate.now()));
			maintenance.setTotalAmount(0);
			maintenance.setMemberId(member.getMemberId());
			maintenance.setMemberName(member.getFirstName() +" "+member.getLastName());
			
			gayatriMaintenanceRepo.save(maintenance);
		});
		
		Year yearEntity = new Year();
		yearEntity.setYear(year);
		yearEntity.setCurrentYear(false);
		
		return yearRepo.save(yearEntity);
	}
	
	
	

	
}
