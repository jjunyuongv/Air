<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    
    <title>글쓰기</title>
    <link rel="stylesheet" href="<c:url value="/css/write.css"/>">    
    
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
    </script>
</head>
<body>
    <h2>자료올리기</h2>
    
    <form name="writeFrm" method="post" action="./write.do" onsubmit="return validateForm(this);">
        <table border="1" width="90%">
            <tr>
                <td>작성자</td>
                <td><input type="text" name="regUserId" style="width:100%;" /></td>
            </tr>
            <tr>
                <td>자료 구분</td>
                <td>
                    <select name="archType" style="width:200px;">
                        <option value="">-- 선택하세요 --</option>
                        <option value="10">근무변경신청</option>
                        <option value="20">휴가신청</option>
                        <option value="30">긴급 운항 변경</option>
                    </select>
                 
	           </td>
            </tr>
            <tr>
                <td>제목</td>
                <td><input type="text" name="archTitle" style="width:100%;" /></td>
            </tr>
            <tr>
                <td>내용</td>
                <td><textarea name="archCtnt" style="width:100%;height:100px;"></textarea></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <button type="submit">작성 완료</button>
                    <button type="reset">RESET</button>
                    <button type="button" onclick="location.href='./list.do';">목록 바로가기</button>
                </td>
            </tr>
        </table>    
    </form>
</body>
</html>
