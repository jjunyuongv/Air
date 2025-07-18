<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>일정 관리</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.13/main.min.css' rel='stylesheet' />

    <style>
        body {
            background: linear-gradient(to bottom right, #e3f2fd, #ffffff);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            margin: 0;
            padding: 0;
        }
        .navbar-nav .nav-link {
            font-weight: 500;
            color: #1976d2 !important;
        }
        .navbar-brand {
            font-weight: bold;
            color: #0d47a1 !important;
        }
        .wrapper {
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding: 20px;
        }
        .main-content {
            max-width: 1200px;
            width: 100%;
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
        }
        h1 i {
            margin-right: 10px;
            font-size: 1.2em;
        }
        #calendar {
            margin: 0 auto;
            padding: 20px 0;
        }
        .fc .fc-button-primary {
            background-color: #3498db;
            border-color: #3498db;
        }
        .fc .fc-button-primary:hover {
            background-color: #2980b9;
            border-color: #2980b9;
        }
        .fc .fc-daygrid-event {
            background-color: #2ecc71;
            border-color: #2ecc71;
        }
        .fc-event {
            border-radius: 3px;
            font-size: .85em;
            padding: 2px 5px;
            cursor: pointer;
        }
        #eventModal .modal-header {
            background-color: #2c3e50;
            color: white;
            border-bottom: none;
        }
        #eventModal .modal-title {
            color: white;
        }
        #eventModal .btn-close {
            filter: invert(1);
        }
        #eventModal .modal-footer {
            border-top: none;
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand bg-white shadow-sm px-4">
        <a class="navbar-brand" href="/">
            ✈
        </a>
        <ul class="navbar-nav mx-auto d-flex flex-row">
            <li class="nav-item me-3"><a class="nav-link" href="/approval/list">전자결재시스템</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/docs/list">문서보관소</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/report/list">업무보고시스템</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/message/inbox">커뮤니케이션기능</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/qna/list">고객응대공유</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/calendar">일정관리</a></li>
            <li class="nav-item me-3"><a class="nav-link" href="/mypage">마이페이지</a></li>
        </ul>
        <div class="d-flex">
            <a class="nav-link" href="/login">로그인/회원가입</a>
        </div>
    </nav>

    <div class="wrapper">
        <div class="main-content">
            <h1><i class="bi bi-calendar"></i> 일정 관리</h1>
            <div id='calendar'></div>

            <div id="eventModal" class="modal fade" tabindex="-1" aria-labelledby="eventModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="eventModalLabel">일정 상세/수정</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <form id="eventForm">
                                <input type="hidden" id="eventId">

                                <input type="hidden" id="eventUserId" value="current_logged_in_user_id">

                                <div class="mb-3">
                                    <label for="eventTitle" class="form-label">제목</label>
                                    <input type="text" class="form-control" id="eventTitle" required>
                                </div>
                                <div class="mb-3">
                                    <label for="eventStartDate" class="form-label">시작일시</label>
                                    <input type="datetime-local" class="form-control" id="eventStartDate" required>
                                </div>
                                <div class="mb-3">
                                    <label for="eventEndDate" class="form-label">종료일시</label>
                                    <input type="datetime-local" class="form-control" id="eventEndDate">
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="allDayEvent">
                                    <label class="form-check-label" for="allDayEvent">종일</label>
                                </div>
                                <div class="mb-3">
                                    <label for="eventLocation" class="form-label">장소</label>
                                    <input type="text" class="form-control" id="eventLocation">
                                </div>
                                <div class="form-check mb-3">
                                    <input class="form-check-input" type="checkbox" id="isRecurringEvent">
                                    <label class="form-check-label" for="isRecurringEvent">반복 일정</label>
                                </div>
                            </form>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-danger" id="deleteEventBtn">삭제</button>
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
                            <button type="button" class="btn btn-primary" id="saveEventBtn">저장</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.1/moment.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.13/index.global.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/@fullcalendar/core/locales/ko.global.min.js'></script>

    <c:import url="/WEB-INF/views/includes/calendar_js.jsp" />
</body>
</html>