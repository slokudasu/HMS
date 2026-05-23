<%
request.setAttribute("pageTitle", "Patient Registration");
request.setAttribute("hmsExtraCss", "/css/hms-patient.css");
request.setAttribute("hmsExtraJs", "/js/hms-patient.js");
%>
<%@ include file="/WEB-INF/jsp/hms/common/layout-start.jspf" %>

<div id="patientRegistrationAlert" class="alert d-none" role="alert"></div>

<div class="row g-3">
    <div class="col-xl-12">
        <section class="hms-form-section">
            <form id="patientRegistrationForm" autocomplete="off">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label for="patientName" class="form-label">Patient Name <span class="text-danger">*</span></label>
                        <input id="patientName" class="form-control" maxlength="140" required>
                    </div>

                    <div class="col-md-2">
                        <label for="gender" class="form-label">Gender <span class="text-danger">*</span></label>
                        <select id="gender" class="form-select" required>
                            <option value="">Select</option>
                            <option value="MALE">Male</option>
                            <option value="FEMALE">Female</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label for="dob" class="form-label">Date of Birth <span class="text-danger">*</span></label>
                        <input id="dob" type="date" class="form-control" required>
                    </div>
                    <div class="col-md-2">
                        <label for="calculatedAge" class="form-label">Age</label>
                        <input id="calculatedAge" class="form-control" readonly>
                    </div>

                    <div class="col-md-3">
                        <label for="mobile" class="form-label">Mobile <span class="text-danger">*</span></label>
                        <input id="mobile" class="form-control" maxlength="10" required>
                    </div>
                    <div class="col-md-2">
                        <label for="bloodGroup" class="form-label">Blood Group</label>
                        <select id="bloodGroup" class="form-select">
                            <option value="">Select</option>
                            <option>O+</option>
                            <option>O-</option>
                            <option>A+</option>
                            <option>A-</option>
                            <option>B+</option>
                            <option>B-</option>
                            <option>AB+</option>
                            <option>AB-</option>
                        </select>
                    </div>

                    <div class="col-4">
                        <label for="address" class="form-label">Address</label>
                        <textarea id="address" class="form-control" rows="3" maxlength="5000"></textarea>
                    </div>
                </div>

                <div class="d-flex flex-wrap gap-2 mt-3">
                    <button id="patientRegistrationSubmit" type="submit" class="btn btn-primary">Save Patient</button>
                    <button id="patientRegistrationClear" type="button" class="btn btn-outline-secondary">Clear</button>
                    <button id="patientRegistrationCancelEdit" type="button" class="btn btn-outline-warning d-none">Cancel Edit</button>
                    <a class="btn btn-outline-info" href="/hms/patient/search">Go to Search</a>
                    <a class="btn btn-outline-info" href="/hms/patient/history">Go to History</a>
                </div>
            </form>
        </section>
    </div>

    <div class="col-xl-12">
        <section class="hms-form-section">
            <div class="hms-form-title">Registered Patients</div>
            <div class="hms-table-wrap">
                <table class="table table-sm table-striped mb-0">
                    <thead>
                    <tr>
                        <th>#</th>
                        <th>Patient ID</th>
                        <th>Name</th>
                        <th>Gender</th>
                        <th>DOB</th>
                        <th>Age</th>
                        <th>Mobile</th>
                        <th>Blood Group</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="patientRegistrationListBody">
                    <tr class="hms-empty-row">
                        <td colspan="9">No patients available</td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/hms/common/layout-end.jspf" %>
