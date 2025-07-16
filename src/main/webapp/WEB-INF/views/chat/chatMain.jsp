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
		<style>
			body {
				font-family: 'Inter', sans-serif;
				background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
				min-height: 100vh;
				display: flex;
				align-items: center;
				justify-content: center;
			}
			
			.chat-welcome-card {
				background: rgba(255, 255, 255, 0.95);
				backdrop-filter: blur(10px);
				border-radius: 20px;
				box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
				padding: 3rem;
				text-align: center;
				max-width: 500px;
				width: 100%;
				margin: 2rem;
			}
			
			.chat-icon {
				font-size: 4rem;
				color: #667eea;
				margin-bottom: 1.5rem;
			}
			
			.welcome-title {
				color: #2d3748;
				font-weight: 700;
				margin-bottom: 0.5rem;
			}
			
			.welcome-subtitle {
				color: #718096;
				margin-bottom: 2rem;
			}
			
			.form-floating {
				margin-bottom: 1.5rem;
			}
			
			.btn-chat-join {
				background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
				border: none;
				border-radius: 50px;
				padding: 0.75rem 2rem;
				font-weight: 600;
				transition: all 0.3s ease;
				width: 100%;
			}
			
			.btn-chat-join:hover {
				transform: translateY(-2px);
				box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
			}
			
			.features {
				margin-top: 2rem;
				display: grid;
				grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
				gap: 1rem;
			}
			
			.feature-item {
				text-align: center;
				padding: 1rem;
				border-radius: 10px;
				background: rgba(102, 126, 234, 0.1);
			}
			
			.feature-icon {
				font-size: 1.5rem;
				color: #667eea;
				margin-bottom: 0.5rem;
			}
			
			.feature-text {
				font-size: 0.875rem;
				color: #4a5568;
				font-weight: 500;
			}
			
			@media (max-width: 576px) {
				.chat-welcome-card {
					margin: 1rem;
					padding: 2rem;
				}
				
				.chat-icon {
					font-size: 3rem;
				}
			}
		</style>
	</head>
	<body>
		<div class="chat-welcome-card">
			<div class="chat-icon">
				<i class="bi bi-chat-dots"></i>
			</div>
			
			<h1 class="welcome-title">Chat</h1>
			<p class="welcome-subtitle">실시간 채팅으로 여행 이야기를 나누어보세요</p>
			
			<form id="chatForm">
				<div class="form-floating">
					<input type="text" class="form-control" id="chatId" placeholder="대화명을 입력하세요" required>
					<label for="chatId">대화명</label>
				</div>
				
				<button type="button" class="btn btn-primary btn-chat-join" onclick="chatWinOpen()">
					<i class="bi bi-arrow-right-circle me-2"></i>
					채팅 참여하기
				</button>
			</form>
			
			<div class="features">
				<div class="feature-item">
					<div class="feature-icon">
						<i class="bi bi-lightning-charge"></i>
					</div>
					<div class="feature-text">실시간</div>
				</div>
				<div class="feature-item">
					<div class="feature-icon">
						<i class="bi bi-shield-check"></i>
					</div>
					<div class="feature-text">안전한</div>
				</div>
				<div class="feature-item">
					<div class="feature-icon">
						<i class="bi bi-people"></i>
					</div>
					<div class="feature-text">소통</div>
				</div>
			</div>
		</div>

		<!-- Bootstrap JS -->
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/js/bootstrap.bundle.min.js"></script>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
		
		<script>
		function chatWinOpen() {
			//채팅대화명이 입력된 상자의 DOM을 얻어온 후..
			var id = document.getElementById("chatId");
			//입력된 대화명이 있는지 확인 
			if (id.value.trim() == ""){
				// Bootstrap alert 대신 custom alert 사용
				showAlert("대화명을 입력해주세요.", "warning");
				id.focus();
				return;
			}
			//채팅창을 팝업으로 오픈한다. 이때 대화명을 파라미터로 전달한다. 
			var chatWindow = window.open(
				"/chat/chatWindow.do?chatId=" + encodeURIComponent(id.value), 
				"chatWindow", 
				"width=400, height=600, scrollbars=yes, resizable=yes"
			);
			//다음 창을 띄울 수 있도록 기존 입력값을 삭제한다. 
			id.value = "";
		}
		
		// Enter 키로 채팅 참여
		document.getElementById("chatId").addEventListener("keypress", function(event) {
			if (event.key === "Enter") {
				event.preventDefault();
				chatWinOpen();
			}
		});
		
		// Custom alert function
		function showAlert(message, type) {
			const alertDiv = document.createElement("div");
			alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
			alertDiv.style.cssText = "top: 20px; right: 20px; z-index: 9999; min-width: 300px;";
			alertDiv.innerHTML = `
				${message}
				<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
			`;
			
			document.body.appendChild(alertDiv);
			
			// 3초 후 자동 제거
			setTimeout(() => {
				if (alertDiv.parentNode) {
					alertDiv.remove();
				}
			}, 3000);
		}
		</script>
	</body>
</html>