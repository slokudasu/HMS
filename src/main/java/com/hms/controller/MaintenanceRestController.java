package com.hms.controller;

import java.io.ByteArrayInputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dao.GayatriMaintenanceRepo;
import com.hms.dao.MaintenanceExcelServiceDao;
import com.hms.dto.MaintenanceSearchRequest;
import com.hms.entity.GayatriMaintenance;
import com.hms.entity.Maintenance;
import com.hms.entity.Member;
import com.hms.service.MaintenanceExcelService;
import com.hms.service.MaintenanceService;
import com.hms.service.MaintenanceSpecification;
import com.hms.service.MemberService;

@RestController
@RequestMapping("/maintenance")
@CrossOrigin

public class MaintenanceRestController {
	
	@Autowired
	MaintenanceService maintenanceService;
	
	@Autowired
	GayatriMaintenanceRepo gayatriMaintenanceRepo;
	
	@Autowired
	MaintenanceExcelService maintenanceExcelService;
	
	@Autowired
	MaintenanceExcelServiceDao maintenanceExcelServiceDao;
	
	@Autowired
	MemberService memberService;
	

	@PostMapping("/save")
	public Maintenance save(@RequestBody Maintenance maintenance) {
		return maintenanceService.save(maintenance);		
	}
	
	@GetMapping("/fetch")
	public List<Maintenance> fetch() {
		return maintenanceService.fetch();
		
	}
	
	@GetMapping("/fetchMaintenance")
	public List<GayatriMaintenance> fetchMaintenance() {
		return gayatriMaintenanceRepo.findAll();
		
	}
	
	@GetMapping("/delete/{id}")
	public String delete(@PathVariable Long id) {
		return maintenanceService.delete(id);
		
	}
	@GetMapping("/edit/{id}")
	public Optional<Maintenance> edit(@PathVariable Long id) {
		return maintenanceService.edit(id);
		
	}
	
	@GetMapping("/fetch/{memberId}")
	public List<Maintenance> findByMemberId(@PathVariable Long memberId) {
		return maintenanceService.findByMemberId(memberId);
		
	}
	
	@GetMapping("/fetch/{memberId}/{year}")
	public List<Maintenance> findByMemberIdAndYear(@PathVariable Long memberId,@PathVariable String year) {		
        return  maintenanceService.findByMemberIdAndYear(memberId , year);
		
	}
	
	@GetMapping("/downloadExcel")
    public ResponseEntity<InputStreamResource> downloadExcel(@RequestParam(required = false) Long memberId,@RequestParam(required = false) String year,
    		@RequestParam(required = false) String month,
    		@RequestParam(required = false) String status) throws Exception {
        List<Maintenance> paidList  = null;
        MaintenanceSearchRequest maintenanceSearchRequest = new MaintenanceSearchRequest();
        maintenanceSearchRequest.setMemberId(memberId);
        maintenanceSearchRequest.setYear(year);
        maintenanceSearchRequest.setMonth(month);
        maintenanceSearchRequest.setStatus(status);
		try {
			Specification<Maintenance> spec = MaintenanceSpecification.filter(maintenanceSearchRequest);	        
			paidList  = maintenanceExcelServiceDao.findAll(spec);
			
	       
		} catch (Exception e) {
			e.printStackTrace();
		}
	    List<Maintenance> finalList = new ArrayList();

		if(!year.isEmpty() && !month.isEmpty()) {
			List<Member> allMembers = memberService.fetchMembers();
			
			// 3. Convert paid to map for faster lookup
		    Map<Long, Maintenance> paidMap = paidList.stream()
		            .collect(Collectors.toMap(Maintenance::getMemberId, m -> m));
			
		    
		 // 5. Loop through all members
		    for (Member member : allMembers) {
		    	Maintenance dto = new Maintenance();
		        dto.setMemberId(member.getMemberId());
		        dto.setMemberName(member.getFirstName() +" "+member.getLastName());
		        dto.setYear(year);
		        dto.setMonth(month);

		        if (paidMap.containsKey(member.getMemberId())) {
		            // Member PAID
		            Maintenance m = paidMap.get(member.getMemberId());
		            dto.setAmount(m.getAmount());
		            dto.setStatus("Paid");
		        } else {
		            // Member UNPAID
		            dto.setAmount(0.0);
		            dto.setStatus("Unpaid");
		        }

		        finalList.add(dto);
		    }
		} else {
			finalList = paidList;
		}
		
		
		
		
		
		ByteArrayInputStream in = maintenanceExcelService.export(finalList);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=maintenance.xlsx");
        return ResponseEntity.ok()
                .headers(headers)	
                .contentType(MediaType.parseMediaType("application/vnd.ms-excel"))
                .body(new InputStreamResource(in));
        
        
        
    }
	
}
