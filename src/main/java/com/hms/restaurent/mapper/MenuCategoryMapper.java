package com.hms.restaurent.mapper;

import com.hms.entity.restaurent.MenuCategory;
import com.hms.restaurent.dto.MenuCategoryDTO;

public class MenuCategoryMapper {

    public static MenuCategoryDTO toDto(MenuCategory entity) {
        MenuCategoryDTO dto = new MenuCategoryDTO();

        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setStatus(entity.getStatus());

        return dto;
    }

    public static MenuCategory toEntity(MenuCategoryDTO dto) {
        MenuCategory entity = new MenuCategory();

        entity.setId(dto.getId());
        entity.setName(dto.getName());
        entity.setStatus(dto.getStatus());

        return entity;
    }

    public static void updateEntity(MenuCategory entity, MenuCategoryDTO dto) {
        entity.setName(dto.getName());
        entity.setStatus(dto.getStatus());
    }
}
