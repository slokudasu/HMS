package com.hms.hmsmodule.controller;

import java.util.Set;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.server.ResponseStatusException;

@Controller
@RequestMapping("/hms")
public class HmsModulePageController {

    private static final Set<String> SECTION_PAGES = Set.of(
            "auth/login",
            "auth/logout",
            "auth/users",
            "master/departments",
            "master/doctors",
            "master/rooms",
            "master/beds",
            "master/medicines",
            "master/lab-tests",
            "patient/registration",
            "patient/search",
            "patient/history",
            "doctor/registration",
            "doctor/specializations",
            "doctor/schedules",
            "appointment/book",
            "appointment/cancel",
            "appointment/history",
            "ipd/admission",
            "ipd/bed-allocation",
            "ipd/room-management",
            "ipd/discharge",
            "opd/consultation",
            "opd/prescription",
            "pharmacy/medicine-management",
            "pharmacy/stock-management",
            "pharmacy/sales",
            "laboratory/test-management",
            "laboratory/test-reports",
            "billing/consultation-charges",
            "billing/room-charges",
            "billing/lab-charges",
            "billing/pharmacy-charges",
            "billing/final-bill",
            "reports/patient-list",
            "reports/admission-report",
            "reports/doctor-appointments",
            "reports/daily-collection",
            "reports/monthly-revenue",
            "reports/stock-summary");

    @GetMapping({"", "/"})
    public String home() {
        return "redirect:/hms/dashboard";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        model.addAttribute("pageTitle", "Hospital Management Dashboard");
        return "hms/dashboard";
    }

    @GetMapping("/login")
    public String loginAlias() {
        return "redirect:/hms/auth/login";
    }

    @GetMapping("/logout")
    public String logoutAlias() {
        return "redirect:/hms/auth/logout";
    }

    @GetMapping("/{module}/{page}")
    public String section(@PathVariable String module, @PathVariable String page, Model model) {
        String key = module + "/" + page;
        if (!SECTION_PAGES.contains(key)) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "HMS page not found");
        }
        model.addAttribute("pageTitle", toTitle(module) + " - " + toTitle(page));
        return "hms/" + key;
    }

    private String toTitle(String slug) {
        if (slug == null || slug.isBlank()) {
            return "";
        }

        String[] parts = slug.trim().split("-");
        StringBuilder builder = new StringBuilder();
        for (String part : parts) {
            if (part.isBlank()) {
                continue;
            }
            if (builder.length() > 0) {
                builder.append(' ');
            }
            builder.append(Character.toUpperCase(part.charAt(0)));
            if (part.length() > 1) {
                builder.append(part.substring(1));
            }
        }
        return builder.toString();
    }
}
