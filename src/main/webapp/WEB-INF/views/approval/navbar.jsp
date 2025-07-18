<%@ page contentType="text/html;charset=UTF-8" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
<style>
body {
    background: linear-gradient(120deg, #e7f0fa 0%, #b4cbe8 100%);
    font-family: 'Segoe UI', 'Malgun Gothic', Arial, sans-serif;
}
.navbar-air {
    background: #144277;
    color: #fff;
    box-shadow: 0 2px 4px rgba(0,0,0,0.06);
}
.table-air th {
    background: #e3eefb;
}
.table-air tr:hover {
    background: #f1f7fc;
}
.btn-air {
    background: #226dc3;
    color: #fff;
    border-radius: 6px;
    transition: 0.15s;
}
.btn-air:hover {
    background: #144277;
    color: #fff;
}
</style>
<nav class="navbar navbar-air navbar-expand-lg mb-4">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/approval/list">
      ✈ AIR CREW 전자결재
    </a>
    <div class="d-flex">
      <span class="me-3">
        <i class="bi bi-person-circle"></i>
        <c:choose>
          <c:when test="${not empty sessionScope.username}">
            ${sessionScope.username} 님
          </c:when>
          <c:otherwise>
            Guest
          </c:otherwise>
        </c:choose>
      </span>
    </div>
  </div>
</nav>
