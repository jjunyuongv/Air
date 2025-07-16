package com.pj.springboot.websocket;

import java.io.IOException;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class WebSocketHandler extends TextWebSocketHandler
{
	/*
	채팅을 위한 접속자의 정보를 저장하기 위해 Map형식의 컬렉션을 생성한다. 
 */
	private static final ConcurrentHashMap<String, WebSocketSession> CLIENTS = new ConcurrentHashMap<String, WebSocketSession>();
	
	/*
		클라이언트가 웹소켓 서버에 접속했을때 호출되는 메서드. 접속시
		WebSocketSession 값이 자동으로 생성되는데, 이 값을 멤버변수인
		CLIENTS에 저장한다. 
	 */
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception
	{
		/*
			Key값으로 웹소켓세션의 아이디를, Value로는 인스턴스 자체를 저장한다. 
		*/
		CLIENTS.put(session.getId(), session);
	}
	
	/*
		웹소켓 서버에서 클라이언트가 접속을 종료했을때 호출되는 메서드.
		Map에서 해당 session값을 제거한다. 
	 */
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception
	{
		CLIENTS.remove(session.getId());
	}
	
	/*
		클라이언트가 웹소켓 서버로 메세지를 보내면 호출되는 메서드. Map에
		저장된 클라이언트의 수만큼 반복한다. 이때 발신자를 제외한 나머지
		클라이언트에게만 메세지를 보내준다. 
	 */
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception
	{
		//메세지를 보낸 사용자의 웹소켓세션 아이디를 얻어온다.
		String id = session.getId();
		String receivedMessage = message.getPayload();
		
		System.out.println("Received message: " + receivedMessage);
		
		//Map에 저장된 클라이언트의 수만큼 반복한다. 
		CLIENTS.entrySet().forEach( arg -> {
			/*
	    	메세지를 보낸 아이디를 제외한 나머지 클라이언트에게만 메세지를
	    	전송한다. 즉 받은 메세지를 그대로 Echo해준다. 
	    	 */
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
