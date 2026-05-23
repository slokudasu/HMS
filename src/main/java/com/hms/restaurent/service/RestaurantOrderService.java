package com.hms.restaurent.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import com.hms.entity.restaurent.Item;
import com.hms.entity.restaurent.Order;
import com.hms.entity.restaurent.OrderDailyCounter;
import com.hms.entity.restaurent.OrderItem;
import com.hms.entity.restaurent.RestaurantTable;
import com.hms.entity.restaurent.SubItem;
import com.hms.restaurent.dto.RestaurantOrderItemRequestDTO;
import com.hms.restaurent.dto.RestaurantOrderItemResponseDTO;
import com.hms.restaurent.dto.RestaurantCustomerLookupResponseDTO;
import com.hms.restaurent.dto.RestaurantOrderRequestDTO;
import com.hms.restaurent.dto.RestaurantOrderResponseDTO;
import com.hms.restaurent.repository.ItemRepository;
import com.hms.restaurent.repository.OrderDailyCounterRepository;
import com.hms.restaurent.repository.OrderRepository;
import com.hms.restaurent.repository.SubItemRepository;
import com.hms.restaurent.repository.TableRepository;

@Service
public class RestaurantOrderService {

    private static final String PAYMENT_METHOD_CASH = "CASH";
    private static final String PAYMENT_METHOD_CARD = "CARD";
    private static final String PAYMENT_METHOD_UPI = "UPI";

    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private TableRepository tableRepository;

    @Autowired
    private ItemRepository itemRepository;

    @Autowired
    private SubItemRepository subItemRepository;

    @Autowired
    private OrderDailyCounterRepository orderDailyCounterRepository;

    @Transactional
    public RestaurantOrderResponseDTO saveOrUpdateOpenOrder(RestaurantOrderRequestDTO request, Long restaurantUserId) {
        if (request == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Request body is required");
        }

        Long tableId = normalizeTableId(request.getTableId());
        List<RestaurantOrderItemRequestDTO> requestItems = aggregateOrderItems(normalizeItems(request.getItems()));

        RestaurantTable table = tableRepository.findByIdAndHall_RestaurantUser_Id(tableId, restaurantUserId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Table not found"));

        Optional<Order> openOrderOptional =
                orderRepository.findFirstByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtDesc(
                        tableId,
                        restaurantUserId,
                        "OPEN");

        Order order = openOrderOptional.orElseGet(Order::new);
        if (order.getId() == null) {
            LocalDateTime createdAt = LocalDateTime.now();
            order.setCreatedAt(createdAt);
            order.setStatus("OPEN");
            order.setOrderNumber(resolveNextDailyOrderNumber(restaurantUserId, createdAt));
        } else if (order.getOrderNumber() == null || order.getOrderNumber() <= 0) {
            LocalDateTime createdAt = order.getCreatedAt();
            if (createdAt == null) {
                createdAt = LocalDateTime.now();
                order.setCreatedAt(createdAt);
            }
            order.setOrderNumber(resolveNextDailyOrderNumber(restaurantUserId, createdAt));
        }

        order.setTable(table);
        order.setOrderType(normalizeOrderType(request.getOrderType()));
        order.setCustomerName(normalizeNullableText(request.getCustomerName()));
        order.setMobile(normalizeNullableText(request.getMobile()));
        order.setPaymentMethod(normalizePaymentMethod(request.getPaymentMethod()));

        List<OrderItem> orderItems = new ArrayList<>();
        double totalAmount = 0;
        for (RestaurantOrderItemRequestDTO requestItem : requestItems) {
            OrderItem orderItem = buildOrderItem(requestItem, order, restaurantUserId);
            orderItems.add(orderItem);
            Double lineTotal = orderItem.getTotal();
            if (lineTotal != null) {
                totalAmount += lineTotal;
            }
        }

        if (order.getOrderItems() == null) {
            order.setOrderItems(new ArrayList<>());
        }
        order.getOrderItems().clear();
        order.getOrderItems().addAll(orderItems);

        Double requestedDiscountPercentage = request.getDiscountPercentage();
        if (requestedDiscountPercentage == null) {
            requestedDiscountPercentage = order.getDiscountPercentage();
        }
        order.setDiscountPercentage(normalizePercentage(requestedDiscountPercentage, "Discount"));

        Double requestedCgstPercentage = request.getCgstPercentage();
        if (requestedCgstPercentage == null) {
            requestedCgstPercentage = order.getCgstPercentage();
        }
        order.setCgstPercentage(normalizePercentage(requestedCgstPercentage, "CGST"));

        Double requestedSgstPercentage = request.getSgstPercentage();
        if (requestedSgstPercentage == null) {
            requestedSgstPercentage = order.getSgstPercentage();
        }
        order.setSgstPercentage(normalizePercentage(requestedSgstPercentage, "SGST"));

        Order saved = orderRepository.save(order);
        return toResponse(saved, restaurantUserId);
    }

    @Transactional(readOnly = true)
    public RestaurantOrderResponseDTO findOpenOrderByTable(Long tableId, Long restaurantUserId) {
        Long normalizedTableId = normalizeTableId(tableId);

        Order order = orderRepository.findFirstByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtDesc(
                        normalizedTableId,
                        restaurantUserId,
                        "OPEN")
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "No open order found for table"));

