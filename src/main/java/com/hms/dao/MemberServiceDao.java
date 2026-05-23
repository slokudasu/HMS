package com.hms.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.Member;

public interface MemberServiceDao extends JpaRepository<Member,Long>{
	public List<Member> findByMemberShipFlag(Boolean memberShipFlag);


}
