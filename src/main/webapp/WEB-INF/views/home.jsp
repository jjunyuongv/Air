<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>그룹웨어</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
  <style>
    body {
      background: linear-gradient(to bottom right, #e3f2fd, #ffffff);
      min-height: 100vh;
      display: flex; /* flexbox를 사용하여 본문 내용을 중앙에 배치하기 위함 */
      flex-direction: column; /* 세로 방향으로 정렬 */
    }
    .navbar-nav .nav-link {
      font-weight: 500;
      color: #1976d2 !important;
    }
    .navbar-brand {
      font-weight: bold;
      color: #0d47a1 !important;
    }
    .main-content { /* 본문 내용을 위한 스타일 */
      flex-grow: 1; /* 남은 공간을 모두 차지하도록 하여 중앙 정렬을 도움 */
      display: flex;
      justify-content: center; /* 수평 중앙 정렬 */
      align-items: center; /* 수직 중앙 정렬 */
      padding: 0px; /* 내부 여백 */
    }
    .main-logo { /* 이미지 스타일 */
      max-width: 100%; /* 이미지 최대 너비 */
      height: auto; /* 비율 유지 */
      display: block; /* margin: auto를 위해 블록 요소로 설정 */
      margin: 0 auto; /* 수평 중앙 정렬 */
      box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* 그림자 효과 */
      border-radius: 8px; /* 모서리 둥글게 */
    }
  </style>
</head>
<body>

  <nav class="navbar navbar-expand bg-white shadow-sm px-4">
    <a class="navbar-brand" href="/">
      ✈
    </a>
      <ul class="navbar-nav mx-auto d-flex flex-row">
        <li class="nav-item me-3"><a class="nav-link" href="/approval/list">전자결재시스템</a></li>
        <li class="nav-item me-3"><a class="nav-link" href="../list.do">문서보관소</a></li>
        <li class="nav-item me-3"><a class="nav-link" href="/admin/dashboard">업무보고시스템(관리자)</a></li>
        <li class="nav-item me-3"><a class="nav-link" href="/employee/dashboard">업무보고시스템</a></li>
        <li class="nav-item me-3"><a class="nav-link" href="/chatMain">커뮤니케이션기능</a></li>
        <li class="nav-item me-3"><a class="nav-link" href="/calendar">일정관리</a></li>
      </ul>
      <div class="d-flex">
        <a class="nav-link" href="/login">로그인/회원가입</a>
      </div>
  	</nav>
		<div class="main-content">
		    <img src="<c:url value='/image/Generated.png' />"
		         alt="그룹웨어 메인 로고" class="main-logo">
		</div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>