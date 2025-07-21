<!-- 혜원 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>문서보관소</title>
		<link rel="stylesheet" href="<c:url value="/css/arch.css"/>">
		<link rel="stylesheet" href="<c:url value="/css/write.css"/>">
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
		<meta charset="UTF-8">
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
			      <a class="nav-link" href="/login">로그인/회원가입</a>
			    </div>
			</nav>
		</div>
		<div id="titleArea">
			<h1>운항매뉴얼</h1>
		</div>
		<div id="dataArea">    
		    <form id="writeFrm" name="writeFrm" method="post" enctype="multipart/form-data">
		        <table id="regData" style="margin: 5px auto !important;">
		            <tr>
		                <td class="label w15p">작성자</td>
		                <td class="w30p tl">
			    			<input type="hidden" name="regUserId" id="regUserId" value="${modelData.regUserId}">
			                ${modelData.regUserId}
		                </td>
		                <td class="label w15p">소속부서</td>
		                <td class="w30p tl">${modelData.department}</td>
		            </tr>
		            <tr>
		                <td class="label w15p">제목</td>
		                <td class="w80p" colspan="3"><input type="text" name="archTitle"/></td>
		            </tr>
		            <tr>
		                <td class="label w15p">첨부파일</td>
		                <td class="w80p" colspan="3">
		                	<div id="fileAtchArea">
		                		<button type="button" id="atchFileBtn" class="blackBtn" onclick="document.getElementById('fileInput').click()">파일첨부</button>
								<input type="file" id="fileInput" multiple  name="fileUpload" accept=".hwp, .docx, .pptx, .xlsx">
								<div id="attachedFileArea">
									<p></p>
									<button type="button" id="deleteFileBtn">X</button>
		                		</div>
		                	</div>
		                </td>
		            </tr>
		            <tr class="tl">
		                <td class="tl label w15p">내용</td>
		                <td colspan="3"><textarea style="height:350px !important;"  class="tl" name="archCtnt"></textarea>
						</td>
		            </tr>
		        </table>    
		    </form>
		</div>
		<div id="buttonBtnArea">
			<button type="button" class="blueBtn" id="insertBtn">등록하기</button>
			<button class="blackBtn" onclick="submitForm('<c:url value="/docs/opsMnal.do"/>')">목록으로</button> 
		</div>
		
		<!-- 목록으로 되돌아갈때 필요 -->
		<form id="hiddenForm" method="post" style="display:none;">
		    <input type="hidden" name="srchType" id="srchType" value="${modelData.srchType}">
		    <input type="hidden" name="srchWord" id="srchWord" value="${modelData.srchWord}">
		</form>
		
		<!-- 팝업 모달 -->
		<div id="confirmModal" class="modal">
		    <div class="modal-content">
		        <h2>확인</h2>
		        <p>등록하시겠습니까?</p>
				<div id="buttonBtnArea">
			        <button id="confirmNo" class="redBtn">취소</button>
			        <button id="confirmYes" class="blueBtn">등록</button>
				</div>
		    </div>
		</div>
	</body>
</html>
<script>
	let validateForm = (frm) => {
	    if(frm.regUserId.value.trim() === ''){
	        alert('작성자를 입력하세요.');
	        frm.regUserId.focus();
	        return false;
	    }
	    if(frm.archType.value.trim() === ''){
	        alert('자료 구분을 선택하세요.');
	        frm.archType.focus();
	        return false;
	    }
	    if(frm.archTitle.value.trim() === ''){
	        alert('제목을 입력하세요.');
	        frm.archTitle.focus();
	        return false;
	    }
	    if(frm.archCtnt.value.trim() === ''){
	        alert('내용을 입력하세요.');
	        frm.archCtnt.focus();
	        return false;
	    }
	    return true;
	}
	let selectedFile;
	$(document).ready(function () {
		if (!selectedFile) {
	        $("#deleteFileBtn").css("display","none");
		}else{
	        $("#deleteFileBtn").css("display","inline-block");
		}
	});


	// 파일 선택 시 
	document.getElementById('fileInput').addEventListener('change', function (event) {
	  selectedFile = event.target.files[0];
		const area = document.getElementById("attachedFileArea");
		if (selectedFile) {
	        $("#attachedFileArea p").text(selectedFile.name);
	        $("#deleteFileBtn").css("display","inline-block");
	    }
	});

	// 파일 삭제 버튼 선택 시 
	$("#deleteFileBtn").on("click", function () {
	    document.getElementById("fileInput").value = "";
	    $("#attachedFileArea p").text("");
	    $("#deleteFileBtn").css("display","none");
	});  	

	// 팝업 모달	
	$("#deleteBtn").on("click", function() {
		$("#confirmModal").css("display", "block");
	});

	$("#deleteBtn ,#insertBtn").on("click", function() {
		const clickedId = $(this).attr("id");
		if(clickedId === "deleteBtn"){
			$("#confirmModal p").text("삭제하시겠습니까?");
			$("#confirmYes").text("삭제");
		}else{
			$("#confirmModal p").text("등록하시겠습니까?");
			$("#confirmYes").text("등록");
		}
		$("#confirmModal").css("display", "block");
	});


	$("#confirmNo").on("click", function() {
		$("#confirmModal").css("display", "none");
	});

	$("#confirmYes").on("click", function() {
		const clickedId = $(this).attr("id");
		const actionUrl = clickedId == "deleteBtn"? "<c:url value="/docs/opsMnalDel.do"/>" : "<c:url value="/docs/opsMnalInsert.do"/>"
	    submitForm(actionUrl);
	});

	function submitForm(actionUrl){
		const form = actionUrl == "<c:url value="/docs/opsMnalDel.do"/>" || "<c:url value="/docs/opsMnal.do"/>" ? document.getElementById("hiddenForm") : document.getElementById("writeFrm");
		form.action = actionUrl; 
		form.append('file', selectedFile);
		form.submit();
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