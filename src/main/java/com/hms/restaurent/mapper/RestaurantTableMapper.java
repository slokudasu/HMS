package com.hms.restaurent.mapper;

import com.hms.entity.restaurent.Hall;
import com.hms.entity.restaurent.RestaurantTable;
import com.hms.restaurent.dto.RestaurantTableDTO;

public class RestaurantTableMapper {

    public static RestaurantTableDTO toDto(RestaurantTable entity) {
        RestaurantTableDTO dto = new RestaurantTableDTO();
        dto.setId(entity.getId());
        dto.setTableName(entity.getTableName());
        dto.setStatus(entity.getStatus());

        Hall hall = entity.getHall();
        if (hall != null) {
            dto.setHallId(hall.getId());
            dto.setHallName(hall.getName());
        }

        return dto;
    }

    public static RestaurantTable toEntity(RestaurantTableDTO dto, Hall hall) {
        RestaurantTable entity = new RestaurantTable();
        entity.setId(dto.getId());
        entity.setTableName(dto.getTableName());
        entity.setStatus(dto.getStatus());
        entity.setHall(hall);
        return entity;
    }

    public static void updateEntity(RestaurantTable entity, RestaurantTableDTO dto, Hall hall) {
        entity.setTableName(dto.getTableName());
        entity.setStatus(dto.getStatus());
        entity.setHall(hall);
    }
}
