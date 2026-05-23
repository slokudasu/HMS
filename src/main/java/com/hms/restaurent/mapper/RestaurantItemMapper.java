package com.hms.restaurent.mapper;

import com.hms.entity.restaurent.Item;
import com.hms.entity.restaurent.MenuCategory;
import com.hms.restaurent.dto.RestaurantItemDTO;

public class RestaurantItemMapper {

    public static RestaurantItemDTO toDto(Item entity) {
        RestaurantItemDTO dto = new RestaurantItemDTO();
        dto.setId(entity.getId());
        dto.setName(entity.getName());
        dto.setDescription(entity.getDescription());
        dto.setStatus(entity.getStatus());
        dto.setPrice(entity.getPrice());

        MenuCategory category = entity.getCategory();
        if (category != null) {
            dto.setCategoryId(category.getId());
            dto.setCategoryName(category.getName());
        }

        return dto;
    }

    public static Item toEntity(RestaurantItemDTO dto, MenuCategory category) {
        Item entity = new Item();
        entity.setId(dto.getId());
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        entity.setStatus(dto.getStatus());
        entity.setPrice(dto.getPrice());
        entity.setCategory(category);
        return entity;
    }

    public static void updateEntity(Item entity, RestaurantItemDTO dto, MenuCategory category) {
        entity.setName(dto.getName());
        entity.setDescription(dto.getDescription());
        entity.setStatus(dto.getStatus());
        entity.setPrice(dto.getPrice());
        entity.setCategory(category);
    }
}
