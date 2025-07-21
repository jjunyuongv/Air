<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 수정</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>사용자 수정</h2>

    <c:if test="${not empty successMessage}">
        <div class="success-message"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="error-message"><c:out value="${errorMessage}"/></div>
    </c:if>

    <form action="<c:url value="/admin/update-user"/>" method="post">
        <div>
            <label for="id">직원 로그인 ID(수정 불가):</label>
            <input type="text" id="id" name="id" value="${user.id}" readonly />
        </div>
        <div>
            <label for="password">비밀번호 (변경 시 입력):</label>
            <input type="password" id="password" name="password" placeholder="비밀번호를 변경하려면 입력하세요" />
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
        <div>
            <label for="enabled">활성화:</label>
            <input type="checkbox" id="enabled" name="enabled" value="true" <c:if test="${user.enabled}">checked="checked"</c:if> />
        </div>
        <button type="submit">사용자 정보 업데이트</button>
    </form>
    <p><a href="<c:url value="/admin/manage-users"/>">사용자 관리로 돌아가기</a></p>
</body>
</html>