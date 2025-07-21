package com.pj.springboot.approval;

/*준영*/

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.jdbc.ParameterDTO;

@Mapper
public interface IApprovalService {

    int create(ApprovalDTO dto);
    ApprovalDTO view(Long approvalNo);
    int update(ApprovalDTO dto);
    int delete(Long approvalNo);
    int getTotalCount(ParameterDTO param);
    List<ApprovalDTO> listPage(ParameterDTO param);
    int updateStatus(Long approvalNo, String status, String userId);
}
