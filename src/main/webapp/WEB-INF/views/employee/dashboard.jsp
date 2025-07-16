<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <title>직원 대시보드</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>직원 대시보드</h2>
    <%-- 현재 로그인한 사용자의 ID 표시 --%>
    <p>환영합니다, <sec:authentication property="principal.username"/>!</p>

    <h3>직원 기능</h3>
    <ul>
        <li><a href="#">내 정보 보기 (TODO)</a></li> <%-- 추후 구현 --%>
        <li><a href="#">근무 스케줄 (TODO)</a></li> <%-- 추후 구현 --%>
        <li><a href="#">요청사항 관리 (TODO)</a></li> <%-- 추후 구현 --%>
    </ul>

    <form action="<c:url value="/logout"/>" method="post">
        <button type="submit">로그아웃</button>
    </form>
</body>
</html>