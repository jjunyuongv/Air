package com.pj.springboot.websocket;

//준영
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ChatController {

    @GetMapping("/chatMain")
    public String chatMain() {
        return "chat/chatMain";          
    }

    @GetMapping("/chat/chatWindow.do")
    public String chatWindow(@RequestParam String chatId, Model model) {
        model.addAttribute("chatId", chatId); 
        return "chat/chatWindow";               
    }
}
