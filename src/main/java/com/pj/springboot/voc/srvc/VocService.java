package com.pj.springboot.voc.srvc;

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.voc.dto.VocDTO;
import com.pj.springboot.docs.dto.AtchFileDTO;

@Mapper
public interface VocService {
	
    //고객응대 총 개수 조회
    int getTotalCount(VocDTO ovocDTO);
    
	//고객응대 다건 조회
    ArrayList<VocDTO> selectVocList(VocDTO ovocDTO);
    
    //고객응대 단건 조회
    VocDTO selectVoc(VocDTO ovocDto);
	
	//고객응대 max조회
	int getMaxArchId();
	
    //고객응대 등록
    int insertVoc(VocDTO ovocDTO);
    
    //고객응대 수정
    int updateVoc(VocDTO ovocDTO);
    
    //고객응대 삭제
    int deleteVoc(VocDTO ovocDTO);    

    //첨부파일 조회
    AtchFileDTO selectAtchFile(int fileId);
    
    //첨부파일 등록
    int insertAtchFile(AtchFileDTO atchFileDTO);

    //첨부파일 삭제
    int deleteAtchFile(int ArchId);    

    // 사용자 정보 조회
    VocDTO selectUserInfo(String regUserId);
}
