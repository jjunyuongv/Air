package com.pj.springboot.jdbc;

/*혜원*/

import java.util.ArrayList;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface IBoardService {

    // 작성
    int write(BoardDTO boardDTO);

    // 목록 조회
    int getTotalCount(ParameterDTO parameterDTO);
    ArrayList<BoardDTO> listPage(ParameterDTO parameterDTO);

    // 열람
    BoardDTO view(BoardDTO boardDTO);

    // 수정
    int edit(BoardDTO boardDTO);

    // 삭제
    int delete(Integer archId);
}
