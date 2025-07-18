<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>결재 상세</title>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="container mt-4">
  <h4 class="fw-bold mb-3">
    <i class="bi bi-file-earmark-text me-2"></i>결재 상세
  </h4>
  <!-- ...중간 상세 정보 테이블 생략... -->

  <!-- 결재선 표시 -->
  <h5 class="fw-bold">결재선</h5>
  <table class="table table-sm table-air mb-4">
    <thead>
      <tr>
        <th>순번</th>
        <th>결재자</th>
        <th>결정</th>
        <th>결정일</th>
        <th>의견</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="line" items="${approvalLines}">
        <tr>
          <td>${line.stepOrder}</td>
          <td><c:out value="${line.approver.username}"/></td>
          <td>
            <c:choose>
              <c:when test="${line.decision eq 'APPROVED'}"><span class="badge bg-success">승인</span></c:when>
              <c:when test="${line.decision eq 'REJECTED'}"><span class="badge bg-danger">반려</span></c:when>
              <c:otherwise><span class="badge bg-secondary">대기</span></c:otherwise>
            </c:choose>
          </td>
          <td>
            <c:if test="${not empty line.decidedAt}">
              <fmt:formatDate value="${line.decidedAt}" pattern="yyyy-MM-dd HH:mm"/>
            </c:if>
          </td>
          <td><c:out value="${line.opinion}"/></td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <!-- 승인/반려 버튼: 관리자+결재자 차례일 때만 노출 -->
  <c:if test="${userId eq 'admin' and isMyTurn}">
    <form action="${pageContext.request.contextPath}/approval/${approval.approvalNo}/approve" method="post" style="display:inline;">
      <button type="submit" class="btn btn-success btn-sm">승인</button>
    </form>
    <form action="${pageContext.request.contextPath}/approval/${approval.approvalNo}/reject" method="post" style="display:inline;">
      <input type="text" name="opinion" placeholder="반려 사유" required style="width:160px;"/>
      <button type="submit" class="btn btn-danger btn-sm">반려</button>
    </form>
  </c:if>

  <a href="${pageContext.request.contextPath}/approval/list" class="btn btn-secondary mt-3">목록으로</a>
</div>
</body>
</html>
