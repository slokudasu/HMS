(function ($) {
    "use strict";

    var apiBase = "/api/hospital";

    var $message = $("#globalMessage");
    var $doctorForm = $("#doctorForm");
    var $patientForm = $("#patientForm");
    var $appointmentForm = $("#appointmentForm");
    var $appointmentsTableBody = $("#appointmentsTableBody");
    var $doctorsTableBody = $("#doctorsTableBody");
    var $patientsTableBody = $("#patientsTableBody");
    var $appointmentDoctor = $("#appointmentDoctor");
    var $appointmentPatient = $("#appointmentPatient");

    function showMessage(type, text) {
        $message.removeClass("d-none alert-success alert-danger alert-warning")
            .addClass("alert-" + type)
            .text(text);
    }

    function clearMessage() {
        $message.addClass("d-none").text("").removeClass("alert-success alert-danger alert-warning");
    }

    function ajaxErrorMessage(xhr) {
        if (xhr && xhr.responseJSON && xhr.responseJSON.message) {
            return xhr.responseJSON.message;
        }
        return "Request failed. Please try again.";
    }

    function formatDateTime(value) {
        if (!value) {
            return "-";
        }
        var date = new Date(value);
        if (isNaN(date.getTime())) {
            return String(value).replace("T", " ");
        }
        return date.toLocaleString();
    }

    function statusBadge(status) {
        var safeStatus = (status || "").toUpperCase();
        if (safeStatus === "COMPLETED") {
            return '<span class="badge text-bg-success status-badge">COMPLETED</span>';
        }
        if (safeStatus === "CANCELLED") {
            return '<span class="badge text-bg-danger status-badge">CANCELLED</span>';
        }
        return '<span class="badge text-bg-warning status-badge">SCHEDULED</span>';
    }

    function renderDoctors(doctors) {
        if (!doctors || doctors.length === 0) {
            $doctorsTableBody.html('<tr><td colspan="6" class="text-center text-muted py-3">No doctors found</td></tr>');
            $appointmentDoctor.html('<option value="">Select doctor</option>');
            return;
        }

        var tableRows = [];
        var selectOptions = ['<option value="">Select doctor</option>'];

        $.each(doctors, function (index, doctor) {
            tableRows.push(
                "<tr>" +
                "<td>" + (index + 1) + "</td>" +
                "<td>" + escapeHtml(doctor.name || "-") + "</td>" +
                "<td>" + escapeHtml(doctor.specialization || "-") + "</td>" +
                "<td>" + escapeHtml(doctor.phone || "-") + "</td>" +
                "<td>" + escapeHtml(doctor.availability || "-") + "</td>" +
                "<td>" + (doctor.consultationFee != null ? doctor.consultationFee : "-") + "</td>" +
                "</tr>"
            );

            selectOptions.push(
                '<option value="' + doctor.id + '">' +
                escapeHtml(doctor.name || "Doctor") + " - " + escapeHtml(doctor.specialization || "General") +
                "</option>"
            );
        });

        $doctorsTableBody.html(tableRows.join(""));
        $appointmentDoctor.html(selectOptions.join(""));
    }

    function renderPatients(patients) {
        if (!patients || patients.length === 0) {
            $patientsTableBody.html('<tr><td colspan="6" class="text-center text-muted py-3">No patients found</td></tr>');
            $appointmentPatient.html('<option value="">Select patient</option>');
            return;
        }

        var tableRows = [];
        var selectOptions = ['<option value="">Select patient</option>'];

        $.each(patients, function (index, patient) {
            tableRows.push(
                "<tr>" +
                "<td>" + (index + 1) + "</td>" +
                "<td>" + escapeHtml(patient.name || "-") + "</td>" +
                "<td>" + escapeHtml(patient.gender || "-") + "</td>" +
                "<td>" + (patient.age != null ? patient.age : "-") + "</td>" +
                "<td>" + escapeHtml(patient.phone || "-") + "</td>" +
                "<td>" + escapeHtml(patient.bloodGroup || "-") + "</td>" +
                "</tr>"
            );

            selectOptions.push(
                '<option value="' + patient.id + '">' +
                escapeHtml(patient.name || "Patient") + " (" + (patient.age != null ? patient.age : "-") + ")" +
                "</option>"
            );
        });

        $patientsTableBody.html(tableRows.join(""));
        $appointmentPatient.html(selectOptions.join(""));
    }

    function renderAppointments(appointments) {
        if (!appointments || appointments.length === 0) {
            $appointmentsTableBody.html('<tr><td colspan="7" class="text-center text-muted py-3">No appointments found</td></tr>');
            return;
        }

        var rows = [];
        $.each(appointments, function (index, appointment) {
            var status = (appointment.status || "").toUpperCase();
            var actions = "-";

            if (status === "SCHEDULED") {
                actions =
                    '<div class="btn-group btn-group-sm" role="group">' +
                    '<button class="btn btn-outline-success appointment-status-btn" data-id="' + appointment.id + '" data-status="COMPLETED">Complete</button>' +
                    '<button class="btn btn-outline-danger appointment-status-btn" data-id="' + appointment.id + '" data-status="CANCELLED">Cancel</button>' +
                    "</div>";
            }

            rows.push(
                "<tr>" +
                "<td>" + (index + 1) + "</td>" +
                "<td>" + escapeHtml(appointment.patientName || "-") + "</td>" +
                "<td>" + escapeHtml(appointment.doctorName || "-") + "</td>" +
                "<td>" + escapeHtml(formatDateTime(appointment.appointmentDateTime)) + "</td>" +
                "<td>" + escapeHtml(appointment.reason || "-") + "</td>" +
                "<td>" + statusBadge(status) + "</td>" +
                "<td>" + actions + "</td>" +
                "</tr>"
            );
        });

        $appointmentsTableBody.html(rows.join(""));
    }

    function loadDashboard() {
        return $.getJSON(apiBase + "/dashboard")
            .done(function (data) {
                $("#totalDoctors").text(data.totalDoctors || 0);
                $("#totalPatients").text(data.totalPatients || 0);
                $("#todayAppointments").text(data.todayAppointments || 0);
                $("#scheduledAppointments").text(data.scheduledAppointments || 0);
            });
    }

    function loadDoctors() {
        return $.getJSON(apiBase + "/doctors")
            .done(function (data) {
                renderDoctors(data || []);
            });
    }

    function loadPatients() {
        return $.getJSON(apiBase + "/patients")
            .done(function (data) {
                renderPatients(data || []);
            });
    }

    function loadAppointments() {
        return $.getJSON(apiBase + "/appointments")
            .done(function (data) {
                renderAppointments(data || []);
            });
    }

    function refreshAllData() {
        clearMessage();
        return $.when(loadDashboard(), loadDoctors(), loadPatients(), loadAppointments())
            .fail(function (xhr) {
                showMessage("danger", ajaxErrorMessage(xhr));
            });
    }

    function escapeHtml(value) {
        return $("<div>").text(value == null ? "" : String(value)).html();
    }

    $doctorForm.on("submit", function (event) {
        event.preventDefault();

        var payload = {
            name: $("#doctorName").val(),
            specialization: $("#doctorSpecialization").val(),
            phone: $("#doctorPhone").val(),
            availability: $("#doctorAvailability").val(),
            consultationFee: $("#doctorFee").val() ? Number($("#doctorFee").val()) : null
        };

        $.ajax({
            url: apiBase + "/doctors",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(payload)
        }).done(function () {
            $doctorForm[0].reset();
            showMessage("success", "Doctor added successfully.");
            refreshAllData();
        }).fail(function (xhr) {
            showMessage("danger", ajaxErrorMessage(xhr));
        });
    });

    $patientForm.on("submit", function (event) {
        event.preventDefault();

        var payload = {
            name: $("#patientName").val(),
            gender: $("#patientGender").val(),
            age: $("#patientAge").val() ? Number($("#patientAge").val()) : null,
            phone: $("#patientPhone").val(),
            bloodGroup: $("#patientBloodGroup").val()
        };

        $.ajax({
            url: apiBase + "/patients",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(payload)
        }).done(function () {
            $patientForm[0].reset();
            showMessage("success", "Patient added successfully.");
            refreshAllData();
        }).fail(function (xhr) {
            showMessage("danger", ajaxErrorMessage(xhr));
        });
    });

    $appointmentForm.on("submit", function (event) {
        event.preventDefault();

        var payload = {
            patientId: $("#appointmentPatient").val() ? Number($("#appointmentPatient").val()) : null,
            doctorId: $("#appointmentDoctor").val() ? Number($("#appointmentDoctor").val()) : null,
            appointmentDateTime: $("#appointmentDateTime").val(),
            reason: $("#appointmentReason").val()
        };

        $.ajax({
            url: apiBase + "/appointments",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(payload)
        }).done(function () {
            $appointmentForm[0].reset();
            showMessage("success", "Appointment created successfully.");
            refreshAllData();
        }).fail(function (xhr) {
            showMessage("danger", ajaxErrorMessage(xhr));
        });
    });

    $appointmentsTableBody.on("click", ".appointment-status-btn", function () {
        var appointmentId = $(this).data("id");
        var status = $(this).data("status");

        $.ajax({
            url: apiBase + "/appointments/" + appointmentId + "/status",
            type: "PUT",
            contentType: "application/json",
            data: JSON.stringify({status: status})
        }).done(function () {
            showMessage("success", "Appointment status updated.");
            refreshAllData();
        }).fail(function (xhr) {
            showMessage("danger", ajaxErrorMessage(xhr));
        });
    });

    $("#refreshAppointmentsBtn").on("click", function () {
        refreshAllData();
    });

    $(function () {
        refreshAllData();
    });
})(jQuery);
