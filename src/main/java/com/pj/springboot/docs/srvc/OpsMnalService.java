package com.pj.springboot.docs.srvc;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.docs.dto.OpsMnalDTO;
import com.pj.springboot.docs.dto.AtchFileDTO;

@Mapper
public interface OpsMnalService {
	
    //운항매뉴얼 총 개수 조회
    int getTotalCount(OpsMnalDTO opsMnalDTO);
    
	//운항매뉴얼 다건 조회
    ArrayList<OpsMnalDTO> selectOpsMnalList(OpsMnalDTO opsMnalDTO);
    
    //운항매뉴얼 단건 조회
    OpsMnalDTO selectOpsMnal(OpsMnalDTO opsMnalDto);
	
	//운항매뉴얼 max조회
	int getMaxArchId();
	
    //운항매뉴얼 등록
    int insertOpsMnal(OpsMnalDTO opsMnalDTO);
    
    //운항매뉴얼 수정
    int updateOpsMnal(OpsMnalDTO opsMnalDTO);
    
    //운항매뉴얼 삭제
    int deleteOpsMnal(OpsMnalDTO opsMnalDTO);    

    //첨부파일 조회
    AtchFileDTO selectAtchFile(int fileId);
    
    //첨부파일 등록
    int insertAtchFile(AtchFileDTO atchFileDTO);

    //첨부파일 삭제
    int deleteAtchFile(int ArchId);    

    // 사용자 정보 조회
    OpsMnalDTO selectUserInfo(String regUserId);
}
