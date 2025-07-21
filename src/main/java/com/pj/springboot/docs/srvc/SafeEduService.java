package com.pj.springboot.docs.srvc;

/*혜원*/

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;
import com.pj.springboot.docs.dto.SafeEduDTO;
import com.pj.springboot.docs.dto.AtchFileDTO;

@Mapper
public interface SafeEduService {
	
    //안전교육 총 개수 조회
    int getTotalCount(SafeEduDTO safeEduDTO);
    
	//안전교육 다건 조회
    ArrayList<SafeEduDTO> selectSafeEduList(SafeEduDTO safeEduDTO);
    
    //안전교육 단건 조회
    SafeEduDTO selectSafeEdu(SafeEduDTO safeEduDTO);
	
	//안전교육 max조회
	int getMaxArchId();
	
    //안전교육 등록
    int insertSafeEdu(SafeEduDTO safeEduDTO);
    
    //안전교육 수정
    int updateSafeEdu(SafeEduDTO safeEduDTO);
    
    //안전교육 삭제
    int deleteSafeEdu(SafeEduDTO safeEduDTO);    

    //첨부파일 조회
    AtchFileDTO selectAtchFile(int fileId);
    
    //첨부파일 등록
    int insertAtchFile(AtchFileDTO atchFileDTO);

    //첨부파일 삭제
    int deleteAtchFile(int ArchId);    

    // 사용자 정보 조회
    SafeEduDTO selectUserInfo(String regUserId);
}
