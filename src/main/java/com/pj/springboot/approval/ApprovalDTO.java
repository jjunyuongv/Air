package com.pj.springboot.approval;

import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ApprovalDTO {
    private Long   approvalNo;
    private String draftUserId;
    private String title;
    private String content;
    private String category;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;
}
