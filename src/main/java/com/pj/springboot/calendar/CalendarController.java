package com.pj.springboot.calendar;

/*윤아*/

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class CalendarController {

    private final ScheduleService scheduleService;

    // 캘린더 JSP 뷰 반환
    @GetMapping("/calendar")
    public String showCalendarPage() {
        return "calendar/calendar";
    }

    // 전체 일정 JSON 반환 (FullCalendar에서 events로 사용)
    @GetMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<List<Map<String, Object>>> getAllSchedules() {
        List<Schedule> schedules = scheduleService.findAllSchedules();

        List<Map<String, Object>> fcEvents = schedules.stream().map(schedule -> {
            Map<String, Object> event = new HashMap<>();
            event.put("id", String.valueOf(schedule.getScheduleId()));
            event.put("title", schedule.getTitle());
            event.put("start", schedule.getStartTime() != null ? schedule.getStartTime().toString() : null);
            event.put("end", schedule.getEndTime() != null ? schedule.getEndTime().toString() : null);

            // allDay 판정: 종료시간 없고, 시작시간이 00:00, 반복 아님
            boolean allDay = schedule.getEndTime() == null
                    && schedule.getStartTime() != null
                    && schedule.getStartTime().toLocalTime().equals(java.time.LocalTime.MIDNIGHT)
                    && !schedule.isRecurringYn();
            event.put("allDay", allDay);

            event.put("backgroundColor", "#2ecc71");
            event.put("borderColor", "#2ecc71");

            Map<String, Object> extendedProps = new HashMap<>();
            extendedProps.put("location", schedule.getLocation());
            extendedProps.put("isRecurring", schedule.isRecurringYn());
            extendedProps.put("userId", schedule.getUserId());
            event.put("extendedProps", extendedProps);

            return event;
        }).collect(Collectors.toList());

        return ResponseEntity.ok(fcEvents);
    }

    // 일정 저장/수정
    @PostMapping("/api/schedules")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveSchedule(@RequestBody Schedule schedule) {
        Schedule saved = scheduleService.saveSchedule(schedule);

        Map<String, Object> res = new HashMap<>();
        res.put("id", String.valueOf(saved.getScheduleId()));
        res.put("title", saved.getTitle());
        res.put("start", saved.getStartTime() != null ? saved.getStartTime().toString() : null);
        res.put("end", saved.getEndTime() != null ? saved.getEndTime().toString() : null);
        boolean allDay = saved.getEndTime() == null
                && saved.getStartTime() != null
                && saved.getStartTime().toLocalTime().equals(java.time.LocalTime.MIDNIGHT)
                && !saved.isRecurringYn();
        res.put("allDay", allDay);
        res.put("backgroundColor", "#2ecc71");
        res.put("borderColor", "#2ecc71");

        Map<String, Object> extendedProps = new HashMap<>();
        extendedProps.put("location", saved.getLocation());
        extendedProps.put("isRecurring", saved.isRecurringYn());
        extendedProps.put("userId", saved.getUserId());
        res.put("extendedProps", extendedProps);

        return new ResponseEntity<>(res, HttpStatus.CREATED);
    }

    // 일정 삭제
    @DeleteMapping("/api/schedules/{id}")
    @ResponseBody
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long id) {
        scheduleService.deleteSchedule(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
