<%
request.setAttribute("pageTitle", "Patient Search");
request.setAttribute("hmsExtraCss", "/css/hms-patient.css");
request.setAttribute("hmsExtraJs", "/js/hms-patient.js");
%>
<%@ include file="/WEB-INF/jsp/hms/common/layout-start.jspf" %>

<section class="hms-form-section">
    <div class="hms-form-title">Search Filters</div>
    <form id="patientSearchForm">
        <div class="row g-2">
            <div class="col-lg-3 col-md-4">
                <label for="searchPatientCode" class="form-label">Patient ID</label>
                <input id="searchPatientCode" class="form-control" placeholder="PAT-20260523-001">
            </div>
            <div class="col-lg-3 col-md-4">
                <label for="searchPatientName" class="form-label">Patient Name</label>
                <input id="searchPatientName" class="form-control" placeholder="Name">
            </div>
            <div class="col-lg-2 col-md-4">
                <label for="searchMobile" class="form-label">Mobile</label>
                <input id="searchMobile" class="form-control" placeholder="98765...">
            </div>
            <div class="col-lg-2 col-md-6">
                <label for="searchGender" class="form-label">Gender</label>
                <select id="searchGender" class="form-select">
                    <option value="">All</option>
                    <option value="Male">Male</option>
                    <option value="Female">Female</option>
                    <option value="Other">Other</option>
                </select>
            </div>
            <div class="col-lg-2 col-md-6">
                <label for="searchBloodGroup" class="form-label">Blood Group</label>
                <select id="searchBloodGroup" class="form-select">
                    <option value="">All</option>
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
        </div>
        <div class="d-flex gap-2 mt-3">
            <button type="submit" class="btn btn-primary">Search</button>
            <button id="patientSearchReset" type="button" class="btn btn-outline-secondary">Reset</button>
            <a class="btn btn-outline-info" href="/hms/patient/registration">New Registration</a>
        </div>
    </form>
</section>

<section class="hms-form-section">
    <div class="d-flex justify-content-between align-items-center mb-2">
        <div class="hms-form-title mb-0">Search Results</div>
        <div class="text-muted">Matched Records: <strong id="patientSearchCount">0</strong></div>
    </div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Patient ID</th>
                <th>Name</th>
                <th>Gender</th>
                <th>DOB</th>
                <th>Mobile</th>
                <th>Blood Group</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody id="patientSearchResultsBody">
            <tr class="hms-empty-row">
                <td colspan="8">No search performed yet</td>
            </tr>
            </tbody>
        </table>
    </div>
</section>

<%@ include file="/WEB-INF/jsp/hms/common/layout-end.jspf" %>