        return toResponse(order, restaurantUserId);
    }

    @Transactional(readOnly = true)
    public RestaurantCustomerLookupResponseDTO findCustomerByMobile(String mobile, Long restaurantUserId) {
        String normalizedMobile = normalizeNullableText(mobile);
        RestaurantCustomerLookupResponseDTO response = new RestaurantCustomerLookupResponseDTO();
        response.setMobile(normalizedMobile);
        response.setVisitCount(0L);
        response.setExistingCustomer(false);

        if (!hasText(normalizedMobile)) {
            return response;
        }

        long visitCount = orderRepository.countByTable_Hall_RestaurantUser_IdAndMobile(restaurantUserId, normalizedMobile);
        response.setVisitCount(visitCount);
        response.setExistingCustomer(visitCount > 0);

        if (visitCount <= 0) {
            return response;
        }

        Optional<Order> recentOrderWithCustomerName =
                orderRepository.findFirstByTable_Hall_RestaurantUser_IdAndMobileAndCustomerNameIsNotNullOrderByCreatedAtDesc(
                        restaurantUserId,
                        normalizedMobile);
        if (recentOrderWithCustomerName.isPresent()) {
            response.setCustomerName(normalizeNullableText(recentOrderWithCustomerName.get().getCustomerName()));
        }

        return response;
    }

    @Transactional
    public void deleteOpenOrderByTable(Long tableId, Long restaurantUserId) {
        Long normalizedTableId = normalizeTableId(tableId);

        List<Order> openOrders =
                orderRepository.findByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtAsc(
                        normalizedTableId,
                        restaurantUserId,
                        "OPEN");
        if (openOrders.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No open order found for table");
        }

        orderRepository.deleteAll(openOrders);
    }

    @Transactional
    public RestaurantOrderResponseDTO completeOpenOrderByTable(Long tableId, Long restaurantUserId) {
        Long normalizedTableId = normalizeTableId(tableId);

        List<Order> openOrders =
                orderRepository.findByTable_IdAndTable_Hall_RestaurantUser_IdAndStatusOrderByCreatedAtAsc(
                        normalizedTableId,
                        restaurantUserId,
                        "OPEN");
        if (openOrders.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "No open order found for table");
        }

        LocalDateTime completionTime = LocalDateTime.now();
        Order lastCompleted = null;
        for (Order order : openOrders) {
            LocalDateTime createdAt = order.getCreatedAt();
            if (createdAt == null) {
                createdAt = completionTime;
                order.setCreatedAt(createdAt);
            }

            if (order.getOrderNumber() == null || order.getOrderNumber() <= 0) {
                order.setOrderNumber(resolveNextDailyOrderNumber(restaurantUserId, createdAt));
            }

            order.setStatus("COMPLETED");
            order.setCompletedAt(completionTime);
            lastCompleted = order;
        }

        List<Order> savedOrders = orderRepository.saveAll(openOrders);
        if (!savedOrders.isEmpty()) {
            lastCompleted = savedOrders.get(savedOrders.size() - 1);
        }
        return toResponse(lastCompleted, restaurantUserId);
    }

    @Transactional(readOnly = true)
    public long countCompletedOrdersForDate(LocalDate date, Long restaurantUserId) {
        if (restaurantUserId == null || restaurantUserId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Restaurant user id is required");
        }

        LocalDate targetDate = date == null ? LocalDate.now() : date;
        LocalDateTime dayStart = targetDate.atStartOfDay();
        LocalDateTime nextDayStart = dayStart.plusDays(1);
        return orderRepository
                .countByTable_Hall_RestaurantUser_IdAndStatusAndCompletedAtGreaterThanEqualAndCompletedAtLessThan(
                        restaurantUserId,
                        "COMPLETED",
                        dayStart,
                        nextDayStart);
    }

    private OrderItem buildOrderItem(RestaurantOrderItemRequestDTO dto, Order order, Long restaurantUserId) {
        if (dto == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order item is required");
        }

        Long itemId = normalizeOptionalId(dto.getItemId());
        Long subItemId = normalizeOptionalId(dto.getSubItemId());

        if (itemId == null && subItemId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Each order item requires itemId or subItemId");
        }

        Item item = null;
        SubItem subItem = null;

        if (subItemId != null) {
            subItem = subItemRepository.findByIdAndItem_Category_RestaurantUser_Id(subItemId, restaurantUserId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Sub item not found"));
            item = subItem.getItem();
        }

        if (itemId != null) {
            Item requestedItem = itemRepository.findByIdAndCategory_RestaurantUser_Id(itemId, restaurantUserId)
                    .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Item not found"));
            if (item != null && item.getId() != null && !item.getId().equals(requestedItem.getId())) {
                throw new ResponseStatusException(
                        HttpStatus.BAD_REQUEST,
                        "itemId does not match subItemId for one of the order rows");
            }
            item = requestedItem;
        }

        int quantity = normalizeQuantity(dto.getQuantity());
        double unitPrice = normalizeUnitPrice(dto.getUnitPrice(), item, subItem);
        String itemName = normalizeItemName(dto.getItemName(), item, subItem);

        OrderItem orderItem = new OrderItem();
        orderItem.setOrder(order);
        orderItem.setItem(item);
        orderItem.setSubItem(subItem);
        orderItem.setItemName(itemName);
        orderItem.setQuantity(quantity);
        orderItem.setPrice(unitPrice);
        orderItem.setTotal(unitPrice * quantity);
        return orderItem;
    }

    private List<RestaurantOrderItemRequestDTO> aggregateOrderItems(List<RestaurantOrderItemRequestDTO> items) {
        Map<String, RestaurantOrderItemRequestDTO> aggregated = new LinkedHashMap<>();

        for (RestaurantOrderItemRequestDTO dto : items) {
            if (dto == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order item is required");
            }

            Long itemId = normalizeOptionalId(dto.getItemId());
            Long subItemId = normalizeOptionalId(dto.getSubItemId());

            if (itemId == null && subItemId == null) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Each order item requires itemId or subItemId");
            }

            int quantity = normalizeQuantity(dto.getQuantity());
            String key = buildAggregationKey(itemId, subItemId);

            RestaurantOrderItemRequestDTO current = aggregated.get(key);
            if (current == null) {
                RestaurantOrderItemRequestDTO normalized = new RestaurantOrderItemRequestDTO();
                normalized.setItemId(itemId);
                normalized.setSubItemId(subItemId);
                normalized.setItemName(normalizeNullableText(dto.getItemName()));
                normalized.setQuantity(quantity);
                normalized.setUnitPrice(dto.getUnitPrice());
                aggregated.put(key, normalized);
                continue;
            }

            int mergedQuantity = normalizeQuantity(current.getQuantity()) + quantity;
            current.setQuantity(mergedQuantity);

            if (current.getUnitPrice() == null && dto.getUnitPrice() != null) {
                current.setUnitPrice(dto.getUnitPrice());
            }

            if (!hasText(current.getItemName()) && hasText(dto.getItemName())) {
                current.setItemName(normalizeNullableText(dto.getItemName()));
            }
        }

        return new ArrayList<>(aggregated.values());
    }

    private String buildAggregationKey(Long itemId, Long subItemId) {
        String itemPart = itemId == null ? "0" : String.valueOf(itemId);
        String subItemPart = subItemId == null ? "0" : String.valueOf(subItemId);
        return itemPart + ":" + subItemPart;
    }

    private RestaurantOrderResponseDTO toResponse(Order order, Long restaurantUserId) {
        RestaurantOrderResponseDTO response = new RestaurantOrderResponseDTO();
        response.setId(order.getId());
        response.setOrderNumber(resolveOrderNumber(order, restaurantUserId));
        response.setStatus(order.getStatus());
        response.setOrderType(order.getOrderType());
        response.setCustomerName(order.getCustomerName());
        response.setMobile(order.getMobile());
        response.setPaymentMethod(order.getPaymentMethod());
        response.setCreatedAt(order.getCreatedAt());
        response.setCompletedAt(order.getCompletedAt());
        if (order.getTable() != null) {
            response.setTableId(order.getTable().getId());
            response.setTableName(order.getTable().getTableName());
        }

        List<OrderItem> items = order.getOrderItems();
        List<RestaurantOrderItemResponseDTO> responseItems = new ArrayList<>();
        double totalAmount = 0;
        if (items != null) {
            for (OrderItem orderItem : items) {
                RestaurantOrderItemResponseDTO responseItem = new RestaurantOrderItemResponseDTO();
                if (orderItem.getItem() != null) {
                    responseItem.setItemId(orderItem.getItem().getId());
                }
                if (orderItem.getSubItem() != null) {
                    responseItem.setSubItemId(orderItem.getSubItem().getId());
                }
                responseItem.setItemName(orderItem.getItemName());
                responseItem.setQuantity(orderItem.getQuantity());
                responseItem.setUnitPrice(orderItem.getPrice());

                Double lineTotal = orderItem.getTotal();
                if (lineTotal == null) {
                    int quantity = orderItem.getQuantity() == null ? 0 : orderItem.getQuantity();
                    double price = orderItem.getPrice() == null ? 0 : orderItem.getPrice();
                    lineTotal = price * quantity;
                }

                responseItem.setTotal(lineTotal);
                totalAmount += lineTotal;
                responseItems.add(responseItem);
            }
        }

        response.setItemCount(responseItems.size());
        response.setTotalAmount(totalAmount);
        double discountPercentage = normalizePercentage(order.getDiscountPercentage(), "Discount");
        double cgstPercentage = normalizePercentage(order.getCgstPercentage(), "CGST");
        double sgstPercentage = normalizePercentage(order.getSgstPercentage(), "SGST");
        double discountAmount = totalAmount * (discountPercentage / 100.0);
        double taxableAmount = totalAmount - discountAmount;
        double cgstAmount = taxableAmount * (cgstPercentage / 100.0);
        double sgstAmount = taxableAmount * (sgstPercentage / 100.0);
        double netAmount = taxableAmount + cgstAmount + sgstAmount;

        response.setDiscountPercentage(discountPercentage);
        response.setDiscountAmount(discountAmount);
        response.setTaxableAmount(taxableAmount);
        response.setCgstPercentage(cgstPercentage);
        response.setSgstPercentage(sgstPercentage);
        response.setCgstAmount(cgstAmount);
        response.setSgstAmount(sgstAmount);
        response.setNetAmount(netAmount);
        response.setItems(responseItems);
        return response;
    }

    private Long resolveOrderNumber(Order order, Long restaurantUserId) {
        if (order == null) {
            return null;
        }

        Long storedOrderNumber = order.getOrderNumber();
        if (storedOrderNumber != null && storedOrderNumber > 0) {
            return storedOrderNumber;
        }

        if (order.getId() == null || restaurantUserId == null || restaurantUserId <= 0) {
            return null;
        }

        LocalDateTime createdAt = order.getCreatedAt();
        if (createdAt == null) {
            return null;
        }

        LocalDateTime dayStart = createdAt.toLocalDate().atStartOfDay();
        LocalDateTime nextDayStart = dayStart.plusDays(1);
        long orderNumber =
                orderRepository
                        .countByTable_Hall_RestaurantUser_IdAndCreatedAtGreaterThanEqualAndCreatedAtLessThanAndIdLessThanEqual(
                                restaurantUserId,
                                dayStart,
                                nextDayStart,
                                order.getId());
        return orderNumber > 0 ? orderNumber : null;
    }

    private Long resolveNextDailyOrderNumber(Long restaurantUserId, LocalDateTime createdAt) {
        if (restaurantUserId == null || restaurantUserId <= 0 || createdAt == null) {
            return null;
        }

        LocalDate orderDate = createdAt.toLocalDate();
        for (int attempt = 0; attempt < 3; attempt++) {
            try {
                Optional<OrderDailyCounter> counterOptional =
                        orderDailyCounterRepository.findByRestaurantUserIdAndCounterDateForUpdate(
                                restaurantUserId,
                                orderDate);
                if (counterOptional.isPresent()) {
                    OrderDailyCounter counter = counterOptional.get();
                    long nextOrderNumber = (counter.getLastOrderNumber() == null ? 0 : counter.getLastOrderNumber()) + 1;
                    counter.setLastOrderNumber(nextOrderNumber);
                    orderDailyCounterRepository.save(counter);
                    return nextOrderNumber > 0 ? nextOrderNumber : null;
                }

                OrderDailyCounter counter = new OrderDailyCounter();
                counter.setRestaurantUserId(restaurantUserId);
                counter.setCounterDate(orderDate);
                counter.setLastOrderNumber(1L);
                orderDailyCounterRepository.saveAndFlush(counter);
                return 1L;
            } catch (DataIntegrityViolationException ex) {
                // Concurrent insert for the same day counter; retry and lock existing row.
            }
        }

        throw new ResponseStatusException(
                HttpStatus.CONFLICT,
                "Unable to generate daily order number. Please retry.");
    }

    private Long normalizeTableId(Long tableId) {
        if (tableId == null || tableId <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Table id is required");
        }
        return tableId;
    }

    private List<RestaurantOrderItemRequestDTO> normalizeItems(List<RestaurantOrderItemRequestDTO> items) {
        if (items == null || items.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order must contain at least one item");
        }
        return items;
    }

    private Long normalizeOptionalId(Long id) {
        if (id == null) {
            return null;
        }
        if (id <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Item id values must be positive");
        }
        return id;
    }

    private int normalizeQuantity(Integer quantity) {
        if (quantity == null || quantity <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Quantity must be greater than zero");
        }
        return quantity;
    }

    private double normalizeUnitPrice(Double unitPrice, Item item, SubItem subItem) {
        if (unitPrice != null) {
            if (unitPrice < 0) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unit price cannot be negative");
            }
            return unitPrice;
        }

        if (subItem != null && subItem.getPrice() != null) {
            return subItem.getPrice();
        }

        if (item != null && item.getPrice() != null) {
            return item.getPrice();
        }

        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Unit price is required");
    }

    private String normalizeItemName(String name, Item item, SubItem subItem) {
        if (hasText(name)) {
            return name.trim();
        }

        if (item != null && subItem != null) {
            return item.getName() + " - " + subItem.getName();
        }

        if (item != null) {
            return item.getName();
        }

        if (subItem != null) {
            return subItem.getName();
        }

        return "Item";
    }

    private String normalizeOrderType(String orderType) {
        if (!hasText(orderType)) {
            return "DINE_IN";
        }

        String normalized = orderType.trim().toUpperCase(Locale.ROOT);
        if (!"DINE_IN".equals(normalized) && !"PARCEL".equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Order type must be DINE_IN or PARCEL");
        }
        return normalized;
    }

    private String normalizePaymentMethod(String paymentMethod) {
        if (!hasText(paymentMethod)) {
            return PAYMENT_METHOD_CASH;
        }

        String normalized = paymentMethod
                .trim()
                .toUpperCase(Locale.ROOT)
                .replace('-', '_')
                .replace(' ', '_');

        if ("UPI_APP".equals(normalized) || "UPI_INTENT".equals(normalized) || "UPI_SCAN".equals(normalized)) {
            normalized = PAYMENT_METHOD_UPI;
        } else if ("DEBIT_CARD".equals(normalized) || "CREDIT_CARD".equals(normalized)) {
            normalized = PAYMENT_METHOD_CARD;
        } else if ("MANUAL".equals(normalized)) {
            normalized = PAYMENT_METHOD_CASH;
        }

        if (!PAYMENT_METHOD_UPI.equals(normalized)
                && !PAYMENT_METHOD_CARD.equals(normalized)
                && !PAYMENT_METHOD_CASH.equals(normalized)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Payment method must be UPI, CARD, or CASH");
        }

        return normalized;
    }

    private double normalizePercentage(Double percentage, String fieldLabel) {
        if (percentage == null) {
            return 0;
        }

        if (percentage < 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, fieldLabel + " percentage cannot be negative");
        }

        if (percentage > 100) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, fieldLabel + " percentage cannot exceed 100");
        }

        return percentage;
    }

    private String normalizeNullableText(String value) {
        if (!hasText(value)) {
            return null;
        }
        return value.trim();
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }
}
