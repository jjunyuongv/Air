// Package Name: com.pj.springboot.calendar
package com.pj.springboot.calendar;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> { // Schedule의 ID가 String이므로 String으로 변경
}