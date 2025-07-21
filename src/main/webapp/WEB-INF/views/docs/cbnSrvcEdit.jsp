<!-- 혜원 -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
			<h1>기내서비스</h1>
		</div>		
		<div id="dataArea">    
		    <form id="writeFrm" name="writeFrm" method="post" enctype="multipart/form-data">
		        <table id="regData">
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
		                <td class="w80p" colspan="3"><input type="text" name="archTitle" value="${modelData.archTitle}"/></td>
		            </tr>
		            <tr>
		                <td class="label w15p">첨부파일</td>
		                <td class="w80p" colspan="3">
		                	<div id="fileAtchArea">
		                		<button type="button" id="atchFileBtn" class="blackBtn" onclick="document.getElementById('fileInput').click()">파일첨부</button>
		    					<input type="hidden" name="fileId" id="fileId" value="${modelData.fileId}">
		    					<input type="hidden" name="archId" id="archId" value="${modelData.archId}">
								<input type="file" id="fileInput" multiple  name="fileUpload" accept=".hwp, .docx, .pptx, .xlsx">
								<div id="attachedFileArea">
									<p style="margin-top:9px !important; display:inline-block;">${modelData.fileNm}</p>
									<button type="button" id="deleteFileBtn">X</button>
								</div>
		                	</div>
		                </td>
		            </tr>
		            <tr>
		                <td class="label w20p">내용</td>
		                <td class="w80p" colspan="3"><textarea style="height:335px;" name="archCtnt">${modelData.archCtnt}</textarea></td>
		            </tr>
		        </table>    
		    </form>
		</div>
		<div id="buttonBtnArea">
			<button type="button" class="blueBtn" id="insertBtn">등록하기</button>
			<button type="button" class="blackBtn" onclick='submitForm("<c:url value="/docs/cbnSrvc.do"/>")'>목록으로</button> 
		</div>
		
		<!-- 목록으로 되돌아갈때 필요 -->
		<form id="hiddenForm" method="post" style="display:none;" action="<c:url value="/docs/cbnSrvc.do"/>">
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

	let selectedFile;
	
	$(document).ready(function () {
		if ("${not empty modelData.fileId}" === "true" || (selectedFile != undefined && selectedFile != '' && selectedFile != null)) {

		        $("#deleteFileBtn").css("display","inline-block");
		}else{
	        $("#deleteFileBtn").css("display","none");
		}
	});
  	// 파일 선택 시 
	document.getElementById('fileInput').addEventListener('change', function (event) {
	  selectedFile = event.target.files[0];
		const allowedExtensions = ['hwp', 'docx', 'pptx', 'xlsx'];
		if (selectedFile) {
		    const fileExt = file.name.split('.').pop().toLowerCase();
		    if (!allowedExtensions.includes(fileExt)) {
		        alert('허용되지 않은 파일 형식입니다.');
		        this.value = ''; // 파일 입력값 초기화
		    }
		}
		const area = document.getElementById("attachedFileArea");
		if (selectedFile) {
	        $("#attachedFileArea p").text(selectedFile.name);
	        $("#deleteFileBtn").css("display","inline-block");
        }
	});
	
	// 파일 삭제 버튼 선택 시 
	$("#deleteFileBtn").on("click", function () {
        $("#fileInput").val("");
        $("#fileId").val("");
        $("#attachedFileArea p").text("");
	        $("#deleteFileBtn").css("display","none");
	});  		
	
	// 팝업 모달	
  	$("#insertBtn").on("click", function() {
  		$("#confirmModal").css("display", "block");
	});
			
	$("#confirmNo").on("click", function() {
  		$("#confirmModal").css("display", "none");
	});

  	$("#confirmYes").on("click", function() {
		 submitForm("<c:url value="/docs/cbnSrvcUpdate.do"/>");
	});
	
  	function submitForm(actionUrl){
 		const form = actionUrl == "<c:url value="/docs/cbnSrvc.do"/>" ? document.getElementById("hiddenForm") : document.getElementById("writeFrm");
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
</style>