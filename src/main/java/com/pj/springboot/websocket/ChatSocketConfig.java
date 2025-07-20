package com.pj.springboot.websocket;


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

	/*
		웹소켓에 접속할 수 있는 요청URL을 생성한다. 우리는 
		ws://localhost:포트번호/myChatServer 로 접속하면 된다. 
		웹소켓 사용시에는 http가 아니라 ws로 접속해야한다. 
	 */
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry)
	{
		registry.addHandler(webSocketHandler, "/myChatServer")
			.setAllowedOrigins("*")
			.withSockJS();
		
		System.out.println("WebSocket handler registered at /myChatServer");
		/*
	        접속시 허용할 도메인 혹은 IP주소를 지정한다. 우리는 학습용이므로
	        모든 주소를 허용해준다. 실제 서비스용으로 개발시에는 *로 지정하면 
	        위험할 수 있으므로 주의해야한다. 
	     */
	}
}
