package com.pj.springboot.approval;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.jdbc.ParameterDTO;

@Mapper
public interface IApprovalService {

    /* CRUD */
    int create(ApprovalDTO dto);
    ApprovalDTO view(Long approvalNo);
    int update(ApprovalDTO dto);
    int delete(Long approvalNo);

    /* 페이징 */
    int getTotalCount(ParameterDTO param);
    List<ApprovalDTO> listPage(ParameterDTO param);

    /* 상태 변경 */
    int updateStatus(Long approvalNo, String status, String userId);
}
