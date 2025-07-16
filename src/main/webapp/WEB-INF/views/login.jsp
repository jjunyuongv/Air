<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>로그인</h2>
    <%-- 로그인 실패 메시지 (Spring Security에서 'error' 파라미터 전달) --%>
    <c:if test="${param.error != null}">
        <p class="error-message">아이디 또는 비밀번호가 잘못되었습니다.</p>
    </c:if>
    <%-- 로그아웃 성공 메시지 (Spring Security에서 'logout' 파라미터 전달) --%>
    <c:if test="${param.logout != null}">
        <p class="success-message">로그아웃되었습니다.</p>
    </c:if>

    <form action="<c:url value="/login"/>" method="post">
        <div>
            <label for="username">아이디:</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div>
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required />
        </div>
        <button type="submit">로그인</button>
    </form>
    <p>직원 또는 관리자 계정으로 로그인하여 해당 대시보드에 접근하세요.</p>
</body>
</html>