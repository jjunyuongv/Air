<!-- 혜원 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>문서보관소</title>
		<link rel="stylesheet" href="<c:url value="/css/arch.css"/>">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	</head>
	<body>
		<div id="navArea">
			<nav class="navbar navbar-expand bg-white shadow-sm px-4">
				<a class="navbar-brand" href="/">
				    ✈
				</a>
				<ul class="navbar-nav mx-auto d-flex flex-row">
					<li class="nav-item me-3"><a class="nav-link" href="/approval/list">전자결재시스템</a></li>
					<li class="nav-item me-3"><a class="nav-link" href="/docs/dashboard.do">문서보관소</a></li>
					<li class="nav-item me-3"><a class="nav-link" href="/admin/dashboard">업무보고시스템(관리자)</a></li>
					<li class="nav-item me-3"><a class="nav-link" href="/employee/dashboard">업무보고시스템</a></li>
					<li class="nav-item me-3"><a class="nav-link" href="/chatMain">커뮤니케이션기능</a></li>
					<li class="nav-item me-3"><a class="nav-link" href="/calendar">일정관리</a></li>
				</ul>
			    <div class="d-flex">
			        <a class="nav-link" href='<c:url value="/login"/>'>로그인/회원가입</a>
			    </div>
			</nav>
		</div>
		<div id="titleArea">
			<h1>안전교육</h1>
		</div>
		<div id="dataArea">    
			<h2>${modelData.archTitle}</h2>
			<ul>
				<li>작성자</li>
				<li>${modelData.regUserId}</li>
				<li><span> | </span></li>
				<li style="margin: 3px;"></li>
				<li>등록일</li>
				<li>${modelData.regDt.substring(0,4)}-${modelData.regDt.substring(4,6)}-${modelData.regDt.substring(6,8)}</li>
			</ul>
			<div id="atchFileArea">
				<c:choose>
	            	<c:when test="${not empty modelData.fileId}">
		            	<form id="downloadForm" method="post" action="<c:url value="/docs/fileDownload.do"/>">
			            	<input type="hidden" name="fileId" value="${modelData.fileId}" />
			            	<input type="hidden" name="fileNm" value="${modelData.fileNm}" />
							<button type="submit" id="downloadBtn">
							    <i class="fa-solid fa-download" style="color: white;"></i>
							</button>
							<label id="atchFileAreaLabel" class="pointer" for="downloadBtn">${modelData.fileNm}</label>
						</form>
				    </c:when>
				    <c:otherwise>
				        -
				    </c:otherwise>
				</c:choose>
			</div>
			<textarea name="content" rows="4" cols="50" disabled>${modelData.archCtnt}</textarea>
		</div>
		<div id="buttonBtnArea">
			<button class="redBtn" id="deleteBtn">삭제하기</button>
			<button class="blueBtn" id="updateBtn" onclick='submitForm("<c:url value="/docs/safeEduEdit.do"/>")'>수정하기</button>
			<button class="blackBtn" onclick='submitForm("<c:url value="/docs/safeEdu.do"/>")'>목록으로</button>
		</div>		
		<!-- 목록으로 되돌아갈때 필요 -->
		<form id="hiddenForm" method="post" style="display:none;">
		    <input type="hidden" name="archId" id="archId" value="${modelData.archId}">
		    <input type="hidden" name="srchType" id="srchType" value="${modelData.srchType}">
		    <input type="hidden" name="srchWord" id="srchWord" value="${modelData.srchWord}">
		</form>		
		<!-- 팝업 모달 -->
		<div id="confirmModal" class="modal">
		    <div class="modal-content">
		        <h2>확인</h2>
		        <p>삭제하시겠습니까?</p>
				<div id="buttonBtnArea">
			        <button id="confirmNo" class="redBtn">취소</button>
			        <button id="confirmYes" class="blueBtn">삭제</button>
				</div>
		    </div>
		</div>
	</body>
</html>
<script>
	$(document).ready(function () {
		document.getElementById("deleteBtn").style.display ="none";
		document.getElementById("updateBtn").style.display ="none";
				
		if("${modelData.userId}" == "${modelData.regUserId}"){
			document.getElementById("deleteBtn").style.display ="inline-block";
			document.getElementById("updateBtn").style.display ="inline-block";
		
			document.getElementById("deleteBtn").addEventListener("click", () => {
			    document.getElementById('confirmModal').style.display = 'block';
			});

			document.getElementById("confirmYes").addEventListener("click", () => {
			    document.getElementById('confirmModal').style.display = "none";
			    submitForm("<c:url value="/docs/safeEduDel.do"/>");
			});

			document.getElementById("confirmNo").addEventListener("click", () => {
			    document.getElementById('confirmModal').style.display = "none";
			});	
		}
	});
	
  	function submitForm(actionUrl){
 		const form = document.getElementById('hiddenForm');
  		form.action = actionUrl; // action 동적으로 변경
 		form.submit(); // 폼 제출
  	}  	
</script>
<style>
	#titleArea{
		background-image: url('<c:url value="/image/Generated.png"/>'); /* JSP에서 이미지 경로 처리 */
		background-size: 100% auto;
		background-repeat: no-repeat;
		background-position: center center;
	}

	#navArea .navbar-nav .nav-link {
	  font-weight: 500;
	  color: #1976d2 ;
	}
</style>