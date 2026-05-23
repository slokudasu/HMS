(function ($) {
    "use strict";
    var apiBase = "/api/hospital";

    function toText(value) {
        if (value === null || value === undefined) {
            return "";
        }
        return String(value);
    }

    function escapeHtml(value) {
        return $("<div>").text(toText(value)).html();
    }

    function setAlert(containerSelector, type, message) {
        var $container = $(containerSelector);
        if ($container.length === 0) {
            return;
        }
        $container.removeClass("d-none alert-success alert-danger alert-warning alert-info")
            .addClass("alert-" + type)
            .text(message);
    }

    function clearAlert(containerSelector) {
        var $container = $(containerSelector);
        if ($container.length === 0) {
            return;
        }
        $container.addClass("d-none")
            .removeClass("alert-success alert-danger alert-warning alert-info")
            .text("");
    }

    function parseDobDate(dobText) {
        if (!dobText) {
            return null;
        }
        var text = toText(dobText).trim();
        var parts = text.split("-");
        if (parts.length !== 3) {
            return null;
        }
        var year = Number(parts[0]);
        var month = Number(parts[1]);
        var day = Number(parts[2]);
        if (!year || !month || !day) {
            return null;
        }
        var dob = new Date(year, month - 1, day);
        if (isNaN(dob.getTime())) {
            return null;
        }
        if (dob.getFullYear() !== year || dob.getMonth() !== month - 1 || dob.getDate() !== day) {
            return null;
        }
        return dob;
    }

    function calculateAge(dobText) {
        var dob = parseDobDate(dobText);
        if (!dob) {
            return "";
        }
        var today = new Date();
        var age = today.getFullYear() - dob.getFullYear();
        var monthDiff = today.getMonth() - dob.getMonth();
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
            age--;
        }
        return age < 0 ? "" : age;
    }

    function normalizeText(value) {
        return toText(value).trim().toLowerCase();
    }

    function formatDate(dateText) {
        if (!dateText) {
            return "-";
        }
        var d = new Date(dateText);
        if (isNaN(d.getTime())) {
            return escapeHtml(dateText);
        }
        return d.toLocaleDateString();
    }

    function formatDateTime(dateText) {
        if (!dateText) {
            return "-";
        }
        var d = new Date(dateText);
        if (isNaN(d.getTime())) {
            return escapeHtml(dateText);
        }
        return d.toLocaleString();
    }

    function ajaxErrorMessage(xhr, fallback) {
        if (xhr && xhr.responseJSON && xhr.responseJSON.message) {
            return xhr.responseJSON.message;
        }
        return fallback || "Request failed. Please try again.";
    }

    function toInputDate(value) {
        if (!value) {
            return "";
        }
        var text = toText(value).trim();
        if (/^\d{4}-\d{2}-\d{2}$/.test(text)) {
            return text;
        }
        var date = new Date(text);
        if (isNaN(date.getTime())) {
            return "";
        }
        return date.toISOString().slice(0, 10);
    }

    function genderLabel(value) {
        var normalized = normalizeText(value);
        if (normalized === "male") {
            return "Male";
        }
        if (normalized === "female") {
            return "Female";
        }
        if (normalized === "other") {
            return "Other";
        }
        return toText(value);
    }

    var defaultStore = {
        patients: [
            {
                patientCode: "PAT-20260523-001",
                name: "Anita Sharma",
                gender: "Female",
                dob: "1993-04-17",
                mobile: "9876500011",
                address: "MG Road, Bengaluru",
                bloodGroup: "O+"
            },
            {
                patientCode: "PAT-20260523-002",
                name: "Ravi Kumar",
                gender: "Male",
                dob: "1988-09-09",
                mobile: "9876500022",
                address: "KPHB, Hyderabad",
                bloodGroup: "B+"
            },
            {
                patientCode: "PAT-20260523-003",
                name: "Meena R",
                gender: "Female",
                dob: "2001-01-12",
                mobile: "9876500033",
                address: "Adyar, Chennai",
                bloodGroup: "A-"
            }
        ],
        historyByPatient: {
            "PAT-20260523-001": {
                appointments: [
                    { dateTime: "2026-05-20T10:30:00", doctor: "Dr. Arjun (Cardiology)", status: "Completed", reason: "Chest discomfort" },
                    { dateTime: "2026-05-29T11:45:00", doctor: "Dr. Kavya (General Medicine)", status: "Booked", reason: "Follow-up review" }
                ],
                opd: [
                    { visitDate: "2026-05-20", diagnosis: "Mild gastritis", notes: "Diet advised", doctor: "Dr. Arjun" }
                ],
                ipd: [
                    { admissionDate: "2026-01-06", dischargeDate: "2026-01-08", room: "A-203", bed: "B2", status: "Discharged" }
                ],
                lab: [
                    { testName: "Blood Test", reportDate: "2026-05-20", result: "Normal", status: "Completed" }
                ],
                prescriptions: [
                    { date: "2026-05-20", medicine: "Pantoprazole 40mg", dosage: "1-0-1", duration: "5 days" }
                ],
                billing: [
                    { billNo: "BL-20260520-001", billDate: "2026-05-20", total: 2500, discount: 200, net: 2300, status: "Paid" }
                ]
            }
        }
    };

    if (!window.hmsPatientStore) {
        window.hmsPatientStore = defaultStore;
    }
    var store = window.hmsPatientStore;

    function initPatientRegistration() {
        var $form = $("#patientRegistrationForm");
        if ($form.length === 0) {
            return;
        }

        var $dob = $("#dob");
        var $age = $("#calculatedAge");
        var $listBody = $("#patientRegistrationListBody");
        var $submit = $("#patientRegistrationSubmit");
        var $cancelEdit = $("#patientRegistrationCancelEdit");
        var editingPatientId = null;
        var registrationPatients = [];

        function setFormMode(editMode) {
            if (editMode) {
                $submit.text("Update Patient");
                $cancelEdit.removeClass("d-none");
                return;
            }
            $submit.text("Save Patient");
            $cancelEdit.addClass("d-none");
        }

        function resetRegistrationForm() {
            editingPatientId = null;
            setFormMode(false);
            $form[0].reset();
            $age.val("");
            clearAlert("#patientRegistrationAlert");
        }

        function syncCalculatedAge() {
            $age.val(calculateAge($dob.val()));
        }

        function renderPatients() {
            var rows = [];
            $.each(registrationPatients, function (idx, patient) {
                var age = patient.age != null ? patient.age : calculateAge(patient.dob);
                rows.push(
                    "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + escapeHtml(patient.patientCode || "-") + "</td>" +
                    "<td>" + escapeHtml(patient.name || "-") + "</td>" +
                    "<td>" + escapeHtml(genderLabel(patient.gender) || "-") + "</td>" +
                    "<td>" + formatDate(patient.dob) + "</td>" +
                    "<td>" + escapeHtml(age || "-") + "</td>" +
                    "<td>" + escapeHtml(patient.mobile || patient.phone || "-") + "</td>" +
                    "<td>" + escapeHtml(patient.bloodGroup || "-") + "</td>" +
                    '<td><div class="btn-group btn-group-sm" role="group">' +
                    '<button type="button" class="btn btn-outline-primary patient-edit-btn" data-id="' + patient.id + '">Edit</button>' +
                    '<button type="button" class="btn btn-outline-danger patient-delete-btn" data-id="' + patient.id + '">Delete</button>' +
                    "</div></td>" +
                    "</tr>"
                );
            });
            if (rows.length === 0) {
                rows.push('<tr class="hms-empty-row"><td colspan="9">No patients available</td></tr>');
            }
            $listBody.html(rows.join(""));
        }

        function loadPatients() {
            return $.getJSON(apiBase + "/patients")
                .done(function (data) {
                    registrationPatients = data || [];
                    renderPatients();
                })
                .fail(function (xhr) {
                    setAlert("#patientRegistrationAlert", "danger", ajaxErrorMessage(xhr, "Unable to load patient data."));
                });
        }

        function setEditPatient(patientId) {
            var selected = null;
            $.each(registrationPatients, function (_, patient) {
                if (String(patient.id) === String(patientId)) {
                    selected = patient;
                    return false;
                }
                return true;
            });
            if (!selected) {
                setAlert("#patientRegistrationAlert", "warning", "Selected patient not found.");
                return;
            }

            editingPatientId = selected.id;
            setFormMode(true);
            $("#patientName").val(selected.name || "");
            $("#gender").val(toText(selected.gender).toUpperCase());
            $("#dob").val(toInputDate(selected.dob));
            $("#mobile").val(selected.mobile || selected.phone || "");
            $("#address").val(selected.address || "");
            $("#bloodGroup").val(selected.bloodGroup || "");
            syncCalculatedAge();
            if (!$age.val() && selected.age != null) {
                $age.val(selected.age);
            }
            setAlert("#patientRegistrationAlert", "info", "Editing patient: " + (selected.name || "-"));
        }

        // Update age immediately whenever DOB is changed by typing, picker select, or blur.
        $dob.on("input change keyup blur", function () {
            syncCalculatedAge();
        });

        $form.on("submit", function (event) {
            event.preventDefault();
            clearAlert("#patientRegistrationAlert");
            syncCalculatedAge();

            var payload = {
                name: $("#patientName").val(),
                gender: $("#gender").val(),
                dob: $("#dob").val(),
                age: $age.val() ? Number($age.val()) : null,
                mobile: $("#mobile").val(),
                address: $("#address").val(),
                bloodGroup: $("#bloodGroup").val()
            };

            if (!payload.name || !payload.gender || !payload.dob || !payload.mobile) {
                setAlert("#patientRegistrationAlert", "danger", "Please fill all required fields.");
                return;
            }

            $.ajax({
                url: editingPatientId == null ? apiBase + "/patients" : apiBase + "/patients/" + editingPatientId,
                type: editingPatientId == null ? "POST" : "PUT",
                contentType: "application/json",
                data: JSON.stringify(payload)
            }).done(function (savedPatient) {
                var action = editingPatientId == null ? "saved" : "updated";
                setAlert(
                    "#patientRegistrationAlert",
                    "success",
                    "Patient " + action + " successfully."
                );
                editingPatientId = null;
                setFormMode(false);
                $form[0].reset();
                $age.val("");
                loadPatients();
            }).fail(function (xhr) {
                setAlert("#patientRegistrationAlert", "danger", ajaxErrorMessage(xhr, "Unable to save patient."));
            });
        });

        $("#patientRegistrationClear").on("click", function () {
            resetRegistrationForm();
        });

        $cancelEdit.on("click", function () {
            resetRegistrationForm();
        });

        $listBody.on("click", ".patient-edit-btn", function () {
            setEditPatient($(this).data("id"));
        });

        $listBody.on("click", ".patient-delete-btn", function () {
            var patientId = $(this).data("id");
            if (!patientId) {
                return;
            }
            if (!window.confirm("Delete this patient record?")) {
                return;
            }

            $.ajax({
                url: apiBase + "/patients/" + patientId,
                type: "DELETE"
            }).done(function () {
                if (String(editingPatientId) === String(patientId)) {
                    resetRegistrationForm();
                }
                setAlert("#patientRegistrationAlert", "success", "Patient deleted successfully.");
                loadPatients();
            }).fail(function (xhr) {
                setAlert("#patientRegistrationAlert", "danger", ajaxErrorMessage(xhr, "Unable to delete patient."));
            });
        });

        loadPatients();
        syncCalculatedAge();
    }

    function initPatientSearch() {
        var $form = $("#patientSearchForm");
        if ($form.length === 0) {
            return;
        }

        var $tbody = $("#patientSearchResultsBody");
        var $resultCount = $("#patientSearchCount");

        function filterPatients() {
            var patientCode = normalizeText($("#searchPatientCode").val());
            var name = normalizeText($("#searchPatientName").val());
            var mobile = normalizeText($("#searchMobile").val());
            var gender = normalizeText($("#searchGender").val());
            var blood = normalizeText($("#searchBloodGroup").val());

            var filtered = $.grep(store.patients, function (p) {
                var okCode = !patientCode || normalizeText(p.patientCode).indexOf(patientCode) !== -1;
                var okName = !name || normalizeText(p.name).indexOf(name) !== -1;
                var okMobile = !mobile || normalizeText(p.mobile).indexOf(mobile) !== -1;
                var okGender = !gender || normalizeText(p.gender) === gender;
                var okBlood = !blood || normalizeText(p.bloodGroup) === blood;
                return okCode && okName && okMobile && okGender && okBlood;
            });

            var rows = [];
            $.each(filtered, function (idx, p) {
                rows.push(
                    "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + escapeHtml(p.patientCode) + "</td>" +
                    "<td>" + escapeHtml(p.name) + "</td>" +
                    "<td>" + escapeHtml(p.gender) + "</td>" +
                    "<td>" + formatDate(p.dob) + "</td>" +
                    "<td>" + escapeHtml(p.mobile) + "</td>" +
                    "<td>" + escapeHtml(p.bloodGroup) + "</td>" +
                    '<td><a class="btn btn-sm btn-outline-primary" href="/hms/patient/history?patientCode=' + encodeURIComponent(p.patientCode) + '">View History</a></td>' +
                    "</tr>"
                );
            });

            if (rows.length === 0) {
                rows.push('<tr class="hms-empty-row"><td colspan="8">No patients matched your criteria</td></tr>');
            }

            $tbody.html(rows.join(""));
            $resultCount.text(filtered.length);
        }

        $form.on("submit", function (event) {
            event.preventDefault();
            filterPatients();
        });

        $("#patientSearchReset").on("click", function () {
            $form[0].reset();
            filterPatients();
        });

        filterPatients();
    }

    function initPatientHistory() {
        var $form = $("#patientHistoryLookupForm");
        if ($form.length === 0) {
            return;
        }

        function renderRows(rows, targetId, mapFn, emptyColspan) {
            var html = [];
            $.each(rows, function (idx, row) {
                html.push(mapFn(idx, row));
            });
            if (html.length === 0) {
                html.push('<tr class="hms-empty-row"><td colspan="' + emptyColspan + '">No records found</td></tr>');
            }
            $(targetId).html(html.join(""));
        }

        function findPatient(query) {
            var needle = normalizeText(query);
            if (!needle) {
                return null;
            }
            var found = null;
            $.each(store.patients, function (_, p) {
                if (normalizeText(p.patientCode) === needle || normalizeText(p.mobile) === needle) {
                    found = p;
                    return false;
                }
                return true;
            });
            return found;
        }

        function applyPatientSummary(patient) {
            $("#summaryPatientCode").text(patient.patientCode || "-");
            $("#summaryPatientName").text(patient.name || "-");
            $("#summaryGender").text(patient.gender || "-");
            $("#summaryDob").text(formatDate(patient.dob));
            $("#summaryAge").text(calculateAge(patient.dob) || "-");
            $("#summaryMobile").text(patient.mobile || "-");
            $("#summaryBloodGroup").text(patient.bloodGroup || "-");
            $("#summaryAddress").text(patient.address || "-");
        }

        function applyHistory(patientCode) {
            var history = store.historyByPatient[patientCode] || {
                appointments: [],
                opd: [],
                ipd: [],
                lab: [],
                prescriptions: [],
                billing: []
            };

            renderRows(history.appointments, "#historyAppointmentsBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + formatDateTime(r.dateTime) + "</td>" +
                    "<td>" + escapeHtml(r.doctor) + "</td>" +
                    "<td>" + escapeHtml(r.reason) + "</td>" +
                    "<td>" + escapeHtml(r.status) + "</td>" +
                    "</tr>";
            }, 5);

            renderRows(history.opd, "#historyOpdBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + formatDate(r.visitDate) + "</td>" +
                    "<td>" + escapeHtml(r.doctor) + "</td>" +
                    "<td>" + escapeHtml(r.diagnosis) + "</td>" +
                    "<td>" + escapeHtml(r.notes) + "</td>" +
                    "</tr>";
            }, 5);

            renderRows(history.ipd, "#historyIpdBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + formatDate(r.admissionDate) + "</td>" +
                    "<td>" + formatDate(r.dischargeDate) + "</td>" +
                    "<td>" + escapeHtml(r.room) + "</td>" +
                    "<td>" + escapeHtml(r.bed) + "</td>" +
                    "<td>" + escapeHtml(r.status) + "</td>" +
                    "</tr>";
            }, 6);

            renderRows(history.lab, "#historyLabBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + escapeHtml(r.testName) + "</td>" +
                    "<td>" + formatDate(r.reportDate) + "</td>" +
                    "<td>" + escapeHtml(r.result) + "</td>" +
                    "<td>" + escapeHtml(r.status) + "</td>" +
                    "</tr>";
            }, 5);

            renderRows(history.prescriptions, "#historyPrescriptionBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + formatDate(r.date) + "</td>" +
                    "<td>" + escapeHtml(r.medicine) + "</td>" +
                    "<td>" + escapeHtml(r.dosage) + "</td>" +
                    "<td>" + escapeHtml(r.duration) + "</td>" +
                    "</tr>";
            }, 5);

            renderRows(history.billing, "#historyBillingBody", function (idx, r) {
                return "<tr>" +
                    "<td>" + (idx + 1) + "</td>" +
                    "<td>" + escapeHtml(r.billNo) + "</td>" +
                    "<td>" + formatDate(r.billDate) + "</td>" +
                    "<td>" + Number(r.total || 0).toFixed(2) + "</td>" +
                    "<td>" + Number(r.discount || 0).toFixed(2) + "</td>" +
                    "<td>" + Number(r.net || 0).toFixed(2) + "</td>" +
                    "<td>" + escapeHtml(r.status) + "</td>" +
                    "</tr>";
            }, 7);
        }

        function loadHistory() {
            clearAlert("#patientHistoryAlert");
            var query = $("#historyPatientCode").val();
            var patient = findPatient(query);

            if (!patient) {
                setAlert("#patientHistoryAlert", "warning", "Patient not found. Enter exact patient code or mobile.");
                return;
            }

            applyPatientSummary(patient);
            applyHistory(patient.patientCode);
            setAlert("#patientHistoryAlert", "info", "Loaded history for " + patient.name + " (" + patient.patientCode + ").");
        }

        $form.on("submit", function (event) {
            event.preventDefault();
            loadHistory();
        });

        $("#historyClear").on("click", function () {
            $form[0].reset();
            clearAlert("#patientHistoryAlert");
        });

        var params = new URLSearchParams(window.location.search);
        var codeFromQuery = params.get("patientCode");
        if (codeFromQuery) {
            $("#historyPatientCode").val(codeFromQuery);
            loadHistory();
        } else {
            $("#historyPatientCode").val("PAT-20260523-001");
            loadHistory();
        }
    }

    $(function () {
        initPatientRegistration();
        initPatientSearch();
        initPatientHistory();
    });
})(jQuery);
