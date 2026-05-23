package com.hms.hmsmodule.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HmsRootController {

    @GetMapping("/")
    public String root() {
        return "redirect:/hms/dashboard";
    }
}
