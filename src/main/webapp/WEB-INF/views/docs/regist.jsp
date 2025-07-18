<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>회원등록</title>
	</head>
	<body>
		<h2>회원등록</h2>
		<form action="regist.do" method="post">
		<table border="1">
			<tr>
				<td>아이디</td>
				<td><input type="text" name="id" value="" /></td>
			</tr>
			<tr>
				<td>패스워드</td>
				<td><input type="text" name="pass" value="" /></td>
			</tr>
			<tr>
				<td>이름</td>
				<td><input type="text" name="name" value="" /></td>
			</tr>
		</table>
		<input type="submit" value="전송하기" />
		</form>
	</body>
</html>