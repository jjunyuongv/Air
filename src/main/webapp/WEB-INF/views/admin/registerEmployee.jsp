<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>직원 계정 등록</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>직원 계정 등록</h2>

    <c:if test="${not empty successMessage}">
        <div class="success-message"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="error-message"><c:out value="${errorMessage}"/></div>
    </c:if>

    <form action="<c:url value="/admin/register-employee"/>" method="post">
        <div>
            <label for="id">직원 로그인 ID:</label>
            <input type="text" id="id" name="id" value="${user.id}" required />
        </div>
        <div>
            <label for="password">비밀번호:</label>
            <input type="password" id="password" name="password" required />
        </div>
        <div>
            <label for="username">이름:</label>
            <input type="text" id="username" name="username" value="${user.username}" required />
        </div>
        <div>
            <label for="employeeNumber">사원 번호:</label>
            <input type="text" id="employeeNumber" name="employeeNumber" value="${user.employeeNumber}" required />
        </div>
        <div>
            <label for="department">직원 소속:</label>
            <input type="text" id="department" name="department" value="${user.department}" />
        </div>
        <button type="submit">직원 등록</button>
    </form>
    <p><a href="<c:url value="/admin/dashboard"/>">관리자 대시보드로 돌아가기</a></p>
</body>
</html>