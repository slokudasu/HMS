package com.hms.restaurent.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.Item;
import com.hms.entity.restaurent.MenuCategory;
import com.hms.restaurent.dto.RestaurantItemDTO;
import com.hms.restaurent.mapper.RestaurantItemMapper;
import com.hms.restaurent.repository.ItemRepository;
import com.hms.restaurent.repository.MenuCategoryRepository;
import com.hms.restaurent.repository.SubItemRepository;

@Service
public class RestaurantItemService {

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private MenuCategoryRepository categoryRepository;

    @Autowired
    private SubItemRepository subItemRepository;

    public RestaurantItemDTO save(RestaurantItemDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String description = normalizeDescription(dto.getDescription());
        String status = normalizeStatus(dto.getStatus());
        Double price = normalizePrice(dto.getPrice());
        Long categoryId = normalizeCategoryId(dto.getCategoryId());

        MenuCategory category = categoryRepository.findByIdAndRestaurantUser_Id(categoryId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu category not found"));

        if (itemRepository.existsByNameIgnoreCaseAndCategory_IdAndCategory_RestaurantUser_Id(name, categoryId, restaurantUserId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Item already exists in selected category");
        }

        dto.setName(name);
        dto.setDescription(description);
        dto.setStatus(status);
        dto.setPrice(price);

        Item entity = RestaurantItemMapper.toEntity(dto, category);
        entity.setId(null);

        Item saved = itemRepository.save(entity);
        return RestaurantItemMapper.toDto(saved);
    }

    public List<RestaurantItemDTO> findAll(Long categoryId, String status, Long restaurantUserId) {
        List<Item> items;
        if (categoryId != null && hasValue(status)) {
            items = itemRepository.findByCategory_RestaurantUser_IdAndCategory_IdAndStatus(
                    restaurantUserId,
                    categoryId,
                    normalizeStatus(status));
        } else if (categoryId != null) {
            items = itemRepository.findByCategory_RestaurantUser_IdAndCategory_Id(restaurantUserId, categoryId);
        } else if (hasValue(status)) {
            items = itemRepository.findByCategory_RestaurantUser_IdAndStatus(restaurantUserId, normalizeStatus(status));
        } else {
            items = itemRepository.findByCategory_RestaurantUser_Id(restaurantUserId);
        }

        return items.stream().map(RestaurantItemMapper::toDto).toList();
    }

    public RestaurantItemDTO findById(Long id, Long restaurantUserId) {
        Item entity = itemRepository.findByIdAndCategory_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));

        return RestaurantItemMapper.toDto(entity);
    }

    public RestaurantItemDTO update(Long id, RestaurantItemDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String description = normalizeDescription(dto.getDescription());
        String status = normalizeStatus(dto.getStatus());
        Double price = normalizePrice(dto.getPrice());
        Long categoryId = normalizeCategoryId(dto.getCategoryId());

        Item entity = itemRepository.findByIdAndCategory_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));

        MenuCategory category = categoryRepository.findByIdAndRestaurantUser_Id(categoryId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu category not found"));

        if (itemRepository.existsByNameIgnoreCaseAndCategory_IdAndCategory_RestaurantUser_IdAndIdNot(
                name,
                categoryId,
                restaurantUserId,
                id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Item already exists in selected category");
        }

        dto.setName(name);
        dto.setDescription(description);
        dto.setStatus(status);
        dto.setPrice(price);

        RestaurantItemMapper.updateEntity(entity, dto, category);
        Item updated = itemRepository.save(entity);
        return RestaurantItemMapper.toDto(updated);
    }

    public void delete(Long id, Long restaurantUserId) {
        Item entity = itemRepository.findByIdAndCategory_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));

        if (subItemRepository.existsByItem_IdAndItem_Category_RestaurantUser_Id(id, restaurantUserId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Delete sub items before deleting item");
        }

        itemRepository.delete(entity);
    }

    private String normalizeName(String name) {
        if (!hasValue(name)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item name is required");
        }
        return name.trim();
    }

    private String normalizeDescription(String description) {
        if (description == null) {
            return "";
        }
        return description.trim();
    }

    private Double normalizePrice(Double price) {
        if (price == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item price is required");
        }
        if (price < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item price must be zero or greater");
        }
        return price;
    }

    private Long normalizeCategoryId(Long categoryId) {
        if (categoryId == null || categoryId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Menu category is required");
        }
        return categoryId;
    }

    private String normalizeStatus(String status) {
        if (!hasValue(status)) {
            return "ACTIVE";
        }
        String normalized = status.trim().toUpperCase(Locale.ROOT);
        if (!"ACTIVE".equals(normalized) && !"INACTIVE".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Status must be ACTIVE or INACTIVE");
        }
        return normalized;
    }

    private boolean hasValue(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
