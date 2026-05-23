package com.hms.service;

import java.util.List;
import java.util.Optional;

import com.hms.entity.Member;

public interface MemberService {
	public Member save(Member member);
	public List<Member> fetchMembers();
	//public List<Member> fetchMembers(Member member);
	public String deleteMember(Long memberId);
	public Optional<Member> edit(Long memberId);
	public List<Member> findByMemberShipFlag(Boolean memberShipFlag);
	

}
