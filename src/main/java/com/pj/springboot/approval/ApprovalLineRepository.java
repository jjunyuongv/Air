package com.pj.springboot.approval;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ApprovalLineRepository extends JpaRepository<ApprovalLine, Long> {
    // approvalNo로 결재선 조회 (Order By STEP_ORDER)
    List<ApprovalLine> findByApproval_ApprovalNoOrderByStepOrderAsc(Long approvalNo);
}
