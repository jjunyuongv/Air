<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>접근 거부</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>접근 권한이 없습니다.</h2>
    <p>이 페이지에 접근할 권한이 없습니다. 필요한 경우 관리자에게 문의하세요.</p>
    <p><a href="<c:url value="/"/>">홈으로 돌아가기</a></p>
    <p><a href="<c:url value="/logout"/>">로그아웃</a></p>
</body>
</html>