package com.hms.restaurent.service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.RestaurantUser;
import com.hms.entity.restaurent.SubscriptionDetail;
import com.hms.restaurent.dto.RestaurantSubscriptionDetailDTO;
import com.hms.restaurent.dto.RestaurantUserSubscriptionDTO;
import com.hms.restaurent.dto.RestaurantUserSubscriptionUpdateDTO;
import com.hms.restaurent.repository.RestaurantUserRepository;
import com.hms.restaurent.repository.SubscriptionDetailRepository;

@Service
public class RestaurantAuthService {

    private static final DateTimeFormatter DISPLAY_DATE_FORMATTER = DateTimeFormatter.ofPattern("dd-MM-yyyy");
    private static final String PLAN_MONTHLY = "MONTHLY";
    private static final String PLAN_QUARTERLY = "QUARTERLY";
    private static final String PLAN_HALF_YEARLY = "HALF_YEARLY";
    private static final String PLAN_YEARLY = "YEARLY";
    private static final String PAYMENT_MODE_MANUAL = "MANUAL";
    private static final String PAYMENT_MODE_SCAN = "SCAN";
    private static final String PAYMENT_MODE_UPI_INTENT = "UPI_INTENT";
    private static final String PAYMENT_MODE_CARD = "CARD";
    private static final String PAYMENT_MODE_NET_BANKING = "NET_BANKING";
    private static final String PAYMENT_MODE_WALLET = "WALLET";

    @Autowired
    private RestaurantUserRepository restaurantUserRepository;

    @Autowired
    private SubscriptionDetailRepository subscriptionDetailRepository;

    @Transactional
    public RestaurantUser register(String mobileNo, String email, String restaurantName, String password) {
        String normalizedMobileNo = normalizeMobileNo(mobileNo);
        String normalizedEmail = normalizeEmail(email);
        String normalizedRestaurantName = normalizeRestaurantName(restaurantName);
        String normalizedPassword = normalizePassword(password);

        if (restaurantUserRepository.existsByMobileNo(normalizedMobileNo)) {
            throw new IllegalArgumentException("Mobile number already registered");
        }

        if (restaurantUserRepository.existsByEmailIgnoreCase(normalizedEmail)) {
            throw new IllegalArgumentException("Email already registered");
        }

        RestaurantUser user = new RestaurantUser();
        user.setMobileNo(normalizedMobileNo);
        user.setEmail(normalizedEmail);
        user.setRestaurantName(normalizedRestaurantName);
        user.setPassword(normalizedPassword);
        user.setCreatedAt(LocalDateTime.now());
        user.setAdminUser(!restaurantUserRepository.existsByAdminUserTrue());
        assignInitialSubscriptionForNewUser(user);

        return restaurantUserRepository.save(user);
    }

    @Transactional
    public RestaurantUser authenticate(String mobileNo, String password) {
        String normalizedMobileNo = normalizeMobileNo(mobileNo);
        String normalizedPassword = normalizePassword(password);

        Optional<RestaurantUser> userOptional = restaurantUserRepository.findByMobileNo(normalizedMobileNo);
        if (userOptional.isEmpty()) {
            throw new IllegalArgumentException("Invalid mobile number or password");
        }

        RestaurantUser user = userOptional.get();
        if (!user.getPassword().equals(normalizedPassword)) {
            throw new IllegalArgumentException("Invalid mobile number or password");
        }

        ensureAdminUserForLegacyData(user);

        if (ensureSubscriptionInitialized(user)) {
            restaurantUserRepository.save(user);
        }

        return user;
    }

