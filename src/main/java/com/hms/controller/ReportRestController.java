package com.hms.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dto.Report;
import com.hms.entity.Builder;
import com.hms.entity.Maintenance;
import com.hms.entity.Member;
import com.hms.entity.Transactions;
import com.hms.service.BuildersService;
import com.hms.service.MaintenanceService;
import com.hms.service.MemberService;
import com.hms.service.TransactionsService;

@RestController
@RequestMapping("/report")
@CrossOrigin

public class ReportRestController {
	
	@Autowired
	TransactionsService transactionsService;
	
	@Autowired
	MaintenanceService maintenanceService;
	
	@Autowired
	MemberService memberService;
	
	@Autowired
	BuildersService buildersService;
	
	
	

	
	@GetMapping("/main")
	public List<Report> fetch() {
		
		List<Report> reportList = new ArrayList<Report>();
		
		
		//Transaction
		Report tran = new Report();
		tran.setLabel("Transaction Amount");
		double trsactionAmount = 0;
		for (Transactions transactions : transactionsService.fetch()) {
			if(transactions.getTransactionType() != null && transactions.getTransactionType().equalsIgnoreCase("Credit")) {
				trsactionAmount = trsactionAmount +  transactions.getAmount(); 
			 } else {
				 trsactionAmount = trsactionAmount -  transactions.getAmount();
			 }
		}
		tran.setY(trsactionAmount);
		
		//Maintenance
		Report mainta = new Report();
		mainta.setLabel("Maintenance Amount");
		double maintaAmount = 0;
		for (Maintenance maintenance : maintenanceService.fetch()) {
			maintaAmount = maintaAmount + maintenance.getAmount();			
		}
		mainta.setY(maintaAmount);
		
		
		//
		Report memberShip = new Report();
		memberShip.setLabel("Membership Amount");
		double memberShipAmount = 0;
		for (Member member : memberService.fetchMembers()) {
			memberShipAmount = memberShipAmount + member.getMemberShipAmount();		
		}
		memberShip.setY(memberShipAmount);
		
		//
		Report builder = new Report();
		builder.setLabel("Builder Amount");
		double builderAmount = 0;
		for (Builder builderData : buildersService.findByStatus("Paid")) {
			builderAmount = builderAmount + builderData.getAmount();		
		}
		builder.setY(builderAmount);
		
		reportList.add(tran);
		reportList.add(mainta);
		reportList.add(memberShip);
		reportList.add(builder);
		
		
		
		
		return reportList;
		
	}
	

	
	
	
}
