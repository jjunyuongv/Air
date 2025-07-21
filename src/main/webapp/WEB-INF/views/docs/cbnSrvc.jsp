<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>문서보관소</title>
		<link rel="stylesheet" href="<c:url value="/css/arch.css"/>">
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
					<a class="nav-link" href='<c:url value="/login"/>'>로그인/회원가입</a>
			    </div>
			</nav>
		</div>
		<div id="titleArea">
			<h1>기내서비스</h1>
		</div>
		<div id="srchArea">
			<form id="srchForm" method="post" action='<c:url value="/docs/cbnSrvc.do"/>'>
	        	<select id="srchType" name="srchType">
		            <option value="ALL" ${srchType == 'ALL' || '' ? 'selected' : ''}>전체</option>
		            <option value="ARCH_TITLE" ${srchType == 'ARCH_TITLE' ? 'selected' : ''}>제목</option>
		            <option value="ARCH_CTNT" ${srchType == 'ARCH_CTNT' ? 'selected' : ''}>내용</option>
		            <option value="REG_USER_ID" ${srchType == 'REG_USER_ID' ? 'selected' : ''}>작성자</option>
		        </select>
		        <input id="srchWord" type="text" name="srchWord" mac="150"placeholder="검색어를 입력하세요" value="${srchWord}"/>
		        <button id="srchBtn" type="submit">
				    <i class="fa fa-search"></i>
				</button> 
			</form>
			<button type="button" id="regMnalRegBtn" class="write-button ">글쓰기</button>
		</div>
		<div id="dataArea">    
			<table style="width:100% important">
			    <tr>
					<th width="11%">번호</th>
					<th width="40%">제목</th>
					<th width="10%">첨부파일</th>
					<th width="13%">작성자ID</th>
					<th width="13%">소속부서</th>
					<th width="13%">등록일</th>
			    </tr>
				<c:choose>
				    <c:when test="${empty lists}"> 
				        <tr>
				            <td colspan="6" align="center">
				                게시물이 없습니다
				            </td>
				        </tr>
				    </c:when> 
				    <c:otherwise> 
				        <c:forEach items="${lists}" var="row" varStatus="loop">    
					        <tr class="listData" data-fileid="${row.archId}">
								<td class="tc">
									<c:set var="vNum" value="${pagingData.totalCount - (((pagingData.pageNum-1) * pagingData.pageSize) + loop.index)}" />
									    ${vNum}
									</td>
								</td>
					            <td>${row.archTitle}</td>
					            <td class="tc">
					            	<c:choose>
						            	<c:when test="${not empty row.fileId}">
						            		<button class="btn" style="padding: 0px !important; "data-fileid="${row.fileId}" data-filenm="${row.fileNm}">
											    <i class="fa-solid fa-download"></i>
											</button>
									    </c:when>
									    <c:otherwise>
									        -
									    </c:otherwise>
									</c:choose>
								</td>
					            <td class="tc">${row.regUserId}</td>
					            <td class="tc">${row.department}</td>
					            <td class="tc">${row.regDt.substring(0,4)}-${row.regDt.substring(4,6)}-${row.regDt.substring(6,8)}</td>
					        </tr>
				        </c:forEach>    
				    </c:otherwise>    
				</c:choose>
			</table>
			<table class="pagination-table">
			    <tr>
			        <td>
			            ${pagingImg}
			        </td>
		        </tr>
	    	</table>
		</div>
		<form id="hiddenForm" method="post" style="display:none;">
		    <input type="hidden" name="archId" id="archId">
		    <input type="hidden" name="srchType" id="srchType">
		    <input type="hidden" name="srchWord" id="srchWord">
		    <input type="hidden" name="regUserId" id="regUserId">
		    <input type="hidden" name="department" id="department">
		</form>
		<form id="downloadForm" method="post" action="<c:url value="/docs/fileDownload.do"/>" style="display:none;">
			<input type="hidden" name="fileId" id="fileId"/>
			<input type="hidden" name="fileNm" id="fileNm"/>
		</form>
	</body>
</html>	
<script>
	$("#regMnalRegBtn").on("click", function() {
		$("#hiddenForm").attr("action", '<c:url value="/docs/cbnSrvcReg.do"/>');
		$("#hiddenForm").submit();
	});

	$(".btn").on("click", function (event) {
	    event.stopPropagation();
		$("#fileId").val($(this).data("fileid"));
		$("#fileNm").val($(this).data("filenm"));		
	    $("#downloadForm").submit();
    });
	
    $(".listData").on("click", function () {
        $("#archId").val($(this).data("fileid"));
        $("#srchType").val($("input[name='srchType']").val());
        $("#srchWord").val($("input[name='srchWord']").val());
	    $("#hiddenForm").attr("action", '<c:url value="/docs/cbnSrvcSpec.do"/>');
        $("#hiddenForm").submit();
    });
</script>
<style>
	#titleArea{
		background-image: url('<c:url value="/image/Generated.png"/>'); /* JSP에서 이미지 경로 처리 */
		background-size: 100% auto;
		background-repeat: no-repeat;
		background-position: center center;
	}

	body {
	  min-height: 100vh;
	  display: flex;
	  flex-direction: column;
	  color: #333;
	}

	#navArea .navbar-nav .nav-link {
	  font-weight: 500;
	  color: #1976d2 ;
	}

	#navArea .navbar-brand {
	  font-weight: bold;
	  color: #0d47a1 ;
	}

	#navArea .main-content {
	  flex-grow: 1;
	  display: flex;
	  justify-content: center;
	  align-items: center;
	  padding: 0px;
	}

	#navArea .main-logo {
	  max-width: 100%;
	  height: auto;
	  display: block;
	  margin: 0 auto;
	  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
	  border-radius: 8px;
	}	
</style>