package com.hms.restaurent.mapper;

import com.hms.entity.restaurent.Hall;
import com.hms.restaurent.dto.HallDTO;

public class HallMapper {

    public static HallDTO toDto(Hall entity) {
        HallDTO dto = new HallDTO();

        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setStatus(entity.getStatus());

        return dto;
    }

    public static Hall toEntity(HallDTO dto) {
        Hall entity = new Hall();

        entity.setId(dto.getId());
        entity.setName(dto.getName());
        entity.setStatus(dto.getStatus());

        return entity;
    }

    public static void updateEntity(Hall entity, HallDTO dto) {
        entity.setName(dto.getName());
        entity.setStatus(dto.getStatus());
    }
}
