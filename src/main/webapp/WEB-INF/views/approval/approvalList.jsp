<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
    <title>전자결재 목록</title>
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"/>
    <style>
        body { background: #f8fafc; font-family: 'Pretendard', 'Malgun Gothic', Arial, sans-serif; }
        .container { margin-top: 40px; }
        .table { border-radius: 15px; background: #fff; }
        .table th { background: #e3e7ef; font-weight: bold; }
        .table td, .table th { vertical-align: middle !important; }
        .title-link { color: #1d3557; text-decoration: none; font-weight: 500; }
        .title-link:hover { color: #457b9d; text-decoration: underline; }
    </style>
</head>
<body>
<div class="container">
    <h2 class="mb-4">전자결재 문서 목록</h2>
    <table class="table table-hover shadow-sm">
        <thead>
        <tr>
            <th scope="col">번호</th>
            <th scope="col">제목</th>
            <th scope="col">카테고리</th>
            <th scope="col">작성자</th>
            <th scope="col">상태</th>
            <th scope="col">작성일</th>
            <th scope="col">완료일</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="approval" items="${approvals}">
            <tr>
                <td>${approval.approvalNo}</td>
                <td>
                    <a class="title-link" href="<c:url value='/approval/${approval.approvalNo}'/>">
                        ${approval.title}
                    </a>
                </td>
                <td>${approval.category}</td>
                <td>${approval.draftUser != null ? approval.draftUser.username : ''}</td>
                <td>
                    <c:choose>
                        <c:when test="${approval.status eq 'DRAFT'}">임시저장</c:when>
                        <c:when test="${approval.status eq 'IN_PROGRESS'}">결재중</c:when>
                        <c:when test="${approval.status eq 'APPROVED'}">승인</c:when>
                        <c:when test="${approval.status eq 'REJECTED'}">반려</c:when>
                        <c:otherwise>${approval.status}</c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <fmt:formatDate value="${approval.createdAt}" pattern="yyyy-MM-dd HH:mm"/>
                </td>
                <td>
                    <c:if test="${approval.completedAt != null}">
                        <fmt:formatDate value="${approval.completedAt}" pattern="yyyy-MM-dd HH:mm"/>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div class="text-end">
        <a href="<c:url value='/approval/form'/>" class="btn btn-primary">새 결재 작성</a>
    </div>
</div>
</body>
</html>
