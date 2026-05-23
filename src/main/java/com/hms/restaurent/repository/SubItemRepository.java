package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.SubItem;

public interface SubItemRepository extends JpaRepository<SubItem, Long> {

    List<SubItem> findByStatus(String status);

    List<SubItem> findByItem_Id(Long itemId);

    List<SubItem> findByItem_IdAndStatus(Long itemId, String status);

    boolean existsByNameIgnoreCaseAndItem_Id(String name, Long itemId);

    boolean existsByNameIgnoreCaseAndItem_IdAndIdNot(String name, Long itemId, Long id);

    boolean existsByItem_Id(Long itemId);

    List<SubItem> findByItem_Category_RestaurantUser_IdAndStatus(Long restaurantUserId, String status);

    List<SubItem> findByItem_Category_RestaurantUser_Id(Long restaurantUserId);

    List<SubItem> findByItem_Category_RestaurantUser_IdAndItem_Id(Long restaurantUserId, Long itemId);

    List<SubItem> findByItem_Category_RestaurantUser_IdAndItem_IdAndStatus(
            Long restaurantUserId,
            Long itemId,
            String status);

    Optional<SubItem> findByIdAndItem_Category_RestaurantUser_Id(Long id, Long restaurantUserId);

    boolean existsByNameIgnoreCaseAndItem_IdAndItem_Category_RestaurantUser_Id(
            String name,
            Long itemId,
            Long restaurantUserId);

    boolean existsByNameIgnoreCaseAndItem_IdAndItem_Category_RestaurantUser_IdAndIdNot(
            String name,
            Long itemId,
            Long restaurantUserId,
            Long id);

    boolean existsByItem_IdAndItem_Category_RestaurantUser_Id(Long itemId, Long restaurantUserId);
}
