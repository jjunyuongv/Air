<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <div class="container">
        <h2>로그인</h2>

        <div class="welcome-message">
            <p>로그인 페이지에 로그인하고 직원 또는 관리자 계정으로 로그인하여 해당 대시보드에 접속하세요.</p>
        </div>

        <c:if test="${not empty sessionScope.loginError}">
            <div class="error-message">
                <c:out value="${sessionScope.loginError}"/>
            </div>
            <c:remove var="loginError" scope="session"/>
        </c:if>

        <c:if test="${not empty param.logout}">
            <div class="success-message">
                로그아웃되었습니다.
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <form action="<c:url value="/login"/>" method="post">
            <div class="input-group">
                <label for="id">아이디:</label>
                <input type="text" id="id" name="username" required>
            </div>
            <div class="input-group">
                <label for="password">비밀번호:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit">로그인</button>
        </form>
    </div>
</body>
</html> 