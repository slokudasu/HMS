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
import org.springframework.web.bind.annotation.RestController;

import com.hms.restaurent.dto.SubscriptionAmountConfigDTO;
import com.hms.restaurent.service.RestaurantSessionService;
import com.hms.restaurent.service.SubscriptionAmountConfigService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/subscription-amounts")
public class SubscriptionAmountConfigController {

    @Autowired
    private SubscriptionAmountConfigService service;

    @Autowired
    private RestaurantSessionService sessionService;

    @GetMapping
    public List<SubscriptionAmountConfigDTO> getAll(HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return service.findAll();
    }

    @GetMapping("/{id}")
    public SubscriptionAmountConfigDTO getById(@PathVariable Long id, HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return service.findById(id);
    }

    @PostMapping
    public SubscriptionAmountConfigDTO save(@RequestBody SubscriptionAmountConfigDTO dto, HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return service.save(dto);
    }

    @PutMapping("/{id}")
    public SubscriptionAmountConfigDTO update(@PathVariable Long id,
                                              @RequestBody SubscriptionAmountConfigDTO dto,
                                              HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        return service.update(id, dto);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id, HttpSession session) {
        sessionService.requireAdminRestaurantUserId(session);
        service.delete(id);
    }
}
