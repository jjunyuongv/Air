<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자결재 ‑ 문서 수정</title>

    <!-- 기본 스타일: 필요시 교체 -->
    <link rel="stylesheet" href="<c:url value='/css/edit.css'/>">

    <script>
    /* 클라이언트 유효성 검사 */
    function validateForm(f) {
        if (f.category.value.trim() === "") {
            alert("문서 유형을 입력하세요.");
            f.category.focus();
            return false;
        }
        if (f.title.value.trim() === "") {
            alert("제목을 입력하세요.");
            f.title.focus();
            return false;
        }
        if (f.content.value.trim() === "") {
            alert("내용을 입력하세요.");
            f.content.focus();
            return false;
        }
        return true;
    }
    </script>
</head>

<body>
<h2>전자결재 ‑ 문서 수정</h2>

<form name="writeFrm"
      method="post"
      action="<c:url value='/approval/edit'/>"
      onsubmit="return validateForm(this);">

    <!-- PK -->
    <input type="hidden" name="approvalNo" value="${approval.approvalNo}" />

    <table border="1" width="90%">
        <tr>
            <td width="15%">작성자</td>
            <td width="85%">
                <input type="text" name="draftUserId"
                       value="${approval.draftUserId}" readonly />
            </td>
        </tr>
        <tr>
            <td>문서 유형</td>
            <td>
                <input type="text" name="category"
                       value="${approval.category}" />
            </td>
        </tr>
        <tr>
            <td>제목</td>
            <td>
                <input type="text" name="title"
                       value="${approval.title}" style="width:80%;" />
            </td>
        </tr>
        <tr>
            <td>내용</td>
            <td>
                <textarea name="content" rows="10" style="width:80%;">${approval.content}</textarea>
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <button type="submit">수정 완료</button>
                <button type="reset">RESET</button>
                <button type="button"
                        onclick="location.href='${ctx}/approval/view?approvalNo=${approval.approvalNo}';">
                    돌아가기
                </button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
