package com.hms.entity.restaurent;

import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table(
        name = "order_daily_counter",
        uniqueConstraints = {
                @UniqueConstraint(columnNames = {"restaurant_user_id", "counter_date"})
        })
public class OrderDailyCounter {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "restaurant_user_id", nullable = false)
    private Long restaurantUserId;

    @Column(name = "counter_date", nullable = false)
    private LocalDate counterDate;

    @Column(name = "last_order_number", nullable = false)
    private Long lastOrderNumber;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getRestaurantUserId() {
        return restaurantUserId;
    }

    public void setRestaurantUserId(Long restaurantUserId) {
        this.restaurantUserId = restaurantUserId;
    }

    public LocalDate getCounterDate() {
        return counterDate;
    }

    public void setCounterDate(LocalDate counterDate) {
        this.counterDate = counterDate;
    }

    public Long getLastOrderNumber() {
        return lastOrderNumber;
    }

    public void setLastOrderNumber(Long lastOrderNumber) {
        this.lastOrderNumber = lastOrderNumber;
    }
}
