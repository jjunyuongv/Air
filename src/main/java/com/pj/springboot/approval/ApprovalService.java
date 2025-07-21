package com.pj.springboot.approval;

/*준영*/

import java.util.List;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.pj.springboot.jdbc.ParameterDTO;


@Service
@RequiredArgsConstructor    
@Transactional              
public class ApprovalService {

    private final IApprovalService mapper;   

    public int getTotalCount(ParameterDTO param)        { return mapper.getTotalCount(param); }
    public List<ApprovalDTO> listPage(ParameterDTO p)   { return mapper.listPage(p); }
    public ApprovalDTO view(Long approvalNo)            { return mapper.view(approvalNo); }
    public void create(ApprovalDTO dto)                 { mapper.create(dto); }
    public void update(ApprovalDTO dto)                 { mapper.update(dto); }
    public void delete(Long approvalNo)                 { mapper.delete(approvalNo); }
    public void changeStatus(Long approvalNo, String status, String userId) {
        mapper.updateStatus(approvalNo, status, userId);
    }
}
