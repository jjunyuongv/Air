<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <title>관리자 대시보드</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>관리자 대시보드</h2>
    <p>환영합니다, <sec:authentication property="principal.username"/>!</p>

    <h3>관리자 기능</h3>
    <ul>
        <li><a href="<c:url value="/admin/register-employee"/>">직원 계정 등록</a></li>
        <li><a href="<c:url value="/admin/manage-users"/>">사용자 관리</a></li>
        <li><a href="<c:url value="/admin/reports/all-reports"/>">모든 보고서 목록</a></li>
        <li><a href="<c:url value="/admin/reports/all-reports/daily-weekly-safety"/>">모든 일일/주간 안전 리포트</a></li>
        <li><a href="<c:url value="/admin/reports/all-reports/aircraft-anomaly"/>">모든 항공기 이상 보고서</a></li>
        <li><a href="<c:url value="/admin/reports/all-reports/flight-ground-status"/>">모든 운항/지상 상황 보고</a></li>
    </ul>

    <form action="<c:url value="/logout"/>" method="post">
        <button type="submit">로그아웃</button>
    </form>
</body>
</html>