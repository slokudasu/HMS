package com.hms.dto;

import java.util.List;

public class Room {
    private String roomName;
    private List<Table> tables;
	public String getRoomName() {
		return roomName;
	}
	public void setRoomName(String roomName) {
		this.roomName = roomName;
	}
	public List<Table> getTables() {
		return tables;
	}
	public void setTables(List<Table> tables) {
		this.tables = tables;
	}

    
}