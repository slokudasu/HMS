package com.hms.dto;


public class MenuItem {

    private String name;
    private int id;

    public MenuItem() {}

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

	public MenuItem(String name, int id) {
		super();
		this.name = name;
		this.id = id;
	}
    

    
}