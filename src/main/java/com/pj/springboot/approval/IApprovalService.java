package com.pj.springboot.approval;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.pj.springboot.jdbc.ParameterDTO;

/**
 * 전자결재(Approval) 전용 MyBatis Mapper
 *  ‑ 작성  : create()
 *  ‑ 목록  : getTotalCount(), listPage()
 *  ‑ 상세  : view()
 *  ‑ 수정  : update()
 *  ‑ 삭제  : delete()
 */
@Mapper
public interface IApprovalService {

    /* 작성(INSERT) */
    int create(ApprovalDTO approvalDTO);

    /* 목록 페이징용 전체 건수 */
    int getTotalCount(ParameterDTO parameterDTO);

    /* 목록 조회(페이징) */
    List<ApprovalDTO> listPage(ParameterDTO parameterDTO);

    /* 상세 조회 */
    ApprovalDTO view(Long approvalNo);

    /* 수정(UPDATE) */
    int update(ApprovalDTO approvalDTO);

    /* 삭제(DELETE) */
    int delete(Long approvalNo);
}
