package com.hms.entity.restaurent.controller;

import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hms.restaurent.dto.RestaurantCustomerLookupResponseDTO;
import com.hms.restaurent.dto.RestaurantOrderRequestDTO;
import com.hms.restaurent.dto.RestaurantOrderResponseDTO;
import com.hms.restaurent.service.RestaurantOrderService;
import com.hms.restaurent.service.RestaurantSessionService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/orders")
public class RestaurantOrderController {

    @Autowired
    private RestaurantOrderService service;

    @Autowired
    private RestaurantSessionService sessionService;

    @PostMapping
    public RestaurantOrderResponseDTO save(@RequestBody RestaurantOrderRequestDTO dto, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.saveOrUpdateOpenOrder(dto, restaurantUserId);
    }

    @GetMapping("/table/{tableId}/open")
    public RestaurantOrderResponseDTO getOpenByTable(@PathVariable Long tableId, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findOpenOrderByTable(tableId, restaurantUserId);
    }

    @GetMapping("/customer/by-mobile")
    public RestaurantCustomerLookupResponseDTO getCustomerByMobile(@RequestParam String mobile, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.findCustomerByMobile(mobile, restaurantUserId);
    }

    @DeleteMapping("/table/{tableId}/open")
    public void deleteOpenByTable(@PathVariable Long tableId, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        service.deleteOpenOrderByTable(tableId, restaurantUserId);
    }

    @PostMapping("/table/{tableId}/complete")
    public RestaurantOrderResponseDTO completeOpenByTable(@PathVariable Long tableId, HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        return service.completeOpenOrderByTable(tableId, restaurantUserId);
    }

    @GetMapping("/completed/count")
    public Map<String, Object> getCompletedOrderCountByDate(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            HttpSession session) {
        Long restaurantUserId = sessionService.requireRestaurantUserId(session);
        LocalDate targetDate = date == null ? LocalDate.now() : date;
        long completedCount = service.countCompletedOrdersForDate(targetDate, restaurantUserId);

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("date", targetDate.toString());
        response.put("completedCount", completedCount);
        return response;
    }
}
