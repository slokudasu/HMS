package com.hms.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.hms.congif.TwilioConfig;
import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;

import jakarta.annotation.PostConstruct;

@Service
public class SmsService {

    private final com.hms.congif.TwilioConfig twilioConfig;

    // ✅ Constructor-based dependency injection
    @Autowired
    public SmsService(TwilioConfig twilioConfig) {
        this.twilioConfig = twilioConfig;
    }

    @PostConstruct
    public void initTwilio() {
        Twilio.init(twilioConfig.getAccountSid(), twilioConfig.getAuthToken());
        System.out.println("✅ Twilio initialized successfully!");
    }

    public String sendSms(String to, String body) {
        Message message = Message.creator(
                new PhoneNumber(to),
                new PhoneNumber(twilioConfig.getFromNumber()),
                body
        ).create();
        return "✅ SMS sent successfully with SID: " + message.getSid();
    }
    public String sendWhatsAppMessage(String to, String body) {
        Message message = Message.creator(
                new PhoneNumber(to),
                new PhoneNumber(twilioConfig.getFromWhataAppNumber()),                
                body
        ).create();
        return "✅ WhatsApp message sent successfully with SID: " + message.getSid();
    }
}