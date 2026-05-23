package com.hms.controller;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;
import java.util.Map;

import javax.imageio.ImageIO;

import org.springframework.http.CacheControl;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.server.ResponseStatusException;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.hms.entity.restaurent.RestaurantUser;
import com.hms.restaurent.service.RestaurantAuthService;
import com.hms.restaurent.service.SubscriptionAmountConfigService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class RestaurantAuthController {

    private static final String UPI_PAYEE_ID = "9666705710@ybl";
    private static final String UPI_PAYEE_NAME = "Gayatri Member Association";
    private static final String PAYMENT_MODE_MANUAL = "MANUAL";
    private static final String PAYMENT_MODE_SCAN = "SCAN";
    private static final String PAYMENT_MODE_UPI_INTENT = "UPI_INTENT";
    private static final String PAYMENT_MODE_CARD = "CARD";
    private static final String PAYMENT_MODE_NET_BANKING = "NET_BANKING";
    private static final String PAYMENT_MODE_WALLET = "WALLET";

    @Autowired
    private RestaurantAuthService restaurantAuthService;

    @Autowired
    private SubscriptionAmountConfigService subscriptionAmountConfigService;

    @GetMapping("/")
    public String root(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }
        return "index";
    }

    @PostMapping("/login")
    public String login(@RequestParam("mobileNo") String mobileNo,
                        @RequestParam("password") String password,
                        HttpSession session,
                        Model model) {
        try {
            RestaurantUser user = restaurantAuthService.authenticate(mobileNo, password);
            session.setAttribute("restaurantUserId", user.getId());
            session.setAttribute("restaurantName", user.getRestaurantName());
            session.setAttribute("restaurantMobileNo", user.getMobileNo());
            session.setAttribute("restaurantIsAdmin", Boolean.TRUE.equals(user.getAdminUser()));
            boolean expired = restaurantAuthService.isSubscriptionExpired(user);
            session.setAttribute("restaurantSubscriptionExpired", expired);
            session.setAttribute("restaurantSubscriptionPlan", user.getSubscriptionPlan());
            session.setAttribute("restaurantSubscriptionEndDate", restaurantAuthService.formatSubscriptionEndDate(user));

            if (expired) {
                return "redirect:/subscription-payment";
            }
            return "redirect:/rest";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("mobileNo", mobileNo);
            return "index";
        }
    }

    @GetMapping("/signup")
    public String signupPage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }
        return "registration";
    }

    @GetMapping("/registration")
    public String registrationAlias(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }
        return "registration";
    }

    @GetMapping("/subscription-payment")
    public String subscriptionPaymentPage(HttpSession session, Model model) {
        if (session.getAttribute("restaurantUserId") == null) {
            return "redirect:/login";
        }

        if (!isSubscriptionExpiredSession(session)) {
            return "redirect:/rest";
        }

        String selectedPlan = normalizePaymentPlan(String.valueOf(
                session.getAttribute("restaurantSubscriptionPlan") == null
                        ? "MONTHLY"
                        : session.getAttribute("restaurantSubscriptionPlan")));

        model.addAttribute("restaurantName", session.getAttribute("restaurantName"));
        model.addAttribute("subscriptionEndDate", session.getAttribute("restaurantSubscriptionEndDate"));
        model.addAttribute("selectedPlan", selectedPlan);
        populateSubscriptionAmountAttributes(model, selectedPlan);
        model.addAttribute("upiPayeeId", UPI_PAYEE_ID);
        model.addAttribute("upiPayeeName", UPI_PAYEE_NAME);
        model.addAttribute("paymentMode", PAYMENT_MODE_UPI_INTENT);
        return "subscriptionPayment";
    }

    @PostMapping("/subscription-payment")
    public String subscriptionPayment(@RequestParam("subscriptionPlan") String subscriptionPlan,
                                      @RequestParam(value = "transactionId", required = false) String transactionId,
                                      @RequestParam(value = "paymentMode", required = false) String paymentMode,
                                      HttpSession session,
                                      Model model,
                                      RedirectAttributes redirectAttributes) {
        Long userId = resolveUserId(session);
        if (userId == null || userId <= 0) {
            return "redirect:/login";
        }
        if (!isSubscriptionExpiredSession(session)) {
            return "redirect:/restaurantHomePage.jsp";
        }

        try {
            String normalizedPlan = normalizePaymentPlan(subscriptionPlan);
            String normalizedPaymentMode = normalizePaymentMode(paymentMode);
            String effectiveTransactionId = resolveTransactionId(transactionId, normalizedPaymentMode);
            BigDecimal amount = subscriptionAmountConfigService.getAmountByPlan(normalizedPlan);

            RestaurantUser user = restaurantAuthService.renewSubscriptionForUser(userId, normalizedPlan);
            restaurantAuthService.recordSubscriptionPayment(
                    userId,
                    normalizedPlan,
                    effectiveTransactionId,
                    amount,
                    normalizedPaymentMode);
            session.setAttribute("restaurantSubscriptionExpired", false);
            session.setAttribute("restaurantSubscriptionPlan", user.getSubscriptionPlan());
            session.setAttribute("restaurantSubscriptionEndDate", restaurantAuthService.formatSubscriptionEndDate(user));
            redirectAttributes.addFlashAttribute("successMessage",
                    "Subscription payment successful. Transaction: " + effectiveTransactionId);
            return "redirect:/restaurantHomePage.jsp";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("restaurantName", session.getAttribute("restaurantName"));
            model.addAttribute("subscriptionEndDate", session.getAttribute("restaurantSubscriptionEndDate"));
            String selectedPlan = safePaymentPlan(subscriptionPlan);
            model.addAttribute("selectedPlan", selectedPlan);
            populateSubscriptionAmountAttributes(model, selectedPlan);
            model.addAttribute("upiPayeeId", UPI_PAYEE_ID);
            model.addAttribute("upiPayeeName", UPI_PAYEE_NAME);
            model.addAttribute("transactionId", transactionId);
            model.addAttribute("paymentMode", normalizePaymentMode(paymentMode));
            return "subscriptionPayment";
        }
    }

    @GetMapping("/subscription-payment/upi-callback")
    public String subscriptionPaymentUpiCallback(@RequestParam Map<String, String> params,
                                                 HttpSession session,
                                                 RedirectAttributes redirectAttributes) {
        Long userId = resolveUserId(session);
        if (userId == null || userId <= 0) {
            return "redirect:/login";
        }

        if (!isSubscriptionExpiredSession(session)) {
            return "redirect:/restaurantHomePage.jsp";
        }

        String status = findParamIgnoreCase(params, "status", "txnStatus", "txnstatus", "result");
        String responseCode = findParamIgnoreCase(params, "responseCode", "resCode", "code");
        if (!isUpiPaymentSuccess(status, responseCode)) {
            redirectAttributes.addFlashAttribute(
                    "errorMessage",
                    "UPI payment not completed. Please complete payment and try again.");
            return "redirect:/subscription-payment";
        }

        String callbackPlan = findParamIgnoreCase(params, "subscriptionPlan", "plan");
        if (!hasText(callbackPlan) && session.getAttribute("restaurantSubscriptionPlan") != null) {
            callbackPlan = String.valueOf(session.getAttribute("restaurantSubscriptionPlan"));
        }

        String normalizedPlan;
        try {
            normalizedPlan = normalizePaymentPlan(callbackPlan);
        } catch (IllegalArgumentException ex) {
            normalizedPlan = "MONTHLY";
        }

        String callbackTxnId = findParamIgnoreCase(
                params,
                "txnId",
                "txnid",
                "txnRef",
                "txnref",
                "approvalRefNo",
                "approvalrefno");
        String effectiveTransactionId = hasText(callbackTxnId) ? callbackTxnId.trim() : createScanTransactionId();
        String callbackPaymentMode = resolveCallbackPaymentMode(findParamIgnoreCase(params, "paymentMode", "mode"));

        try {
            BigDecimal amount = subscriptionAmountConfigService.getAmountByPlan(normalizedPlan);
            RestaurantUser user = restaurantAuthService.renewSubscriptionForUser(userId, normalizedPlan);
            restaurantAuthService.recordSubscriptionPayment(
                    userId,
                    normalizedPlan,
                    effectiveTransactionId,
                    amount,
                    callbackPaymentMode);

            session.setAttribute("restaurantSubscriptionExpired", false);
            session.setAttribute("restaurantSubscriptionPlan", user.getSubscriptionPlan());
            session.setAttribute("restaurantSubscriptionEndDate", restaurantAuthService.formatSubscriptionEndDate(user));
            redirectAttributes.addFlashAttribute(
                    "successMessage",
                    "Subscription payment successful. Transaction: " + effectiveTransactionId);
            return "redirect:/restaurantHomePage.jsp";
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
            return "redirect:/subscription-payment";
        }
    }

    @GetMapping("/subscription-payment/upi-qr")
    public ResponseEntity<byte[]> subscriptionPaymentQr(@RequestParam("subscriptionPlan") String subscriptionPlan,
                                                        @RequestParam(value = "paymentMode", required = false) String paymentMode,
                                                        HttpServletRequest request,
                                                        HttpSession session) {
        Long userId = resolveUserId(session);
        if (userId == null || userId <= 0) {
            return ResponseEntity.status(401).build();
        }

        String normalizedPlan = normalizePaymentPlan(subscriptionPlan);
        BigDecimal amount = subscriptionAmountConfigService.getAmountByPlan(normalizedPlan);
        String note = "Subscription " + normalizedPlan;
        String callbackUrl = buildUpiCallbackUrl(request, normalizedPlan, normalizeUpiPaymentMode(paymentMode));
        String upiUri = buildUpiUri(UPI_PAYEE_ID, UPI_PAYEE_NAME, amount, note, callbackUrl);

        byte[] qrBytes = generateQrCodeBytes(upiUri);
        return ResponseEntity.ok()
                .header(HttpHeaders.CACHE_CONTROL, CacheControl.noStore().mustRevalidate().getHeaderValue())
                .contentType(MediaType.IMAGE_PNG)
                .body(qrBytes);
    }

    @PostMapping("/signup")
    public String signup(@RequestParam("mobileNo") String mobileNo,
                         @RequestParam("email") String email,
                         @RequestParam("restaurantName") String restaurantName,
                         @RequestParam("password") String password,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        try {
            restaurantAuthService.register(mobileNo, email, restaurantName, password);
            redirectAttributes.addFlashAttribute("successMessage", "Signup successful. Please login.");
            return "redirect:/login";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
        } catch (DataIntegrityViolationException ex) {
            model.addAttribute("errorMessage", "Mobile number or email already registered");
        }

        model.addAttribute("mobileNo", mobileNo);
        model.addAttribute("email", email);
        model.addAttribute("restaurantName", restaurantName);
        return "registration";
    }

    @GetMapping("/forgot-password")
    public String forgotPasswordPage(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }
        return "forgotPassword";
    }

    @PostMapping("/forgot-password")
    public String forgotPassword(@RequestParam("mobileNo") String mobileNo,
                                 @RequestParam("password") String password,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 Model model,
                                 RedirectAttributes redirectAttributes,
                                 HttpSession session) {
        if (session.getAttribute("restaurantUserId") != null) {
            return isSubscriptionExpiredSession(session)
                    ? "redirect:/subscription-payment"
                    : "redirect:/rest";
        }

        try {
            restaurantAuthService.resetPassword(mobileNo, password, confirmPassword);
            redirectAttributes.addFlashAttribute("successMessage", "Password updated successfully. Please login.");
            return "redirect:/login";
        } catch (IllegalArgumentException ex) {
            model.addAttribute("errorMessage", ex.getMessage());
            model.addAttribute("mobileNo", mobileNo);
            return "forgotPassword";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.invalidate();
        redirectAttributes.addFlashAttribute("successMessage", "Logged out successfully");
        return "redirect:/login";
    }

    private String normalizePaymentPlan(String subscriptionPlan) {
        if (subscriptionPlan == null || subscriptionPlan.trim().isEmpty()) {
            return "MONTHLY";
        }

        String normalized = subscriptionPlan.trim().toUpperCase()
                .replace("-", "_")
                .replace(" ", "_");

        if ("QUATRLY".equals(normalized)) {
            return "QUARTERLY";
        }
        if ("HALFYEAR".equals(normalized) || "HALF_YEAR".equals(normalized)) {
            return "HALF_YEARLY";
        }

        if ("MONTHLY".equals(normalized)
                || "QUARTERLY".equals(normalized)
                || "HALF_YEARLY".equals(normalized)
                || "YEARLY".equals(normalized)) {
            return normalized;
        }

        throw new IllegalArgumentException("Invalid subscription plan");
    }

    private String safePaymentPlan(String subscriptionPlan) {
        try {
            return normalizePaymentPlan(subscriptionPlan);
        } catch (IllegalArgumentException ex) {
            return "MONTHLY";
        }
    }

    private String normalizePaymentMode(String paymentMode) {
        if (paymentMode == null || paymentMode.trim().isEmpty()) {
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

    private String resolveTransactionId(String transactionId, String paymentMode) {
        if (!hasText(transactionId)) {
            return createModeTransactionId(paymentMode);
        }
        validateTransactionId(transactionId);
        return transactionId.trim();
    }

    private String createScanTransactionId() {
        return "SCAN-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
    }

    private String createModeTransactionId(String paymentMode) {
        String normalizedMode = normalizePaymentMode(paymentMode);
        if (PAYMENT_MODE_SCAN.equals(normalizedMode)) {
            return createScanTransactionId();
        }
        if (PAYMENT_MODE_UPI_INTENT.equals(normalizedMode)) {
            return "UPI-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }
        if (PAYMENT_MODE_CARD.equals(normalizedMode)) {
            return "CARD-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }
        if (PAYMENT_MODE_NET_BANKING.equals(normalizedMode)) {
            return "NET-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }
        if (PAYMENT_MODE_WALLET.equals(normalizedMode)) {
            return "WALLET-" + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
        }
        throw new IllegalArgumentException("Transaction ID is required");
    }

    private void populateSubscriptionAmountAttributes(Model model, String selectedPlan) {
        Map<String, String> planAmounts = subscriptionAmountConfigService.getEffectivePlanAmounts();
        model.addAttribute("monthlyPlanAmount", planAmounts.getOrDefault("MONTHLY", "499.00"));
        model.addAttribute("quarterlyPlanAmount", planAmounts.getOrDefault("QUARTERLY", "1399.00"));
        model.addAttribute("halfYearlyPlanAmount", planAmounts.getOrDefault("HALF_YEARLY", "2599.00"));
        model.addAttribute("yearlyPlanAmount", planAmounts.getOrDefault("YEARLY", "4999.00"));
        model.addAttribute(
                "selectedPlanAmount",
                planAmounts.getOrDefault(selectedPlan, subscriptionAmountConfigService.getFormattedAmountByPlan(selectedPlan)));
    }

    private String formatAmount(BigDecimal amount) {
        if (amount == null) {
            return "0.00";
        }
        return amount.setScale(2, RoundingMode.HALF_UP).toPlainString();
    }

    private String buildUpiUri(String upiId, String payeeName, BigDecimal amount, String note, String callbackUrl) {
        String upiUri = "upi://pay?pa=" + encodeValue(upiId)
                + "&pn=" + encodeValue(payeeName)
                + "&am=" + encodeValue(formatAmount(amount))
                + "&cu=INR"
                + "&tn=" + encodeValue(note);
        if (hasText(callbackUrl)) {
            upiUri += "&url=" + encodeValue(callbackUrl);
        }
        return upiUri;
    }

    private String buildUpiCallbackUrl(HttpServletRequest request, String subscriptionPlan, String paymentMode) {
        if (request == null) {
            return null;
        }

        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int port = request.getServerPort();
        String contextPath = request.getContextPath() == null ? "" : request.getContextPath();

        StringBuilder callbackUrl = new StringBuilder();
        callbackUrl.append(scheme).append("://").append(serverName);

        boolean defaultHttpPort = "http".equalsIgnoreCase(scheme) && port == 80;
        boolean defaultHttpsPort = "https".equalsIgnoreCase(scheme) && port == 443;
        if (!defaultHttpPort && !defaultHttpsPort) {
            callbackUrl.append(":").append(port);
        }

        callbackUrl.append(contextPath)
                .append("/subscription-payment/upi-callback?subscriptionPlan=")
                .append(subscriptionPlan)
                .append("&paymentMode=")
                .append(encodeValue(paymentMode));
        return callbackUrl.toString();
    }

    private String normalizeUpiPaymentMode(String paymentMode) {
        String normalized = normalizePaymentMode(paymentMode);
        if (PAYMENT_MODE_UPI_INTENT.equals(normalized)) {
            return PAYMENT_MODE_UPI_INTENT;
        }
        return PAYMENT_MODE_SCAN;
    }

    private String resolveCallbackPaymentMode(String paymentMode) {
        if (!hasText(paymentMode)) {
            return PAYMENT_MODE_SCAN;
        }
        String normalized = normalizePaymentMode(paymentMode);
        if (PAYMENT_MODE_UPI_INTENT.equals(normalized) || PAYMENT_MODE_SCAN.equals(normalized)) {
            return normalized;
        }
        return PAYMENT_MODE_SCAN;
    }

    private String encodeValue(String value) {
        return URLEncoder.encode(value == null ? "" : value, StandardCharsets.UTF_8);
    }

    private byte[] generateQrCodeBytes(String upiUri) {
        try {
            QRCodeWriter qrCodeWriter = new QRCodeWriter();
            BitMatrix bitMatrix = qrCodeWriter.encode(upiUri, BarcodeFormat.QR_CODE, 320, 320);
            BufferedImage image = MatrixToImageWriter.toBufferedImage(bitMatrix);
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            ImageIO.write(image, "PNG", outputStream);
            return outputStream.toByteArray();
        } catch (WriterException | IOException ex) {
            throw new ResponseStatusException(org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR,
                    "Unable to generate UPI QR");
        }
    }

    private void validateTransactionId(String transactionId) {
        if (transactionId == null || transactionId.trim().isEmpty()) {
            throw new IllegalArgumentException("Transaction ID is required");
        }

        String normalized = transactionId.trim();
        if (normalized.length() < 6 || normalized.length() > 40) {
            throw new IllegalArgumentException("Enter valid transaction ID");
        }
    }

    private String findParamIgnoreCase(Map<String, String> params, String... keys) {
        if (params == null || params.isEmpty() || keys == null || keys.length == 0) {
            return null;
        }

        for (String lookupKey : keys) {
            if (!hasText(lookupKey)) {
                continue;
            }
            for (Map.Entry<String, String> entry : params.entrySet()) {
                if (entry.getKey() != null
                        && lookupKey.trim().equalsIgnoreCase(entry.getKey().trim())
                        && hasText(entry.getValue())) {
                    return entry.getValue().trim();
                }
            }
        }
        return null;
    }

    private boolean isUpiPaymentSuccess(String status, String responseCode) {
        if (hasText(status)) {
            String normalizedStatus = status.trim().toUpperCase(Locale.ROOT);
            if ("SUCCESS".equals(normalizedStatus)
                    || "S".equals(normalizedStatus)
                    || "CAPTURED".equals(normalizedStatus)
                    || "COMPLETED".equals(normalizedStatus)) {
                return true;
            }
        }

        if (hasText(responseCode)) {
            String normalizedResponseCode = responseCode.trim().toUpperCase(Locale.ROOT);
            return "00".equals(normalizedResponseCode)
                    || "0".equals(normalizedResponseCode)
                    || "SUCCESS".equals(normalizedResponseCode);
        }

        return false;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private Long resolveUserId(HttpSession session) {
        if (session == null) {
            return null;
        }

        Object userIdValue = session.getAttribute("restaurantUserId");
        if (userIdValue instanceof Number number) {
            long id = number.longValue();
            return id > 0 ? id : null;
        }

        if (userIdValue != null) {
            try {
                long id = Long.parseLong(String.valueOf(userIdValue).trim());
                return id > 0 ? id : null;
            } catch (NumberFormatException ignored) {
                return null;
            }
        }

        return null;
    }

    private boolean isSubscriptionExpiredSession(HttpSession session) {
        if (session == null) {
            return false;
        }

        Object expiredValue = session.getAttribute("restaurantSubscriptionExpired");
        if (expiredValue instanceof Boolean boolValue) {
            return boolValue;
        }
        if (expiredValue != null) {
            return "true".equalsIgnoreCase(String.valueOf(expiredValue).trim());
        }
        return false;
    }
}
