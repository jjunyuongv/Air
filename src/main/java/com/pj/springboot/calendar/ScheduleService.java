package com.pj.springboot.calendar;

/*윤아*/

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ScheduleService {

    private final ScheduleRepository scheduleRepository;

    // 전체 스케줄 조회
    public List<Schedule> findAllSchedules() {
        return scheduleRepository.findAll();
    }

    // ID로 단건 조회
    public Optional<Schedule> findScheduleById(Long id) {
        return scheduleRepository.findById(id);
    }

    // 저장/수정
    @Transactional
    public Schedule saveSchedule(Schedule schedule) {
        // isRecurring 값 'Y'/'N' 보정(혹시 boolean으로 오는 경우 등)
        if (schedule.getIsRecurring() == null) {
            schedule.setIsRecurring("N");
        } else if (!schedule.getIsRecurring().equalsIgnoreCase("Y")) {
            schedule.setIsRecurring("N");
        }
        return scheduleRepository.save(schedule);
    }

    // 삭제
    @Transactional
    public void deleteSchedule(Long id) {
        scheduleRepository.deleteById(id);
    }
}
