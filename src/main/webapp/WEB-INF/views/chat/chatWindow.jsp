<!-- 준영 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>웹소켓 체팅</title>
		<!-- Bootstrap CSS -->
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet">
		<!-- Bootstrap Icons -->
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
		<!-- Google Fonts -->
		<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
		<script>
		var webSocket = new WebSocket("ws://192.168.0.25:8081/myChatServer");
		
		var chatWindow, chatMessage, chatId;
		
		window.onload = function(){
			chatWindow = document.getElementById("chatWindow");
			chatMessage = document.getElementById("chatMessage");
			chatId = document.getElementById("chatId").value;
		}
		
		function sendMessage() {
			chatWindow.innerHTML += "<div class='myMsg'>" + chatMessage.value + "</div>"
			webSocket.send(chatId + '|' + chatMessage.value);
			console.log(chatMessage);
			chatMessage.value = "";
			chatWindow.scrollTop = chatWindow.scrollHeight;
		}
		
		function disconnect() {
			webSocket.close();
		}
		
		function enterKey(){
			console.log("키 눌러짐", window.event.keyCode);
			if(window.event.keyCode == 13){
				sendMessage();
			}
		}
		
		webSocket.onopen = function(event){
			chatWindow.innerHTML += "웹소켓 서버에 연결되었습니다.<br/>";
		};
		
		webSocket.onclose = function(event){
			chatWindow.innerHTML += "웹소켓 서버가 종료되었습니다.<br/>";
		};
		
		webSocket.onerror = function(event){
			alert(event.data);
			chatWindow.innerHTML += "체팅 중 에러가 발생하였습니다.<br/>";
		};
		
		webSocket.onmessage = function(event){
			var message = event.data.split("|");
			var sender = message[0];
			var content = message[1];
			if(content != ""){
				if(content.match("/")){
		        	if(content.match(("/" + chatId))) {
						var temp = content.replace(("/"+chatId), "[귓속말] : ");
						chatWindow.innerHTML += "<div>" + sender + temp + "</div>";
		        	}
				} else {
					chatWindow.innerHTML += "<div>" + sender + " : " + content + "</div>";
				}
			}
			chatWindow.scrollTop = chatWindow.scrollHeight;
		};
		</script>
		<style>
		body {
			font-family: 'Inter', sans-serif;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			min-height: 100vh;
			margin: 0;
			display: flex;
			align-items: center;
			justify-content: center;
		}
		.chat-bootstrap-card {
			background: #fff;
			border-radius: 1.5rem;
			box-shadow: 0 8px 32px rgba(0,0,0,0.12);
			max-width: 400px;
			width: 100%;
			overflow: hidden;
			display: flex;
			flex-direction: column;
		}
		.chat-header {
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			color: #fff;
			padding: 1rem 1.5rem;
			display: flex;
			align-items: center;
			justify-content: space-between;
		}
		.chat-header .title {
			font-weight: 600;
			font-size: 1.2rem;
			display: flex;
			align-items: center;
			gap: 0.5rem;
		}
		.chat-header .user {
			font-size: 0.95rem;
			display: flex;
			align-items: center;
			gap: 0.5rem;
		}
		.chat-header .user i {
			font-size: 1.1rem;
		}
		.chat-header .btn {
			color: #fff;
			border: none;
			background: transparent;
			font-size: 1.2rem;
		}
		.chat-header .btn:hover {
			color: #ffd6e0;
		}
		#chatWindow {
			background: #f8f9fa;
			height: 350px;
			overflow-y: auto;
			padding: 1rem;
			border-bottom: 1px solid #e9ecef;
			font-size: 0.98rem;
			display: flex;
			flex-direction: column;
			gap: 0.3rem;
		}
		.myMsg {
			align-self: flex-end;
			text-align: right;
			color: #fff;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			display: inline-block;
			padding: 0.5rem 1rem;
			border-radius: 1rem 1rem 0.25rem 1rem;
			margin-bottom: 0.2rem;
			margin-left: 20%;
			margin-right: 0;
			max-width: 80%;
			word-break: break-all;
		}
		.otherMsg {
			align-self: flex-start;
			text-align: left;
			color: #333;
			background: #e2e3e5;
			display: inline-block;
			padding: 0.5rem 1rem;
			border-radius: 1rem 1rem 1rem 0.25rem;
			margin-bottom: 0.2rem;
			margin-right: 20%;
			margin-left: 0;
			max-width: 80%;
			word-break: break-all;
		}
		.systemMsg {
			text-align: center;
			color: #6c757d;
			background: #e9ecef;
			display: block;
			padding: 0.3rem 0.5rem;
			border-radius: 0.75rem;
			margin: 0.5rem auto;
			font-size: 0.92rem;
			width: fit-content;
		}
		.chat-input-area {
			background: #fff;
			padding: 1rem 1.5rem;
			display: flex;
			gap: 0.5rem;
			align-items: center;
		}
		#chatMessage {
			flex: 1;
			border-radius: 2rem;
			border: 1.5px solid #e9ecef;
			padding: 0.5rem 1rem;
			font-size: 1rem;
		}
		#sentBtn {
			border-radius: 50%;
			background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
			color: #fff;
			border: none;
			width: 44px;
			height: 44px;
			display: flex;
			align-items: center;
			justify-content: center;
			font-size: 1.3rem;
			transition: background 0.2s;
		}
		#sentBtn:hover {
			background: linear-gradient(135deg, #764ba2 0%, #667eea 100%);
		}
		#closeBtn {
			display: none;
		}
		@media (max-width: 500px) {
			.chat-bootstrap-card { max-width: 100vw; border-radius: 0; }
			.chat-header, .chat-input-area { padding: 0.7rem 0.7rem; }
		}
		</style>
	</head>
	<body>
		<div class="chat-bootstrap-card">
			<div class="chat-header">
				<span class="title">
					<i class="bi bi-chat-dots"></i>Chat
				</span>
				<span class="user">
					<i class="bi bi-person"></i>
					<span id="userName">${param.chatId}</span>
				</span>
				<button class="btn" onclick="disconnect()" title="채팅 종료">
					<i class="bi bi-x-lg"></i>
				</button>
			</div>
			<div id="chatWindow">
				<span class="systemMsg">
					<i class="bi bi-info-circle me-1"></i>채팅방에 입장했습니다. 즐거운 대화 되세요!
				</span>
			</div>
			<div class="chat-input-area">
				<input type="text" id="chatMessage" placeholder="메시지를 입력하세요..." onkeyup="enterKey()" autocomplete="off">
				<button id="sentBtn" onclick="sendMessage()"><i class="bi bi-send"></i></button>
			</div>
			<input type="hidden" id="chatId" value="${param.chatId}" />
		</div>
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
		
	</body>
</html>
