package com.pj.springboot.approval;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ApprovalService {

    private final ApprovalRepository approvalRepository;
    private final ApprovalLineRepository approvalLineRepository; // 결재선 추가

    // 결재 생성
    public Approval createApproval(Approval approval) {
        return approvalRepository.save(approval);
    }

    // 전체 결재 리스트
    public List<Approval> getAllApprovals() {
        return approvalRepository.findAll();
    }

    // 단일 결재 조회
    public Approval getApproval(Long approvalNo) {
        return approvalRepository.findById(approvalNo)
                .orElseThrow(() -> new IllegalArgumentException("Approval not found"));
    }

    // ***이 함수가 빠졌을 것***
    public List<ApprovalLine> getApprovalLines(Long approvalNo) {
        // approvalNo 기준으로 결재선 리스트 조회
        return approvalLineRepository.findByApproval_ApprovalNoOrderByStepOrderAsc(approvalNo);
        // 위 함수 이름은 ApprovalLineRepository에 정의된 쿼리 메서드랑 맞춰야 함!
    }
}
