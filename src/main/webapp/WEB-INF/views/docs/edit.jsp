<!-- 혜원 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>전자결재 문서 수정</title>

    <link rel="stylesheet" href='<c:url value="/css/edit.css"/>' />

    <script>
    function validateForm(f) {
        if (f.draftUserId.value.trim() === '') {
            alert('작성자를 입력하세요.'); f.draftUserId.focus(); return false;
        }
        if (f.category.value.trim() === '') {
            alert('문서 유형을 선택하세요.'); f.category.focus(); return false;
        }
        if (f.title.value.trim() === '') {
            alert('제목을 입력하세요.'); f.title.focus(); return false;
        }
        if (f.content.value.trim() === '') {
            alert('내용을 입력하세요.'); f.content.focus(); return false;
        }
        return true;
    }
    </script>
</head>

<body>
<h2>전자결재 ‑ 문서 수정</h2>

<form name="editFrm"
      method="post"
      action="${ctx}/approval/edit"
      onsubmit="return validateForm(this);">

    <!-- 수정할 문서 PK -->
    <input type="hidden" name="approvalNo" value="${approval.approvalNo}" />

    <table border="1" width="90%">
        <tr>
            <td>작성자</td>
            <td><input type="text" name="draftUserId"
                       value="${approval.draftUserId}" style="width:100%;"/></td>
        </tr>

        <tr>
            <td>문서 유형</td>
            <td>
                <select name="category" style="width:200px;">
                    <option value="">-- 선택하세요 --</option>
                    <option value="정비 승인"
                            <c:if test="${approval.category eq '정비 승인'}">selected</c:if>>
                        정비 승인
                    </option>
                    <option value="휴가/근무 변경"
                            <c:if test="${approval.category eq '휴가/근무 변경'}">selected</c:if>>
                        휴가/근무 변경
                    </option>
                    <option value="긴급 운항 변경"
                            <c:if test="${approval.category eq '긴급 운항 변경'}">selected</c:if>>
                        긴급 운항 변경
                    </option>
                </select>
            </td>
        </tr>

        <tr>
            <td>제목</td>
            <td><input type="text" name="title"
                       value="${approval.title}" style="width:100%;"/></td>
        </tr>

        <tr>
            <td>내용</td>
            <td><textarea name="content"
                          style="width:100%;height:120px;">${approval.content}</textarea></td>
        </tr>

        <tr>
            <td colspan="2" align="center">
                <button type="submit">수정 완료</button>
                <button type="reset">RESET</button>
                <button type="button"
                        onclick="location.href='${ctx}/approval/list';">
                    목록 바로가기
                </button>
            </td>
        </tr>
    </table>
</form>
</body>
</html>
