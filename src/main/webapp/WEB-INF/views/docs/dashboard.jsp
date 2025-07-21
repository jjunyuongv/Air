<!-- 혜원 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<!DOCTYPE html>
<html>
   <head>
       <title>문서보관소</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
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
      <div id="mainArea">
          <h2 id="TitleH2">직원 대시보드</h2>
          <p>환영합니다, <sec:authentication property="principal.username"/>!</p>
          <h3 id="TitleH3">직원 기능</h3>
          <ul id="menuListUl">
              <li class="menuListLi"><a class="menuListA" href="<c:url value="/docs/opsMnal.do"/>">운항매뉴얼</a></li>
              <li class="menuListLi"><a class="menuListA" href="<c:url value="/docs/cbnSrvc.do"/>">기내서비스</a></li>
              <li class="menuListLi"><a class="menuListA" href="<c:url value="/docs/safeEdu.do"/>">안전교육</a></li> 
          </ul>
      
          <form id="mainForm" action="<c:url value="/logout"/>" method="post">
              <button id="logoutBtn" type="submit">로그아웃</button>
          </form>
      </div>
   </body>
</html>
<style>
    body {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
     background-color: #f4f4f4;
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
   
   #mainArea{
      padding: 0px 20px;
      font-family: Arial, sans-serif;
   }

   #TitleH2 
   {
       color: #0056b3 ;
      display: block;
      font-size: 1.5em;
      margin-block-start: 0.83em;
      margin-block-end: 0.83em;
      margin-inline-start: 0px;
      margin-inline-end: 0px;
      font-weight: bold;
      unicode-bidi: isolate;
      font-family: Arial, sans-serif;
   }

   #TitleH3
   {
       color: #0056b3 ;
      display: block ;
      font-size: 1.17em ;
      margin-block-start: 1em ;
      margin-block-end: 1em ;
      margin-inline-start: 0px ;
      margin-inline-end: 0px ;
      font-weight: bold ;
      unicode-bidi: isolate ;
      font-family: Arial, sans-serif;
   }

   #mainForm 
   {
       background-color: #fff;
       padding: 20px;
       border-radius: 8px;
       box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
       max-width: 400px;
       margin: 20px auto;
      font-family: Arial, sans-serif;
   }

   #logoutBtn 
   {
       background-color: #007bff;
       color: #fff ;
       padding: 10px 15px ;
       border: none ;
       border-radius: 4px ;
       cursor: pointer ;
       font-size: 16px ;
       width: 100% ;
      font-family: Arial, sans-serif;
   }

   #logoutBtn:hover
   {
       background-color: #0056b3 ;
   }

   #menuListUl 
   {
       list-style-type: none ;
       padding: 0 ;
   }

   #menuListUl .menuListLi
   {
       background-color: #e9ecef ;
       margin-bottom: 10px ;
       padding: 10px ;
       border-radius: 5px ;
      font-family: Arial, sans-serif;
   }

   #menuListUl .menuListLi .menuListA
   {
       display: block ;
       font-weight: bold  ;
      font-family: Arial, sans-serif;
   }

   .menuListA 
   {
       color: #007bff ;
       text-decoration: none ;
      font-family: Arial, sans-serif;
   }

   .menuListA:hover 
   {
       text-decoration: underline ;
      font-family: Arial, sans-serif;
   }
  </style>