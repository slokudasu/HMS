package com.hms.hospital.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HospitalPageController {

    @GetMapping("/hospital")
    public String hospitalPage() {
        return "hospital";
    }
}
