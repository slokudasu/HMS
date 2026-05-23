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

import com.hms.restaurent.dto.RestaurantSubItemDTO;
import com.hms.restaurent.service.RestaurantSessionService;
import com.hms.restaurent.service.RestaurantSubItemService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/sub-items")
public class RestaurantSubItemController {

    @Autowired
    private RestaurantSubItemService service;

    @Autowired
    private RestaurantSessionService sessionService;

    @PostMapping
    public RestaurantSubItemDTO save(@RequestBody RestaurantSubItemDTO dto, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.save(dto, restaurantUserId);
    }

    @GetMapping
    public List<RestaurantSubItemDTO> getAll(
            @RequestParam(required = false) Long itemId,
            @RequestParam(required = false) String status,
            HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findAll(itemId, status, restaurantUserId);
    }

    @GetMapping("/{id}")
    public RestaurantSubItemDTO getById(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findById(id, restaurantUserId);
    }

    @PutMapping("/{id}")
    public RestaurantSubItemDTO update(@PathVariable Long id,
                                       @RequestBody RestaurantSubItemDTO dto,
                                       HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.update(id, dto, restaurantUserId);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        service.delete(id, restaurantUserId);
    }
}
