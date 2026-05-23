package com.hms.restaurent.repository;

import java.time.LocalDate;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.hms.entity.restaurent.OrderDailyCounter;

import jakarta.persistence.LockModeType;

public interface OrderDailyCounterRepository extends JpaRepository<OrderDailyCounter, Long> {

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query(
            "select c from OrderDailyCounter c "
                    + "where c.restaurantUserId = :restaurantUserId and c.counterDate = :counterDate")
    Optional<OrderDailyCounter> findByRestaurantUserIdAndCounterDateForUpdate(
            @Param("restaurantUserId") Long restaurantUserId,
            @Param("counterDate") LocalDate counterDate);
}
