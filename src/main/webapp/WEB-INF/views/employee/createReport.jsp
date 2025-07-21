<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>새 보고서 작성</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>새 보고서 작성</h2>

    <c:if test="${not empty successMessage}">
        <div class="success-message"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="error-message"><c:out value="${errorMessage}"/></div>
    </c:if>

    <form action="<c:url value="/employee/reports/create"/>" method="post">
        <div>
            <label for="reportType">보고서 종류:</label>
            <select id="reportType" name="reportType" required>
                <option value="">선택하세요</option>
                <c:forEach var="typeArray" items="${reportTypes}">
                    <option value="<c:out value="${typeArray[0]}"/>"><c:out value="${typeArray[1]}"/></option>
                </c:forEach>
            </select>
        </div>
        <div>
            <label for="title">제목:</label>
            <input type="text" id="title" name="title" value="${report.title}" required />
        </div>
        <div>
            <label for="content">내용:</label>
            <textarea id="content" name="content" rows="10" required><c:out value="${report.content}"/></textarea>
        </div>
        <button type="submit">보고서 작성</button>
    </form>
    <p><a href="<c:url value="/employee/reports/my-reports"/>">내 보고서 목록으로 돌아가기</a></p>
</body>
</html>