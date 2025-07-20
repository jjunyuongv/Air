<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  

<%-- contextPath 한 번만 저장 --%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자결재 ‑ 문서보관함</title>

    <link rel="stylesheet" href='<c:url value="/css/list.css"/>' />
</head>

<body>
<h2>문서보관함</h2>

<!-- ★ 검색 폼 action → /approval/list -->
<form method="get" action="${ctx}/approval/list">
    <table width="90%">
        <tr>
            <td style="text-align:left;">
                <select name="searchField">
                    <option value="APPROVAL_NO">번호</option>
                    <option value="TITLE">제목</option>
                    <option value="CATEGORY">유형</option>
                    <option value="DRAFT_USER_ID">작성자</option>
                    <option value="CREATED_AT">작성일</option>
                </select>
                <input type="text" name="searchKeyword"/>
                <input type="submit" value="검색하기" class="search-button"/>
            </td>
        </tr>
    </table>
</form>

<table width="90%">
    <tr>
        <th width="10%">번호</th>
        <th width="*">제목</th>
        <th width="15%">유형</th>
        <th width="10%">작성자</th>
        <th width="15%">작성일</th>
    </tr>

    <c:choose>
        <c:when test="${empty lists}">
            <tr><td colspan="5" align="center">등록된 문서가 없습니다.</td></tr>
        </c:when>

        <c:otherwise>
            <c:forEach items="${lists}" var="row" varStatus="loop">
                <tr align="center">
                    <td>
                        <c:set var="vNum"
                               value="${maps.totalCount - (((maps.pageNum-1) * maps.pageSize) + loop.index)}"/>
                        ${vNum}
                    </td>

                    <td align="left">
                        <!-- ★ 상세보기 링크 → /approval/view -->
                        <a href="${ctx}/approval/view?approvalNo=${row.approvalNo}&vNum=${vNum}">
                            ${row.title}
                        </a>
                    </td>

                    <td>${row.category}</td>
                    <td>${row.draftUserId}</td>
                    <td>${row.createdAt}</td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</table>

<table width="90%" class="pagination-table">
    <tr>
        <td>${pagingImg}</td>
        <td style="text-align:right;">
            <!-- ★ 글쓰기 버튼 → /approval/write -->
            <button type="button"
                    onclick="location.href='${ctx}/approval/write';"
                    class="write-button">
                글쓰기
            </button>
        </td>
    </tr>
</table>
</body>
</html>
