package com.hms.restaurent.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.SubscriptionAmountConfig;
import com.hms.restaurent.dto.SubscriptionAmountConfigDTO;
import com.hms.restaurent.repository.SubscriptionAmountConfigRepository;

@Service
public class SubscriptionAmountConfigService {

    private static final String PLAN_MONTHLY = "MONTHLY";
    private static final String PLAN_QUARTERLY = "QUARTERLY";
    private static final String PLAN_HALF_YEARLY = "HALF_YEARLY";
    private static final String PLAN_YEARLY = "YEARLY";

    private static final Map<String, BigDecimal> DEFAULT_AMOUNTS;

    static {
        Map<String, BigDecimal> defaults = new LinkedHashMap<>();
        defaults.put(PLAN_MONTHLY, new BigDecimal("499.00"));
        defaults.put(PLAN_QUARTERLY, new BigDecimal("1399.00"));
        defaults.put(PLAN_HALF_YEARLY, new BigDecimal("2599.00"));
        defaults.put(PLAN_YEARLY, new BigDecimal("4999.00"));
        DEFAULT_AMOUNTS = defaults;
    }

    @Autowired
    private SubscriptionAmountConfigRepository repository;

    @Transactional(readOnly = true)
    public List<SubscriptionAmountConfigDTO> findAll() {
        return repository.findAllByOrderByIdAsc()
                .stream()
                .map(this::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public SubscriptionAmountConfigDTO findById(Long id) {
        SubscriptionAmountConfig entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Subscription amount not found"));
        return toDto(entity);
    }

    @Transactional
    public SubscriptionAmountConfigDTO save(SubscriptionAmountConfigDTO dto) {
        if (dto == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request body is required");
        }

        String plan = normalizeSubscriptionPlan(dto.getSubscriptionPlan());
        BigDecimal amount = normalizeAmount(dto.getAmount());

        if (repository.existsBySubscriptionPlan(plan)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Subscription plan amount already exists");
        }

        SubscriptionAmountConfig entity = new SubscriptionAmountConfig();
        entity.setSubscriptionPlan(plan);
        entity.setAmount(amount);
        entity.setCreatedAt(LocalDateTime.now());
        entity.setUpdatedAt(LocalDateTime.now());

        return toDto(repository.save(entity));
    }

    @Transactional
    public SubscriptionAmountConfigDTO update(Long id, SubscriptionAmountConfigDTO dto) {
        if (id == null || id <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid subscription amount id");
        }
        if (dto == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request body is required");
        }

        SubscriptionAmountConfig entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Subscription amount not found"));

        String plan = normalizeSubscriptionPlan(dto.getSubscriptionPlan());
        BigDecimal amount = normalizeAmount(dto.getAmount());

        if (repository.existsBySubscriptionPlanAndIdNot(plan, id)) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Subscription plan amount already exists");
        }

        entity.setSubscriptionPlan(plan);
        entity.setAmount(amount);
        entity.setUpdatedAt(LocalDateTime.now());

        return toDto(repository.save(entity));
    }

    @Transactional
    public void delete(Long id) {
        if (id == null || id <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid subscription amount id");
        }

        SubscriptionAmountConfig entity = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Subscription amount not found"));
        repository.delete(entity);
    }

    @Transactional(readOnly = true)
    public BigDecimal getAmountByPlan(String subscriptionPlan) {
        String normalizedPlan = normalizeSubscriptionPlan(subscriptionPlan);
        return repository.findBySubscriptionPlan(normalizedPlan)
                .map(SubscriptionAmountConfig::getAmount)
                .map(this::normalizeAmount)
                .orElseGet(() -> normalizeAmount(DEFAULT_AMOUNTS.get(normalizedPlan)));
    }

    @Transactional(readOnly = true)
    public Map<String, String> getEffectivePlanAmounts() {
        Map<String, String> result = new LinkedHashMap<>();
        result.put(PLAN_MONTHLY, formatAmount(getAmountByPlan(PLAN_MONTHLY)));
        result.put(PLAN_QUARTERLY, formatAmount(getAmountByPlan(PLAN_QUARTERLY)));
        result.put(PLAN_HALF_YEARLY, formatAmount(getAmountByPlan(PLAN_HALF_YEARLY)));
        result.put(PLAN_YEARLY, formatAmount(getAmountByPlan(PLAN_YEARLY)));
        return result;
    }

    @Transactional(readOnly = true)
    public String getFormattedAmountByPlan(String subscriptionPlan) {
        return formatAmount(getAmountByPlan(subscriptionPlan));
    }

    private SubscriptionAmountConfigDTO toDto(SubscriptionAmountConfig entity) {
        SubscriptionAmountConfigDTO dto = new SubscriptionAmountConfigDTO();
        dto.setId(entity.getId());
        dto.setSubscriptionPlan(entity.getSubscriptionPlan());
        dto.setAmount(entity.getAmount() == null ? null : normalizeAmount(entity.getAmount()));
        return dto;
    }

    private String normalizeSubscriptionPlan(String plan) {
        if (plan == null || plan.trim().isEmpty()) {
            throw new ResponseStatusException(
                    HttpStatus.BAD_REQUEST,
                    "Subscription plan is required (MONTHLY, QUARTERLY, HALF_YEARLY, YEARLY)");
        }

        String normalized = plan.trim().toUpperCase(Locale.ROOT)
                .replace("-", "_")
                .replace(" ", "_");

        if ("QUATRLY".equals(normalized)) {
            normalized = PLAN_QUARTERLY;
        }
        if ("HALFYEAR".equals(normalized) || "HALF_YEAR".equals(normalized)) {
            normalized = PLAN_HALF_YEARLY;
        }

        if (PLAN_MONTHLY.equals(normalized)
                || PLAN_QUARTERLY.equals(normalized)
                || PLAN_HALF_YEARLY.equals(normalized)
                || PLAN_YEARLY.equals(normalized)) {
            return normalized;
        }

        throw new ResponseStatusException(
                HttpStatus.BAD_REQUEST,
                "Invalid subscription plan. Allowed: MONTHLY, QUARTERLY, HALF_YEARLY, YEARLY");
    }

    private BigDecimal normalizeAmount(BigDecimal amount) {
        if (amount == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Subscription amount is required");
        }
        if (amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Subscription amount must be greater than zero");
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private String formatAmount(BigDecimal amount) {
        return normalizeAmount(amount).toPlainString();
    }
}
