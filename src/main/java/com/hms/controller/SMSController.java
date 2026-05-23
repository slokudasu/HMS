package com.hms.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.hms.service.SmsService;

@RestController
@RequestMapping("/api/sms")
public class SMSController {

	
	SmsService smsService;

    public SMSController(SmsService smsService) {
        this.smsService = smsService;
    }

    @GetMapping("/sendSms")
    public String sendSms() {
        return smsService.sendSms("+917893429128", "Dear Lokudasu, please pay ₹300 for December month maintenance. – Gayatri Colony Admin");
    }
    
    @GetMapping("/sendWhatsAppMessage")
    public String sendWhatsAppMessage() {
        return smsService.sendWhatsAppMessage("whatsapp:+919666705710", "Dear Lokudasu, please pay ₹300 for December month maintenance. – Gayatri Colony Admin");
    }
}	 