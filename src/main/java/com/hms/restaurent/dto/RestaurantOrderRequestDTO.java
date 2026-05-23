package com.hms.restaurent.dto;

import java.util.List;

public class RestaurantOrderRequestDTO {

    private Long tableId;
    private String orderType;
    private String customerName;
    private String mobile;
    private String paymentMethod;
    private Double discountPercentage;
    private Double cgstPercentage;
    private Double sgstPercentage;
    private List<RestaurantOrderItemRequestDTO> items;

    public Long getTableId() {
        return tableId;
    }

    public void setTableId(Long tableId) {
        this.tableId = tableId;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getMobile() {
        return mobile;
    }

    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Double getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Double discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Double getCgstPercentage() {
        return cgstPercentage;
    }

    public void setCgstPercentage(Double cgstPercentage) {
        this.cgstPercentage = cgstPercentage;
    }

    public Double getSgstPercentage() {
        return sgstPercentage;
    }

    public void setSgstPercentage(Double sgstPercentage) {
        this.sgstPercentage = sgstPercentage;
    }

    public List<RestaurantOrderItemRequestDTO> getItems() {
        return items;
    }

    public void setItems(List<RestaurantOrderItemRequestDTO> items) {
        this.items = items;
    }
}
