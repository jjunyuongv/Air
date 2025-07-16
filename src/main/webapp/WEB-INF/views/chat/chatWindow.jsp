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
		/*
		페이지가 로드되면 제일 먼저 웹소켓 객체를 생성한다. 이때 사용하는 주소는
		웹소켓 설정 클래스에서 지정한 요청명을 사용해야한다. 
		localhost(127.0.0.1)로 기술하면 내컴퓨터(ipconfig cmd창에서)에서만 테스트할 수 있고, 
		내부아이피를 사용하면 다른 사람이 내 컴퓨터로 접속할 수 있다. 
		 */
		var webSocket = new WebSocket("ws://192.168.0.25:8081/myChatServer");
		
		//채팅을 위한 전역변수 생성 
		var chatWindow, chatMessage, chatId;
		
		/* 채팅창이 열리면 대화창, 메세지입력상자, 대화명입력상자로 사용할 DOM을 
		얻어와서 전역변수에 저장한다 */
		window.onload = function(){
			chatWindow = document.getElementById("chatWindow");
			chatMessage = document.getElementById("chatMessage");
			chatId = document.getElementById("chatId").value;
		}
		
		//입력된 메세지를 서버로 전송할 때 호출
		function sendMessage() {
			//입력한 메세지를 대화창에 추가한다.
			chatWindow.innerHTML += "<div class='myMsg'>" + chatMessage.value + "</div>"
			//웹소켓 서버에 메세지를 전송. 형식은 '채팅대화명|메세지' 
			webSocket.send(chatId + '|' + chatMessage.value);
			//다음 메세지를 즉시 입력할 수 있도록 비워준다. 
			console.log(chatMessage);
			chatMessage.value = "";
			//대화창의 스크롤을 항상 제일 아래로 내려준다.
			chatWindow.scrollTop = chatWindow.scrollHeight;
			/*
		   	채팅창은 최신 대화내역이 아래에 위치하는 특성을 가지므로 스크롤이
		   	위쪽에 있다면 입력한 대화내용을 확인할 수 없다. 
		   	*/
		}
		
		//웹소켓 서버에서 접속종료 
		function disconnect() {
			webSocket.close();
		}
		
		//메세지 입력후 엔터키를 누르면 즉시 메세지 전송 
		function enterKey(){
			console.log("키 눌러짐", window.event.keyCode);
			//keyCode를 통해 입력한 키보드를 알아낸다. 
			if(window.event.keyCode == 13){
				sendMessage();
			}
		}
		
		//웹소켓 서버에 연결되었을때 이벤트 리스너를 통해 자동으로 호출 
		webSocket.onopen = function(event){
			chatWindow.innerHTML += "웹소켓 서버에 연결되었습니다.<br/>";
		};
		
		//웹소켓 서버가 종료되었을때..
		webSocket.onclose = function(event){
			chatWindow.innerHTML += "웹소켓 서버가 종료되었습니다.<br/>";
		};
		
		//웹소켓 서버에서 에러가 발생되었을때..
		webSocket.onerror = function(event){
			alert(event.data);
			chatWindow.innerHTML += "체팅 중 에러가 발생하였습니다.<br/>";
		};
		
		//웹소켓 서버가 메세지를 받았을때.. 
		webSocket.onmessage = function(event){
			//대화명과 메세지를 분리한다. 전송시 |(파이프)로 조립해서 보낸다.
			var message = event.data.split("|");
			//앞부분은 보낸사람의 대화명
			var sender = message[0];
			//뒷부분은 메세지 
			var content = message[1];
			//메세지가 빈값이 아닌 경우..
			if(content != ""){
				//메세지에 슬러쉬가 포함된 경우에는 명령어로 인식
				if(content.match("/")){
					/*
		        	귓속말의 경우 "/받는사람 보낼메세지"와 같이 작성된다. 
		        	따라서 받는사람의 아이디와 동일한 대화창에만 대화내용을 
		        	디스플레이한다. 
		        	*/
		        	if(content.match(("/" + chatId))) {
						var temp = content.replace(("/"+chatId), "[귓속말] : ");
						chatWindow.innerHTML += "<div>" + sender + temp + "</div>";
		        	}
				} else {
					//슬러쉬가 없다면 일반 메세지로 판단 
					chatWindow.innerHTML += "<div>" + sender + " : " + content + "</div>";
				}
			}
			//스크롤바를 제일 아래로 내려준다.
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
		<!-- Bootstrap JS -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
		
	</body>
</html>
