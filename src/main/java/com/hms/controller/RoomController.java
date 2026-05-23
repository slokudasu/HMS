package com.hms.controller;

import java.util.Arrays;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.dto.Room;
import com.hms.dto.Table;


@RestController
public class RoomController {

    @GetMapping("/rooms1")
    public List<Room> getRooms() {

        List<Table> acTables = Arrays.asList(
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(1L, "T1", "Available"),
            createTable(2L, "T2", "Occupied")
        );

        List<Table> nonAcTables = Arrays.asList(
            createTable(3L, "T3", "Available")
        );
        
        List<Table> parcleTables = Arrays.asList(
        		createTable(1L, "P1", "Available"),
        		createTable(2L, "P2", "Occupied"),
        		createTable(2L, "P3", "Occupied"),
        		createTable(2L, "P4", "Occupied"),
        		createTable(2L, "P5", "Occupied"),
        		createTable(2L, "P6", "Occupied")
            );

        Room room1 = new Room();
        room1.setRoomName("AC Hall");
        room1.setTables(acTables);

        Room room2 = new Room();
        room2.setRoomName("Non-AC Hall");
        room2.setTables(nonAcTables);
        
        Room room3 = new Room();
        room3.setRoomName("Parcel");
        room3.setTables(parcleTables);

        return Arrays.asList(room1, room2, room3);
    }

    private Table createTable(Long id, String name, String status) {
        Table t = new Table();
        t.setTableId(id);
        t.setTableName(name);
        t.setStatus(status);
        return t;
    }
}