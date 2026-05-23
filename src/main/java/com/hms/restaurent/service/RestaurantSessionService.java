package com.hms.restaurent.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.RestaurantUser;
import com.hms.restaurent.repository.RestaurantUserRepository;

import jakarta.servlet.http.HttpSession;

@Service
public class RestaurantSessionService {

    @Autowired
    private RestaurantUserRepository restaurantUserRepository;

    public Long requireRestaurantUserId(HttpSession session) {
        if (session == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        }

        if (isSubscriptionExpired(session)) {
            throw new ResponseStatusException(HttpStatus.PAYMENT_REQUIRED, "Subscription expired. Please renew.");
        }

        Object userIdValue = session.getAttribute("restaurantUserId");
        if (userIdValue == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
        }

        if (userIdValue instanceof Number number) {
            long id = number.longValue();
            if (id > 0) {
                return id;
            }
        }

        String textValue = String.valueOf(userIdValue).trim();
        if (!textValue.isEmpty()) {
            try {
                long id = Long.parseLong(textValue);
                if (id > 0) {
                    return id;
                }
            } catch (NumberFormatException ignored) {
                // handled below
            }
        }

        throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Login required");
    }

    public Long requireAdminRestaurantUserId(HttpSession session) {
        Long userId = requireRestaurantUserId(session);
        if (!isAdminUser(session, userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Admin access required");
        }
        return userId;
    }

    public boolean isAdminUser(HttpSession session) {
        Long userId = requireRestaurantUserId(session);
        return isAdminUser(session, userId);
    }

    private boolean isAdminUser(HttpSession session, Long userId) {
        if (session == null || userId == null || userId <= 0) {
            return false;
        }

        Object adminValue = session.getAttribute("restaurantIsAdmin");
        Boolean fromSession = parseBoolean(adminValue);
        if (fromSession != null) {
            return fromSession;
        }

        boolean isAdminFromDb = restaurantUserRepository.findById(userId)
                .map(RestaurantUser::getAdminUser)
                .map(Boolean.TRUE::equals)
                .orElse(false);

        session.setAttribute("restaurantIsAdmin", isAdminFromDb);
        return isAdminFromDb;
    }

    private Boolean parseBoolean(Object value) {
        if (value == null) {
            return null;
        }

        if (value instanceof Boolean boolValue) {
            return boolValue;
        }

        String text = String.valueOf(value).trim();
        if (text.isEmpty()) {
            return null;
        }
        if ("true".equalsIgnoreCase(text)) {
            return true;
        }
        if ("false".equalsIgnoreCase(text)) {
            return false;
        }
        return null;
    }

    private boolean isSubscriptionExpired(HttpSession session) {
        if (session == null) {
            return false;
        }

        Object expiredValue = session.getAttribute("restaurantSubscriptionExpired");
        Boolean parsed = parseBoolean(expiredValue);
        return Boolean.TRUE.equals(parsed);
    }
}
