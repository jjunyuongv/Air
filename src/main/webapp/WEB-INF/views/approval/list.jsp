<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자결재 ‑ 문서보관함</title>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        th, td { text-align:center; }
        td:first-child { width:6%; }
        td:nth-child(2) { text-align:left; }
    </style>
</head>

<body class="p-4">

<h2>전자결재</h2>

<!-- ▼ 검색 폼 -->
<form method="get" action="${ctx}/approval/list" class="mb-3 d-flex">
    <select name="searchField" class="form-select w-auto me-2">
        <option value="APPROVAL_NO">번호</option>
        <option value="TITLE">제목</option>
        <option value="CATEGORY">유형</option>
        <option value="DRAFT_USER_ID">작성자</option>
        <option value="CREATED_AT">작성일</option>
    </select>
    <input type="text" name="searchKeyword" class="form-control me-2" style="max-width:260px;">
    <button class="btn btn-primary">검색하기</button>
</form>
<!-- ▲ 검색 폼 -->

<!-- ▼ 목록 테이블 -->
<table class="table table-hover">
    <thead class="table-light">
    <tr>
        <th>번호</th><th>제목</th><th>유형</th><th>작성자</th><th>작성일</th>
        <th>상태</th><th>작업</th>
    </tr>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty lists}">
            <tr><td colspan="7">등록된 문서가 없습니다.</td></tr>
        </c:when>
        <c:otherwise>
            <c:forEach items="${lists}" var="row" varStatus="loop">
                <tr>
                    <td>
                        <c:set var="vNum"
                               value="${maps.totalCount - (((maps.pageNum-1)*maps.pageSize)+loop.index)}"/>
                        ${vNum}
                    </td>
                    <td>
                        <a href="${ctx}/approval/view?approvalNo=${row.approvalNo}">
                            ${row.title}
                        </a>
                    </td>
                    <td>${row.category}</td>
                    <td>${row.draftUserId}</td>
                    <td>${row.createdAt}</td>
                    <td>
                        <span class="badge
                            <c:choose>
                                <c:when test='${row.status eq "APPROVED"}'>bg-success</c:when>
                                <c:when test='${row.status eq "REJECTED"}'>bg-danger</c:when>
                                <c:otherwise>bg-secondary</c:otherwise>
                            </c:choose>">
                            ${row.status}
                        </span>
                    </td>
                    <td>
                        <c:if test='${row.status eq "DRAFT"}'>
                            <form action="${ctx}/approval/approve" method="post" style="display:inline;">
                                <input type="hidden" name="approvalNo" value="${row.approvalNo}">
                                <button class="btn btn-success btn-sm">승인</button>
                            </form>
                            <form action="${ctx}/approval/reject" method="post" style="display:inline;">
                                <input type="hidden" name="approvalNo" value="${row.approvalNo}">
                                <button class="btn btn-danger btn-sm">반려</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
    </tbody>
</table>
<!-- ▲ 목록 테이블 -->

<!-- ▼ 페이징 & 버튼 -->
<div class="d-flex justify-content-between align-items-center mt-3">
    <div>${pagingImg}</div>

    <div>
        <!-- 홈으로 가기 -->
        <button class="btn btn-outline-secondary me-2"
                onclick="location.href='${ctx}/';">
            홈으로
        </button>

        <!-- 글쓰기 -->
        <button class="btn btn-outline-primary"
                onclick="location.href='${ctx}/approval/write';">
            글쓰기
        </button>
    </div>
</div>
<!-- ▲ 페이징 & 버튼 -->

</body>
</html>
