package com.hms.controller;

import java.io.ByteArrayInputStream;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.entity.Member;
import com.hms.service.MemberExcelService;
import com.hms.service.MemberService;

@RestController
@RequestMapping("/member")
@CrossOrigin

public class AddMemberRestController {
	@Autowired
	MemberService memberService;
	
	@Autowired
    private MemberExcelService excelService;
	
	@GetMapping("test")
	public String test() {
		return "loku";
	}
	
	@PostMapping("save")
	public Member save(@RequestBody Member member) {
		return memberService.save(member);		
	}
	
	@GetMapping("/fetch")
	public List<Member> fetchMembers() {		
		return memberService.fetchMembers();
		
	}
	
	@GetMapping("/delete/{memberId}")
	public String delete(@PathVariable Long memberId) {
		return memberService.deleteMember(memberId);
		
	}
	@GetMapping("/edit/{memberId}")
	public Optional<Member> edit(@PathVariable Long memberId) {
		return memberService.edit(memberId);
		
	}
	
	@GetMapping("/fetch/{memberShipFlag}")
	public List<Member> findByMemberType(@PathVariable Boolean memberShipFlag) {		
		return memberService.findByMemberShipFlag(memberShipFlag);
		
	}
	
	@GetMapping("/downloadExcel")
    public ResponseEntity<InputStreamResource> downloadExcel() throws Exception {
        List<Member> members = memberService.fetchMembers();

        ByteArrayInputStream in = excelService.export(members);

        HttpHeaders headers = new HttpHeaders();
        headers.add("Content-Disposition", "attachment; filename=members.xlsx");
        return ResponseEntity.ok()
                .headers(headers)
                .contentType(MediaType.parseMediaType("application/vnd.ms-excel"))
                .body(new InputStreamResource(in));
    }
	
	
	
	
}
