<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>  
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mybatis게시판</title>
</head>
	<body>
    <link rel="stylesheet" href="<c:url value="/css/list.css"/>">
	<h2>문서보관함</h2>
	<form method="get">
	<table width="90%">
	<tr>
	     <td style="text-align: left;" > 
	        <select name="searchField">
	            <option value="ARCH_ID">번호</option>
	            <option value="ARCH_TITLE">제목</option>
	            <option value="ARCH_TYPE">유형</option>
	            <option value="REG_USER_ID">작성자</option>
	            <option value="REG_DT">작성일</option>
	        </select>
	        <input type="text" name="searchKeyword" />
	        <input type="submit" value="검색하기" class="search-button" />
	     
	   </td>

	    
	    
	</tr>
	</table>      
	</form>
	
	<table width="90%">
	    <tr>
	        <th width="10%">번호</th>
	        <th width="*">제목</th>
	        <th width="15%">유형</th>
	        <th width="10%">작성자</th>
	        <th width="15%">작성일</th>
	    </tr>
	<c:choose>
	    <c:when test="${empty lists}"> 
	        <tr>
	            <td colspan="5" align="center">
	                등록된 게시물이 없습니다^^*
	            </td>
	        </tr>
	    </c:when> 
	    <c:otherwise> 
	        <c:forEach items="${lists}" var="row" varStatus="loop">    
	        <tr align="center">
	            <td> 
	            <c:set var="vNum" value="${maps.totalCount - (((maps.pageNum-1) * maps.pageSize) + loop.index)}" />
	                ${vNum}
	            </td>
	            <td align="left"> 
	                <a href="./view.do?archId=${row.archId}&vNum=${vNum}">
	                ${row.archTitle}</a>
	            </td> 
	            <td>${row.archType}</td> 
	            <td>${row.regUserId}</td> 
	            <td>${row.regDt}</td> 
	        </tr>
	        </c:forEach>        
	    </c:otherwise>    
	</c:choose>
	</table>
		
	<table width="90%" class="pagination-table">
	<tr>
	    <td> ${pagingImg}
	        </td>
	        <td style="text-align: right;"><button type="button"
	            onclick="location.href='./write.do';"
	            class="write-button">글쓰기</button>
	        </td>
	        </tr>
	      </table>
	  </body>
</html>