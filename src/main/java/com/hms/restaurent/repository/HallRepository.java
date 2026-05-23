package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.Hall;

public interface HallRepository extends JpaRepository<Hall, Long> {

    List<Hall> findByStatus(String status);
    
    boolean existsByNameIgnoreCase(String name);
    
    boolean existsByNameIgnoreCaseAndIdNot(String name, Long id);

    List<Hall> findByRestaurantUser_Id(Long restaurantUserId);

    List<Hall> findByRestaurantUser_IdAndStatus(Long restaurantUserId, String status);

    boolean existsByRestaurantUser_IdAndNameIgnoreCase(Long restaurantUserId, String name);

    boolean existsByRestaurantUser_IdAndNameIgnoreCaseAndIdNot(Long restaurantUserId, String name, Long id);

    Optional<Hall> findByIdAndRestaurantUser_Id(Long id, Long restaurantUserId);

    boolean existsByIdAndRestaurantUser_Id(Long id, Long restaurantUserId);

}	
