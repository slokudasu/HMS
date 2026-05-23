package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {

    List<Item> findByStatus(String status);

    List<Item> findByCategory_Id(Long categoryId);

    List<Item> findByCategory_IdAndStatus(Long categoryId, String status);

    boolean existsByNameIgnoreCaseAndCategory_Id(String name, Long categoryId);

    boolean existsByNameIgnoreCaseAndCategory_IdAndIdNot(String name, Long categoryId, Long id);

    List<Item> findByCategory_RestaurantUser_IdAndStatus(Long restaurantUserId, String status);

    List<Item> findByCategory_RestaurantUser_Id(Long restaurantUserId);

    List<Item> findByCategory_RestaurantUser_IdAndCategory_Id(Long restaurantUserId, Long categoryId);

    List<Item> findByCategory_RestaurantUser_IdAndCategory_IdAndStatus(Long restaurantUserId, Long categoryId, String status);

    Optional<Item> findByIdAndCategory_RestaurantUser_Id(Long id, Long restaurantUserId);

    boolean existsByNameIgnoreCaseAndCategory_IdAndCategory_RestaurantUser_Id(
            String name,
            Long categoryId,
            Long restaurantUserId);

    boolean existsByNameIgnoreCaseAndCategory_IdAndCategory_RestaurantUser_IdAndIdNot(
            String name,
            Long categoryId,
            Long restaurantUserId,
            Long id);
}
