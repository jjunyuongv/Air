<!-- 현석 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
<head>
    <title>사용자 관리</title>
    <link rel="stylesheet" href="<c:url value="/css/style.css"/>">
</head>
<body>
    <h2>사용자 관리</h2>

    <c:if test="${not empty successMessage}">
        <div class="success-message"><c:out value="${successMessage}"/></div>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <div class="error-message"><c:out value="${errorMessage}"/></div>
    </c:if>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>이름</th>
                <th>사원 번호</th>
                <th>소속</th>
                <th>역할</th>
                <th>활성화</th>
                <th>액션</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="user" items="${users}">
                <tr>
                    <td><c:out value="${user.id}"/></td>
                    <td><c:out value="${user.username}"/></td>
                    <td><c:out value="${user.employeeNumber}"/></td>
                    <td><c:out value="${user.department}"/></td>
                    <td>
                        <c:forEach var="role" items="${user.roles}" varStatus="loop">
                            <span class="user-roles"><c:out value="${role.roleName}"/></span><c:if test="${!loop.last}">, </c:if>
                        </c:forEach>
                    </td>
                    <td>
                        <span class="enabled-status ${user.enabled ? 'enabled-true' : 'enabled-false'}">
                            <c:out value="${user.enabled ? '활성화' : '비활성화'}"/>
                        </span>
                    </td>
                    <td class="action-buttons">
                        <c:set var="isAdminUser" value="false"/>
                        <c:forEach var="role" items="${user.roles}">
                            <c:if test="${role.roleName eq 'ROLE_ADMIN'}">
                                <c:set var="isAdminUser" value="true"/>
                            </c:if>
                        </c:forEach>

                        <c:if test="${!isAdminUser}">
                            <a href="<c:url value="/admin/edit-user?id=${user.id}"/>">수정</a>
                            <form action="<c:url value="/admin/delete-user"/>" method="post" onsubmit="return confirm('정말로 이 사용자를 삭제하시겠습니까?');">
                                <input type="hidden" name="id" value="<c:out value="${user.id}"/>"/>
                                <button type="submit">삭제</button>
                            </form>
                        </c:if>
                        <c:if test="${isAdminUser}">
                            <span class="no-action">관리자 계정</span>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty users}">
                <tr>
                    <td colspan="7">등록된 사용자가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <p><a href="<c:url value="/admin/dashboard"/>">관리자 대시보드로 돌아가기</a></p>
</body>
</html>