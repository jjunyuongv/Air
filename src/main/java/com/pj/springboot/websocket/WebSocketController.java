package com.pj.springboot.websocket;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebSocketController
{
	 @GetMapping("/chatMain")
     public String chatMain() {
         return "chat/chatMain";
     }
}
