package com.hms.restaurent.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.Item;
import com.hms.entity.restaurent.SubItem;
import com.hms.restaurent.dto.RestaurantSubItemDTO;
import com.hms.restaurent.mapper.RestaurantSubItemMapper;
import com.hms.restaurent.repository.ItemRepository;
import com.hms.restaurent.repository.SubItemRepository;

@Service
public class RestaurantSubItemService {

    @Autowired
    private SubItemRepository subItemRepository;

    @Autowired
    private ItemRepository itemRepository;

    public RestaurantSubItemDTO save(RestaurantSubItemDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());
        Double price = normalizePrice(dto.getPrice());
        Long itemId = normalizeItemId(dto.getItemId());

        Item item = itemRepository.findByIdAndCategory_RestaurantUser_Id(itemId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));

        if (subItemRepository.existsByNameIgnoreCaseAndItem_IdAndItem_Category_RestaurantUser_Id(
                name,
                itemId,
                restaurantUserId)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Sub item already exists in selected item");
        }

        dto.setName(name);
        dto.setStatus(status);
        dto.setPrice(price);

        SubItem entity = RestaurantSubItemMapper.toEntity(dto, item);
        entity.setId(null);

        SubItem saved = subItemRepository.save(entity);
        return RestaurantSubItemMapper.toDto(saved);
    }

    public List<RestaurantSubItemDTO> findAll(Long itemId, String status, Long restaurantUserId) {
        List<SubItem> subItems;
        if (itemId != null && hasValue(status)) {
            subItems = subItemRepository.findByItem_Category_RestaurantUser_IdAndItem_IdAndStatus(
                    restaurantUserId,
                    itemId,
                    normalizeStatus(status));
        } else if (itemId != null) {
            subItems = subItemRepository.findByItem_Category_RestaurantUser_IdAndItem_Id(restaurantUserId, itemId);
        } else if (hasValue(status)) {
            subItems = subItemRepository.findByItem_Category_RestaurantUser_IdAndStatus(
                    restaurantUserId,
                    normalizeStatus(status));
        } else {
            subItems = subItemRepository.findByItem_Category_RestaurantUser_Id(restaurantUserId);
        }

        return subItems.stream().map(RestaurantSubItemMapper::toDto).toList();
    }

    public RestaurantSubItemDTO findById(Long id, Long restaurantUserId) {
        SubItem entity = subItemRepository.findByIdAndItem_Category_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub item not found"));

        return RestaurantSubItemMapper.toDto(entity);
    }

    public RestaurantSubItemDTO update(Long id, RestaurantSubItemDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());
        Double price = normalizePrice(dto.getPrice());
        Long itemId = normalizeItemId(dto.getItemId());

        SubItem entity = subItemRepository.findByIdAndItem_Category_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub item not found"));

        Item item = itemRepository.findByIdAndCategory_RestaurantUser_Id(itemId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));

        if (subItemRepository.existsByNameIgnoreCaseAndItem_IdAndItem_Category_RestaurantUser_IdAndIdNot(
                name,
                itemId,
                restaurantUserId,
                id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Sub item already exists in selected item");
        }

        dto.setName(name);
        dto.setStatus(status);
        dto.setPrice(price);

        RestaurantSubItemMapper.updateEntity(entity, dto, item);
        SubItem updated = subItemRepository.save(entity);
        return RestaurantSubItemMapper.toDto(updated);
    }

    public void delete(Long id, Long restaurantUserId) {
        SubItem entity = subItemRepository.findByIdAndItem_Category_RestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub item not found"));
        subItemRepository.delete(entity);
    }

    private String normalizeName(String name) {
        if (!hasValue(name)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Sub item name is required");
        }
        return name.trim();
    }

    private Double normalizePrice(Double price) {
        if (price == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Sub item price is required");
        }
        if (price < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Sub item price must be zero or greater");
        }
        return price;
    }

    private Long normalizeItemId(Long itemId) {
        if (itemId == null || itemId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item is required");
        }
        return itemId;
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
