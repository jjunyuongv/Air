package com.pj.springboot.jdbc;

import lombok.Data;

@Data
public class BoardDTO 
{
    private int archId;         // 문서 ID
    private String archType;     // 문서 유형 (CHAR 2)
    private String archTitle;    // 글 제목
    private String archCtnt;     // 글 내용
    private String udtDt;        // 수정 일자 (YYYYMMDD)
    private String udtTm;        // 수정 시각 (HHMISS)
    private String udtUserId;    // 수정 사용자 ID
    private String regDt;        // 등록 일자 (YYYYMMDD)
    private String regTm;        // 등록 시각 (HHMISS)
    private String regUserId;    // 등록 사용자 ID

}