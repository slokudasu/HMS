package com.hms.restaurent.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.Order;

public interface OrderRepository extends JpaRepository<Order, Long> {

    Optional<Order> findFirstByTable_IdAndStatusOrderByCreatedAtDesc(Long tableId, String status);

    Optional<Order> findFirstByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtDesc(
            Long tableId,
            Long restaurantUserId,
            String status);

    List<Order> findByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtAsc(
            Long tableId,
            Long restaurantUserId,
            String status);

    Optional<Order> findFirstByTable_Hall_RestaurantUser_IdAndMobileAndCustomerNameIsNotNullOrderByCreatedAtDesc(
            Long restaurantUserId,
            String mobile);

    long countByTable_Hall_RestaurantUser_IdAndMobile(Long restaurantUserId, String mobile);

    long countByTable_Hall_RestaurantUser_IdAndCreatedAtGreaterThanEqualAndCreatedAtLessThanAndIdLessThanEqual(
            Long restaurantUserId,
            LocalDateTime dayStart,
            LocalDateTime nextDayStart,
            Long id);

    long countByTable_Hall_RestaurantUser_IdAndStatusAndCompletedAtGreaterThanEqualAndCompletedAtLessThan(
            Long restaurantUserId,
            String status,
            LocalDateTime dayStart,
            LocalDateTime nextDayStart);
}
