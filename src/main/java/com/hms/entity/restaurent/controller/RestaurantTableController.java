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

import com.hms.restaurent.dto.RestaurantTableDTO;
import com.hms.restaurent.service.RestaurantSessionService;
import com.hms.restaurent.service.RestaurantTableService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/tables")
public class RestaurantTableController {

    @Autowired
    private RestaurantTableService service;

    @Autowired
    private RestaurantSessionService sessionService;

    @PostMapping
    public RestaurantTableDTO save(@RequestBody RestaurantTableDTO dto, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.save(dto, restaurantUserId);
    }

    @GetMapping
    public List<RestaurantTableDTO> getAll(
            @RequestParam(required = false) Long hallId,
            @RequestParam(required = false) String status,
            HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findAll(hallId, status, restaurantUserId);
    }

    @GetMapping("/{id}")
    public RestaurantTableDTO getById(@PathVariable Long id, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findById(id, restaurantUserId);
    }

    @PutMapping("/{id}")
    public RestaurantTableDTO update(@PathVariable Long id,
                                     @RequestBody RestaurantTableDTO dto,
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
