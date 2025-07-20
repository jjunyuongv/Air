<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 등록</title>

    <link rel="stylesheet" href='<c:url value="/css/write.css"/>' />
</head>

<body>
<h2>회원 등록</h2>

<!-- ★ action → /admin/register-employee -->
<form action="${ctx}/admin/register-employee" method="post">
    <table border="1">
        <tr>
            <td>아이디</td>
            <td><input type="text" name="id" style="width:200px;" /></td>
        </tr>
        <tr>
            <td>패스워드</td>
            <td><input type="password" name="password" style="width:200px;" /></td>
        </tr>
        <tr>
            <td>이름</td>
            <td><input type="text" name="username" style="width:200px;" /></td>
        </tr>
    </table>
    <button type="submit">등록하기</button>
</form>
</body>
</html>
