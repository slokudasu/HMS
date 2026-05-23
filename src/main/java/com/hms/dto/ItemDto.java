package com.hms.dto;

import java.util.List;

public class ItemDto {
	 private String name;
	 private int id;
	 private double price;
	 private List<SubItemDto> subItems;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public List<SubItemDto> getSubItems() {
		return subItems;
	}
	public void setSubItems(List<SubItemDto> subItems) {
		this.subItems = subItems;
	}
	
	
	 
	 
}
