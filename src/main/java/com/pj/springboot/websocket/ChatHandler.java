package com.pj.springboot.websocket;
//준영

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class ChatHandler extends TextWebSocketHandler
{

	private static final ConcurrentHashMap<String, WebSocketSession> CLIENTS = new ConcurrentHashMap<String, WebSocketSession>();
	
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception
	{
	
		CLIENTS.put(session.getId(), session);
	}
	

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception
	{
		CLIENTS.remove(session.getId());
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
	{
		String id = session.getId();
		String receivedMessage = message.getPayload();
		
		System.out.println("Received message: " + receivedMessage);
		
		CLIENTS.entrySet().forEach( arg -> {
			if (!arg.getKey().equals(id))
			{
				try
				{
					arg.getValue().sendMessage(new TextMessage(receivedMessage));
					System.out.println("Sent message to: " + arg.getKey());
				} catch (IOException e)
				{
					e.printStackTrace();
				}
			}
		});
	}
}
