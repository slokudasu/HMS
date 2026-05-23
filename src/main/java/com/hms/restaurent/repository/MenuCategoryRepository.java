package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.MenuCategory;

public interface MenuCategoryRepository extends JpaRepository<MenuCategory, Long> {
	List<MenuCategory> findByStatus(String status);
	
	boolean existsByNameIgnoreCase(String name);
	
	boolean existsByNameIgnoreCaseAndIdNot(String name, Long id);

	List<MenuCategory> findByRestaurantUser_Id(Long restaurantUserId);

	List<MenuCategory> findByRestaurantUser_IdAndStatus(Long restaurantUserId, String status);

	boolean existsByRestaurantUser_IdAndNameIgnoreCase(Long restaurantUserId, String name);

	boolean existsByRestaurantUser_IdAndNameIgnoreCaseAndIdNot(Long restaurantUserId, String name, Long id);

	Optional<MenuCategory> findByIdAndRestaurantUser_Id(Long id, Long restaurantUserId);

	boolean existsByIdAndRestaurantUser_Id(Long id, Long restaurantUserId);
}
