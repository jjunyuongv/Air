<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>새 결재 작성</title>
</head>
<body>
<jsp:include page="navbar.jsp"/>
<div class="container mt-4">
  <h4 class="fw-bold mb-3"><i class="bi bi-pencil-square me-2"></i>새 결재 작성</h4>
  <form action="${pageContext.request.contextPath}/approval/form" method="post" class="card p-4 shadow-sm" style="max-width:700px;">
    <div class="mb-3">
      <label class="form-label fw-bold">제목</label>
      <input type="text" name="title" required class="form-control"/>
    </div>
    <div class="mb-3">
      <label class="form-label fw-bold">카테고리</label>
      <select name="category" required class="form-select">
        <option value="">선택</option>
        <option value="정비 승인">정비 승인</option>
        <option value="휴가/근무 변경">휴가/근무 변경</option>
        <option value="긴급 운항 변경">긴급 운항 변경</option>
      </select>
    </div>
    <div class="mb-3">
      <label class="form-label fw-bold">내용</label>
      <textarea name="content" rows="7" class="form-control" required></textarea>
    </div>
    <!-- 버튼: 동일 크기/길이, 3~4px 간격 -->
    <div class="d-flex gap-1 mt-3">
      <button type="submit" class="btn btn-air flex-fill" style="min-width:120px; height:44px;">저장</button>
      <a href="${pageContext.request.contextPath}/approval/list" class="btn btn-secondary flex-fill" style="min-width:120px; height:44px;">취소</a>
    </div>
  </form>
</div>
</body>
</html>
