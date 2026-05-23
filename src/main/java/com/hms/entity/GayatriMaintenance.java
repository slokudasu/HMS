package com.hms.entity;

import java.sql.Date;

import org.hibernate.annotations.DynamicUpdate;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
@Entity
@Table(name = "GayatriMaintenance")
@DynamicUpdate
public class GayatriMaintenance {
	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;
	
    Date creationDateTime;
	
	private String year;
	private double January;
	private double February;
	private double March;
	private double April;
	private double May;
	private double June;
	private double July;
	private double August;
	private double September;
	private double October;
	private double November;
	private double December;
	private double totalAmount;
	private Long memberId;
	private String memberName;
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Date getCreationDateTime() {
		return creationDateTime;
	}
	public void setCreationDateTime(Date creationDateTime) {
		this.creationDateTime = creationDateTime;
	}
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public double getJanuary() {
		return January;
	}
	public void setJanuary(double january) {
		January = january;
	}
	public double getFebruary() {
		return February;
	}
	public void setFebruary(double february) {
		February = february;
	}
	public double getMarch() {
		return March;
	}
	public void setMarch(double march) {
		March = march;
	}
	public double getApril() {
		return April;
	}
	public void setApril(double april) {
		April = april;
	}
	public double getMay() {
		return May;
	}
	public void setMay(double may) {
		May = may;
	}
	public double getJune() {
		return June;
	}
	public void setJune(double june) {
		June = june;
	}
	public double getJuly() {
		return July;
	}
	public void setJuly(double july) {
		July = july;
	}
	public double getAugust() {
		return August;
	}
	public void setAugust(double august) {
		August = august;
	}
	public double getSeptember() {
		return September;
	}
	public void setSeptember(double september) {
		September = september;
	}
	public double getOctober() {
		return October;
	}
	public void setOctober(double october) {
		October = october;
	}
	public double getNovember() {
		return November;
	}
	public void setNovember(double november) {
		November = november;
	}
	public double getDecember() {
		return December;
	}
	public void setDecember(double december) {
		December = december;
	}
	public double getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}
	public Long getMemberId() {
		return memberId;
	}
	public void setMemberId(Long memberId) {
		this.memberId = memberId;
	}
	public String getMemberName() {
		return memberName;
	}
	public void setMemberName(String memberName) {
		this.memberName = memberName;
	}
	
	
	
	
	
}
