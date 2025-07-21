package com.pj.springboot.docs.dto;

import lombok.Data;

/**
 * 첨부파일 DTO
 */
@Data
public class AtchFileDTO 
{
    private int fileId;          	// 파일 ID  		
    private int archId;          	// 문서 ID  		
    private String logiPath; 		// 논리 경로 		
    private String physPath;    	// 물리 경로 		
    private String regUserId;    	// 등록 사용자 ID
}