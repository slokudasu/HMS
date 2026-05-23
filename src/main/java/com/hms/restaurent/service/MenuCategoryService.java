package com.hms.restaurent.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.MenuCategory;
import com.hms.entity.restaurent.RestaurantUser;
import com.hms.restaurent.dto.MenuCategoryDTO;
import com.hms.restaurent.mapper.MenuCategoryMapper;
import com.hms.restaurent.repository.MenuCategoryRepository;
import com.hms.restaurent.repository.RestaurantUserRepository;

@Service
public class MenuCategoryService {

    @Autowired
    private MenuCategoryRepository repository;

    @Autowired
    private RestaurantUserRepository restaurantUserRepository;

    public MenuCategoryDTO save(MenuCategoryDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());
        RestaurantUser restaurantUser = findRestaurantUser(restaurantUserId);

        if (repository.existsByRestaurantUser_IdAndNameIgnoreCase(restaurantUserId, name)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Menu category already exists");
        }

        MenuCategory entity = MenuCategoryMapper.toEntity(dto);
        entity.setId(null);
        entity.setName(name);
        entity.setStatus(status);
        entity.setRestaurantUser(restaurantUser);

        MenuCategory saved = repository.save(entity);

        return MenuCategoryMapper.toDto(saved);
    }

    public List<MenuCategoryDTO> findAll(Long restaurantUserId) {
        return repository.findByRestaurantUser_Id(restaurantUserId)
                .stream()
                .map(MenuCategoryMapper::toDto)
                .toList();
    }

    public MenuCategoryDTO findById(Long id, Long restaurantUserId) {
        MenuCategory entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu category not found"));

        return MenuCategoryMapper.toDto(entity);
    }

    public MenuCategoryDTO update(Long id, MenuCategoryDTO dto, Long restaurantUserId) {
        String name = normalizeName(dto.getName());
        String status = normalizeStatus(dto.getStatus());

        MenuCategory entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu category not found"));

        if (repository.existsByRestaurantUser_IdAndNameIgnoreCaseAndIdNot(restaurantUserId, name, id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Menu category already exists");
        }

        MenuCategoryMapper.updateEntity(entity, dto);
        entity.setName(name);
        entity.setStatus(status);

        MenuCategory updated = repository.save(entity);

        return MenuCategoryMapper.toDto(updated);
    }

    public void delete(Long id, Long restaurantUserId) {
        MenuCategory entity = repository.findByIdAndRestaurantUser_Id(id, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Menu category not found"));
        repository.delete(entity);
    }

    public List<MenuCategoryDTO> findByStatus(String status, Long restaurantUserId) {
        String normalized = normalizeStatus(status);
        return repository.findByRestaurantUser_IdAndStatus(restaurantUserId, normalized)
                .stream()
                .map(MenuCategoryMapper::toDto)
                .toList();
    }

    private RestaurantUser findRestaurantUser(Long restaurantUserId) {
        if (restaurantUserId == null || restaurantUserId <= 0) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        }

        return restaurantUserRepository.findById(restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required"));
    }

    private String normalizeName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Menu category name is required");
        }
        return name.trim();
    }

    private String normalizeStatus(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "ACTIVE";
        }
        String normalized = status.trim().toUpperCase(Locale.ROOT);
        if (!"ACTIVE".equals(normalized) && !"INACTIVE".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Status must be ACTIVE or INACTIVE");
        }
        return normalized;
    }
}
