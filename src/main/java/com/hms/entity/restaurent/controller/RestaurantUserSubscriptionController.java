package com.hms.entity.restaurent.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.restaurent.dto.RestaurantSubscriptionDetailDTO;
import com.hms.restaurent.dto.RestaurantUserSubscriptionDTO;
import com.hms.restaurent.dto.RestaurantUserSubscriptionUpdateDTO;
import com.hms.restaurent.service.RestaurantAuthService;
import com.hms.restaurent.service.RestaurantSessionService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/restaurant-users")
public class RestaurantUserSubscriptionController {

    @Autowired
    private RestaurantAuthService restaurantAuthService;

    @Autowired
    private RestaurantSessionService sessionService;

    @GetMapping("/subscriptions")
    public List<RestaurantUserSubscriptionDTO> getAllSubscriptions(HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return restaurantAuthService.getAllUserSubscriptions();
    }

    @GetMapping("/subscription-details")
    public List<RestaurantSubscriptionDetailDTO> getAllSubscriptionDetails(HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return restaurantAuthService.getAllSubscriptionDetails();
    }

    @PutMapping("/{id}/subscription")
    public RestaurantUserSubscriptionDTO updateSubscription(
            @PathVariable Long id,
            @RequestBody RestaurantUserSubscriptionUpdateDTO request,
            HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return restaurantAuthService.updateUserSubscription(id, request);
    }
}
