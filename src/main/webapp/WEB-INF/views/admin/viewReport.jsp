<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>보고서 상세 열람 (관리자)</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <div class="report-detail-container">
        <h2>보고서 상세 열람 (관리자)</h2>

        <c:if test="${not empty errorMessage}">
            <div class="error-message"><c:out value="${errorMessage}"/></div>
        </c:if>

        <div class="report-info">
            <p><strong>제목:</strong> <c:out value="${report.title}"/></p>
            <p><strong>종류:</strong> <c:out value="${report.reportType}"/></p>
            <p><strong>작성자 ID:</strong> <c:out value="${report.authorId}"/></p>
            <p><strong>작성일:</strong> <c:out value="${report.createdAt}"/></p>
            <p><strong>수정일:</strong> <c:out value="${report.updatedAt}"/></p>
        </div>

        <h3>내용</h3>
        <div class="report-content">
            <c:out value="${report.content}"/>
        </div>

        <div class="back-link">
            <a href="<c:url value="/admin/reports/all-reports"/>">모든 보고서 목록으로 돌아가기</a>
        </div>
    </div>
</body>
</html>