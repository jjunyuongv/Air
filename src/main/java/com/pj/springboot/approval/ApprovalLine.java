package com.pj.springboot.approval;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "APPROVAL_LINE")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ApprovalLine {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "approval_line_seq")
    @SequenceGenerator(name = "approval_line_seq", sequenceName = "APPROVAL_LINE_SEQ", allocationSize = 1)
    @Column(name = "LINE_ID")
    private Long lineId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "APPROVAL_NO")
    private Approval approval;

    @Column(name = "STEP_ORDER")
    private int stepOrder;

    @Column(name = "APPROVER_ID")
    private String approverId;

    @Column(name = "DECIDED")
    private String decided; // 예: Y/N

    @Column(name = "DECIDED_AT")
    private LocalDateTime decidedAt;
}
