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

import com.hms.restaurent.dto.HallDTO;
import com.hms.restaurent.service.HallService;
import com.hms.restaurent.service.RestaurantSessionService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rooms")
public class HallController {

    @Autowired
    private HallService service;

    @Autowired
    private RestaurantSessionService sessionService;

    @PostMapping
    public HallDTO save(@RequestBody HallDTO dto, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.save(dto, restaurantUserId);
    }

    @GetMapping
    public List<HallDTO> getAll(
            @RequestParam(required = false) String status,
            HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        if ("ACTIVE".equalsIgnoreCase(status)) {
            return service.findActive(restaurantUserId);
        }
        return service.findAll(restaurantUserId);
    }

    @GetMapping("/{id}")
    public HallDTO getById(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findById(id, restaurantUserId);
    }

    @PutMapping("/{id}")
    public HallDTO update(@PathVariable Long id,
                          @RequestBody HallDTO dto,
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
