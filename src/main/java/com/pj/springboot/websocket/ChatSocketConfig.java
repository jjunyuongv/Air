package com.pj.springboot.websocket;

//준영


import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSocket
@RequiredArgsConstructor
public class ChatSocketConfig implements WebSocketConfigurer
{
	private final ChatHandler  webSocketHandler;

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry)
	{
		registry.addHandler(webSocketHandler, "/myChatServer")
			.setAllowedOrigins("*")
			.withSockJS();
		
		System.out.println("WebSocket handler registered at /myChatServer");
	}
}
