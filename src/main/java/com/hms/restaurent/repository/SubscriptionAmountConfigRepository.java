package com.hms.restaurent.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.SubscriptionAmountConfig;

public interface SubscriptionAmountConfigRepository extends JpaRepository<SubscriptionAmountConfig, Long> {

    List<SubscriptionAmountConfig> findAllByOrderByIdAsc();

    Optional<SubscriptionAmountConfig> findBySubscriptionPlan(String subscriptionPlan);

    boolean existsBySubscriptionPlan(String subscriptionPlan);

    boolean existsBySubscriptionPlanAndIdNot(String subscriptionPlan, Long id);
}
