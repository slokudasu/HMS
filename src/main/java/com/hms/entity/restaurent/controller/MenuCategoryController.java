package com.hms.entity.restaurent.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hms.restaurent.dto.MenuCategoryDTO;
import com.hms.restaurent.service.MenuCategoryService;
import com.hms.restaurent.service.RestaurantSessionService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/menu-category")
public class MenuCategoryController {

    @Autowired
    private MenuCategoryService service;

    @Autowired
    private RestaurantSessionService sessionService;

    // SAVE
    @PostMapping
    public MenuCategoryDTO save(@RequestBody MenuCategoryDTO dto, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.save(dto, restaurantUserId);
    }

    // FETCH ALL
    @GetMapping
    public List<MenuCategoryDTO> getAll(
            @RequestParam(required = false) String status,
            HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);

        if (status != null) {
            return service.findByStatus(status, restaurantUserId);
        }
        return service.findAll(restaurantUserId);
    }

    // FETCH BY ID (EDIT)
    @GetMapping("/{id}")
    public MenuCategoryDTO getById(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findById(id, restaurantUserId);
    }

    // UPDATE
    @PutMapping("/{id}")
    public MenuCategoryDTO update(@PathVariable Long id,
                                 @RequestBody MenuCategoryDTO dto,
                                 HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.update(id, dto, restaurantUserId);
    }

    // DELETE
    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        service.delete(id, restaurantUserId);
    }
}
