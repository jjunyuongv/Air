package com.pj.springboot.calendar;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "SCHEDULE")
@Getter @Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Schedule {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "schedule_seq_gen")
    @SequenceGenerator(name = "schedule_seq_gen", sequenceName = "SCHEDULE_SEQ", allocationSize = 1)
    @Column(name = "SCHEDULE_ID")  // 실제 PK 컬럼명만 매핑
    private Long scheduleId;

    @Column(name = "USER_ID")
    private String userId;

    @Column(name = "TITLE")
    private String title;

    @Column(name = "START_TIME")
    private LocalDateTime startTime;

    @Column(name = "END_TIME")
    private LocalDateTime endTime;

    @Column(name = "LOCATION")
    private String location;

    @Column(name = "IS_RECURRING")
    private String isRecurring; // "Y" 또는 "N"

    // 필요하면 boolean getter/setter
    public boolean isRecurringYn() {
        return "Y".equalsIgnoreCase(isRecurring);
    }

    public void setRecurringYn(boolean recurring) {
        this.isRecurring = recurring ? "Y" : "N";
    }
}
