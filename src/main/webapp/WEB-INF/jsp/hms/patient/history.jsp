<%
request.setAttribute("pageTitle", "Patient History");
request.setAttribute("hmsExtraCss", "/css/hms-patient.css");
request.setAttribute("hmsExtraJs", "/js/hms-patient.js");
%>
<%@ include file="/WEB-INF/jsp/hms/common/layout-start.jspf" %>

<div id="patientHistoryAlert" class="alert d-none" role="alert"></div>

<section class="hms-form-section">
    <div class="hms-form-title">Lookup Patient</div>
    <form id="patientHistoryLookupForm" class="row g-2 align-items-end">
        <div class="col-md-4">
            <label for="historyPatientCode" class="form-label">Patient ID / Mobile</label>
            <input id="historyPatientCode" class="form-control" placeholder="PAT-20260523-001 or 98765...">
        </div>
        <div class="col-auto d-flex gap-2">
            <button type="submit" class="btn btn-primary">Load History</button>
            <button id="historyClear" type="button" class="btn btn-outline-secondary">Clear</button>
            <a class="btn btn-outline-info" href="/hms/patient/search">Back to Search</a>
        </div>
    </form>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">Patient Summary</div>
    <div class="hms-summary-grid">
        <div class="hms-summary-item"><div class="hms-muted-label">Patient ID</div><div id="summaryPatientCode" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Name</div><div id="summaryPatientName" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Gender</div><div id="summaryGender" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">DOB</div><div id="summaryDob" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Age</div><div id="summaryAge" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Mobile</div><div id="summaryMobile" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Blood Group</div><div id="summaryBloodGroup" class="hms-data-value">-</div></div>
        <div class="hms-summary-item"><div class="hms-muted-label">Address</div><div id="summaryAddress" class="hms-data-value">-</div></div>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">Appointment History</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Date & Time</th>
                <th>Doctor</th>
                <th>Reason</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="historyAppointmentsBody">
            <tr class="hms-empty-row"><td colspan="5">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">OPD Consultation History</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Visit Date</th>
                <th>Doctor</th>
                <th>Diagnosis</th>
                <th>Notes</th>
            </tr>
            </thead>
            <tbody id="historyOpdBody">
            <tr class="hms-empty-row"><td colspan="5">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">IPD Admission History</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Admission Date</th>
                <th>Discharge Date</th>
                <th>Room</th>
                <th>Bed</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="historyIpdBody">
            <tr class="hms-empty-row"><td colspan="6">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">Lab Reports</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Test</th>
                <th>Report Date</th>
                <th>Result</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="historyLabBody">
            <tr class="hms-empty-row"><td colspan="5">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">Prescription History</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Date</th>
                <th>Medicine</th>
                <th>Dosage</th>
                <th>Duration</th>
            </tr>
            </thead>
            <tbody id="historyPrescriptionBody">
            <tr class="hms-empty-row"><td colspan="5">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<section class="hms-form-section">
    <div class="hms-form-title">Billing History</div>
    <div class="hms-table-wrap">
        <table class="table table-sm table-striped mb-0">
            <thead>
            <tr>
                <th>#</th>
                <th>Bill No</th>
                <th>Date</th>
                <th>Total</th>
                <th>Discount</th>
                <th>Net</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody id="historyBillingBody">
            <tr class="hms-empty-row"><td colspan="7">No records found</td></tr>
            </tbody>
        </table>
    </div>
</section>

<%@ include file="/WEB-INF/jsp/hms/common/layout-end.jspf" %>
