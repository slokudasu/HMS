<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${empty restaurantName ? 'Restaurant' : restaurantName}</title>

    <!-- Bootstrap Icons LOCAL -->
    <link rel="stylesheet" href="/css/bootstrap-icons.css" />

    <!-- Bootstrap CSS LOCAL -->
    <link rel="stylesheet" href="/css/bootstrap5.min.css" />
    <link rel="stylesheet" href="/css/bootstrap.min.css" />

    <!-- Your custom CSS -->
    <link rel="stylesheet" href="/css/styles.css" />
    <style>
      .configuration-frame-wrap {
        width: 100%;
        min-height: calc(100vh - 220px);
        background: #ffffff;
        border: 1px solid #e3d6ff;
        border-radius: 10px;
        overflow: hidden;
      }

      .configuration-frame {
        width: 100%;
        height: calc(100vh - 220px);
        border: 0;
        display: block;
      }

      .configuration-frame-status {
        height: calc(100vh - 220px);
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        font-size: 14px;
        font-weight: 600;
        color: #6b2fd4;
      }

      .configuration-frame-status.configuration-frame-error {
        color: #b02a37;
        font-weight: 600;
      }

      .configuration-frame-status .spinner-border {
        width: 1.2rem;
        height: 1.2rem;
        border-width: 0.16em;
      }

      @media (max-width: 991px) {
        .configuration-frame-wrap {
          min-height: calc(100vh - 190px);
          border-radius: 8px;
        }

        .configuration-frame {
          height: calc(100vh - 190px);
        }

        .configuration-frame-status {
          height: calc(100vh - 190px);
        }
      }

      .restaurant-page.configuration-fullscreen .sidebar {
        display: none;
      }

      .restaurant-page.configuration-fullscreen .content {
        position: fixed;
        top: 60px;
        left: 0;
        right: 0;
        bottom: 0;
        margin: 0;
        padding: 0;
        height: auto;
        overflow: hidden;
      }

      .restaurant-page.configuration-fullscreen .content-row {
        margin: 0;
        height: 100%;
        min-height: 100%;
        --bs-gutter-x: 0;
        --bs-gutter-y: 0;
      }

      .restaurant-page.configuration-fullscreen .content-row > [class*="col-"] {
        padding-left: 0;
        padding-right: 0;
        padding-top: 0;
      }

      .restaurant-page.configuration-fullscreen .leftContent {
        flex: 0 0 100%;
        max-width: 100%;
        min-height: 100%;
        max-height: none;
        height: 100%;
        overflow: hidden;
        padding: 0;
      }

      .restaurant-page.configuration-fullscreen .configuration-frame-wrap {
        height: 100%;
        min-height: 100%;
        border: 0;
        border-radius: 0;
      }

      .restaurant-page.configuration-fullscreen .configuration-frame,
      .restaurant-page.configuration-fullscreen .configuration-frame-status {
        height: 100%;
      }

      .restaurant-page.configuration-fullscreen .footer {
        display: none;
      }

      .subscription-expiry-marquee-wrap {
        background: #fff3cd;
        border-top: 1px solid #ffe69c;
        border-bottom: 1px solid #ffe69c;
        color: #7a3e00;
        font-weight: 600;
        font-size: 13px;
        padding: 6px 0;
        position: fixed;
        top: 60px;
        left: 0;
        right: 0;
        z-index: 998;
      }

      .subscription-expiry-marquee-wrap marquee {
        margin: 0;
      }

      .restaurant-page.subscription-warning-visible .content {
        margin-top: 94px;
        height: calc(100vh - 124px);
      }

      .order-payment-method-section {
        border: 1px solid #e9ecef;
        border-radius: 6px;
        padding: 8px 10px;
        background: #ffffff;
      }

      .order-payment-method-options {
        display: flex;
        flex-wrap: wrap;
        gap: 1px;
      }

      .order-payment-method-options .form-check {
        margin-right: 0;
      }

      .order-payment-method-options .form-check-label {
        cursor: pointer;
      }

      .order-payment-method-inline {
        display: inline-flex;
        align-items: center;
        flex-wrap: nowrap;
        gap: 1px;
        margin-right: 0;
      }

      .order-payment-method-inline .form-check {
        display: inline-flex;
        align-items: center;
        gap: 1px;
        margin: 0;
        padding-left: 0;
        min-height: 0;
      }

      .order-payment-method-inline .form-check-input {
        margin: 0;
        float: none;
      }

      .order-payment-method-inline .form-check-label {
        font-size: 12px;
        line-height: 1.2;
        margin: 0;
      }

      .order-payment-method-summary {
        font-size: 12px;
        color: #6c757d;
      }

      .order-details-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 10px;
        margin-bottom: 8px;
      }

      .order-details-title {
        margin: 0;
        font-size: 14px;
        font-weight: 600;
        line-height: 1.2;
        flex: 0 0 auto;
        white-space: nowrap;
      }

      .order-details-header .order-selected-table-info {
        margin: 0;
        font-size: 12px;
        line-height: 1.2;
        text-align: right;
        flex: 1 1 auto;
        min-width: 0;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
      }

      .order-page-alert-box {
        position: fixed;
        top: 74px;
        right: 16px;
        z-index: 1200;
        min-width: 250px;
        max-width: min(360px, calc(100vw - 24px));
      }

      .order-page-alert-box .alert {
        margin-bottom: 0;
        box-shadow: 0 8px 20px rgba(20, 20, 20, 0.16);
      }

      .restaurant-page.subscription-warning-visible .order-page-alert-box {
        top: 108px;
      }

      @media (max-width: 768px) {
        .subscription-expiry-marquee-wrap {
          left: 0;
          top: 60px;
        }

        .restaurant-page.topbar-mobile-open .subscription-expiry-marquee-wrap {
          top: 124px;
        }

        .restaurant-page.subscription-warning-visible .content {
          margin-top: 94px;
          height: calc(100vh - 124px);
        }

        .restaurant-page.topbar-mobile-open.subscription-warning-visible .content {
          margin-top: 158px;
          height: calc(100vh - 188px);
        }

        .order-page-alert-box {
          top: 66px;
          right: 10px;
          left: 10px;
          min-width: 0;
          max-width: none;
        }

        .restaurant-page.topbar-mobile-open .order-page-alert-box {
          top: 128px;
        }

        .restaurant-page.subscription-warning-visible .order-page-alert-box {
          top: 100px;
        }

        .restaurant-page.topbar-mobile-open.subscription-warning-visible .order-page-alert-box {
          top: 162px;
        }

        .order-details-title {
          font-size: 13px;
        }

        .order-details-header .order-selected-table-info {
          font-size: 11px;
        }
      }
    </style>
    <!-- JS -->
    <script src="/js/jquery.min.js"></script>
    <script src="/js/bootstrap.min.js"></script>
  </head>
  <body class="restaurant-page">
    <!-- Sidebar -->
    <div class="sidebar" id="sidebar"></div>

    <!-- Topbar -->
    <div class="topbar">
      <button
        class="btn btn-light btn-sm me-2"
        id="sidebarToggleBtn"
        type="button"
        onclick="toggleSidebar()"
        aria-controls="sidebar"
        aria-expanded="false"
        aria-label="Toggle category menu"
      >
        <i class="bi bi-list"></i>
      </button>

      <div class="topbar-main ms-2 ms-md-0">
        <div class="app-brand">
          <i class="bi bi-shop app-brand-icon" aria-hidden="true"></i>
          <span class="app-title">${empty restaurantName ? 'Restaurant' : restaurantName}</span>
        </div>
        <a
          href="#"
          class="new-order-btn"
          onclick="newOrder('newOrder'); return false;"
          aria-label="Create new order"
        >
          <i class="bi bi-plus-circle"></i>
          <span class="new-order-text">New Order</span>
        </a>
      </div>

      <button
        class="btn btn-light btn-sm d-md-none ms-auto"
        type="button"
        id="topbarMenuToggle"
        onclick="toggleTopbarLinks()"
        aria-controls="topbarMobileLinks"
        aria-expanded="false"
        aria-label="Toggle top menu"
      >
        <i class="bi bi-three-dots-vertical"></i>
      </button>

      <!-- Full Top Menu Links -->
      <nav class="topbar-links d-none d-md-flex" aria-label="Primary navigation">
        <a
          href="#"
          class="topbar-link active"
          data-nav-key="home"
          onclick="reloadRestaurantHomePage(); return false;"
        >
          <i class="bi bi-house-door"></i>
          <span>Home</span>
        </a>
        <a
          href="#"
          class="topbar-link"
          data-nav-key="billing"
          onclick="setActiveTopbarLink('billing'); loadPage('billing'); return false;"
        >
          <i class="bi bi-receipt"></i>
          <span>Billing</span>
        </a>
        <a
          href="#"
          class="topbar-link"
          data-nav-key="configuration"
          onclick="setActiveTopbarLink('configuration'); loadPage('configuration'); return false;"
        >
          <i class="bi bi-sliders"></i>
          <span>Configuration</span>
        </a>
        <a href="/logout" class="topbar-link">
          <i class="bi bi-box-arrow-right"></i>
          <span>Logout</span>
        </a>
      </nav>
    </div>
    <nav
      class="topbar-mobile-links"
      id="topbarMobileLinks"
      aria-label="Mobile navigation"
    >
      <a
        href="#"
        class="topbar-mobile-link active"
        data-nav-key="home"
        onclick="reloadRestaurantHomePage(); return false;"
      >
        <i class="bi bi-house-door"></i>
        <span>Home</span>
      </a>
      <a
        href="#"
        class="topbar-mobile-link"
        data-nav-key="billing"
        onclick="setActiveTopbarLink('billing'); loadPage('billing'); return false;"
      >
        <i class="bi bi-receipt"></i>
        <span>Billing</span>
      </a>
      <a
        href="#"
        class="topbar-mobile-link"
        data-nav-key="configuration"
        onclick="setActiveTopbarLink('configuration'); loadPage('configuration'); return false;"
      >
        <i class="bi bi-sliders"></i>
        <span>Configuration</span>
      </a>
      <a href="/logout" class="topbar-mobile-link">
        <i class="bi bi-box-arrow-right"></i>
        <span>Logout</span>
      </a>
    </nav>

    <div id="subscriptionExpiryMarqueeWrap" class="subscription-expiry-marquee-wrap d-none">
      <marquee behavior="scroll" direction="left" scrollamount="6" id="subscriptionExpiryMarquee">
        ${subscriptionExpiryWarningMessage}
      </marquee>
    </div>

    <div id="orderPageAlertBox" class="order-page-alert-box" aria-live="polite" aria-atomic="true"></div>

    <!-- Content -->
    <input type="hidden" id="selectedTableId" />
    <input type="hidden" id="selectedTableName" />
    <input type="hidden" id="selectedOrderId" />
    <input type="hidden" id="selectedOrderNumber" />
    <div class="content">
      <div class="row g-3 content-row">
        <!-- LEFT SIDE (Dynamic Content) -->
        <div
          class="col-12 col-lg-7 leftContent"
          id="leftContent"
        >
          <!-- JSP / API content will load here -->
        </div>

        <!-- RIGHT SIDE (FIXED BILL PANEL) -->
        <div class="col-12 col-lg-5" id="orderDetailsColumn">
          <div class="bill-panel">
            <div class="order-details-header">
              <h4 class="order-details-title">Order Details</h4>
              <div id="orderSelectedTableInfo" class="order-selected-table-info">
                Selected table: -
              </div>
            </div>

            <div class="table-responsive order-table-wrap">
              <table class="table table-bordered table-sm order-items-table">
                <thead>
                  <tr>
                    <th>Item</th>
                    <th>Qty</th>
                    <th>Price</th>
                  </tr>
                </thead>
                <tbody id="tableMenu"></tbody>
              </table>
            </div>

            <div class="order-details-footer mt-2">
              <input type="hidden" id="orderPaymentMethod" value="" />

              <div class="order-details-toolbar d-flex align-items-center">
                <div class="order-total-inline">
                  <span>Total Amount:</span>
                  <b class="order-total-inline-value">Rs. <span id="orderNetTotalAmount">0.00</span></b>
                </div>
                <div class="order-toolbar-actions" role="group" aria-label="Order Actions">
                  <div
                    id="orderPaymentMethodOptions"
                    class="order-payment-method-options order-payment-method-inline"
                    role="radiogroup"
                    aria-label="Payment Method"
                  >
                    <div class="form-check form-check-inline mb-0">
                      <input
                        class="form-check-input order-payment-method-radio"
                        type="radio"
                        name="orderPaymentMethodOption"
                        id="orderPaymentMethodUpi"
                        value="UPI"
                      />
                      <label class="form-check-label" for="orderPaymentMethodUpi">UPI</label>
                    </div>
                    <div class="form-check form-check-inline mb-0">
                      <input
                        class="form-check-input order-payment-method-radio"
                        type="radio"
                        name="orderPaymentMethodOption"
                        id="orderPaymentMethodCard"
                        value="CARD"
                      />
                      <label class="form-check-label" for="orderPaymentMethodCard">Card</label>
                    </div>
                    <div class="form-check form-check-inline mb-0">
                      <input
                        class="form-check-input order-payment-method-radio"
                        type="radio"
                        name="orderPaymentMethodOption"
                        id="orderPaymentMethodCash"
                        value="CASH"
                      />
                      <label class="form-check-label" for="orderPaymentMethodCash">Cash</label>
                    </div>
                  </div>
                  <div class="order-toolbar-icon-actions" role="group" aria-label="Order Action Buttons">

                    <button
                      type="button"
                      class="btn btn-default btn-sm order-action-btn order-icon-save saveTableOrder"
                      title="Save Order"
                      aria-label="Save Order"
                    >
                      <i class="bi bi-save"></i>
                    </button>
                    <button
                      type="button"
                      class="btn btn-default btn-sm order-action-btn order-icon-print printTableOrder"
                      title="Print Order"
                      aria-label="Print Order"
                    >
                      <i class="bi bi-printer"></i>
                    </button>
                    <button
                      type="button"
                      class="btn btn-default btn-sm order-action-btn order-icon-close closeTableOrder"
                      title="Complete Order"
                      aria-label="Complete Order"
                    >
                      <i class="bi bi-check2-circle"></i>
                    </button>
                    <button
                      type="button"
                      class="btn btn-default btn-sm order-action-btn order-icon-delete deleteTableOrder"
                      title="Delete Order"
                      aria-label="Delete Order"
                    >
                      <i class="bi bi-trash"></i>
                    </button>
                    <button
                            type="button"
                            class="btn btn-default btn-sm order-detail-icon-btn order-icon-discount editDiscountSettings"
                            title="Discount Settings"
                            aria-label="Discount Settings"
                    >
                      <i class="bi bi-percent"></i>
                    </button>
                    <button
                            type="button"
                            class="btn btn-default btn-sm order-detail-icon-btn order-icon-customer editCustomerSettings"
                            title="Customer Information"
                            aria-label="Customer Information"
                    >
                      <i class="bi bi-person-vcard"></i>
                    </button>
                    <button
                            type="button"
                            class="btn btn-default btn-sm order-detail-icon-btn order-icon-gst editGstSettings"
                            title="GST Settings"
                            aria-label="GST Settings"
                    >
                      <i class="bi bi-receipt-cutoff"></i>
                    </button>
                  </div>
                </div>
              </div>

              <input type="hidden" id="orderDiscountPercentage" value="0.00" />
              <input type="hidden" id="orderCgstPercentage" value="0.00" />
              <input type="hidden" id="orderSgstPercentage" value="0.00" />
              <input type="hidden" id="orderCustomerName" value="" />
              <input type="hidden" id="orderCustomerMobile" value="" />

              <div class="order-metrics-hidden d-none" aria-hidden="true">
                <span id="orderSubTotalAmount">0.00</span>
                <span id="orderDiscountPercentDisplay">0.00</span>
                <span id="orderDiscountAppliedAmount">0.00</span>
                <span id="orderTaxableAmount">0.00</span>
                <span id="orderCgstPercentDisplay">0.00</span>
                <span id="orderCgstAmount">0.00</span>
                <span id="orderSgstPercentDisplay">0.00</span>
                <span id="orderSgstAmount">0.00</span>
                <span id="orderCustomerSummary">Walk-in</span>
              </div>

              <div
                id="orderSaveStatus"
                class="small order-save-status d-none"
                role="status"
                aria-live="polite"
              ></div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer">&copy; 2026 SSS App | All Rights Reserved</div>

    <div
      id="actionLoader"
      class="action-loader d-none"
      role="status"
      aria-live="polite"
      aria-atomic="true"
    >
      <div class="action-loader-box">
        <div class="spinner-border text-light action-loader-spinner" role="presentation"></div>
        <div id="actionLoaderText" class="action-loader-text">Please wait...</div>
      </div>
    </div>

    <!-- JS -->
    <script>
      window.addEventListener("pageshow", function (event) {
        const navEntries =
          typeof performance !== "undefined" &&
          typeof performance.getEntriesByType === "function"
            ? performance.getEntriesByType("navigation")
            : [];
        const isBackForwardNavigation =
          event.persisted ||
          (Array.isArray(navEntries) &&
            navEntries.length > 0 &&
            navEntries[0].type === "back_forward");

        if (isBackForwardNavigation) {
          window.location.reload();
        }
      });

      (function () {
        const marqueeWrap = document.getElementById("subscriptionExpiryMarqueeWrap");
        const marquee = document.getElementById("subscriptionExpiryMarquee");
        const body = document.body;
        if (!marqueeWrap || !marquee) {
          return;
        }
        const message = marquee.textContent ? marquee.textContent.trim() : "";
        if (message) {
          marqueeWrap.classList.remove("d-none");
          if (body) {
            body.classList.add("subscription-warning-visible");
          }
        } else {
          marqueeWrap.classList.add("d-none");
          if (body) {
            body.classList.remove("subscription-warning-visible");
          }
        }
      })();

      function reloadRestaurantHomePage() {
        window.location.reload();
      }

      function showDeleteConfirmModal(message, onConfirm, options) {
        const opts = options || {};
        const modal = $("#deleteConfirmModal");
        const confirmBtn = $("#deleteConfirmOkBtn");
        const modalTitle = $("#deleteConfirmTitle");

        modalTitle.text(opts.title || "Delete Confirmation");
        confirmBtn.text(opts.confirmLabel || "Delete");

        $("#deleteConfirmMessage").text(
          message || "Are you sure you want to delete?"
        );

        confirmBtn.off("click.deleteConfirm").on("click.deleteConfirm", function () {
          modal.modal("hide");
          if (typeof onConfirm === "function") {
            onConfirm();
          }
        });

        modal
          .off("hidden.bs.modal.deleteConfirm")
          .on("hidden.bs.modal.deleteConfirm", function () {
            confirmBtn.off("click.deleteConfirm");
          });

        modal.modal("show");
      }

      function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        const toggleBtn = document.getElementById("sidebarToggleBtn");

        if (!sidebar) {
          return;
        }

        const isOpen = sidebar.classList.toggle("active");
        document.body.classList.toggle("sidebar-open", isOpen);
        if (toggleBtn) {
          toggleBtn.setAttribute("aria-expanded", isOpen ? "true" : "false");
        }
      }

      function closeSidebar() {
        const sidebar = document.getElementById("sidebar");
        const toggleBtn = document.getElementById("sidebarToggleBtn");

        if (!sidebar) {
          return;
        }

        sidebar.classList.remove("active");
        document.body.classList.remove("sidebar-open");
        if (toggleBtn) {
          toggleBtn.setAttribute("aria-expanded", "false");
        }
      }

      function toggleTopbarLinks() {
        const mobileLinks = document.getElementById("topbarMobileLinks");
        const toggleBtn = document.getElementById("topbarMenuToggle");

        if (!mobileLinks || !toggleBtn) {
          return;
        }

        const isOpen = mobileLinks.classList.toggle("active");
        document.body.classList.toggle("topbar-mobile-open", isOpen);
        toggleBtn.setAttribute("aria-expanded", isOpen ? "true" : "false");
      }

      function setActiveTopbarLink(key) {
        if (!key) {
          return;
        }

        document
          .querySelectorAll("[data-nav-key]")
          .forEach(function (topbarLink) {
            if (topbarLink.dataset.navKey === key) {
              topbarLink.classList.add("active");
            } else {
              topbarLink.classList.remove("active");
            }
          });
      }

      function closeTopbarLinks() {
        const mobileLinks = document.getElementById("topbarMobileLinks");
        const toggleBtn = document.getElementById("topbarMenuToggle");

        if (!mobileLinks || !toggleBtn) {
          return;
        }

        mobileLinks.classList.remove("active");
        document.body.classList.remove("topbar-mobile-open");
        toggleBtn.setAttribute("aria-expanded", "false");
        scheduleOrderTableHeightRefresh();
      }

      function setOrderDetailsVisibility(visible) {
        const orderDetailsColumn = $("#orderDetailsColumn");
        const leftContent = $("#leftContent");

        if (visible) {
          orderDetailsColumn.removeClass("d-none");
          leftContent.removeClass("col-lg-12").addClass("col-lg-7");
          scheduleOrderTableHeightRefresh();
          return;
        }

        orderDetailsColumn.addClass("d-none");
        leftContent.removeClass("col-lg-7").addClass("col-lg-12");
      }

      function setConfigurationFullscreen(enabled) {
        const body = document.body;
        if (!body) {
          return;
        }

        if (enabled) {
          body.classList.add("configuration-fullscreen");
          closeTopbarLinks();
          closeSidebar();
          return;
        }

        body.classList.remove("configuration-fullscreen");
      }

      function newOrder(page) {
        setConfigurationFullscreen(false);
        setOrderDetailsVisibility(true);
        renderEmptyOrderDetailsRow("Select a table to view order details.");
        $("#selectedTableId").val("");
        $("#selectedTableName").val("");
        $("#selectedOrderId").val("");
        $("#selectedOrderNumber").val("");
        updateOrderSelectedTableInfo(null, "", null);
        resetOrderTotals();
        showOrderSaveStatus("", false);
        loadTables();
        //oppendPage(page);
      }

      function loadTables() {
        loadRoomWiseTables();
        return;

        $.ajax({
          url: "rooms?status=ACTIVE",
          type: "GET",
          loadingText: "Loading rooms and tables...",
          success: function (response) {
            console.log("Response:", response);

            let html = "";

            response.forEach(function (room) {
              let roomName = room.roomName || room.name; // ðŸ”¥ flexible
              let tables = room.tables || room.tableList; // ðŸ”¥ flexible

              html +=
                '<div class="panel panel-default"><div class="panel-heading"><b>' +
                roomName +
                '</b></div><div class="panel-body"><div class="form-group col-md-12 row">';

              if (tables) {
                tables.forEach(function (table) {
                  html +=
                    '<button type="button" class="tables-btn" data-table="' +
                    table.tableId +
                    '">' +
                    table.tableName +
                    "" +
                    '<div class="icons"><i class="bi bi-eye view-icon"></i><i class="bi bi-printer print-icon"></i></div></button>';
                });
              }

              html += `
                    </div>
                  </div>
                </div>
              `;
            });

            console.log("Final HTML:", html);

            // ðŸ”¥ IMPORTANT: use correct container
            $(".leftContent").html(html);
          },
          error: function (err) {
            console.log(err);
          },
        });
      }

      function loadRoomWiseTables() {
        $.ajax({
          url: "rooms?status=ACTIVE",
          type: "GET",
          loadingText: "Loading rooms and tables...",
          success: function (response) {
            let html = "";
            const rooms = Array.isArray(response) ? response : [];

            if (rooms.length === 0) {
              $(".leftContent").html(
                '<div class="menu-empty-state">No active rooms found</div>'
              );
              return;
            }

            rooms.forEach(function (room) {
              let roomName = room.roomName || room.name || "Room";
              let tables = Array.isArray(room.tables)
                ? room.tables
                : Array.isArray(room.tableList)
                ? room.tableList
                : [];

              html +=
                '<div class="panel panel-default"><div class="panel-heading"><b>' +
                roomName +
                '</b></div><div class="panel-body"><div class="form-group col-md-12 row">';

              if (tables.length > 0) {
                tables.forEach(function (table) {
                  let tableId = table.tableId || table.id;
                  let tableName = table.tableName || table.name || "Table";

                  if (!tableId) {
                    return;
                  }

                  html +=
                    '<button type="button" class="tables-btn" data-table="' +
                    tableId +
                    '">' +
                    tableName +
                    '<div class="icons"><i class="bi bi-eye view-icon"></i><i class="bi bi-printer print-icon"></i></div></button>';
                });
              } else {
                html +=
                  '<div class="menu-empty-state">No tables configured in this room</div>';
              }

              html += "</div></div></div>";
            });

            $(".leftContent").html(html);
          },
          error: function () {
            $(".leftContent").html(
              '<div class="menu-empty-state">Unable to load rooms and tables</div>'
            );
          },
        });
      }

      function loadPage(page) {
        setConfigurationFullscreen(page === "configuration");
        setOrderDetailsVisibility(page !== "configuration");
        closeTopbarLinks();
        closeSidebar();
        if (page === "configuration") {
          renderConfigurationFrame();
          return;
        }
        oppendPage(page);
      }

      let selectedMenuItem = null;

      function escapeHtml(value) {
        const text = value == null ? "" : String(value);
        return text
          .replace(/&/g, "&amp;")
          .replace(/</g, "&lt;")
          .replace(/>/g, "&gt;")
          .replace(/"/g, "&quot;")
          .replace(/'/g, "&#39;");
      }

      function toAmount(value) {
        const amount = parseFloat(value);
        return Number.isFinite(amount) ? amount : 0;
      }

      function formatAmount(value) {
        return toAmount(value).toFixed(2);
      }

      function toInteger(value) {
        const number = parseInt(value, 10);
        return Number.isFinite(number) ? number : null;
      }

      function resolveOrderDisplayNumber(orderNumber, fallbackOrderId) {
        const normalizedOrderNumber = toInteger(orderNumber);
        if (normalizedOrderNumber !== null && normalizedOrderNumber > 0) {
          return normalizedOrderNumber;
        }

        const normalizedOrderId = toInteger(fallbackOrderId);
        if (normalizedOrderId !== null && normalizedOrderId > 0) {
          return normalizedOrderId;
        }

        return null;
      }

      function getSelectedOrderDisplayNumber() {
        return resolveOrderDisplayNumber(
          $("#selectedOrderNumber").val(),
          $("#selectedOrderId").val()
        );
      }

      function scheduleOrderTableHeightRefresh() {
        if (typeof window !== "undefined" && typeof window.requestAnimationFrame === "function") {
          window.requestAnimationFrame(updateOrderDetailsTableHeight);
          return;
        }
        setTimeout(updateOrderDetailsTableHeight, 0);
      }

      function updateOrderDetailsTableHeight() {
        const orderDetailsColumn = $("#orderDetailsColumn");
        if (
          orderDetailsColumn.length === 0 ||
          orderDetailsColumn.hasClass("d-none") ||
          !orderDetailsColumn.is(":visible")
        ) {
          return;
        }

        const panel = orderDetailsColumn.find(".bill-panel").first();
        const tableWrap = panel.find(".order-table-wrap").first();
        const panelTitle = panel.find("h4").first();
        const panelFooter = panel.find(".order-details-footer").first();

        if (panel.length === 0 || tableWrap.length === 0) {
          return;
        }

        const panelInnerHeight = panel.innerHeight();
        const titleHeight = panelTitle.length > 0 ? panelTitle.outerHeight(true) : 0;
        const footerHeight = panelFooter.length > 0 ? panelFooter.outerHeight(true) : 0;

        const width = window.innerWidth || document.documentElement.clientWidth || 1200;
        const minHeightPx = width <= 480 ? 210 : width <= 768 ? 260 : 320;
        let tableHeightPx = Math.floor((panelInnerHeight || 0) - titleHeight - footerHeight);
        if (!Number.isFinite(tableHeightPx) || tableHeightPx < minHeightPx) {
          tableHeightPx = minHeightPx;
        }

        tableWrap.css({
          height: tableHeightPx + "px",
          minHeight: tableHeightPx + "px",
          maxHeight: tableHeightPx + "px",
        });
      }

      let actionLoadingCount = 0;
      let orderPageAlertTimer = null;

      function showActionLoading(message) {
        const loader = $("#actionLoader");
        const loaderText = $("#actionLoaderText");
        actionLoadingCount += 1;
        loaderText.text(message || "Please wait...");
        loader.removeClass("d-none");
      }

      function hideActionLoading() {
        actionLoadingCount = Math.max(0, actionLoadingCount - 1);
        if (actionLoadingCount === 0) {
          $("#actionLoader").addClass("d-none");
          $("#actionLoaderText").text("Please wait...");
        }
      }

      function showOrderSaveStatus(message, isError) {
        const statusEl = $("#orderSaveStatus");
        if (!message) {
          statusEl.addClass("d-none").text("");
          statusEl.removeClass("text-danger text-success");
          scheduleOrderTableHeightRefresh();
          return;
        }

        statusEl
          .removeClass("d-none text-danger text-success")
          .addClass(isError ? "text-danger" : "text-success")
          .text(message);
        scheduleOrderTableHeightRefresh();
      }

      function showTopRightMessage(message, type) {
        const alertBox = $("#orderPageAlertBox");
        if (alertBox.length === 0) {
          return;
        }

        clearTimeout(orderPageAlertTimer);

        const normalizedType = (type || "").toString().trim().toLowerCase();
        let alertClass = "alert-success";
        if (normalizedType === "error") {
          alertClass = "alert-danger";
        } else if (normalizedType === "warning") {
          alertClass = "alert-warning";
        }

        if (!message) {
          alertBox.empty();
          return;
        }

        const html =
          '<div class="alert ' +
          alertClass +
          '" role="alert"><strong>' +
          escapeHtml(message) +
          "</strong></div>";
        alertBox.html(html);

        orderPageAlertTimer = setTimeout(function () {
          alertBox.empty();
        }, 3000);
      }

      function renderEmptyOrderDetailsRow(message) {
        const emptyMessage = message || "No items in order.";
        $("#tableMenu").html(
          "<tr class='order-empty-row'><td colspan='3' class='text-center text-muted'>" +
            escapeHtml(emptyMessage) +
            "</td></tr>"
        );
        updateOrderTotalsSummary();
        scheduleOrderTableHeightRefresh();
      }

      function hasOrderLineRows() {
        return $("#tableMenu tr").not(".order-empty-row").length > 0;
      }

      function calculateOrderSubTotal() {
        let subTotal = 0;
        $("#tableMenu tr")
          .not(".order-empty-row")
          .each(function () {
            const row = $(this);
            const qty = getOrderRowQuantity(row);
            const unitPrice = resolveOrderRowUnitPrice(row);
            subTotal += unitPrice * qty;
          });
        return subTotal;
      }

      function sanitizePercentage(value) {
        const safeValue = toAmount(value);
        return Math.min(100, Math.max(0, safeValue));
      }

      function getOrderDiscountPercentageInputValue() {
        return sanitizePercentage($("#orderDiscountPercentage").val());
      }

      function getOrderCgstPercentageInputValue() {
        return sanitizePercentage($("#orderCgstPercentage").val());
      }

      function getOrderSgstPercentageInputValue() {
        return sanitizePercentage($("#orderSgstPercentage").val());
      }

      function setOrderTaxPercentages(discountPercentage, cgstPercentage, sgstPercentage) {
        $("#orderDiscountPercentage").val(formatAmount(sanitizePercentage(discountPercentage)));
        $("#orderCgstPercentage").val(formatAmount(sanitizePercentage(cgstPercentage)));
        $("#orderSgstPercentage").val(formatAmount(sanitizePercentage(sgstPercentage)));
        updateOrderTotalsSummary();
      }

      function setOrderCustomerDetails(name, mobile) {
        const customerName = (name || "").trim();
        const customerMobile = (mobile || "").trim();
        $("#orderCustomerName").val(customerName);
        $("#orderCustomerMobile").val(customerMobile);
        updateOrderCustomerSummary();
      }

      function getOrderCustomerNameValue() {
        const customerName = ($("#orderCustomerName").val() || "").trim();
        return customerName !== "" ? customerName : null;
      }

      function getOrderCustomerMobileValue() {
        const customerMobile = ($("#orderCustomerMobile").val() || "").trim();
        return customerMobile !== "" ? customerMobile : null;
      }

      function normalizeOrderPaymentMethod(paymentMethod) {
        const normalizedValue = (paymentMethod || "")
          .toString()
          .trim()
          .toUpperCase()
          .replace(/[\s-]+/g, "_");

        if (
          normalizedValue === "UPI" ||
          normalizedValue === "UPI_INTENT" ||
          normalizedValue === "UPI_APP" ||
          normalizedValue === "UPI_SCAN"
        ) {
          return "UPI";
        }

        if (
          normalizedValue === "CARD" ||
          normalizedValue === "DEBIT_CARD" ||
          normalizedValue === "CREDIT_CARD"
        ) {
          return "CARD";
        }

        if (normalizedValue === "CASH" || normalizedValue === "MANUAL") {
          return "CASH";
        }

        return "CASH";
      }

      function formatOrderPaymentMethod(paymentMethod) {
        const normalizedValue = normalizeOrderPaymentMethod(paymentMethod);
        if (normalizedValue === "UPI") {
          return "UPI";
        }
        if (normalizedValue === "CARD") {
          return "Card";
        }
        return "Cash";
      }

      function getOrderPaymentMethodInputValue() {
        const selectedPaymentMethod = $(".order-payment-method-radio:checked").val();
        if (selectedPaymentMethod) {
          return normalizeOrderPaymentMethod(selectedPaymentMethod);
        }

        const hiddenPaymentMethod = ($("#orderPaymentMethod").val() || "").trim();
        if (hiddenPaymentMethod === "") {
          return "";
        }

        return normalizeOrderPaymentMethod(hiddenPaymentMethod);
      }

      function updateOrderPaymentMethodSummary() {
        const paymentMethod = getOrderPaymentMethodInputValue();
        $("#orderPaymentMethodSummary").text(
          paymentMethod ? formatOrderPaymentMethod(paymentMethod) : "-"
        );
      }

      function setOrderPaymentMethod(paymentMethod) {
        const normalizedValue = normalizeOrderPaymentMethod(paymentMethod);
        $("#orderPaymentMethod").val(normalizedValue);
        $(".order-payment-method-radio").prop("checked", false);
        $(".order-payment-method-radio[value='" + normalizedValue + "']").prop(
          "checked",
          true
        );
        updateOrderPaymentMethodSummary();
      }

      function clearOrderPaymentMethod() {
        $("#orderPaymentMethod").val("");
        $(".order-payment-method-radio").prop("checked", false);
        updateOrderPaymentMethodSummary();
      }

      function updateOrderCustomerSummary() {
        const customerName = ($("#orderCustomerName").val() || "").trim();
        const customerMobile = ($("#orderCustomerMobile").val() || "").trim();
        let summary = "Walk-in";
        if (customerName !== "" && customerMobile !== "") {
          summary = customerName + " (" + customerMobile + ")";
        } else if (customerName !== "") {
          summary = customerName;
        } else if (customerMobile !== "") {
          summary = customerMobile;
        }
        $("#orderCustomerSummary").text(summary);
      }

      let customerLookupDebounceTimer = null;
      let customerLookupRequestSequence = 0;

      function resetCustomerLookupInfo() {
        $("#customerLookupInfo")
          .addClass("d-none")
          .removeClass("text-danger text-muted")
          .text("");
      }

      function setCustomerLookupInfo(message, isError) {
        const infoEl = $("#customerLookupInfo");
        if (!message) {
          resetCustomerLookupInfo();
          return;
        }

        infoEl
          .removeClass("d-none text-danger text-muted")
          .addClass(isError ? "text-danger" : "text-muted")
          .text(message);
      }

      function requestExistingCustomerByMobile(mobile) {
        const normalizedMobile = (mobile || "").trim();
        if (normalizedMobile === "") {
          resetCustomerLookupInfo();
          return;
        }

        const requestSequence = ++customerLookupRequestSequence;
        setCustomerLookupInfo("Checking customer history...", false);

        $.ajax({
          url: "orders/customer/by-mobile",
          type: "GET",
          data: { mobile: normalizedMobile },
          global: false,
          success: function (response) {
            if (requestSequence !== customerLookupRequestSequence) {
              return;
            }

            const visitCount = Math.max(0, toInteger(response && response.visitCount) || 0);
            const customerName =
              response && response.customerName ? String(response.customerName).trim() : "";

            if (customerName !== "") {
              $("#customerNameInput").val(customerName);
            }

            if (visitCount <= 0) {
              setCustomerLookupInfo("No previous visits found for this number.", false);
              return;
            }

            const visitLabel = visitCount === 1 ? "time" : "times";
            if (customerName !== "") {
              setCustomerLookupInfo(
                customerName + " | Visited " + visitCount + " " + visitLabel,
                false
              );
              return;
            }

            setCustomerLookupInfo("Existing customer | Visited " + visitCount + " " + visitLabel, false);
          },
          error: function () {
            if (requestSequence !== customerLookupRequestSequence) {
              return;
            }
            setCustomerLookupInfo("Unable to fetch customer history.", true);
          },
        });
      }

      function scheduleExistingCustomerLookupByMobile(mobile) {
        clearTimeout(customerLookupDebounceTimer);
        const normalizedMobile = (mobile || "").trim();
        if (normalizedMobile === "") {
          resetCustomerLookupInfo();
          return;
        }

        customerLookupDebounceTimer = setTimeout(function () {
          requestExistingCustomerByMobile(normalizedMobile);
        }, 300);
      }

      function calculateOrderTotalsSummaryData() {
        const subTotal = calculateOrderSubTotal();
        const discountPercentage = getOrderDiscountPercentageInputValue();
        const discountAmount = subTotal * (discountPercentage / 100.0);
        const taxableAmount = Math.max(0, subTotal - discountAmount);
        const cgstPercentage = getOrderCgstPercentageInputValue();
        const sgstPercentage = getOrderSgstPercentageInputValue();
        const cgstAmount = taxableAmount * (cgstPercentage / 100.0);
        const sgstAmount = taxableAmount * (sgstPercentage / 100.0);
        const netAmount = taxableAmount + cgstAmount + sgstAmount;

        return {
          subTotal: subTotal,
          discountPercentage: discountPercentage,
          discountAmount: discountAmount,
          taxableAmount: taxableAmount,
          cgstPercentage: cgstPercentage,
          sgstPercentage: sgstPercentage,
          cgstAmount: cgstAmount,
          sgstAmount: sgstAmount,
          netAmount: netAmount,
        };
      }

      function updateOrderTotalsSummary() {
        const totals = calculateOrderTotalsSummaryData();
        $("#orderSubTotalAmount").text(formatAmount(totals.subTotal));
        $("#orderDiscountPercentDisplay").text(formatAmount(totals.discountPercentage));
        $("#orderDiscountAppliedAmount").text(formatAmount(totals.discountAmount));
        $("#orderTaxableAmount").text(formatAmount(totals.taxableAmount));
        $("#orderCgstPercentDisplay").text(formatAmount(totals.cgstPercentage));
        $("#orderCgstAmount").text(formatAmount(totals.cgstAmount));
        $("#orderSgstPercentDisplay").text(formatAmount(totals.sgstPercentage));
        $("#orderSgstAmount").text(formatAmount(totals.sgstAmount));
        $("#orderNetTotalAmount").text(formatAmount(totals.netAmount));
        updateOrderCustomerSummary();
        updateOrderPaymentMethodSummary();
      }

      function resetOrderTotals() {
        setOrderTaxPercentages(0, 0, 0);
        setOrderCustomerDetails("", "");
        clearOrderPaymentMethod();
      }

      function collectOrderPayloadItems() {
        const items = [];
        $("#tableMenu tr")
          .not(".order-empty-row")
          .each(function () {
          const row = $(this);
          const qty = getOrderRowQuantity(row);
          const unitPrice = resolveOrderRowUnitPrice(row);
          const itemName = row.attr("data-item-name") || row.find("td").eq(0).text();
          const itemId = toInteger(row.attr("data-item-id"));
          const subItemId = toInteger(row.attr("data-sub-item-id"));

          if (!itemName || itemName.trim() === "") {
            return;
          }

          items.push({
            itemId: itemId,
            subItemId: subItemId,
            itemName: itemName,
            quantity: qty,
            unitPrice: unitPrice,
          });
          });

        return items;
      }

      function getOrderRowQuantity(row) {
        const qtyEl = row.find(".order-qty-value").first();
        if (qtyEl.length > 0) {
          return Math.max(1, toInteger(qtyEl.text()) || 1);
        }

        return Math.max(1, toInteger(row.find("td").eq(1).text()) || 1);
      }

      function toAmountFromText(value) {
        const normalizedValue =
          value === null || value === undefined
            ? ""
            : String(value).replace(/[^0-9.\-]/g, "");
        return toAmount(normalizedValue);
      }

      function resolveOrderRowUnitPrice(row) {
        const qty = getOrderRowQuantity(row);
        let unitPrice = toAmount(row.attr("data-unit-price"));
        if (unitPrice > 0) {
          return unitPrice;
        }

        const lineTotalEl = row.find(".order-line-price").first();
        const lineTotalText =
          lineTotalEl.length > 0 ? lineTotalEl.text() : row.find("td").eq(2).text();
        const lineTotal = toAmountFromText(lineTotalText);
        if (lineTotal > 0 && qty > 0) {
          unitPrice = lineTotal / qty;
          row.attr("data-unit-price", unitPrice);
          return unitPrice;
        }

        const fallbackCellAmount = toAmountFromText(row.find("td").eq(2).text());
        if (fallbackCellAmount > 0) {
          row.attr("data-unit-price", fallbackCellAmount);
          return fallbackCellAmount;
        }

        return 0;
      }

      function setOrderRowQuantityAndPrice(row, qty) {
        const safeQty = Math.max(1, toInteger(qty) || 1);
        const unitPrice = resolveOrderRowUnitPrice(row);
        const lineTotal = formatAmount(unitPrice * safeQty);

        const qtyEl = row.find(".order-qty-value").first();
        if (qtyEl.length > 0) {
          qtyEl.text(safeQty);
        } else {
          row.find("td").eq(1).text(safeQty);
        }

        const lineTotalEl = row.find(".order-line-price").first();
        if (lineTotalEl.length > 0) {
          lineTotalEl.text(lineTotal);
        } else {
          row.find("td").eq(2).text(lineTotal);
        }

        updateOrderTotalsSummary();
      }

      function getTableLabel(tableName, tableId) {
        const label = (tableName || "").trim();
        return label !== "" ? label : "Table " + tableId;
      }

      function getSelectedTableLabel(tableId, fallbackTableName) {
        const fallbackName = (fallbackTableName || "").trim();
        const selectedName = ($("#selectedTableName").val() || "").trim();
        const displayName = fallbackName !== "" ? fallbackName : selectedName;
        return getTableLabel(displayName, tableId);
      }

      function updateOrderSelectedTableInfo(tableId, tableName, orderNumber) {
        const infoEl = $("#orderSelectedTableInfo");
        if (infoEl.length === 0) {
          return;
        }

        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          infoEl.text("Selected table: -");
          return;
        }

        const tableLabel = getTableLabel(tableName, normalizedTableId);
        const normalizedOrderNumber = toInteger(orderNumber);
        if (normalizedOrderNumber !== null && normalizedOrderNumber > 0) {
          infoEl.text("Selected table: " + tableLabel + " (Order #" + normalizedOrderNumber + ").");
          return;
        }

        infoEl.text("Selected table: " + tableLabel + ".");
      }

      function getRestaurantDisplayName() {
        const appTitle = $(".app-title").first().text();
        const displayName = (appTitle || "").trim();
        return displayName !== "" ? displayName : "Restaurant";
      }

      function formatBillDateTime(value) {
        if (value === null || value === undefined || value === "") {
          return "-";
        }

        const dateValue = value instanceof Date ? value : new Date(value);
        if (Number.isNaN(dateValue.getTime())) {
          return String(value);
        }

        return dateValue.toLocaleString("en-IN", {
          day: "2-digit",
          month: "short",
          year: "numeric",
          hour: "2-digit",
          minute: "2-digit",
        });
      }

      function buildPrintableRowsFromCurrentOrder() {
        const rows = [];
        $("#tableMenu tr")
          .not(".order-empty-row")
          .each(function () {
            const row = $(this);
            const qty = getOrderRowQuantity(row);
            const unitPrice = resolveOrderRowUnitPrice(row);
            const total = unitPrice * qty;
            const itemName =
              (row.attr("data-item-name") || row.find("td").eq(0).text() || "Item").trim();

            if (itemName === "") {
              return;
            }

            rows.push({
              itemName: itemName,
              quantity: qty,
              unitPrice: unitPrice,
              total: total,
            });
          });
        return rows;
      }

      function buildPrintableRowsFromResponse(response) {
        const responseItems = Array.isArray(response && response.items)
          ? response.items
          : [];
        const rows = [];

        responseItems.forEach(function (item) {
          const qty = Math.max(1, toInteger(item && item.quantity) || 1);
          const responseTotal = toAmount(item && item.total);
          const unitPrice =
            qty > 0 && responseTotal > 0
              ? responseTotal / qty
              : toAmount(item && item.unitPrice);
          const total = responseTotal > 0 ? responseTotal : unitPrice * qty;
          const itemName = (item && item.itemName ? item.itemName : "Item").trim();

          if (itemName === "") {
            return;
          }

          rows.push({
            itemName: itemName,
            quantity: qty,
            unitPrice: unitPrice,
            total: total,
          });
        });

        return rows;
      }

      function resolvePosPaperWidthMm(requestedWidthMm) {
        const requested = toInteger(requestedWidthMm);
        if (requested === 58 || requested === 80) {
          return requested;
        }

        let storedWidth = null;
        try {
          if (window && window.localStorage) {
            storedWidth = toInteger(window.localStorage.getItem("posPaperWidthMm"));
          }
        } catch (error) {
          storedWidth = null;
        }

        if (storedWidth === 58 || storedWidth === 80) {
          return storedWidth;
        }

        return 80;
      }

      function openPrintableBill(orderData) {
        const data = orderData || {};
        const items = Array.isArray(data.items) ? data.items : [];

        if (items.length === 0) {
          showOrderSaveStatus("No items found to print the bill.", true);
          return false;
        }

        let totalQuantity = 0;
        let grandTotal = 0;
        const itemRowsHtml = items
          .map(function (item) {
            const qty = Math.max(1, toInteger(item.quantity) || 1);
            const unitPrice = toAmount(item.unitPrice);
            const lineTotal = toAmount(item.total);
            totalQuantity += qty;
            grandTotal += lineTotal;

            return (
              "<tr>" +
              "<td class='item-cell text-start'>" +
              escapeHtml(item.itemName || "Item") +
              "</td>" +
              "<td class='text-end'>" +
              qty +
              "</td>" +
              "<td class='text-end'>" +
              formatAmount(unitPrice) +
              "</td>" +
              "<td class='text-end'>" +
              formatAmount(lineTotal) +
              "</td>" +
              "</tr>"
            );
          })
          .join("");
        const discountPercentage = sanitizePercentage(data.discountPercentage);
        const cgstPercentage = sanitizePercentage(data.cgstPercentage);
        const sgstPercentage = sanitizePercentage(data.sgstPercentage);
        const calculatedDiscountAmount = grandTotal * (discountPercentage / 100.0);
        const receivedDiscountAmount =
          data && data.discountAmount !== undefined && data.discountAmount !== null
            ? Math.max(0, toAmount(data.discountAmount))
            : calculatedDiscountAmount;
        const discountAmount = Math.min(receivedDiscountAmount, grandTotal);
        const calculatedTaxableAmount = Math.max(0, grandTotal - discountAmount);
        const taxableAmount =
          data && data.taxableAmount !== undefined && data.taxableAmount !== null
            ? Math.max(0, toAmount(data.taxableAmount))
            : calculatedTaxableAmount;
        const calculatedCgstAmount = taxableAmount * (cgstPercentage / 100.0);
        const calculatedSgstAmount = taxableAmount * (sgstPercentage / 100.0);
        const cgstAmount =
          data && data.cgstAmount !== undefined && data.cgstAmount !== null
            ? Math.max(0, toAmount(data.cgstAmount))
            : calculatedCgstAmount;
        const sgstAmount =
          data && data.sgstAmount !== undefined && data.sgstAmount !== null
            ? Math.max(0, toAmount(data.sgstAmount))
            : calculatedSgstAmount;
        const calculatedNetAmount = taxableAmount + cgstAmount + sgstAmount;
        const netTotal =
          data && data.netAmount !== undefined && data.netAmount !== null
            ? Math.max(0, toAmount(data.netAmount))
            : calculatedNetAmount;
        const hasTaxOrDiscount =
          discountAmount > 0 || cgstAmount > 0 || sgstAmount > 0;
        const subTotalHtml = hasTaxOrDiscount
          ? "<div class='bill-total'><span>Sub Total</span><span>Rs. " +
            formatAmount(grandTotal) +
            "</span></div>"
          : "";
        const discountHtml =
          discountAmount > 0
            ? "<div class='bill-total'><span>Discount (" +
              formatAmount(discountPercentage) +
              "%)</span><span>- Rs. " +
              formatAmount(discountAmount) +
              "</span></div>"
            : "";
        const taxableHtml = hasTaxOrDiscount
          ? "<div class='bill-total'><span>Taxable Amount</span><span>Rs. " +
            formatAmount(taxableAmount) +
            "</span></div>"
          : "";
        const cgstHtml =
          cgstAmount > 0
            ? "<div class='bill-total'><span>CGST (" +
              formatAmount(cgstPercentage) +
              "%)</span><span>Rs. " +
              formatAmount(cgstAmount) +
              "</span></div>"
            : "";
        const sgstHtml =
          sgstAmount > 0
            ? "<div class='bill-total'><span>SGST (" +
              formatAmount(sgstPercentage) +
              "%)</span><span>Rs. " +
              formatAmount(sgstAmount) +
              "</span></div>"
            : "";
        const finalTotalLabel = hasTaxOrDiscount ? "Net Total" : "Grand Total";

        const tableId = toInteger(data.tableId);
        const tableLabel = getTableLabel(data.tableName, tableId || "-");
        const orderId = toInteger(data.orderId);
        const orderTypeRaw = (data.orderType || "DINE_IN").toString();
        const orderType = orderTypeRaw.replace(/_/g, " ");
        const customerName = (data.customerName || "").trim();
        const customerMobile = (data.mobile || "").trim();
        const customerNameHtml =
          customerName !== ""
            ? "<div class='bill-meta'><span>Name</span><span>" +
              escapeHtml(customerName) +
              "</span></div>"
            : "";
        const customerMobileHtml =
          customerMobile !== ""
            ? "<div class='bill-meta'><span>Mobile</span><span>" +
              escapeHtml(customerMobile) +
              "</span></div>"
            : "";
        const paymentMethod = normalizeOrderPaymentMethod(data.paymentMethod);
        const paymentMethodHtml =
          "<div class='bill-meta'><span>Payment</span><span>" +
          escapeHtml(formatOrderPaymentMethod(paymentMethod)) +
          "</span></div>";
        const restaurantName = getRestaurantDisplayName();
        const paperWidthMm = resolvePosPaperWidthMm(data.paperWidthMm);
        const isNarrowPaper = paperWidthMm === 58;
        const contentWidthMm = isNarrowPaper ? 52 : 72;
        const previewWindowWidth = isNarrowPaper ? 330 : 390;
        const previewWindowHeight = 760;
        const printWindow = window.open(
          "",
          "_blank",
          "width=" + previewWindowWidth + ",height=" + previewWindowHeight
        );

        if (!printWindow) {
          showOrderSaveStatus(
            "Unable to open print window. Please allow pop-ups and try again.",
            true
          );
          return false;
        }

        const printableHtml =
          "<!DOCTYPE html>" +
          "<html><head><meta charset='UTF-8'><title>Order Bill</title>" +
          "<style>" +
          "@page{size:" +
          paperWidthMm +
          "mm auto;margin:0;}" +
          "html{width:" +
          paperWidthMm +
          "mm;margin:0;padding:0;background:#fff;color:#000;}" +
          "body{width:" +
          contentWidthMm +
          "mm;margin:0 auto;padding:0;background:#fff;color:#000;font-family:'Courier New',monospace;font-size:" +
          (isNarrowPaper ? "10px" : "11px") +
          ";line-height:1.15;}" +
          ".bill-wrap{width:100%;margin:0;padding:0;}" +
          ".bill-title{text-align:center;font-weight:700;font-size:" +
          (isNarrowPaper ? "13px" : "14px") +
          ";margin-bottom:1px;}" +
          ".bill-sub{text-align:center;font-size:" +
          (isNarrowPaper ? "10px" : "11px") +
          ";margin-bottom:2px;}" +
          ".bill-meta{display:flex;justify-content:space-between;align-items:flex-start;font-size:" +
          (isNarrowPaper ? "9px" : "10px") +
          ";margin-bottom:0;gap:2px;}" +
          ".bill-meta span:first-child{padding-right:2px;}" +
          ".bill-meta span:last-child{text-align:right;word-break:break-word;}" +
          ".bill-divider{border-top:1px dashed #000;margin:2px 0;}" +
          "table{width:100%;border-collapse:collapse;table-layout:fixed;font-size:" +
          (isNarrowPaper ? "9px" : "10px") +
          ";}" +
          "th,td{padding:1px 0;vertical-align:top;}" +
          "th{font-weight:700;border-bottom:1px dashed #000;}" +
          "th:nth-child(1),td:nth-child(1){width:" +
          (isNarrowPaper ? "44%" : "46%") +
          ";}" +
          "th:nth-child(2),td:nth-child(2){width:14%;}" +
          "th:nth-child(3),td:nth-child(3){width:" +
          (isNarrowPaper ? "24%" : "22%") +
          ";}" +
          "th:nth-child(4),td:nth-child(4){width:18%;}" +
          ".item-cell{padding-right:1px;word-break:break-word;}" +
          ".text-start{text-align:left;}" +
          ".text-end{text-align:right;}" +
          ".bill-total{display:flex;justify-content:space-between;font-size:" +
          (isNarrowPaper ? "10px" : "11px") +
          ";font-weight:700;margin-top:1px;}" +
          ".bill-footer{text-align:center;font-size:" +
          (isNarrowPaper ? "9px" : "10px") +
          ";margin-top:3px;}" +
          "@media print{html{width:" +
          paperWidthMm +
          "mm !important;}body{width:" +
          contentWidthMm +
          "mm !important;margin:0 auto !important;}.bill-wrap{width:100% !important;}}" +
          "</style></head><body>" +
          "<div class='bill-wrap'>" +
          "<div class='bill-title'>" +
          escapeHtml(restaurantName) +
          "</div>" +
          "<div class='bill-sub'>Restaurant Bill</div>" +
          "<div class='bill-meta'><span>Table</span><span>" +
          escapeHtml(tableLabel) +
          "</span></div>" +
          "<div class='bill-meta'><span>Order</span><span>" +
          escapeHtml(orderId ? "#" + orderId : "-") +
          "</span></div>" +
          "<div class='bill-meta'><span>Type</span><span>" +
          escapeHtml(orderType) +
          "</span></div>" +
          customerNameHtml +
          customerMobileHtml +
          paymentMethodHtml +
          "<div class='bill-meta'><span>Order Time</span><span>" +
          escapeHtml(formatBillDateTime(data.createdAt || new Date())) +
          "</span></div>" +
          "<div class='bill-meta'><span>Print Time</span><span>" +
          escapeHtml(formatBillDateTime(new Date())) +
          "</span></div>" +
          "<div class='bill-divider'></div>" +
          "<table><thead><tr><th class='text-start'>Item</th><th class='text-end'>Qty</th><th class='text-end'>Rate</th><th class='text-end'>Amt</th></tr></thead><tbody>" +
          itemRowsHtml +
          "</tbody></table>" +
          "<div class='bill-total'><span>Total Qty</span><span>" +
          totalQuantity +
          "</span></div>" +
          subTotalHtml +
          discountHtml +
          taxableHtml +
          cgstHtml +
          sgstHtml +
          "<div class='bill-total'><span>" +
          finalTotalLabel +
          "</span><span>Rs. " +
          formatAmount(netTotal) +
          "</span></div>" +
          "<div class='bill-divider'></div>" +
          "<div class='bill-footer'>Thank you. Visit Again.</div>" +
          "</div>" +
          "<script>" +
          "window.onload=function(){setTimeout(function(){window.print();window.close();},150);};" +
          "<\/script>" +
          "</body></html>";

        printWindow.document.open();
        printWindow.document.write(printableHtml);
        printWindow.document.close();
        return true;
      }

      function printOpenOrderBillForTable(tableId, tableName) {
        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          showOrderSaveStatus("Select a valid table before printing bill.", true);
          return;
        }

        const tableLabel = getTableLabel(tableName, normalizedTableId);
        showOrderSaveStatus("Preparing bill for " + tableLabel + "...", false);

        $.ajax({
          url: "orders/table/" + normalizedTableId + "/open",
          type: "GET",
          loadingText: "Preparing bill for " + tableLabel + "...",
          success: function (response) {
            const rows = buildPrintableRowsFromResponse(response);
            const didOpen = openPrintableBill({
              tableId: response && response.tableId ? response.tableId : normalizedTableId,
              tableName: response && response.tableName ? response.tableName : tableName,
              orderId: resolveOrderDisplayNumber(
                response && response.orderNumber !== undefined ? response.orderNumber : null,
                response && response.id ? response.id : null
              ),
              orderType: response && response.orderType ? response.orderType : "DINE_IN",
              createdAt: response && response.createdAt ? response.createdAt : null,
              customerName:
                response && response.customerName !== undefined
                  ? response.customerName
                  : "",
              mobile:
                response && response.mobile !== undefined
                  ? response.mobile
                  : "",
              paymentMethod:
                response && response.paymentMethod !== undefined
                  ? response.paymentMethod
                  : getOrderPaymentMethodInputValue(),
              discountPercentage:
                response && response.discountPercentage !== undefined
                  ? response.discountPercentage
                  : 0,
              discountAmount:
                response && response.discountAmount !== undefined
                  ? response.discountAmount
                  : 0,
              taxableAmount:
                response && response.taxableAmount !== undefined
                  ? response.taxableAmount
                  : null,
              cgstPercentage:
                response && response.cgstPercentage !== undefined
                  ? response.cgstPercentage
                  : 0,
              sgstPercentage:
                response && response.sgstPercentage !== undefined
                  ? response.sgstPercentage
                  : 0,
              cgstAmount:
                response && response.cgstAmount !== undefined
                  ? response.cgstAmount
                  : null,
              sgstAmount:
                response && response.sgstAmount !== undefined
                  ? response.sgstAmount
                  : null,
              netAmount:
                response && response.netAmount !== undefined
                  ? response.netAmount
                  : null,
              items: rows,
            });

            if (didOpen) {
              showOrderSaveStatus("Bill opened for " + tableLabel + ".", false);
            }
          },
          error: function (xhr) {
            if (xhr && xhr.status === 404) {
              showOrderSaveStatus("No open order found for " + tableLabel + ".", true);
              return;
            }
            showOrderSaveStatus("Unable to prepare bill for " + tableLabel + ".", true);
          },
        });
      }

      function resolveTableContext(buttonElement) {
        const tableButton = $(buttonElement).closest(".tables-btn");
        if (tableButton.length === 0) {
          return null;
        }

        const tableId = toInteger(tableButton.attr("data-table"));
        if (tableId === null || tableId <= 0) {
          return null;
        }

        const tableName = $.trim(tableButton.clone().children().remove().end().text());
        return {
          tableId: tableId,
          tableName: tableName,
        };
      }

      function showPendingOrderUpdateStatus(actionLabel) {
        const tableId = toInteger($("#selectedTableId").val());
        if (tableId !== null && tableId > 0) {
          showOrderSaveStatus(
            actionLabel +
              " for table " +
              tableId +
              ". Click Save to update table order.",
            false
          );
          return;
        }

        showOrderSaveStatus(
          actionLabel + ". Select a table and click Save to update order.",
          false
        );
      }

      let autoSaveQtyTimer = null;
      let isOrderSaveRequestInFlight = false;
      let pendingAutoSaveRequest = false;

      function scheduleAutoSaveForQtyChange(delayMs) {
        clearTimeout(autoSaveQtyTimer);
        autoSaveQtyTimer = setTimeout(function () {
          saveCurrentTableOrder({ autoTriggered: true });
        }, delayMs || 300);
      }

      function saveCurrentTableOrder(options) {
        const opts = options || {};
        const autoTriggered = opts.autoTriggered === true;
        const onSaved = typeof opts.onSaved === "function" ? opts.onSaved : null;
        const onSaveError = typeof opts.onSaveError === "function" ? opts.onSaveError : null;
        const onSaveComplete = typeof opts.onSaveComplete === "function" ? opts.onSaveComplete : null;
        const tableId = toInteger($("#selectedTableId").val());

        if (tableId === null || tableId <= 0) {
          if (!autoTriggered) {
            showOrderSaveStatus("Select a table before saving the order.", true);
          }
          return;
        }

        const items = collectOrderPayloadItems();
        if (items.length === 0) {
          if (!autoTriggered) {
            showOrderSaveStatus("Add at least one item before saving.", true);
          }
          return;
        }
        const totals = calculateOrderTotalsSummaryData();

        if (isOrderSaveRequestInFlight) {
          if (autoTriggered) {
            pendingAutoSaveRequest = true;
          }
          return;
        }

        const saveButton = $(".saveTableOrder");
        saveButton.prop("disabled", true).addClass("is-loading");
        showOrderSaveStatus(autoTriggered ? "Auto saving order..." : "Saving order...", false);

        isOrderSaveRequestInFlight = true;

        $.ajax({
          url: "orders",
          type: "POST",
          contentType: "application/json",
          loadingText: autoTriggered ? "Auto saving order..." : "Saving order...",
          data: JSON.stringify({
            tableId: tableId,
            orderType: "DINE_IN",
            customerName: getOrderCustomerNameValue(),
            mobile: getOrderCustomerMobileValue(),
            paymentMethod: getOrderPaymentMethodInputValue(),
            discountPercentage: totals.discountPercentage,
            cgstPercentage: totals.cgstPercentage,
            sgstPercentage: totals.sgstPercentage,
            items: items,
          }),
          success: function (response) {
            const orderId = response && response.id ? response.id : null;
            const orderDisplayNumber = resolveOrderDisplayNumber(
              response && response.orderNumber !== undefined ? response.orderNumber : null,
              orderId
            );
            $("#selectedOrderId").val(orderId ? orderId : "");
            $("#selectedOrderNumber").val(
              orderDisplayNumber !== null ? String(orderDisplayNumber) : ""
            );
            if (response) {
              setOrderTaxPercentages(
                response.discountPercentage,
                response.cgstPercentage,
                response.sgstPercentage
              );
              setOrderCustomerDetails(response.customerName, response.mobile);
              setOrderPaymentMethod(response.paymentMethod);
            } else {
              updateOrderTotalsSummary();
            }
            const tableLabel = getSelectedTableLabel(
              tableId,
              response && response.tableName ? response.tableName : ""
            );
            if (response && response.tableName) {
                  $("#selectedTableName").val(response.tableName);
            }
            updateOrderSelectedTableInfo(
              tableId,
              $("#selectedTableName").val(),
              orderDisplayNumber
            );
            if (orderDisplayNumber !== null) {
              showOrderSaveStatus(
                "Order #" +
                  orderDisplayNumber +
                  (autoTriggered ? " auto-saved for " : " saved for ") +
                  tableLabel +
                  ".",
                false
              );
            } else {
              showOrderSaveStatus(
                autoTriggered ? "Order auto-saved successfully." : "Order saved successfully.",
                false
              );
            }
            if (onSaved) {
              onSaved(response);
            }
          },
          error: function (xhr) {
            let message = "Unable to save order";
            if (
              xhr &&
              xhr.responseJSON &&
              xhr.responseJSON.message &&
              xhr.responseJSON.message.trim() !== ""
            ) {
              message = xhr.responseJSON.message;
            }
            showOrderSaveStatus(message, true);
            if (onSaveError) {
              onSaveError(xhr, message);
            }
          },
          complete: function () {
            isOrderSaveRequestInFlight = false;
            saveButton.prop("disabled", false).removeClass("is-loading");

            if (pendingAutoSaveRequest) {
              pendingAutoSaveRequest = false;
              scheduleAutoSaveForQtyChange(150);
            }
            if (onSaveComplete) {
              onSaveComplete();
            }
          },
        });
      }

      function deleteOpenOrderForTable(tableId, options) {
        const opts = options || {};
        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          showOrderSaveStatus("Select a table before deleting the order.", true);
          return;
        }

        const tableLabel = opts.tableLabel || getSelectedTableLabel(normalizedTableId, "");
        const successMessage =
          opts.successMessage || "Order deleted for " + tableLabel + ".";
        const notFoundMessage =
          opts.notFoundMessage || "No open order found for " + tableLabel + ".";
        const deletingMessage =
          opts.deletingMessage || "Deleting order for " + tableLabel + "...";
        const shouldShowDeletingMessage = opts.showDeletingMessage !== false;
        const deleteButton = opts.deleteButton || null;
        const onSuccess = typeof opts.onSuccess === "function" ? opts.onSuccess : null;
        const onNotFound = typeof opts.onNotFound === "function" ? opts.onNotFound : null;
        const onError = typeof opts.onError === "function" ? opts.onError : null;
        const onComplete = typeof opts.onComplete === "function" ? opts.onComplete : null;

        if (shouldShowDeletingMessage) {
          showOrderSaveStatus(deletingMessage, false);
        }

        $.ajax({
          url: "orders/table/" + normalizedTableId + "/open",
          type: "DELETE",
          loadingText: "Deleting order...",
          success: function () {
            renderEmptyOrderDetailsRow("No items in order for selected table.");
            resetOrderTotals();
            const selectedTableId = toInteger($("#selectedTableId").val());
            if (selectedTableId === normalizedTableId) {
              $("#selectedOrderId").val("");
              $("#selectedOrderNumber").val("");
              updateOrderSelectedTableInfo(normalizedTableId, $("#selectedTableName").val(), null);
            }
            showOrderSaveStatus(successMessage, false);
            if (onSuccess) {
              onSuccess();
            }
          },
          error: function (xhr) {
            if (xhr && xhr.status === 404) {
              renderEmptyOrderDetailsRow("No items in order for selected table.");
              resetOrderTotals();
              const selectedTableId = toInteger($("#selectedTableId").val());
              if (selectedTableId === normalizedTableId) {
                $("#selectedOrderId").val("");
                $("#selectedOrderNumber").val("");
                updateOrderSelectedTableInfo(normalizedTableId, $("#selectedTableName").val(), null);
              }
              showOrderSaveStatus(notFoundMessage, false);
              if (onNotFound) {
                onNotFound();
              }
              return;
            }

            let message = "Unable to delete order";
            if (
              xhr &&
              xhr.responseJSON &&
              xhr.responseJSON.message &&
              xhr.responseJSON.message.trim() !== ""
            ) {
              message = xhr.responseJSON.message;
            }
            showOrderSaveStatus(message, true);
            if (onError) {
              onError(xhr, message);
            }
          },
          complete: function () {
            if (deleteButton) {
              deleteButton.prop("disabled", false).removeClass("is-loading");
            }
            if (onComplete) {
              onComplete();
            }
          },
        });
      }

      function completeOpenOrderForTable(tableId, options) {
        const opts = options || {};
        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          showOrderSaveStatus("Select a table before completing the order.", true);
          return;
        }

        const tableLabel = opts.tableLabel || getSelectedTableLabel(normalizedTableId, "");
        const successMessage =
          opts.successMessage || "Order completed for " + tableLabel + ".";
        const notFoundMessage =
          opts.notFoundMessage || "No open order found for " + tableLabel + ".";
        const completingMessage =
          opts.completingMessage || "Completing order for " + tableLabel + "...";
        const shouldShowCompletingMessage = opts.showCompletingMessage !== false;
        const completeButton = opts.completeButton || null;
        const onSuccess = typeof opts.onSuccess === "function" ? opts.onSuccess : null;
        const onNotFound = typeof opts.onNotFound === "function" ? opts.onNotFound : null;
        const onError = typeof opts.onError === "function" ? opts.onError : null;
        const onComplete = typeof opts.onComplete === "function" ? opts.onComplete : null;

        if (shouldShowCompletingMessage) {
          showOrderSaveStatus(completingMessage, false);
        }

        $.ajax({
          url: "orders/table/" + normalizedTableId + "/complete",
          type: "POST",
          loadingText: "Completing order...",
          success: function (response) {
            renderEmptyOrderDetailsRow("No items in order for selected table.");
            resetOrderTotals();
            const selectedTableId = toInteger($("#selectedTableId").val());
            if (selectedTableId === normalizedTableId) {
              $("#selectedOrderId").val("");
              $("#selectedOrderNumber").val("");
              updateOrderSelectedTableInfo(normalizedTableId, $("#selectedTableName").val(), null);
            }
            showOrderSaveStatus(successMessage, false);
            if (onSuccess) {
              onSuccess(response);
            }
          },
          error: function (xhr) {
            if (xhr && xhr.status === 404) {
              renderEmptyOrderDetailsRow("No items in order for selected table.");
              resetOrderTotals();
              const selectedTableId = toInteger($("#selectedTableId").val());
              if (selectedTableId === normalizedTableId) {
                $("#selectedOrderId").val("");
                $("#selectedOrderNumber").val("");
                updateOrderSelectedTableInfo(normalizedTableId, $("#selectedTableName").val(), null);
              }
              showOrderSaveStatus(notFoundMessage, false);
              if (onNotFound) {
                onNotFound();
              }
              return;
            }

            let message = "Unable to complete order";
            if (
              xhr &&
              xhr.responseJSON &&
              xhr.responseJSON.message &&
              xhr.responseJSON.message.trim() !== ""
            ) {
              message = xhr.responseJSON.message;
            }
            showOrderSaveStatus(message, true);
            if (onError) {
              onError(xhr, message);
            }
          },
          complete: function () {
            if (completeButton) {
              completeButton.prop("disabled", false).removeClass("is-loading");
            }
            if (onComplete) {
              onComplete();
            }
          },
        });
      }

      function populateOrderDetails(orderResponse) {
        const items = Array.isArray(orderResponse && orderResponse.items)
          ? orderResponse.items
          : [];
        const responseDiscountPercentage =
          orderResponse && orderResponse.discountPercentage !== undefined
            ? orderResponse.discountPercentage
            : 0;
        const responseCgstPercentage =
          orderResponse && orderResponse.cgstPercentage !== undefined
            ? orderResponse.cgstPercentage
            : 0;
        const responseSgstPercentage =
          orderResponse && orderResponse.sgstPercentage !== undefined
            ? orderResponse.sgstPercentage
            : 0;
        const responseCustomerName =
          orderResponse && orderResponse.customerName ? orderResponse.customerName : "";
        const responseMobile =
          orderResponse && orderResponse.mobile ? orderResponse.mobile : "";

        if (items.length === 0) {
          renderEmptyOrderDetailsRow("No items in order for selected table.");
          setOrderTaxPercentages(
            responseDiscountPercentage,
            responseCgstPercentage,
            responseSgstPercentage
          );
          setOrderCustomerDetails(responseCustomerName, responseMobile);
          clearOrderPaymentMethod();
          return;
        }

        let rows = "";

        items.forEach(function (item) {
          const qty = Math.max(1, toInteger(item.quantity) || 1);
          const lineTotal = toAmount(item.total);
          const unitPriceValue =
            qty > 0 && lineTotal > 0
              ? lineTotal / qty
              : toAmount(item.unitPrice);
          const itemName = item.itemName || "Item";

          rows += buildOrderRow(itemName, qty, unitPriceValue, {
            itemId: toInteger(item.itemId),
            subItemId: toInteger(item.subItemId),
            itemName: itemName,
          });
        });

        if (rows === "") {
          renderEmptyOrderDetailsRow("No items in order for selected table.");
          setOrderTaxPercentages(
            responseDiscountPercentage,
            responseCgstPercentage,
            responseSgstPercentage
          );
          setOrderCustomerDetails(responseCustomerName, responseMobile);
          clearOrderPaymentMethod();
          return;
        }

        $("#tableMenu").html(rows);
        setOrderTaxPercentages(
          responseDiscountPercentage,
          responseCgstPercentage,
          responseSgstPercentage
        );
        setOrderCustomerDetails(responseCustomerName, responseMobile);
        clearOrderPaymentMethod();
      }

      function loadOpenOrderForTable(tableId, tableName) {
        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          return;
        }
        $("#selectedTableName").val((tableName || "").trim());
        updateOrderSelectedTableInfo(normalizedTableId, tableName, null);

        $("#tableMenu").empty();
        $("#selectedOrderId").val("");
        $("#selectedOrderNumber").val("");
        resetOrderTotals();
        showOrderSaveStatus(
          "Loading order details for " +
            getTableLabel(tableName, normalizedTableId) +
            "...",
          false
        );

        $.ajax({
          url: "orders/table/" + normalizedTableId + "/open",
          type: "GET",
          loadingText:
            "Loading order details for " +
            getTableLabel(tableName, normalizedTableId) +
            "...",
          success: function (response) {
            populateOrderDetails(response);
            const orderId = response && response.id ? response.id : null;
            const orderDisplayNumber = resolveOrderDisplayNumber(
              response && response.orderNumber !== undefined ? response.orderNumber : null,
              orderId
            );
            $("#selectedOrderId").val(orderId ? orderId : "");
            $("#selectedOrderNumber").val(
              orderDisplayNumber !== null ? String(orderDisplayNumber) : ""
            );
            const selectedTableName =
              response && response.tableName ? response.tableName : tableName;
            $("#selectedTableName").val((selectedTableName || "").trim());
            updateOrderSelectedTableInfo(normalizedTableId, selectedTableName, orderDisplayNumber);
            showOrderSaveStatus(
              orderDisplayNumber !== null ? "Order details loaded successfully." : "Table loaded.",
              false
            );
          },
          error: function (xhr) {
            renderEmptyOrderDetailsRow("No items in order for selected table.");
            $("#selectedOrderId").val("");
            $("#selectedOrderNumber").val("");
            resetOrderTotals();
            updateOrderSelectedTableInfo(normalizedTableId, tableName, null);
            if (xhr && xhr.status === 404) {
              showOrderSaveStatus(
                "No open order found for selected table.",
                false
              );
              return;
            }

            showOrderSaveStatus(
              "Unable to load order details for selected table.",
              true
            );
          },
        });
      }

      function openTableOrderViewModal(tableId, tableName) {
        const normalizedTableId = toInteger(tableId);
        if (normalizedTableId === null || normalizedTableId <= 0) {
          return;
        }

        const fallbackLabel = getTableLabel(tableName, normalizedTableId);
        $("#viewOrderModalTableName").text(fallbackLabel);
        $("#viewOrderModalOrderId").text("-");
        $("#viewOrderModalStatus").text("-");
        $("#viewOrderModalBody").html(
          '<tr><td colspan="3" class="text-center text-muted">Loading order details...</td></tr>'
        );
        $("#viewOrderModal").modal("show");

        $.ajax({
          url: "orders/table/" + normalizedTableId + "/open",
          type: "GET",
          loadingText:
            "Loading order details for " +
            getTableLabel(tableName, normalizedTableId) +
            "...",
          success: function (response) {
            const selectedTableName =
              response && response.tableName ? response.tableName : tableName;
            const tableLabel = getTableLabel(selectedTableName, normalizedTableId);
            const orderDisplayNumber = resolveOrderDisplayNumber(
              response && response.orderNumber !== undefined ? response.orderNumber : null,
              response && response.id ? response.id : null
            );
            const orderStatus =
              response && response.status ? response.status : "OPEN";
            const items = Array.isArray(response && response.items)
              ? response.items
              : [];

            $("#viewOrderModalTableName").text(tableLabel);
            $("#viewOrderModalOrderId").text(
              orderDisplayNumber !== null ? "#" + orderDisplayNumber : "-"
            );
            $("#viewOrderModalStatus").text(orderStatus);

            if (items.length === 0) {
              $("#viewOrderModalBody").html(
                '<tr><td colspan="3" class="text-center text-muted">No items found for this order.</td></tr>'
              );
              return;
            }

            let rows = "";
            items.forEach(function (item) {
              const qty = Math.max(1, toInteger(item.quantity) || 1);
              const lineTotal = toAmount(item.total);
              const unitPriceValue =
                qty > 0 && lineTotal > 0
                  ? lineTotal / qty
                  : toAmount(item.unitPrice);
              const itemName = item.itemName || "Item";

              rows +=
                "<tr><td>" +
                escapeHtml(itemName) +
                "</td><td>" +
                qty +
                "</td><td>" +
                formatAmount(unitPriceValue * qty) +
                "</td></tr>";
            });

            $("#viewOrderModalBody").html(rows);
          },
          error: function (xhr) {
            $("#viewOrderModalOrderId").text("-");
            $("#viewOrderModalStatus").text("-");

            if (xhr && xhr.status === 404) {
              $("#viewOrderModalBody").html(
                '<tr><td colspan="3" class="text-center text-muted">No open order found for this table.</td></tr>'
              );
              return;
            }

            $("#viewOrderModalBody").html(
              '<tr><td colspan="3" class="text-center text-danger">Unable to load order details.</td></tr>'
            );
          },
        });
      }

      function buildOrderRow(name, qty, unitPrice, options) {
        const meta = options || {};
        const safeQty = Math.max(1, parseInt(qty, 10) || 1);
        const safeUnitPrice = toAmount(unitPrice);
        const total = safeUnitPrice * safeQty;
        const itemName = meta.itemName || name;
        const itemIdAttr =
          meta.itemId !== undefined && meta.itemId !== null
            ? ' data-item-id="' + meta.itemId + '"'
            : "";
        const subItemIdAttr =
          meta.subItemId !== undefined && meta.subItemId !== null
            ? ' data-sub-item-id="' + meta.subItemId + '"'
            : "";

        return (
          "<tr" +
          itemIdAttr +
          subItemIdAttr +
          ' data-item-name="' +
          escapeHtml(itemName) +
          '" data-unit-price="' +
          safeUnitPrice +
          '"><td class=\'order-item-cell\'><button type=\'button\' class=\'removeItem order-remove-btn order-remove-inline\' title=\'Delete item\' aria-label=\'Delete item\'><i class=\'bi bi-trash\'></i></button><span class=\'order-item-text\'>' +
          escapeHtml(name) +
          "</span></td><td><div class='order-qty-controls'>" +
          "<button type='button' class='order-qty-btn orderQtyMinus' title='Decrease quantity' aria-label='Decrease quantity'><i class='bi bi-dash'></i></button>" +
          "<span class='order-qty-value'>" +
          safeQty +
          "</span>" +
          "<button type='button' class='order-qty-btn orderQtyPlus' title='Increase quantity' aria-label='Increase quantity'><i class='bi bi-plus'></i></button>" +
          "</div></td><td class='order-line-price'>" +
          formatAmount(total) +
          "</td></tr>"
        );
      }

      function findExistingOrderRow(itemId, subItemId, itemName) {
        const normalizedItemId = toInteger(itemId);
        const normalizedSubItemId = toInteger(subItemId);
        const normalizedItemName = (itemName || "").trim();
        let matchedRow = null;

        $("#tableMenu tr").each(function () {
          const row = $(this);
          const rowItemId = toInteger(row.attr("data-item-id"));
          const rowSubItemId = toInteger(row.attr("data-sub-item-id"));
          const rowItemName = (row.attr("data-item-name") || "").trim();

          const isSameById =
            rowItemId === normalizedItemId && rowSubItemId === normalizedSubItemId;
          const isSameByName =
            normalizedItemId === null &&
            rowItemId === null &&
            normalizedSubItemId === null &&
            rowSubItemId === null &&
            normalizedItemName !== "" &&
            rowItemName.toLowerCase() === normalizedItemName.toLowerCase();

          if (isSameById || isSameByName) {
            matchedRow = row;
            return false;
          }
        });

        return matchedRow;
      }

      function addOrUpdateOrderRow(name, qty, unitPrice, options) {
        const meta = options || {};
        const safeQty = Math.max(1, parseInt(qty, 10) || 1);
        const safeUnitPrice = toAmount(unitPrice);
        const itemName = meta.itemName || name;

        const existingRow = findExistingOrderRow(meta.itemId, meta.subItemId, itemName);
        if (existingRow && existingRow.length > 0) {
          const existingQty = getOrderRowQuantity(existingRow);
          const existingUnitPrice = toAmount(existingRow.attr("data-unit-price"));
          const mergedQty = existingQty + safeQty;
          const effectiveUnitPrice =
            existingUnitPrice > 0 ? existingUnitPrice : safeUnitPrice;

          if (meta.itemId !== undefined && meta.itemId !== null) {
            existingRow.attr("data-item-id", meta.itemId);
          }
          if (meta.subItemId !== undefined && meta.subItemId !== null) {
            existingRow.attr("data-sub-item-id", meta.subItemId);
          }

          existingRow.attr("data-item-name", itemName);
          existingRow.attr("data-unit-price", effectiveUnitPrice);
          const itemCell = existingRow.find("td").eq(0);
          const itemTextEl = itemCell.find(".order-item-text").first();
          if (itemTextEl.length > 0) {
            itemTextEl.text(name);
          } else {
            itemCell.html(
              "<button type='button' class='removeItem order-remove-btn order-remove-inline' title='Delete item' aria-label='Delete item'><i class='bi bi-trash'></i></button><span class='order-item-text'>" +
                escapeHtml(name) +
                "</span>"
            );
          }
          setOrderRowQuantityAndPrice(existingRow, mergedQty);
          return true;
        }

        $("#tableMenu .order-empty-row").remove();
        $("#tableMenu").append(buildOrderRow(name, safeQty, safeUnitPrice, meta));
        updateOrderTotalsSummary();
        return false;
      }

      function buildBaseItemRow(item) {
        if (!item) {
          return;
        }

        const itemName = item.name || "Item";
        const itemPrice = toAmount(item.price);

        const row =
          '<tr data-item-id="' +
          item.id +
          '" data-item-name="' +
          escapeHtml(itemName) +
          '" data-item-price="' +
          itemPrice +
          '">' +
          "<td>" +
          escapeHtml(itemName) +
          '</td><td><div class="d-flex align-items-center gap-2">' +
          '<button type="button" class="btn btn-danger btn-sm minusQty">-</button>' +
          '<span class="qty">1</span>' +
          '<button type="button" class="btn btn-success btn-sm plusQty">+</button>' +
          "</div></td><td>" +
          formatAmount(itemPrice) +
          "</td></tr>";

        $("#itemTbData").html(row);
      }

      function loadLeftMenu(page) {
        if (page !== undefined && page !== null && page !== "") {
          $("#sidebar a").removeClass("active");
          $('#sidebar a[data-menu-id="' + page + '"]').addClass("active");
        }

        const requestData = { status: "ACTIVE" };
        if (page !== undefined && page !== null && page !== "") {
          requestData.categoryId = page;
        }

        /* fetching left menu items */
        $.ajax({
          url: "menu-items",
          type: "GET",
          data: requestData,
          contentType: "application/json",
          loadingText: "Loading menu items...",
          beforeSend: function () {},
        })
          .done(function (data) {
            let leftContent = $("#leftContent");
            leftContent.empty();

            let menuHtml = '<div class="row g-2 menu-items-wrap">';

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                const itemName = item.name || "Item";
                const itemPrice = toAmount(item.price);
                menuHtml +=
                  '<div class="col-4 col-sm-3 col-lg-2"><div class="card sub-card-sm text-center p-1 menuItems menu-item-card" data-id="' +
                  item.id +
                  '" data-name="' +
                  escapeHtml(itemName) +
                  '" data-price="' +
                  itemPrice +
                  '">' +
                  '<div class="sub-name menu-item-name">' +
                  escapeHtml(itemName) +
                  "</div></div></div>";
              });
            } else {
              menuHtml +=
                '<div class="col-12"><div class="menu-empty-state">No menu items available</div></div>';
            }

            menuHtml += "</div>";
            leftContent.append(menuHtml);
          })
          .fail(function () {
            $("#leftContent").html(
              '<div class="menu-empty-state">Unable to load menu items</div>'
            );
          });
      }

      $(document).ready(function () {
        $(document).on("click", "#sidebar a", function () {
          closeSidebar();
        });

        $(document).on("click", function (event) {
          const target = event.target;
          if ($(target).closest("#sidebar, #sidebarToggleBtn").length > 0) {
            return;
          }
          closeSidebar();
        });

        window.addEventListener("resize", function () {
          if (window.innerWidth > 768) {
            closeTopbarLinks();
          }
          closeSidebar();
          scheduleOrderTableHeightRefresh();
        });

        $(document).ajaxSend(function (event, jqXHR, settings) {
          const loadingText =
            settings && settings.loadingText
              ? settings.loadingText
              : "Please wait...";
          showActionLoading(loadingText);
        });

        $(document).ajaxComplete(function () {
          hideActionLoading();
        });

        $(document).on("click", "#subItemContainer .sub-card-sm", function () {
          $(this).toggleClass("active"); // âœ… multi select
        });

        $("body").on("click", ".menuItems", function () {
          var id = $(this).data("id");

          $.ajax({
            url: "items",
            type: "GET",
            loadingText: "Loading item options...",
            success: function (res) {
              var subHtml = "";
              $("#itemTbData").empty();
              $("#subItemContainer").empty();

              if (res.subItems && res.subItems.length > 0) {
                $("#itemTables").hide();
                $.each(res.subItems, function (i, sub) {
                  subHtml +=
                    '<div class="col-3 col-md-3 col-lg-3">' +
                    '<div class="card sub-card-sm text-center p-1" data-name="' +
                    res.id +
                    "~" +
                    sub.id +
                    '">' +
                    '<div class="sub-name">' +
                    sub.name +
                    '</div><div class="sub-price">' +
                    sub.price +
                    "</div>" +
                    "</div></div>";
                });

                $("#subItemContainer").html(subHtml);
              } else {
                $("#itemTables").show();
                subHtml +=
                  "<tr><td>" +
                  res.name +
                  '</td><td><div style="display:flex;gap:5px;align-items:center">' +
                  '<button class="btn btn-danger btn-xs minusQty">-</button>' +
                  '<span class="qty">1</span>' +
                  '<button class="btn btn-success btn-xs plusQty">+</button>' +
                  "</div></td><td>" +
                  res.price +
                  "</td></tr>"; // âœ… fixed

                $("#itemTbData").append(subHtml);
              }
            },
            error: function () {
              alert("API failed");
            },
          });

          $("#myModal").modal("show");
        });
        /* Increase quantity */
        $(document).on("click", ".plusQty", function () {
          let qtyEl = $(this).closest("td").find(".qty");
          let qty = parseInt(qtyEl.text());
          qtyEl.text(qty + 1);
        });

        /* Decrease quantity */
        $(document).on("click", ".minusQty", function () {
          let qtyEl = $(this).closest("td").find(".qty");
          let qty = parseInt(qtyEl.text());
          if (qty > 1) {
            qtyEl.text(qty - 1);
          }
        });

        /* Add to table (UPDATED) */
        $(document).on("click", ".addToTable", function () {
          let qty = $(".qty").text();
          let item = "Vegetable Clear Soup";
          let price = $(".price").text();
          // alert($("#itemTbData tr").first().data("id"));

          let row =
            "<tr><td class='order-item-cell'><button type='button' class='removeItem order-remove-btn order-remove-inline' title='Delete item' aria-label='Delete item'><i class='bi bi-trash'></i></button><span class='order-item-text'>" +
            item +
            "</span></td><td>" +
            qty +
            "</td><td>" +
            price * qty +
              "</td></tr>";

          $("#tableMenu").append(row);

          $("#myModal").modal("hide");

          let rows = "";

          $(".sub-card-sm.active").each(function () {
            let name = $(this).data("name");
            let price = $(this).data("price");
            alert(name);
          });

          $("#tableMenu").append(rows);
          $("#myModal").modal("hide");
        });

        /* Reset qty when modal opens */
        $("#myModal").on("shown.bs.modal", function () {
          $(".qty").text(1);
        });

        $(document).on("click", ".removeItem", function () {
          const $row = $(this).closest("tr");
          showDeleteConfirmModal(
            "Delete this item from current order?",
            function () {
              $row.remove();
              updateOrderTotalsSummary();
              const tableId = toInteger($("#selectedTableId").val());
              if (!hasOrderLineRows()) {
                renderEmptyOrderDetailsRow("No items in order for selected table.");
                clearTimeout(autoSaveQtyTimer);
                pendingAutoSaveRequest = false;

                if (tableId !== null && tableId > 0) {
                  const tableLabel = getSelectedTableLabel(tableId, "");
                  deleteOpenOrderForTable(tableId, {
                    tableLabel: tableLabel,
                    deletingMessage: "Removing item from " + tableLabel + "...",
                    successMessage: "Item removed and order deleted for " + tableLabel + ".",
                    notFoundMessage: "Item removed. No open order found for " + tableLabel + ".",
                    showDeletingMessage: true,
                  });
                  return;
                }

                showPendingOrderUpdateStatus("Item removed");
                return;
              }

              if (tableId !== null && tableId > 0) {
                saveCurrentTableOrder({ autoTriggered: true });
                return;
              }

              showPendingOrderUpdateStatus("Item removed");
            }
          );
        });

        /* fetching left menu items */
        $.ajax({
          url: "menu-category?status=ACTIVE",
          type: "GET",
          contentType: "application/json",
          loadingText: "Loading menu categories...",
          beforeSend: function () {},
        })
          .done(function (data) {
            let sidebar = $("#sidebar");
            sidebar.empty();

            if (Array.isArray(data) && data.length > 0) {
              $.each(data, function (index, item) {
                let menuHtml =
                  '<a href="#" data-menu-id="' +
                  item.id +
                  '" onclick="loadLeftMenu(\'' +
                  item.id +
                  "'); return false;\">" +
                  item.name +
                  "</a>";

                sidebar.append(menuHtml);
              });
              if ($("#leftContent").children().length === 0) {
                $("#leftContent").html(
                  '<div class="menu-empty-state">Select a category to load menu items</div>'
                );
              }
            } else {
              sidebar.append(
                '<div class="sidebar-empty">No active categories found</div>'
              );
              if ($("#leftContent").children().length === 0) {
                $("#leftContent").html(
                  '<div class="menu-empty-state">No menu categories available</div>'
                );
              }
            }
          })
          .fail(function () {
            $("#sidebar").html(
              '<div class="sidebar-empty">Unable to load categories</div>'
            );
            if ($("#leftContent").children().length === 0) {
              $("#leftContent").html(
                '<div class="menu-empty-state">Unable to load menu categories</div>'
              );
            }
          })
          .always(function (data, textStatus, jqXHR) {});

        $(document).off("click", "#subItemContainer .sub-card-sm");
        $(document).on("click", "#subItemContainer .sub-card-sm", function () {
          $(this).toggleClass("active");
          $("#modalSelectionError").addClass("d-none").text("");
        });

        $("body").off("click", ".menuItems");
        $("body").on("click", ".menuItems", function () {
          const id = $(this).data("id");
          const name = $(this).data("name");
          const price = toAmount($(this).data("price"));

          if (!id) {
            return;
          }

          selectedMenuItem = {
            id: id,
            name: name || "Item",
            price: price,
          };

          $("#itemTbData").empty();
          $("#subItemContainer").empty();
          $("#modalSelectionError").addClass("d-none").text("");
          $("#itemTables").hide();

          $.ajax({
            url: "sub-items",
            type: "GET",
            data: {
              itemId: id,
              status: "ACTIVE",
            },
            loadingText: "Loading item options...",
            success: function (res) {
              const subItems = Array.isArray(res) ? res : [];
              if (subItems.length > 0) {
                let subHtml = "";
                $.each(subItems, function (i, sub) {
                  const subName = sub.name || "Option";
                  const subPrice = toAmount(sub.price);
                  subHtml +=
                    '<div class="col-6 col-sm-4 col-lg-3">' +
                    '<div class="card sub-card-sm text-center p-2" data-id="' +
                    sub.id +
                    '" data-name="' +
                    escapeHtml(subName) +
                    '" data-price="' +
                    subPrice +
                    '">' +
                    '<div class="sub-name">' +
                    escapeHtml(subName) +
                    '</div><div class="sub-price">&#8377; ' +
                    formatAmount(subPrice) +
                    "</div>" +
                    "</div></div>";
                });
                $("#subItemContainer").html(subHtml);
              } else {
                $("#itemTables").show();
                buildBaseItemRow(selectedMenuItem);
              }
              $("#myModal").modal("show");
            },
            error: function () {
              $("#itemTables").show();
              buildBaseItemRow(selectedMenuItem);
              $("#myModal").modal("show");
            },
          });
        });

        $(document).off("click", ".addToTable");
        $(document).on("click", ".addToTable", function () {
          if (!selectedMenuItem) {
            return;
          }

          const selectedSubItems = $("#subItemContainer .sub-card-sm.active");
          const hasSubItems = $("#subItemContainer .sub-card-sm").length > 0;

          if (hasSubItems) {
            if (selectedSubItems.length === 0) {
              $("#modalSelectionError")
                .text("Select at least one option to add.")
                .removeClass("d-none");
              return;
            }

            let itemMerged = false;
            selectedSubItems.each(function () {
              const subName = $(this).data("name") || "Option";
              const subPrice = toAmount($(this).data("price"));
              const subItemId = $(this).data("id");
              const lineName = selectedMenuItem.name + " - " + subName;
              if (
                addOrUpdateOrderRow(
                lineName,
                1,
                subPrice,
                {
                  itemId: selectedMenuItem.id,
                  subItemId: subItemId,
                  itemName: lineName,
                }
                )
              ) {
                itemMerged = true;
              }
            });
            const tableIdForAutoSave = toInteger($("#selectedTableId").val());
            if (tableIdForAutoSave !== null && tableIdForAutoSave > 0) {
              saveCurrentTableOrder({ autoTriggered: true });
            } else {
              showPendingOrderUpdateStatus(
                itemMerged ? "Item quantity updated" : "Item added"
              );
            }
            $("#myModal").modal("hide");
            return;
          }

          const row = $("#itemTbData tr").first();
          const qty = Math.max(1, parseInt(row.find(".qty").text(), 10) || 1);
          const rowName = row.data("item-name") || selectedMenuItem.name;
          const rowPriceValue = row.data("item-price");
          const rowPrice = toAmount(
            rowPriceValue !== undefined ? rowPriceValue : selectedMenuItem.price
          );

          const wasMerged = addOrUpdateOrderRow(rowName, qty, rowPrice, {
              itemId: selectedMenuItem.id,
              itemName: rowName,
            });
          const tableIdForAutoSave = toInteger($("#selectedTableId").val());
          if (tableIdForAutoSave !== null && tableIdForAutoSave > 0) {
            saveCurrentTableOrder({ autoTriggered: true });
          } else {
            showPendingOrderUpdateStatus(
              wasMerged ? "Item quantity updated" : "Item added"
            );
          }
          $("#myModal").modal("hide");
        });

        $(document).off("click", ".orderQtyPlus");
        $(document).on("click", ".orderQtyPlus", function () {
          const row = $(this).closest("tr");
          const currentQty = getOrderRowQuantity(row);
          setOrderRowQuantityAndPrice(row, currentQty + 1);
          scheduleAutoSaveForQtyChange();
        });

        $(document).off("click", ".orderQtyMinus");
        $(document).on("click", ".orderQtyMinus", function () {
          const row = $(this).closest("tr");
          const currentQty = getOrderRowQuantity(row);
          if (currentQty <= 1) {
            return;
          }
          setOrderRowQuantityAndPrice(row, currentQty - 1);
          scheduleAutoSaveForQtyChange();
        });

        $(document).off("click", ".editDiscountSettings");
        $(document).on("click", ".editDiscountSettings", function () {
          $("#discountPercentageInput").val($("#orderDiscountPercentage").val() || "0.00");
          $("#discountSettingsModal").modal("show");
        });

        $(document).off("click", "#applyDiscountSettingsBtn");
        $(document).on("click", "#applyDiscountSettingsBtn", function () {
          setOrderTaxPercentages(
            $("#discountPercentageInput").val(),
            $("#orderCgstPercentage").val(),
            $("#orderSgstPercentage").val()
          );
          $("#discountSettingsModal").modal("hide");
          const tableId = toInteger($("#selectedTableId").val());
          if (tableId !== null && tableId > 0 && hasOrderLineRows()) {
            scheduleAutoSaveForQtyChange(300);
          }
        });

        $(document).off("click", ".editGstSettings");
        $(document).on("click", ".editGstSettings", function () {
          $("#cgstPercentageInput").val($("#orderCgstPercentage").val() || "0.00");
          $("#sgstPercentageInput").val($("#orderSgstPercentage").val() || "0.00");
          $("#gstSettingsModal").modal("show");
        });

        $(document).off("click", "#applyGstSettingsBtn");
        $(document).on("click", "#applyGstSettingsBtn", function () {
          setOrderTaxPercentages(
            $("#orderDiscountPercentage").val(),
            $("#cgstPercentageInput").val(),
            $("#sgstPercentageInput").val()
          );
          $("#gstSettingsModal").modal("hide");
          const tableId = toInteger($("#selectedTableId").val());
          if (tableId !== null && tableId > 0 && hasOrderLineRows()) {
            scheduleAutoSaveForQtyChange(300);
          }
        });

        $(document).off("click", ".editCustomerSettings");
        $(document).on("click", ".editCustomerSettings", function () {
          $("#customerNameInput").val($("#orderCustomerName").val() || "");
          $("#customerMobileInput").val($("#orderCustomerMobile").val() || "");
          resetCustomerLookupInfo();
          const existingMobile = ($("#customerMobileInput").val() || "").trim();
          if (existingMobile !== "") {
            requestExistingCustomerByMobile(existingMobile);
          }
          $("#customerSettingsModal").modal("show");
        });

        $(document).off("input", "#customerMobileInput");
        $(document).on("input", "#customerMobileInput", function () {
          scheduleExistingCustomerLookupByMobile($(this).val());
        });

        $(document).off("blur", "#customerMobileInput");
        $(document).on("blur", "#customerMobileInput", function () {
          clearTimeout(customerLookupDebounceTimer);
          requestExistingCustomerByMobile($(this).val());
        });

        $("#customerSettingsModal").off("hidden.bs.modal");
        $("#customerSettingsModal").on("hidden.bs.modal", function () {
          clearTimeout(customerLookupDebounceTimer);
          customerLookupRequestSequence += 1;
          resetCustomerLookupInfo();
        });

        $(document).off("click", "#applyCustomerSettingsBtn");
        $(document).on("click", "#applyCustomerSettingsBtn", function () {
          setOrderCustomerDetails(
            $("#customerNameInput").val(),
            $("#customerMobileInput").val()
          );
          $("#customerSettingsModal").modal("hide");
          const tableId = toInteger($("#selectedTableId").val());
          if (tableId !== null && tableId > 0 && hasOrderLineRows()) {
            scheduleAutoSaveForQtyChange(300);
          }
        });

        $(document).off("change", ".order-payment-method-radio");
        $(document).on("change", ".order-payment-method-radio", function () {
          setOrderPaymentMethod($(this).val());
          const tableId = toInteger($("#selectedTableId").val());
          if (tableId !== null && tableId > 0 && hasOrderLineRows()) {
            scheduleAutoSaveForQtyChange(300);
          }
        });

        $(document).off("click", ".saveTableOrder");
        $(document).on("click", ".saveTableOrder", function () {
          saveCurrentTableOrder({ autoTriggered: false });
        });

        $(document).off("click", ".closeTableOrder");
        $(document).on("click", ".closeTableOrder", function () {
          const tableId = toInteger($("#selectedTableId").val());
          const closeButton = $(this);

          if (tableId === null || tableId <= 0) {
            showOrderSaveStatus("Select a table before completing the order.", true);
            return;
          }

          if (!hasOrderLineRows()) {
            showOrderSaveStatus("Add at least one item before completing the order.", true);
            return;
          }

          const selectedPaymentMethod = $(".order-payment-method-radio:checked").val();
          if (!selectedPaymentMethod) {
            showTopRightMessage("Select payment type before completing the order.", "error");
            return;
          }

          setOrderPaymentMethod(selectedPaymentMethod);

          if (isOrderSaveRequestInFlight) {
            showOrderSaveStatus(
              "Order save is in progress. Please wait and complete again.",
              true
            );
            return;
          }

          const tableLabel = getSelectedTableLabel(tableId, "");
          clearTimeout(autoSaveQtyTimer);
          pendingAutoSaveRequest = false;

          showDeleteConfirmModal(
            "Complete order for " + tableLabel + " and open table for new order?",
            function () {
              closeButton.prop("disabled", true).addClass("is-loading");
              saveCurrentTableOrder({
                autoTriggered: false,
                onSaved: function () {
                  completeOpenOrderForTable(tableId, {
                    tableLabel: tableLabel,
                    completeButton: closeButton,
                    completingMessage: "Completing order for " + tableLabel + "...",
                    successMessage:
                      "Order completed for " + tableLabel + ". Table is open for new order.",
                    notFoundMessage:
                      "No open order found for " + tableLabel + ". Table is already open.",
                    showCompletingMessage: true,
                    onSuccess: function () {
                      renderEmptyOrderDetailsRow(
                        "Order completed. Add items to start a new order."
                      );
                    },
                    onNotFound: function () {
                      renderEmptyOrderDetailsRow(
                        "Table is open for new order. Add items to start a new order."
                      );
                    },
                  });
                },
                onSaveError: function () {
                  closeButton.prop("disabled", false).removeClass("is-loading");
                },
              });
            },
            {
              title: "Complete Confirmation",
              confirmLabel: "Complete",
            }
          );
        });

        $(document).off("click", ".deleteTableOrder");
        $(document).on("click", ".deleteTableOrder", function () {
          const tableId = toInteger($("#selectedTableId").val());
          const deleteButton = $(this);

          if (tableId === null || tableId <= 0) {
            showOrderSaveStatus("Select a table before deleting the order.", true);
            return;
          }

          const tableLabel = getSelectedTableLabel(tableId, "");
          clearTimeout(autoSaveQtyTimer);
          pendingAutoSaveRequest = false;

          showDeleteConfirmModal(
            "Delete open order for " + tableLabel + "?",
            function () {
              deleteButton.prop("disabled", true).addClass("is-loading");

              deleteOpenOrderForTable(tableId, {
                tableLabel: tableLabel,
                deleteButton: deleteButton,
                deletingMessage: "Deleting order for " + tableLabel + "...",
                successMessage: "Order deleted for " + tableLabel + ".",
                notFoundMessage: "No open order found for " + tableLabel + ".",
                showDeletingMessage: true,
              });
            }
          );
        });

        $(document).off("click", ".printTableOrder");
        $(document).on("click", ".printTableOrder", function () {
          const tableId = toInteger($("#selectedTableId").val());
          if (tableId === null || tableId <= 0) {
            showOrderSaveStatus("Select a table before printing bill.", true);
            return;
          }

          const tableName = ($("#selectedTableName").val() || "").trim();
          const rows = buildPrintableRowsFromCurrentOrder();
          if (rows.length === 0) {
            printOpenOrderBillForTable(tableId, tableName);
            return;
          }

          const currentTotals = calculateOrderTotalsSummaryData();
          openPrintableBill({
            tableId: tableId,
            tableName: tableName,
            orderId: getSelectedOrderDisplayNumber(),
            orderType: "DINE_IN",
            createdAt: new Date(),
            customerName: getOrderCustomerNameValue() || "",
            mobile: getOrderCustomerMobileValue() || "",
            paymentMethod: getOrderPaymentMethodInputValue(),
            discountPercentage: currentTotals.discountPercentage,
            discountAmount: currentTotals.discountAmount,
            taxableAmount: currentTotals.taxableAmount,
            cgstPercentage: currentTotals.cgstPercentage,
            sgstPercentage: currentTotals.sgstPercentage,
            cgstAmount: currentTotals.cgstAmount,
            sgstAmount: currentTotals.sgstAmount,
            netAmount: currentTotals.netAmount,
            items: rows,
          });
        });

        $(document).off("click", ".print-icon");
        $(document).on("click", ".print-icon", function (event) {
          event.preventDefault();
          event.stopPropagation();
          const tableContext = resolveTableContext(this);
          if (!tableContext) {
            return;
          }
          printOpenOrderBillForTable(tableContext.tableId, tableContext.tableName);
        });

        $(document).off("click", ".view-icon");
        $(document).on("click", ".view-icon", function (event) {
          event.preventDefault();
          event.stopPropagation();
          const tableContext = resolveTableContext(this);
          if (!tableContext) {
            return;
          }
          openTableOrderViewModal(tableContext.tableId, tableContext.tableName);
        });

        $("#myModal").off("shown.bs.modal");
        $("#myModal").on("shown.bs.modal", function () {
          $(".qty").text(1);
          $("#modalSelectionError").addClass("d-none").text("");
        });

        $("#myModal").off("hidden.bs.modal");
        $("#myModal").on("hidden.bs.modal", function () {
          $("#itemTbData").empty();
          $(".sub-card-sm").removeClass("active");
          $("#modalSelectionError").addClass("d-none").text("");
        });

        document.addEventListener("click", function (e) {
          if (e.target.closest(".print-icon") || e.target.closest(".view-icon")) {
            return;
          }

          const tableContext = resolveTableContext(e.target);
          if (tableContext) {
            $("#selectedTableId").val(tableContext.tableId);
            $("#selectedTableName").val(tableContext.tableName);
            loadOpenOrderForTable(tableContext.tableId, tableContext.tableName);
          }
        });

        // Default view after login: load tables for new order
        clearOrderPaymentMethod();
        newOrder("newOrder");
        scheduleOrderTableHeightRefresh();
      });

      function renderConfigurationFrame() {
        const leftContent = document.getElementById("leftContent");
        if (!leftContent) {
          return;
        }

        showActionLoading("Loading configuration screen...");

        leftContent.innerHTML =
          '<div class="configuration-frame-wrap">' +
          '<div class="configuration-frame-status" id="configurationFrameStatus">' +
          '<div class="spinner-border text-primary" role="presentation"></div>' +
          '<span>Loading configuration screen...</span>' +
          "</div>" +
          '<iframe src="configuration" class="configuration-frame d-none" id="configurationFrame" title="Configuration"></iframe>' +
          "</div>";

        const frame = document.getElementById("configurationFrame");
        const frameStatus = document.getElementById("configurationFrameStatus");
        let isHandled = false;

        function completeConfigurationLoad(success) {
          if (isHandled) {
            return;
          }
          isHandled = true;
          hideActionLoading();

          if (!frameStatus) {
            return;
          }

          if (success) {
            frameStatus.classList.add("d-none");
            if (frame) {
              frame.classList.remove("d-none");
            }
            return;
          }

          frameStatus.classList.add("configuration-frame-error");
          frameStatus.innerHTML = "<span>Unable to load configuration screen. Please try again.</span>";
        }

        if (!frame) {
          completeConfigurationLoad(false);
          return;
        }

        frame.addEventListener(
          "load",
          function () {
            completeConfigurationLoad(true);
          },
          { once: true }
        );

        frame.addEventListener(
          "error",
          function () {
            completeConfigurationLoad(false);
          },
          { once: true }
        );

        setTimeout(function () {
          if (!isHandled) {
            completeConfigurationLoad(false);
          }
        }, 20000);
      }

      function oppendPage(url) {
        showActionLoading("Loading page...");
        fetch(url)
          .then((response) => {
            if (!response.ok) {
              throw new Error("Failed to load page");
            }
            return response.text();
          })
          .then((html) => {
            document.getElementById("leftContent").innerHTML = html;
          })
          .catch(() => {
            document.getElementById("leftContent").innerHTML =
              "<p>Error loading page</p>";
          })
          .finally(() => {
            hideActionLoading();
          });
      }
    </script>

    <div id="myModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Item Detail</h4>
          </div>

          <div class="modal-body">
            <table class="table" id="itemTables">
              <thead>
                <tr>
                  <th>Item</th>
                  <th>Quantity</th>
                  <th>Price</th>
                </tr>
              </thead>
              <tbody id="itemTbData"></tbody>
            </table>

            <div class="row g-2" id="subItemContainer"></div>
            <div
              class="text-danger small mt-2 d-none"
              id="modalSelectionError"
            ></div>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-success addToTable">
              Add
            </button>
            <button type="button" class="btn btn-danger" data-dismiss="modal">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <div id="viewOrderModal" class="modal fade" role="dialog">
      <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title">Table Order Details</h4>
          </div>

          <div class="modal-body">
            <div class="small text-muted mb-2">
              <div><b>Table:</b> <span id="viewOrderModalTableName">-</span></div>
              <div>
                <b>Order:</b> <span id="viewOrderModalOrderId">-</span>
                &nbsp;&nbsp;<b>Status:</b> <span id="viewOrderModalStatus">-</span>
              </div>
            </div>

            <table class="table table-bordered table-sm">
              <thead>
                <tr>
                  <th>Item</th>
                  <th>Quantity</th>
                  <th>Price</th>
                </tr>
              </thead>
              <tbody id="viewOrderModalBody"></tbody>
            </table>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-danger" data-dismiss="modal">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <div id="deleteConfirmModal" class="modal delete-confirm-modal" role="dialog" aria-labelledby="deleteConfirmTitle">
      <div class="modal-dialog modal-sm modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title" id="deleteConfirmTitle">Delete Confirmation</h4>
          </div>
          <div class="modal-body">
            <p id="deleteConfirmMessage" class="mb-0">Are you sure you want to delete?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">
              Cancel
            </button>
            <button type="button" class="btn btn-danger" id="deleteConfirmOkBtn">
              Delete
            </button>
          </div>
        </div>
      </div>
    </div>

    <div id="discountSettingsModal" class="modal fade" role="dialog" aria-labelledby="discountSettingsTitle">
      <div class="modal-dialog modal-sm modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title" id="discountSettingsTitle">Discount</h4>
          </div>
          <div class="modal-body">
            <label for="discountPercentageInput" class="small text-muted">Discount Percentage (%)</label>
            <input
              type="number"
              id="discountPercentageInput"
              class="form-control"
              min="0"
              max="100"
              step="0.01"
              value="0.00"
            />
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">
              Cancel
            </button>
            <button type="button" class="btn btn-primary" id="applyDiscountSettingsBtn">
              Apply
            </button>
          </div>
        </div>
      </div>
    </div>

    <div id="customerSettingsModal" class="modal fade" role="dialog" aria-labelledby="customerSettingsTitle">
      <div class="modal-dialog modal-sm modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title" id="customerSettingsTitle">Customer Information</h4>
          </div>
          <div class="modal-body">
            <div class="form-group mb-2">
              <label for="customerMobileInput" class="small text-muted">Mobile Number</label>
              <input type="text" id="customerMobileInput" class="form-control" maxlength="20" />
            </div>
            <div class="form-group mb-0">
              <label for="customerNameInput" class="small text-muted">Customer Name</label>
              <input type="text" id="customerNameInput" class="form-control" maxlength="100" />
            </div>
            <div
              id="customerLookupInfo"
              class="small text-muted mt-2 d-none"
              role="status"
              aria-live="polite"
            ></div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">
              Cancel
            </button>
            <button type="button" class="btn btn-primary" id="applyCustomerSettingsBtn">
              Apply
            </button>
          </div>
        </div>
      </div>
    </div>

    <div id="gstSettingsModal" class="modal fade" role="dialog" aria-labelledby="gstSettingsTitle">
      <div class="modal-dialog modal-sm modal-dialog-scrollable">
        <div class="modal-content">
          <div class="modal-header">
            <h4 class="modal-title" id="gstSettingsTitle">GST</h4>
          </div>
          <div class="modal-body">
            <div class="form-group mb-2">
              <label for="cgstPercentageInput" class="small text-muted">CGST Percentage (%)</label>
              <input
                type="number"
                id="cgstPercentageInput"
                class="form-control"
                min="0"
                max="100"
                step="0.01"
                value="0.00"
              />
            </div>
            <div class="form-group mb-0">
              <label for="sgstPercentageInput" class="small text-muted">SGST Percentage (%)</label>
              <input
                type="number"
                id="sgstPercentageInput"
                class="form-control"
                min="0"
                max="100"
                step="0.01"
                value="0.00"
              />
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">
              Cancel
            </button>
            <button type="button" class="btn btn-primary" id="applyGstSettingsBtn">
              Apply
            </button>
          </div>
        </div>
      </div>
    </div>
  </body>
</html>
