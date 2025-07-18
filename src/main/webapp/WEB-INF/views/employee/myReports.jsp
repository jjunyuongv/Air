<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>내 보고서 목록</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>내 보고서 목록</h2>

    <c:if test="${not empty successMessage}">
        <div class="success-message"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="error-message"><c:out value="${errorMessage}"/></div>
    </c:if>

    <p><a href="<c:url value="/employee/reports/create"/>">새 보고서 작성</a></p>

    <table class="report-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>제목</th>
                <th>종류</th>
                <th>작성일</th>
                <th>수정일</th>
                <th>액션</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="report" items="${reports}">
                <tr>
                    <td><c:out value="${report.id}"/></td>
                    <td><c:out value="${report.title}"/></td>
                    <td><c:out value="${report.reportType}"/></td>
                    <td><c:out value="${report.createdAt}"/></td>
                    <td><c:out value="${report.updatedAt}"/></td>
                    <td class="report-actions">
                        <a href="<c:url value="/employee/reports/view?id=${report.id}"/>">열람</a> 
                        <a href="<c:url value="/employee/reports/edit?id=${report.id}"/>">수정</a>
                        <form action="<c:url value="/employee/reports/delete"/>" method="post" onsubmit="return confirm('정말로 이 보고서를 삭제하시겠습니까?');">
                            <input type="hidden" name="id" value="<c:out value="${report.id}"/>"/>
                            <button type="submit" class="delete-btn">삭제</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty reports}">
                <tr>
                    <td colspan="6">작성된 보고서가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <p><a href="<c:url value="/employee/dashboard"/>">직원 대시보드로 돌아가기</a></p>
</body>
</html>