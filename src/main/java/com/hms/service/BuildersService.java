package com.hms.service;

import java.util.List;

import com.hms.entity.Builder;

public interface BuildersService {
	public Builder save(Builder member);
	List<Builder> fetch();
	public String delete(Long id);
	public List<Builder> findByStatus(String status);

}