    @Transactional
    public RestaurantUser renewSubscriptionForUser(Long userId, String subscriptionPlan) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("Login required");
        }

        RestaurantUser user = restaurantUserRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        String plan = normalizeSubscriptionPlan(subscriptionPlan);
        assignSubscription(user, plan, LocalDate.now());
        return restaurantUserRepository.save(user);
    }

    @Transactional
    public void recordSubscriptionPayment(
            Long userId,
            String subscriptionPlan,
            String transactionId,
            BigDecimal amount,
            String paymentMode) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("Login required");
        }

        RestaurantUser user = restaurantUserRepository.findById(userId)
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        SubscriptionDetail detail = new SubscriptionDetail();
        detail.setRestaurantUser(user);
        detail.setSubscriptionPlan(normalizeSubscriptionPlan(subscriptionPlan));
        detail.setAmount(normalizeAmount(amount));
        detail.setTransactionId(normalizeTransactionId(transactionId));
        detail.setPaymentMode(normalizePaymentMode(paymentMode));
        detail.setSubscriptionStartDate(user.getSubscriptionStartDate());
        detail.setSubscriptionEndDate(user.getSubscriptionEndDate());

        LocalDateTime paymentTime = LocalDateTime.now();
        detail.setPaymentDate(paymentTime);
        detail.setCreatedAt(paymentTime);
        subscriptionDetailRepository.save(detail);
    }

    @Transactional(readOnly = true)
    public List<RestaurantUserSubscriptionDTO> getAllUserSubscriptions() {
        LocalDate today = LocalDate.now();
        return restaurantUserRepository.findAllByOrderByCreatedAtDesc()
                .stream()
                .map(user -> toSubscriptionDto(user, today))
                .toList();
    }

    @Transactional(readOnly = true)
    public List<RestaurantSubscriptionDetailDTO> getAllSubscriptionDetails() {
        return subscriptionDetailRepository.findAllByOrderByPaymentDateDesc()
                .stream()
                .map(this::toSubscriptionDetailDto)
                .toList();
    }

    @Transactional
    public RestaurantUserSubscriptionDTO updateUserSubscription(Long userId, RestaurantUserSubscriptionUpdateDTO request) {
        if (userId == null || userId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "User id is required");
        }

        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request body is required");
        }

        RestaurantUser user = restaurantUserRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        String plan = normalizeSubscriptionPlan(request.getSubscriptionPlan());
        LocalDate startDate = normalizeDate(request.getSubscriptionStartDate(), "Subscription start date is required");

        assignSubscription(user, plan, startDate);
        RestaurantUser updated = restaurantUserRepository.save(user);
        return toSubscriptionDto(updated, LocalDate.now());
    }

    @Transactional
    public void resetPassword(String mobileNo, String newPassword, String confirmPassword) {
        String normalizedMobileNo = normalizeMobileNo(mobileNo);
        String normalizedPassword = normalizePassword(newPassword);
        String normalizedConfirmPassword = normalizePassword(confirmPassword);

        if (!normalizedPassword.equals(normalizedConfirmPassword)) {
            throw new IllegalArgumentException("Password and confirm password must match");
        }

        RestaurantUser user = restaurantUserRepository.findByMobileNo(normalizedMobileNo)
                .orElseThrow(() -> new IllegalArgumentException("Mobile number not registered"));

        user.setPassword(normalizedPassword);
        restaurantUserRepository.save(user);
    }

    private RestaurantUserSubscriptionDTO toSubscriptionDto(RestaurantUser user, LocalDate today) {
        RestaurantUserSubscriptionDTO dto = new RestaurantUserSubscriptionDTO();
        dto.setId(user.getId());
        dto.setRestaurantName(user.getRestaurantName());
        dto.setMobileNo(user.getMobileNo());
        dto.setEmail(user.getEmail());
        dto.setSubscriptionPlan(user.getSubscriptionPlan());
        dto.setSubscriptionStartDate(formatDate(user.getSubscriptionStartDate()));
        dto.setSubscriptionEndDate(formatDate(user.getSubscriptionEndDate()));
        dto.setSubscriptionActive(!isSubscriptionExpired(user, today));
        return dto;
    }

    private RestaurantSubscriptionDetailDTO toSubscriptionDetailDto(SubscriptionDetail detail) {
        RestaurantSubscriptionDetailDTO dto = new RestaurantSubscriptionDetailDTO();
        dto.setId(detail.getId());
        if (detail.getRestaurantUser() != null) {
            dto.setRestaurantUserId(detail.getRestaurantUser().getId());
            dto.setRestaurantName(detail.getRestaurantUser().getRestaurantName());
            dto.setMobileNo(detail.getRestaurantUser().getMobileNo());
            dto.setEmail(detail.getRestaurantUser().getEmail());
        }
        dto.setSubscriptionPlan(detail.getSubscriptionPlan());
        dto.setAmount(formatAmount(detail.getAmount()));
        dto.setTransactionId(detail.getTransactionId());
        dto.setPaymentMode(detail.getPaymentMode());
        dto.setSubscriptionStartDate(formatDate(detail.getSubscriptionStartDate()));
        dto.setSubscriptionEndDate(formatDate(detail.getSubscriptionEndDate()));
        dto.setPaymentDate(formatDateTime(detail.getPaymentDate()));
        return dto;
    }

    private boolean ensureSubscriptionInitialized(RestaurantUser user) {
        LocalDate startDate = user.getSubscriptionStartDate();
        String plan = user.getSubscriptionPlan();
        LocalDate endDate = user.getSubscriptionEndDate();

        if (startDate != null && hasText(plan) && endDate != null) {
            return false;
        }

        assignSubscription(user, PLAN_MONTHLY, LocalDate.now());
        return true;
    }

    private void ensureAdminUserForLegacyData(RestaurantUser loggedInUser) {
        if (restaurantUserRepository.existsByAdminUserTrue()) {
            return;
        }

        Optional<RestaurantUser> firstUserOptional = restaurantUserRepository.findFirstByOrderByIdAsc();
        if (firstUserOptional.isEmpty()) {
            return;
        }

        RestaurantUser firstUser = firstUserOptional.get();
        if (!Boolean.TRUE.equals(firstUser.getAdminUser())) {
            firstUser.setAdminUser(true);
            restaurantUserRepository.save(firstUser);
        }

        if (loggedInUser.getId() != null && loggedInUser.getId().equals(firstUser.getId())) {
            loggedInUser.setAdminUser(true);
        }
    }

    private void assignSubscription(RestaurantUser user, String plan, LocalDate startDate) {
        String normalizedPlan = normalizeSubscriptionPlan(plan);
        LocalDate normalizedStartDate = startDate == null ? LocalDate.now() : startDate;
        LocalDate calculatedEndDate = calculateSubscriptionEndDate(normalizedStartDate, normalizedPlan);

        user.setSubscriptionPlan(normalizedPlan);
        user.setSubscriptionStartDate(normalizedStartDate);
        user.setSubscriptionEndDate(calculatedEndDate);
    }

    private void assignInitialSubscriptionForNewUser(RestaurantUser user) {
        // New users should pass subscription verification on first login.
        assignSubscription(user, PLAN_MONTHLY, LocalDate.now().minusMonths(1));
    }

    private LocalDate calculateSubscriptionEndDate(LocalDate startDate, String plan) {
        if (PLAN_MONTHLY.equals(plan)) {
            return startDate.plusMonths(1).minusDays(1);
        }
        if (PLAN_QUARTERLY.equals(plan)) {
            return startDate.plusMonths(3).minusDays(1);
        }
        if (PLAN_HALF_YEARLY.equals(plan)) {
            return startDate.plusMonths(6).minusDays(1);
        }
        if (PLAN_YEARLY.equals(plan)) {
            return startDate.plusYears(1).minusDays(1);
        }
        throw new IllegalArgumentException("Invalid subscription plan");
    }

    private boolean isSubscriptionExpired(RestaurantUser user, LocalDate today) {
        if (user == null || user.getSubscriptionEndDate() == null) {
            return false;
        }
        return today.isAfter(user.getSubscriptionEndDate());
    }

    public boolean isSubscriptionExpired(RestaurantUser user) {
        return isSubscriptionExpired(user, LocalDate.now());
    }

    public String formatSubscriptionEndDate(RestaurantUser user) {
        if (user == null || user.getSubscriptionEndDate() == null) {
            return null;
        }
        return user.getSubscriptionEndDate().format(DISPLAY_DATE_FORMATTER);
    }

    private String normalizeSubscriptionPlan(String plan) {
        if (!hasText(plan)) {
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

    private LocalDate normalizeDate(String value, String message) {
        if (!hasText(value)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, message);
        }
        try {
            return LocalDate.parse(value.trim(), DateTimeFormatter.ISO_DATE);
        } catch (DateTimeParseException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Date must be in YYYY-MM-DD format");
        }
    }

    private String formatDate(LocalDate date) {
        if (date == null) {
            return null;
        }
        return date.format(DateTimeFormatter.ISO_DATE);
    }

    private String formatDateTime(LocalDateTime dateTime) {
        if (dateTime == null) {
            return null;
        }
        return dateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    private String formatAmount(BigDecimal amount) {
        if (amount == null) {
            return "0.00";
        }
        return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    private BigDecimal normalizeAmount(BigDecimal amount) {
        if (amount == null || amount.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Invalid subscription amount");
        }
        return amount.setScale(2, RoundingMode.HALF_UP);
    }

    private String normalizeTransactionId(String transactionId) {
        if (!hasText(transactionId)) {
            throw new IllegalArgumentException("Transaction ID is required");
        }

        String normalized = transactionId.trim();
        if (normalized.length() < 6 || normalized.length() > 50) {
            throw new IllegalArgumentException("Invalid transaction ID");
        }
        return normalized;
    }

    private String normalizePaymentMode(String paymentMode) {
        if (!hasText(paymentMode)) {
            return PAYMENT_MODE_MANUAL;
        }

        String normalized = paymentMode.trim().toUpperCase(Locale.ROOT)
                .replace("-", "_")
                .replace(" ", "_");

        if ("UPI".equals(normalized) || "UPI_APP".equals(normalized)) {
            return PAYMENT_MODE_UPI_INTENT;
        }
        if ("UPI_SCAN".equals(normalized)) {
            return PAYMENT_MODE_SCAN;
        }
        if ("NETBANKING".equals(normalized)) {
            return PAYMENT_MODE_NET_BANKING;
        }

        if (PAYMENT_MODE_SCAN.equals(normalized)
                || PAYMENT_MODE_MANUAL.equals(normalized)
                || PAYMENT_MODE_UPI_INTENT.equals(normalized)
                || PAYMENT_MODE_CARD.equals(normalized)
                || PAYMENT_MODE_NET_BANKING.equals(normalized)
                || PAYMENT_MODE_WALLET.equals(normalized)) {
            return normalized;
        }
        return PAYMENT_MODE_MANUAL;
    }

    private String normalizeMobileNo(String mobileNo) {
        if (mobileNo == null) {
            throw new IllegalArgumentException("Mobile number is required");
        }

        String digitsOnly = mobileNo.replaceAll("[^0-9]", "");
        if (digitsOnly.length() < 10 || digitsOnly.length() > 15) {
            throw new IllegalArgumentException("Enter valid mobile number");
        }

        return digitsOnly;
    }

    private String normalizeEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email is required");
        }
        String normalized = email.trim().toLowerCase(Locale.ROOT);
        if (!normalized.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$")) {
            throw new IllegalArgumentException("Enter valid email");
        }
        return normalized;
    }

    private String normalizeRestaurantName(String restaurantName) {
        if (restaurantName == null || restaurantName.trim().isEmpty()) {
            throw new IllegalArgumentException("Restaurant name is required");
        }
        return restaurantName.trim();
    }

    private String normalizePassword(String password) {
        if (password == null || password.trim().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        return password.trim();
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
