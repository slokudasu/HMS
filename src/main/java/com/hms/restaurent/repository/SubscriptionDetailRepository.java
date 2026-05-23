package com.hms.restaurent.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hms.entity.restaurent.SubscriptionDetail;

public interface SubscriptionDetailRepository extends JpaRepository<SubscriptionDetail, Long> {

    List<SubscriptionDetail> findAllByOrderByPaymentDateDesc();
}
