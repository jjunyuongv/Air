package com.pj.springboot.websocket;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ChatController {

    /** 채팅 메인(대화명 입력 페이지) */
    @GetMapping("/chatMain")
    public String chatMain() {
        return "chat/chatMain";          // /WEB-INF/views/chat/chatMain.jsp
    }

    /** 실제 채팅창 팝업 */
    @GetMapping("/chat/chatWindow.do")
    public String chatWindow(@RequestParam String chatId, Model model) {
        model.addAttribute("chatId", chatId);   // 뷰에 넘김
        return "chat/chatWindow";               // /WEB-INF/views/chat/chatWindow.jsp
    }
}
