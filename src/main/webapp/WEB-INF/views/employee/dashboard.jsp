<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <title>직원 대시보드</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
    <style>
        /* 간단한 홈 버튼 색상(필요 시 style.css로 이동) */
        .home-btn {
            display:inline-block; margin:0 0 20px 0;           /* 제목 밑 여백 */
            padding:8px 18px; border:none; border-radius:6px;
            background:#1976d2; color:#fff; font-weight:600;
            text-decoration:none; transition:.25s;
        }
        .home-btn:hover { background:#1565c0; }
    </style>
</head>
<body>
    <!-- 홈으로 버튼 -->
    <a href="<c:url value='/'/>" class="home-btn">홈으로</a>
    <h2>직원 대시보드</h2>
    <p>환영합니다, <sec:authentication property="principal.username"/>!</p>

    <h3>직원 기능</h3>
    <ul>
        <li><a href="<c:url value="/employee/reports/create"/>">새 보고서 작성</a></li>
        <li><a href="<c:url value="/employee/reports/my-reports"/>">내 모든 보고서 목록</a></li>
        <li><a href="<c:url value="/employee/reports/my-reports/daily-weekly-safety"/>">내 일일/주간 안전 리포트</a></li>
        <li><a href="<c:url value="/employee/reports/my-reports/aircraft-anomaly"/>">내 항공기 이상 보고서</a></li>
        <li><a href="<c:url value="/employee/reports/my-reports/flight-ground-status"/>">내 운항/지상 상황 보고</a></li> 
    </ul>

    <form action="<c:url value="/logout"/>" method="post">
        <button type="submit">로그아웃</button>
    </form>
</body>
</html>