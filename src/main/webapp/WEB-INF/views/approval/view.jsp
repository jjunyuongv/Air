<!-- 준영 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<c:set var="ctx" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
	<head>
	    <meta charset="UTF-8">
	    <title>전자결재 내용 보기</title>
	
	    <link rel="stylesheet" href='<c:url value="/css/view.css"/>' />
	
	    <script>
	    function deleteApproval(no) {
	        if (confirm("정말로 삭제하시겠습니까?")) {
	            const form = document.delFrm;
	            form.approvalNo.value = no;
	            form.submit();
	        }
	    }
	    </script>
	</head>
	
	<body>
	<h2>전자결재 ‑ 문서 내용</h2>
	
	<form name="delFrm" method="post" action="${ctx}/approval/delete">
	    <input type="hidden" name="approvalNo"/>
	</form>
	
	<table border="1" width="90%">
	    <colgroup>
	        <col width="15%"/>
	        <col width="35%"/>
	        <col width="15%"/>
	        <col width="35%"/>
	    </colgroup>
	
	    <tr>
	        <td>번호</td>      <td>${approval.approvalNo}</td>
	        <td>작성자</td>    <td>${approval.draftUserId}</td>
	    </tr>
	    <tr>
	        <td>작성일</td>    <td>${approval.createdAt}</td>
	        <td>완료일</td>    <td>${approval.completedAt}</td>
	    </tr>
	    <tr>
	        <td>문서 유형</td> <td>${approval.category}</td>
	        <td>결재 상태</td> <td>${approval.status}</td>
	    </tr>
	
	    <tr>
	        <td>제목</td>
	        <td colspan="3">${approval.title}</td>
	    </tr>
	    <tr>
	        <td align="center">내용</td>
	        <td colspan="3" style="height:120px;">
	            <c:out value="${approval.content}" escapeXml="false"/>
	        </td>
	    </tr>
	
	    <tr>
	        <td colspan="4" align="center">
	            <button type="button"
	                    onclick="location.href='${ctx}/approval/edit?approvalNo=${approval.approvalNo}';">
	                수정하기
	            </button>
	            <button type="button" onclick="deleteApproval(${approval.approvalNo});">
	                삭제하기
	            </button>
	            <button type="button" onclick="location.href='${ctx}/approval/list';">
	                목록 바로가기
	            </button>
	        </td>
	    </tr>
	</table>
	</body>
</html>
