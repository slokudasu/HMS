<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hospital Management System</title>
    <link rel="stylesheet" href="/css/bootstrap5.min.css">
    <link rel="stylesheet" href="/css/bootstrap-icons.css">
    <style>
        body {
            background: #f4f6f9;
            font-size: 14px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            margin: 0;
        }

        .card {
            border-radius: 8px;
        }

        .metric-value {
            font-size: 24px;
            font-weight: 700;
            line-height: 1;
        }

        .metric-label {
            color: #6c757d;
            font-size: 13px;
            margin-top: 4px;
        }

        .table thead th {
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0;
        }

        .table td {
            vertical-align: middle;
        }

        .status-badge {
            min-width: 88px;
            display: inline-block;
            text-align: center;
        }

        .form-label {
            font-weight: 600;
            font-size: 13px;
        }
    </style>
</head>
<body>
<div class="container-fluid py-3">
    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
        <div>
            <h1 class="page-title">Hospital Management System</h1>
            <div class="text-muted">JSP and jQuery workflow using existing project libraries.</div>
        </div>
        <a class="btn btn-outline-secondary btn-sm" href="/login">
            <i class="bi bi-box-arrow-in-right me-1"></i>Restaurant Module
        </a>
    </div>

    <div id="globalMessage" class="alert d-none py-2" role="alert"></div>

    <div class="row g-3 mb-3">
        <div class="col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="metric-value text-primary" id="totalDoctors">0</div>
                    <div class="metric-label">Total Doctors</div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="metric-value text-success" id="totalPatients">0</div>
                    <div class="metric-label">Total Patients</div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="metric-value text-info" id="todayAppointments">0</div>
                    <div class="metric-label">Appointments Today</div>
                </div>
            </div>
        </div>
        <div class="col-md-6 col-xl-3">
            <div class="card shadow-sm h-100">
                <div class="card-body">
                    <div class="metric-value text-warning" id="scheduledAppointments">0</div>
                    <div class="metric-label">Scheduled Appointments</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3 mb-3">
        <div class="col-lg-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-white">
                    <strong>Add Doctor</strong>
                </div>
                <div class="card-body">
                    <form id="doctorForm">
                        <div class="mb-2">
                            <label class="form-label" for="doctorName">Name</label>
                            <input id="doctorName" class="form-control form-control-sm" required maxlength="120">
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="doctorSpecialization">Specialization</label>
                            <input id="doctorSpecialization" class="form-control form-control-sm" required maxlength="120">
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="doctorPhone">Phone</label>
                            <input id="doctorPhone" class="form-control form-control-sm" maxlength="20">
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="doctorAvailability">Availability</label>
                            <input id="doctorAvailability" class="form-control form-control-sm" maxlength="60" placeholder="09:00-17:00">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="doctorFee">Consultation Fee</label>
                            <input id="doctorFee" type="number" min="0" step="0.01" class="form-control form-control-sm">
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm w-100">
                            <i class="bi bi-person-plus me-1"></i>Save Doctor
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-white">
                    <strong>Add Patient</strong>
                </div>
                <div class="card-body">
                    <form id="patientForm">
                        <div class="mb-2">
                            <label class="form-label" for="patientName">Name</label>
                            <input id="patientName" class="form-control form-control-sm" required maxlength="120">
                        </div>
                        <div class="row g-2">
                            <div class="col-6">
                                <label class="form-label" for="patientGender">Gender</label>
                                <select id="patientGender" class="form-select form-select-sm" required>
                                    <option value="MALE">Male</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                            <div class="col-6">
                                <label class="form-label" for="patientAge">Age</label>
                                <input id="patientAge" type="number" min="1" max="120" class="form-control form-control-sm" required>
                            </div>
                        </div>
                        <div class="mb-2 mt-2">
                            <label class="form-label" for="patientPhone">Phone</label>
                            <input id="patientPhone" class="form-control form-control-sm" maxlength="20">
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="patientBloodGroup">Blood Group</label>
                            <select id="patientBloodGroup" class="form-select form-select-sm">
                                <option value="">Select</option>
                                <option>A+</option>
                                <option>A-</option>
                                <option>B+</option>
                                <option>B-</option>
                                <option>AB+</option>
                                <option>AB-</option>
                                <option>O+</option>
                                <option>O-</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-sm w-100">
                            <i class="bi bi-person-plus-fill me-1"></i>Save Patient
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-4">
            <div class="card shadow-sm h-100">
                <div class="card-header bg-white">
                    <strong>Book Appointment</strong>
                </div>
                <div class="card-body">
                    <form id="appointmentForm">
                        <div class="mb-2">
                            <label class="form-label" for="appointmentPatient">Patient</label>
                            <select id="appointmentPatient" class="form-select form-select-sm" required>
                                <option value="">Select patient</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="appointmentDoctor">Doctor</label>
                            <select id="appointmentDoctor" class="form-select form-select-sm" required>
                                <option value="">Select doctor</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <label class="form-label" for="appointmentDateTime">Date & Time</label>
                            <input id="appointmentDateTime" type="datetime-local" class="form-control form-control-sm" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label" for="appointmentReason">Reason</label>
                            <textarea id="appointmentReason" class="form-control form-control-sm" rows="3" maxlength="500"></textarea>
                        </div>
                        <button type="submit" class="btn btn-info btn-sm w-100 text-white">
                            <i class="bi bi-calendar-plus me-1"></i>Create Appointment
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <div class="col-12">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <strong>Appointments</strong>
                    <button class="btn btn-outline-secondary btn-sm" id="refreshAppointmentsBtn">
                        <i class="bi bi-arrow-clockwise me-1"></i>Refresh
                    </button>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-sm mb-0">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Patient</th>
                                <th>Doctor</th>
                                <th>Date & Time</th>
                                <th>Reason</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="appointmentsTableBody">
                            <tr><td colspan="7" class="text-center text-muted py-3">No appointments found</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-white"><strong>Doctors</strong></div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-sm mb-0">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Specialization</th>
                                <th>Phone</th>
                                <th>Availability</th>
                                <th>Fee</th>
                            </tr>
                            </thead>
                            <tbody id="doctorsTableBody">
                            <tr><td colspan="6" class="text-center text-muted py-3">No doctors found</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card shadow-sm">
                <div class="card-header bg-white"><strong>Patients</strong></div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-striped table-sm mb-0">
                            <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Gender</th>
                                <th>Age</th>
                                <th>Phone</th>
                                <th>Blood Group</th>
                            </tr>
                            </thead>
                            <tbody id="patientsTableBody">
                            <tr><td colspan="6" class="text-center text-muted py-3">No patients found</td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="/js/jquery.min.js"></script>
<script src="/js/bootstrap5.bundle.min.js"></script>
<script src="/js/hospital.js"></script>
</body>
</html>
