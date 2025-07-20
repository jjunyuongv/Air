<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %> 
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시판수정</title>
    <link rel="stylesheet" href="<c:url value="/css/edit.css"/>">  
    
    <script type="text/javascript">
    function validateForm(form) { 
        if (form.regUserId.value.trim() === "") {
            alert("작성자를 입력하세요.");
            form.regUserId.focus();
            return false;
        }
        if (form.archTitle.value.trim() === "") {
            alert("제목을 입력하세요.");
            form.archTitle.focus();
            return false;
        }
        if (form.archCtnt.value.trim() === "") {
            alert("내용을 입력하세요.");
            form.archCtnt.focus();
            return false;
        }
    }
    </script>
</head>
<body>
    <h2>게시판 수정</h2>
    <form name="writeFrm" method="post" action="./edit.do" onsubmit="return validateForm(this);">
        <!-- 수정할 게시물의 ID -->
        <input type="hidden" name="archId" value="${boardDTO.archId}" />
        
        <table border="1" >
            <tr>
                <td>작성자</td>
                <td>
                    <input type="text" name="regUserId" 
                        value="${boardDTO.regUserId}" />
                </td>
            </tr>
            <tr>
                <td>제목</td>
                <td>
                    <input type="text" name="archTitle" 
                        value="${boardDTO.archTitle}" />
                </td>
            </tr>
            <tr>
                <td>내용</td>
                <td>
                    <textarea name="archCtnt" >${boardDTO.archCtnt}</textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <button type="submit">작성 완료</button>
                    <button type="reset">RESET</button>
                    <button type="button" onclick="location.href='./list.do';">
                        목록 바로가기
                    </button>
                </td>
            </tr>
        </table>    
    </form>
</body>
</html>
