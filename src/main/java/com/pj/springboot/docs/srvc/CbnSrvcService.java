package com.pj.springboot.docs.srvc;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.docs.dto.CbnSrvcDTO;
import com.pj.springboot.docs.dto.AtchFileDTO;

@Mapper
public interface CbnSrvcService {
	
    //기내서비스 총 개수 조회
    int getTotalCount(CbnSrvcDTO CbnSrvcDTO);
    
	//기내서비스 다건 조회
    ArrayList<CbnSrvcDTO> selectCbnSrvcList(CbnSrvcDTO CbnSrvcDTO);
    
    //기내서비스 단건 조회
    CbnSrvcDTO selectCbnSrvc(CbnSrvcDTO CbnSrvcDTO);
	
	//기내서비스 max조회
	int getMaxArchId();
	
    //기내서비스 등록
    int insertCbnSrvc(CbnSrvcDTO CbnSrvcDTO);
    
    //기내서비스 수정
    int updateCbnSrvc(CbnSrvcDTO CbnSrvcDTO);
    
    //기내서비스 삭제
    int deleteCbnSrvc(CbnSrvcDTO CbnSrvcDTO);    

    //첨부파일 조회
    AtchFileDTO selectAtchFile(int fileId);
    
    //첨부파일 등록
    int insertAtchFile(AtchFileDTO atchFileDTO);

    //첨부파일 삭제
    int deleteAtchFile(int ArchId);    

    // 사용자 정보 조회
    CbnSrvcDTO selectUserInfo(String regUserId);
}
