package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.RestaurantTable;

public interface TableRepository extends JpaRepository<RestaurantTable, Long> {

    List<RestaurantTable> findByStatus(String status);
    
    List<RestaurantTable> findByHall_Id(Long hallId);
    
    List<RestaurantTable> findByHall_IdAndStatus(Long hallId, String status);
    
    boolean existsByTableNameIgnoreCaseAndHall_Id(String tableName, Long hallId);
    
    boolean existsByTableNameIgnoreCaseAndHall_IdAndIdNot(String tableName, Long hallId, Long id);

    List<RestaurantTable> findByHall_RestaurantUser_IdAndStatus(Long restaurantUserId, String status);

    List<RestaurantTable> findByHall_RestaurantUser_Id(Long restaurantUserId);

    List<RestaurantTable> findByHall_RestaurantUser_IdAndHall_Id(Long restaurantUserId, Long hallId);

    List<RestaurantTable> findByHall_RestaurantUser_IdAndHall_IdAndStatus(
            Long restaurantUserId,
            Long hallId,
            String status);

    boolean existsByTableNameIgnoreCaseAndHall_IdAndHall_RestaurantUser_Id(
            String tableName,
            Long hallId,
            Long restaurantUserId);

    boolean existsByTableNameIgnoreCaseAndHall_IdAndHall_RestaurantUser_IdAndIdNot(
            String tableName,
            Long hallId,
            Long restaurantUserId,
            Long id);

    Optional<RestaurantTable> findByIdAndHall_RestaurantUser_Id(Long id, Long restaurantUserId);

    boolean existsByIdAndHall_RestaurantUser_Id(Long id, Long restaurantUserId);

}
