<!-- 준영 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <title>전자결재 문서 작성</title>
	
	    <link rel="stylesheet" href='<c:url value="/css/write.css"/>' />
	
	    <script>
	    function validateForm(frm) {
	        if (frm.draftUserId.value.trim() === '') {
	            alert('작성자를 입력하세요.');
	            frm.draftUserId.focus(); return false;
	        }
	        if (frm.category.value.trim() === '') {
	            alert('문서 유형을 선택하세요.');
	            frm.category.focus(); return false;
	        }
	        if (frm.title.value.trim() === '') {
	            alert('제목을 입력하세요.');
	            frm.title.focus(); return false;
	        }
	        if (frm.content.value.trim() === '') {
	            alert('내용을 입력하세요.');
	            frm.content.focus(); return false;
	        }
	        return true;
	    }
	    </script>
	</head>
	
	<body>
	<h2>전자결재 ‑ 문서 작성</h2>
	
	<form name="writeFrm"
	      method="post"
	      action="${ctx}/approval/write"
	      onsubmit="return validateForm(this);">
	
	    <table border="1" width="90%">
	        <tr>
	            <td>작성자</td>
	            <td><input type="text" name="draftUserId" style="width:100%;"/></td>
	        </tr>
	
	        <tr>
	            <td>문서 유형</td>
	            <td>
	                <select name="category" style="width:200px;">
	                    <option value="">-- 선택하세요 --</option>
	                    <option value="정비 승인">정비 승인</option>
	                    <option value="휴가/근무 변경">휴가/근무 변경</option>
	                    <option value="긴급 운항 변경">긴급 운항 변경</option>
	                </select>
	            </td>
	        </tr>
	
	        <tr>
	            <td>제목</td>
	            <td><input type="text" name="title" style="width:100%;"/></td>
	        </tr>
	
	        <tr>
	            <td>내용</td>
	            <td><textarea name="content" style="width:100%;height:120px;"></textarea></td>
	        </tr>
	
	        <tr>
	            <td colspan="2" align="center">
	                <button type="submit">작성 완료</button>
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
