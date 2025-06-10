package com.example.demo.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import com.example.demo.dto.NotificationMessage;

@Controller
public class NotificationController {
	
	private final SimpMessagingTemplate template;
	
	public NotificationController(SimpMessagingTemplate template) {
		this.template = template;
	}
	
	@MessageMapping("/send")
	public void send(NotificationMessage message) {
		template.convertAndSend("/sub/" + message.getRecipient(), message.getContent());
	}
}