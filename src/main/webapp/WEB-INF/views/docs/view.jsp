<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>내용 보기</title>
    <link rel="stylesheet" href="<c:url value="/css/view.css"/>">  
    <script>
    function deletePost(archId){
        var confirmed = confirm("정말로 삭제하겠습니까?");
        if(confirmed){
            var form = document.writeFrm;
            form.method = "post";
            form.action = "delete.do";

            // 삭제할 게시글 ID를 hidden input에 세팅
            form.archId.value = archId;

            form.submit();
        }
    }
    </script>
</head>
<body>
    <h2>문서내용</h2>    
    <form name="writeFrm">
        <!-- 파라미터명은 archId로 맞추기 -->
        <input type="hidden" name="archId" value="${boardDTO.archId}" />
    </form>

    <table border="1" width="90%">
        <colgroup>
            <col width="15%"/> 
            <col width="35%"/>
            <col width="15%"/> 
            <col width="15%"/> 
            
            <col width="*"/>
        </colgroup>    
        <!-- 게시글 정보 -->
        <tr>
            <td>번호</td> <td>${boardDTO.archId}</td>
            <td>작성자</td> <td>${boardDTO.regUserId}</td>
        </tr>
        <tr>
            <td>작성일</td> 
            <td>${boardDTO.regDt} ${boardDTO.regTm}</td>
            <td>수정일</td> <td>${boardDTO.udtDt} ${boardDTO.udtTm}</td>
        </tr>
        <tr>
            <td>제목</td>
            <td colspan="3">${boardDTO.archTitle}</td>

            
        </tr>
        <tr>
            <td align="center">내용</td>
            <td colspan="3" height="100">${boardDTO.archCtnt}</td>
        </tr>

        <!-- 하단 메뉴(버튼) -->
        <tr>
            <td colspan="4" align="center">
                <button type="button" onclick="location.href='./edit.do?archId=${boardDTO.archId}';">
                    수정하기
                </button>
                <button type="button" onclick="deletePost(${boardDTO.archId});">
                    삭제하기
                </button>
                <button type="button" onclick="location.href='./list.do';">
                    목록 바로가기
                </button>
            </td>
        </tr>
    </table>
</body>
</html>
