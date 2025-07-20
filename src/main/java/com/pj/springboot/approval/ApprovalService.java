package com.pj.springboot.approval;

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pj.springboot.jdbc.ParameterDTO;

/**
 * 전자결재 비즈니스 로직 담당 Service
 *  - Controller ↔ Mapper 사이의 중간 계층
 */
@Service
@RequiredArgsConstructor      // 생성자 주입
@Transactional                // 메서드 전체를 하나의 트랜잭션으로 처리
public class ApprovalService {

    private final IApprovalService mapper;   // MyBatis Mapper 주입

    /* 목록/페이징 */
    public int getTotalCount(ParameterDTO param)        { return mapper.getTotalCount(param); }
    public List<ApprovalDTO> listPage(ParameterDTO p)   { return mapper.listPage(p); }

    /* 단건 조회 */
    public ApprovalDTO view(Long approvalNo)            { return mapper.view(approvalNo); }

    /* 작성 */
    public void create(ApprovalDTO dto)                 { mapper.create(dto); }

    /* 수정 */
    public void update(ApprovalDTO dto)                 { mapper.update(dto); }

    /* 삭제 */
    public void delete(Long approvalNo)                 { mapper.delete(approvalNo); }

    /* 상태 변경 : APPROVED / REJECTED */
    public void changeStatus(Long approvalNo, String status, String userId) {
        mapper.updateStatus(approvalNo, status, userId);
    }
}
