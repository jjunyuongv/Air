package com.pj.springboot.approval;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Approval {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long approvalNo;

    @ManyToOne
    @JoinColumn(name = "DRAFT_USER_ID")
    private AirJourneyUser draftUser;

    private String title;

    @Lob
    private String content;

    private String category;

    private String status;

    @Temporal(TemporalType.TIMESTAMP)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    private Date completedAt;

    // 기타 필요한 필드 및 생성자/메소드
}
