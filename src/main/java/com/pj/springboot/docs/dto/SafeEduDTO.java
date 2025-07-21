package com.pj.springboot.docs.dto;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

/**
 *  안전교육 DTO
 */
@Data
public class SafeEduDTO 
{
    private int archId;          	// 문서 ID  		
    private String archType = "30"; // 문서 유형 		
    private String archTitle;    	// 글 제목   		
    private String archCtnt;     	// 글 내용   		
    private String regDt;        	// 등록 일자 		
    private String regUserId;    	// 등록 사용자 ID	
    private String department;    	// 부서	        
    private String fileId;    		// 파일 ID	      
    private String fileNm;        	// 파일명
    
    private String srchType;     	// 검색 타입 구분
    private String srchWord;        // 검색어

	private MultipartFile fileUpload;

	private String userId;
	
	//게시물의 구간을 표현하는 멤버변수 
	private int start;
	private int end;
}