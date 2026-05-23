<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/hms/common/layout-start.jspf" %>
<div class="hms-placeholder-grid mb-3">
    <div class="hms-stat-card">
        <div class="hms-stat-label">Total Patients</div>
        <div class="hms-stat-value">0</div>
    </div>
    <div class="hms-stat-card">
        <div class="hms-stat-label">Today's Appointments</div>
        <div class="hms-stat-value">0</div>
    </div>
    <div class="hms-stat-card">
        <div class="hms-stat-label">Admitted Patients</div>
        <div class="hms-stat-value">0</div>
    </div>
    <div class="hms-stat-card">
        <div class="hms-stat-label">Available Beds</div>
        <div class="hms-stat-value">0</div>
    </div>
    <div class="hms-stat-card">
        <div class="hms-stat-label">Doctors Available</div>
        <div class="hms-stat-value">0</div>
    </div>
    <div class="hms-stat-card">
        <div class="hms-stat-label">Today's Revenue</div>
        <div class="hms-stat-value">0</div>
    </div>
</div>

<div class="card shadow-sm">
    <div class="card-header bg-white">
        <strong>Phase-wise Delivery Plan</strong>
    </div>
    <div class="card-body">
        <ol class="mb-0">
            <li>Authentication</li>
            <li>Master Data</li>
            <li>Patient Registration</li>
            <li>Appointment Management</li>
            <li>OPD Module</li>
            <li>IPD Module</li>
            <li>Laboratory Module</li>
            <li>Pharmacy Module</li>
            <li>Billing & Reports</li>
        </ol>
    </div>
</div>
<%@ include file="/WEB-INF/jsp/hms/common/layout-end.jspf" %>
