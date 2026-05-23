<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%
String errorMessage = (String) request.getAttribute("errorMessage");
String successMessage = (String) request.getAttribute("successMessage");
String restaurantName = (String) request.getAttribute("restaurantName");
String subscriptionEndDate = (String) request.getAttribute("subscriptionEndDate");
String selectedPlan = (String) request.getAttribute("selectedPlan");
String selectedPlanAmount = (String) request.getAttribute("selectedPlanAmount");
String monthlyPlanAmount = (String) request.getAttribute("monthlyPlanAmount");
String quarterlyPlanAmount = (String) request.getAttribute("quarterlyPlanAmount");
String halfYearlyPlanAmount = (String) request.getAttribute("halfYearlyPlanAmount");
String yearlyPlanAmount = (String) request.getAttribute("yearlyPlanAmount");
String paymentMode = (String) request.getAttribute("paymentMode");
String upiPayeeId = (String) request.getAttribute("upiPayeeId");
String upiPayeeName = (String) request.getAttribute("upiPayeeName");
String transactionId = (String) request.getAttribute("transactionId");

if (restaurantName == null) {
    restaurantName = "Restaurant";
}
if (selectedPlan == null || selectedPlan.trim().isEmpty()) {
    selectedPlan = "MONTHLY";
}
if (monthlyPlanAmount == null || monthlyPlanAmount.trim().isEmpty()) {
    monthlyPlanAmount = "499.00";
}
if (quarterlyPlanAmount == null || quarterlyPlanAmount.trim().isEmpty()) {
    quarterlyPlanAmount = "1399.00";
}
if (halfYearlyPlanAmount == null || halfYearlyPlanAmount.trim().isEmpty()) {
    halfYearlyPlanAmount = "2599.00";
}
if (yearlyPlanAmount == null || yearlyPlanAmount.trim().isEmpty()) {
    yearlyPlanAmount = "4999.00";
}
if (selectedPlanAmount == null || selectedPlanAmount.trim().isEmpty()) {
    if ("QUARTERLY".equalsIgnoreCase(selectedPlan)) {
        selectedPlanAmount = quarterlyPlanAmount;
    } else if ("HALF_YEARLY".equalsIgnoreCase(selectedPlan)) {
        selectedPlanAmount = halfYearlyPlanAmount;
    } else if ("YEARLY".equalsIgnoreCase(selectedPlan)) {
        selectedPlanAmount = yearlyPlanAmount;
    } else {
        selectedPlanAmount = monthlyPlanAmount;
    }
}
if (upiPayeeId == null || upiPayeeId.trim().isEmpty()) {
    upiPayeeId = "gayatrimemberassociation@oksbi";
}
if (upiPayeeName == null || upiPayeeName.trim().isEmpty()) {
    upiPayeeName = "Gayatri Member Association";
}
if (transactionId == null) {
    transactionId = "";
}
if (paymentMode == null || paymentMode.trim().isEmpty()) {
    paymentMode = "UPI_INTENT";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Subscription Payment</title>
  <link rel="stylesheet" href="/css/bootstrap5.min.css">
  <style>
    :root {
      --purple-200: #d9cbff;
      --purple-500: #7b4dff;
      --purple-600: #673de6;
      --purple-700: #5b35ce;
      --text-700: #2f2b3d;
      --text-500: #6e6487;
    }

    body {
      margin: 0;
      min-height: 100vh;
      position: relative;
      background-color: #1f1537;
      background-image: url("/images/auth-theme.jpeg");
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      font-family: Arial, sans-serif;
      display: flex;
      align-items: center;
      justify-content: flex-end;
      padding: 20px 5vw;
    }

    body::before {
      content: "";
      position: fixed;
      inset: 0;
      background: rgba(35, 22, 64, 0.58);
      z-index: 0;
    }

    .auth-wrap {
      width: 100%;
      max-width: 820px;
      background: #ffffff;
      border: 1px solid var(--purple-200);
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 10px 24px rgba(103, 61, 230, 0.14);
      position: relative;
      z-index: 1;
      backdrop-filter: blur(1px);
    }

    .auth-title {
      margin: 0 0 8px;
      font-size: 22px;
      font-weight: 700;
      color: var(--purple-700);
    }

    .auth-subtitle {
      margin: 0 0 8px;
      color: var(--text-500);
      font-size: 14px;
    }

    .expiry-text {
      margin: 0 0 16px;
      color: #8c2f39;
      font-weight: 600;
      font-size: 13px;
    }

    .payment-layout {
      display: grid;
      grid-template-columns: 260px minmax(0, 1fr);
      gap: 18px;
      align-items: start;
    }

    .qr-panel {
      border: 1px solid #e8ddff;
      border-radius: 10px;
      padding: 12px;
      background: #faf7ff;
      text-align: center;
    }

    .qr-image-wrap {
      width: 220px;
      height: 220px;
      margin: 0 auto 10px;
      border: 1px solid #dfd2ff;
      background: #ffffff;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      overflow: hidden;
    }

    .qr-image-wrap img {
      width: 100%;
      height: 100%;
      object-fit: contain;
      display: block;
    }

    .qr-caption {
      margin: 0;
      font-size: 12px;
      color: #5f5482;
      line-height: 1.35;
    }

    .upi-link {
      display: inline-block;
      margin-top: 10px;
      font-size: 12px;
      font-weight: 600;
      color: var(--purple-600);
      text-decoration: none;
    }

    .upi-link:hover {
      color: var(--purple-700);
      text-decoration: underline;
    }

    .payment-form-panel {
      border: 1px solid #e8ddff;
      border-radius: 10px;
      padding: 14px;
      background: #ffffff;
    }

    .amount-box {
      border: 1px solid #e4d8ff;
      border-radius: 8px;
      padding: 10px 12px;
      margin-bottom: 12px;
      background: #f8f4ff;
    }

    .amount-label {
      margin: 0;
      color: #6a5d92;
      font-size: 12px;
      font-weight: 600;
    }

    .amount-value {
      margin: 2px 0 0;
      color: var(--purple-700);
      font-size: 20px;
      font-weight: 700;
      line-height: 1.2;
    }

    .payee-text {
      margin: 2px 0 0;
      font-size: 12px;
      color: #5f5482;
      word-break: break-word;
    }

    .payment-method-grid {
      display: grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap: 8px;
      margin-top: 6px;
      margin-bottom: 8px;
    }

    .payment-method-btn {
      border: 1px solid #d8cdf4;
      border-radius: 8px;
      background: #f9f5ff;
      color: #4a3f69;
      font-size: 12px;
      font-weight: 600;
      padding: 8px 6px;
      line-height: 1.2;
      text-align: center;
      transition: all 0.2s ease;
      cursor: pointer;
    }

    .payment-method-btn:hover {
      border-color: #ad93ef;
      color: #3e2d73;
    }

    .payment-method-btn.active {
      border-color: var(--purple-600);
      color: var(--purple-700);
      box-shadow: inset 0 0 0 1px var(--purple-600);
      background: #f3ebff;
    }

    .method-hint {
      margin: 0;
      font-size: 12px;
      color: #5f5482;
      min-height: 18px;
    }

    .hidden {
      display: none !important;
    }

    .form-label {
      color: var(--text-700);
      font-weight: 600;
    }

    .form-control {
      border-color: #d4cde8;
    }

    .form-control:focus {
      border-color: var(--purple-500);
      box-shadow: 0 0 0 0.2rem rgba(123, 77, 255, 0.2);
    }

    .btn.btn-primary {
      background-color: var(--purple-600);
      border-color: var(--purple-600);
      font-weight: 600;
    }

    .btn.btn-primary:hover,
    .btn.btn-primary:focus {
      background-color: var(--purple-700);
      border-color: var(--purple-700);
    }

    .logout-link {
      color: var(--purple-600);
      text-decoration: none;
      font-weight: 600;
    }

    .logout-link:hover {
      color: var(--purple-700);
      text-decoration: underline;
    }

    @media (max-width: 900px) {
      body {
        justify-content: center;
      }

      .auth-wrap {
        max-width: 560px;
      }

      .payment-layout {
        grid-template-columns: 1fr;
      }

      .qr-panel {
        max-width: 260px;
        margin: 0 auto;
      }
    }

    @media (max-width: 768px) {
      body {
        justify-content: center;
        padding: 14px;
      }

      .auth-wrap {
        padding: 14px;
      }

      .payment-method-grid {
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }
  </style>
</head>
<body>
  <div class="auth-wrap">
    <h1 class="auth-title">Subscription Payment</h1>
    <p class="auth-subtitle">Hi <%= HtmlUtils.htmlEscape(restaurantName) %>, renew your subscription to continue.</p>

    <% if (subscriptionEndDate != null && !subscriptionEndDate.trim().isEmpty()) { %>
      <p class="expiry-text">Previous subscription expired on <%= HtmlUtils.htmlEscape(subscriptionEndDate) %>.</p>
    <% } %>

    <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
      <div class="alert alert-danger py-2" role="alert"><%= HtmlUtils.htmlEscape(errorMessage) %></div>
    <% } %>
    <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
      <div class="alert alert-success py-2" role="alert"><%= HtmlUtils.htmlEscape(successMessage) %></div>
    <% } %>

    <div class="payment-layout">
      <div class="qr-panel" id="qrPanel">
        <div class="qr-image-wrap">
          <img id="upiQrImage"
               src="/subscription-payment/upi-qr?subscriptionPlan=<%= HtmlUtils.htmlEscape(selectedPlan) %>&paymentMode=SCAN"
               alt="UPI QR Code">
        </div>
        <p class="qr-caption" id="qrCaption">Scan using any UPI app. After successful payment, you will be redirected automatically when callback is supported.</p>
        <a id="openUpiAppLink" class="upi-link" href="#">Open UPI App</a>
      </div>

      <div class="payment-form-panel">
        <div class="amount-box">
          <p class="amount-label">Amount To Pay</p>
          <p class="amount-value">&#8377; <span id="selectedPlanAmount"><%= HtmlUtils.htmlEscape(selectedPlanAmount) %></span></p>
          <p class="payee-text" id="upiPayeeText"><%= HtmlUtils.htmlEscape(upiPayeeName) %> - <%= HtmlUtils.htmlEscape(upiPayeeId) %></p>
        </div>

        <form id="subscriptionPaymentForm" action="/subscription-payment" method="post" autocomplete="off">
          <input type="hidden" id="paymentMode" name="paymentMode" value="<%= HtmlUtils.htmlEscape(paymentMode) %>">
          <div class="mb-3">
            <label for="subscriptionPlan" class="form-label">Subscription Plan</label>
            <select id="subscriptionPlan" name="subscriptionPlan" class="form-control" required>
              <option value="MONTHLY" <%= "MONTHLY".equalsIgnoreCase(selectedPlan) ? "selected" : "" %>>MONTHLY</option>
              <option value="QUARTERLY" <%= "QUARTERLY".equalsIgnoreCase(selectedPlan) ? "selected" : "" %>>QUARTERLY</option>
              <option value="HALF_YEARLY" <%= "HALF_YEARLY".equalsIgnoreCase(selectedPlan) ? "selected" : "" %>>HALF YEAR</option>
              <option value="YEARLY" <%= "YEARLY".equalsIgnoreCase(selectedPlan) ? "selected" : "" %>>YEARLY</option>
            </select>
          </div>

          <div class="mb-3">
            <label class="form-label mb-1">Payment Method</label>
            <div class="payment-method-grid" id="paymentMethodGrid">
              <button type="button" class="payment-method-btn" data-mode="SCAN">UPI QR</button>
              <button type="button" class="payment-method-btn" data-mode="UPI_INTENT">UPI App</button>
              <button type="button" class="payment-method-btn" data-mode="CARD">Card</button>
              <button type="button" class="payment-method-btn" data-mode="NET_BANKING">Net Banking</button>
              <button type="button" class="payment-method-btn" data-mode="WALLET">Wallet</button>
              <button type="button" class="payment-method-btn" data-mode="MANUAL">Manual UTR</button>
            </div>
            <p class="method-hint" id="paymentModeHint"></p>
          </div>

          <div class="mb-3">
            <label for="transactionId" class="form-label" id="transactionLabel">Transaction Reference</label>
            <input type="text"
                   class="form-control"
                   id="transactionId"
                   name="transactionId"
                   value="<%= HtmlUtils.htmlEscape(transactionId) %>"
                   placeholder="Enter transaction reference (optional)"
                   maxlength="40">
          </div>

          <button type="submit" id="manualPayBtn" class="btn btn-primary w-100 mb-2">Payment Successful - Continue</button>
          <button type="button" id="scanPaySuccessBtn" class="btn btn-success w-100">Scanner Payment Success (If Not Redirected)</button>
        </form>
      </div>
    </div>

    <p class="text-center mt-3 mb-0">
      <a class="logout-link" href="/logout">Logout</a>
    </p>
  </div>

  <script>
    (function () {
      const planAmounts = {
        MONTHLY: "<%= HtmlUtils.htmlEscape(monthlyPlanAmount) %>",
        QUARTERLY: "<%= HtmlUtils.htmlEscape(quarterlyPlanAmount) %>",
        HALF_YEARLY: "<%= HtmlUtils.htmlEscape(halfYearlyPlanAmount) %>",
        YEARLY: "<%= HtmlUtils.htmlEscape(yearlyPlanAmount) %>",
      };
      const modeHints = {
        SCAN: "Scan QR with any UPI app for fastest payment.",
        UPI_INTENT: "Open UPI app directly and complete payment.",
        CARD: "Pay via debit or credit card and continue.",
        NET_BANKING: "Pay through net banking and continue.",
        WALLET: "Pay from supported wallet and continue.",
        MANUAL: "Enter UTR/reference after completing payment."
      };

      const upiPayeeId = "<%= HtmlUtils.htmlEscape(upiPayeeId) %>";
      const upiPayeeName = "<%= HtmlUtils.htmlEscape(upiPayeeName) %>";
      const contextPath = "<%= HtmlUtils.htmlEscape(request.getContextPath() == null ? "" : request.getContextPath()) %>";
      const paymentForm = document.getElementById("subscriptionPaymentForm");
      const planSelect = document.getElementById("subscriptionPlan");
      const amountEl = document.getElementById("selectedPlanAmount");
      const qrImage = document.getElementById("upiQrImage");
      const qrPanel = document.getElementById("qrPanel");
      const qrCaption = document.getElementById("qrCaption");
      const upiAppLink = document.getElementById("openUpiAppLink");
      const paymentModeInput = document.getElementById("paymentMode");
      const paymentMethodButtons = document.querySelectorAll(".payment-method-btn");
      const paymentModeHint = document.getElementById("paymentModeHint");
      const transactionLabel = document.getElementById("transactionLabel");
      const transactionInput = document.getElementById("transactionId");
      const scanPaySuccessBtn = document.getElementById("scanPaySuccessBtn");
      const paymentBaseUrl = (contextPath || "") + "/subscription-payment";

      function normalizeMode(mode) {
        if (!mode || !String(mode).trim()) {
          return "UPI_INTENT";
        }
        const normalized = String(mode).trim().toUpperCase().replace(/-/g, "_").replace(/\s+/g, "_");
        if (normalized === "UPI" || normalized === "UPI_APP") {
          return "UPI_INTENT";
        }
        if (normalized === "UPI_SCAN") {
          return "SCAN";
        }
        if (normalized === "NETBANKING") {
          return "NET_BANKING";
        }
        if (normalized === "SCAN"
            || normalized === "UPI_INTENT"
            || normalized === "CARD"
            || normalized === "NET_BANKING"
            || normalized === "WALLET"
            || normalized === "MANUAL") {
          return normalized;
        }
        return "UPI_INTENT";
      }

      function isUpiMode(mode) {
        return mode === "SCAN" || mode === "UPI_INTENT";
      }

      function generateTransactionId(prefix) {
        const now = new Date();
        const pad = (v) => String(v).padStart(2, "0");
        return (
          prefix +
          "-" +
          now.getFullYear() +
          pad(now.getMonth() + 1) +
          pad(now.getDate()) +
          pad(now.getHours()) +
          pad(now.getMinutes()) +
          pad(now.getSeconds())
        );
      }

      function autoTransactionIdByMode(mode) {
        if (mode === "SCAN") {
          return generateTransactionId("SCAN");
        }
        if (mode === "UPI_INTENT") {
          return generateTransactionId("UPI");
        }
        if (mode === "CARD") {
          return generateTransactionId("CARD");
        }
        if (mode === "NET_BANKING") {
          return generateTransactionId("NET");
        }
        if (mode === "WALLET") {
          return generateTransactionId("WALLET");
        }
        return "";
      }

      function setPaymentMode(mode) {
        if (paymentModeInput) {
          paymentModeInput.value = normalizeMode(mode);
        }
      }

      function updateQrAndAmount() {
        if (!planSelect || !amountEl) {
          return;
        }

        const selectedPlan = planSelect.value || "MONTHLY";
        const amount = planAmounts[selectedPlan] || planAmounts.MONTHLY;
        const currentMode = normalizeMode(paymentModeInput ? paymentModeInput.value : "UPI_INTENT");
        const callbackMode = currentMode === "SCAN" ? "SCAN" : "UPI_INTENT";
        const callbackUrl =
          window.location.origin +
          paymentBaseUrl +
          "/upi-callback?subscriptionPlan=" +
          encodeURIComponent(selectedPlan) +
          "&paymentMode=" +
          encodeURIComponent(callbackMode);

        amountEl.textContent = amount;
        if (isUpiMode(currentMode) && qrImage) {
          qrImage.src =
            paymentBaseUrl +
            "/upi-qr?subscriptionPlan=" +
            encodeURIComponent(selectedPlan) +
            "&paymentMode=" +
            encodeURIComponent(callbackMode) +
            "&_t=" +
            Date.now();
        }

        if (upiAppLink) {
          const upiUri =
            "upi://pay?pa=" +
            encodeURIComponent(upiPayeeId) +
            "&pn=" +
            encodeURIComponent(upiPayeeName) +
            "&am=" +
            encodeURIComponent(amount) +
            "&cu=INR" +
            "&tn=" +
            encodeURIComponent("Subscription " + selectedPlan) +
            "&url=" +
            encodeURIComponent(callbackUrl);
          upiAppLink.href = upiUri;
        }
      }

      function updateModeUi(mode) {
        const normalizedMode = normalizeMode(mode);
        setPaymentMode(normalizedMode);

        paymentMethodButtons.forEach(function (btn) {
          const btnMode = normalizeMode(btn.getAttribute("data-mode"));
          btn.classList.toggle("active", btnMode === normalizedMode);
        });

        if (paymentModeHint) {
          paymentModeHint.textContent = modeHints[normalizedMode] || "";
        }

        const upiMode = isUpiMode(normalizedMode);
        if (qrPanel) {
          qrPanel.classList.toggle("hidden", !upiMode);
        }
        if (scanPaySuccessBtn) {
          scanPaySuccessBtn.classList.toggle("hidden", normalizedMode !== "SCAN");
        }

        if (qrCaption) {
          qrCaption.textContent = normalizedMode === "SCAN"
            ? "Scan using any UPI app. After successful payment, you will be redirected automatically when callback is supported."
            : "Open UPI app to pay directly. After successful payment, you will be redirected automatically when callback is supported.";
        }

        if (transactionLabel) {
          transactionLabel.textContent = normalizedMode === "MANUAL"
            ? "Transaction ID (Required)"
            : "Transaction Reference";
        }

        if (transactionInput) {
          transactionInput.required = normalizedMode === "MANUAL";
          if (normalizedMode === "MANUAL") {
            transactionInput.placeholder = "Enter payment reference / UTR";
          } else {
            transactionInput.placeholder = "Leave empty to auto-generate reference";
          }
        }

        updateQrAndAmount();
      }

      paymentMethodButtons.forEach(function (btn) {
        btn.addEventListener("click", function () {
          updateModeUi(btn.getAttribute("data-mode"));
        });
      });

      if (scanPaySuccessBtn) {
        scanPaySuccessBtn.addEventListener("click", function () {
          setPaymentMode("SCAN");
          if (transactionInput && !transactionInput.value.trim()) {
            transactionInput.value = autoTransactionIdByMode("SCAN");
          }
          if (paymentForm) {
            paymentForm.submit();
          }
        });
      }

      if (paymentForm) {
        paymentForm.addEventListener("submit", function (event) {
          const mode = normalizeMode(paymentModeInput ? paymentModeInput.value : "UPI_INTENT");
          setPaymentMode(mode);

          if (mode === "MANUAL") {
            if (transactionInput && !transactionInput.value.trim()) {
              event.preventDefault();
              transactionInput.setCustomValidity("Transaction ID is required for manual mode");
              transactionInput.reportValidity();
              return;
            }
          } else if (transactionInput && !transactionInput.value.trim()) {
            transactionInput.value = autoTransactionIdByMode(mode);
          }

          if (transactionInput) {
            transactionInput.setCustomValidity("");
          }
        });
      }

      if (transactionInput) {
        transactionInput.addEventListener("input", function () {
          transactionInput.setCustomValidity("");
        });
      }

      if (planSelect) {
        planSelect.addEventListener("change", updateQrAndAmount);
      }
      updateModeUi(paymentModeInput ? paymentModeInput.value : "UPI_INTENT");
    })();
  </script>
</body>
</html>
