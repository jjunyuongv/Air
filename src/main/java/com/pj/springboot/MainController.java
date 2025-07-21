package com.pj.springboot;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.pj.springboot.jdbc.BoardDTO;
import com.pj.springboot.jdbc.IBoardService;
import com.pj.springboot.jdbc.ParameterDTO;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class MainController {

    @GetMapping("/")
    public String home(Model model) {
        return "home"; 
    }
    
    @Autowired
	IBoardService dao;
    
    @RequestMapping("/list.do")
	public String boardList(Model model, HttpServletRequest req, 
			ParameterDTO parameterDTO) {

		int totalCount = dao.getTotalCount(parameterDTO);
		
		//페이징을 위한 설정값(하드코딩)
		//페이지 당 출력할 게시물의 갯수
		int pageSize = 10; 
		//한 블록당 출력할 페이지번호의 갯수 
		int blockPage = 5; 
		
		/* 목록에 첫 진입시에는 페이지번호가 없으므로 무조건 1로 설정하고, 파라미터로
		전달된 페이지번호가 있다면 받은후 정수로 변경한다. */
		int pageNum = (req.getParameter("pageNum")==null 
			|| req.getParameter("pageNum").equals("")) 
			? 1 : Integer.parseInt(req.getParameter("pageNum"));
		
		//현제 페이지에 출력할 게시물의 구간을 계산한다. 
		int start = (pageNum-1) * pageSize + 1;
		int end = pageNum * pageSize;
		//계산의 결과는 DTO에 저장한다. 
		parameterDTO.setStart(start);
		parameterDTO.setEnd(end);
		
		//View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장 
		Map<String, Object> maps = new HashMap<String, Object>();
		maps.put("totalCount", totalCount);
		maps.put("pageSize", pageSize);
		maps.put("pageNum", pageNum);
		model.addAttribute("maps", maps);
		
		//DB에서 인출한 게시물의 목록을 Model에 저장 
	      ArrayList<BoardDTO> lists = dao.listPage(parameterDTO);

	      model.addAttribute("lists", lists);
	      System.out.println("리스트 사이즈::::::");
	      System.out.println(lists.size());
	      System.out.println("리스트::::::");
	      for(int i = 0; i < lists.size(); i++ ) {
	         System.out.println(lists.get(i));
	      }
		
		//게시판 하단에 출력할 페이지번호를 String으로 저장한 후 Model에 저장
		String pagingImg =
			PagingUtil.pagingImg(totalCount, pageSize, 
				blockPage, pageNum,
				req.getContextPath()+"/list.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		//View로 포워드한다. 
		return "docs/list";       
	}
	
	//입력1 : 작성 페이지 매핑 
	@GetMapping("/write.do")
	public String boardWriteGet(Model model)
	{
		return "docs/write";
	}
	
	//입력2 : 사용자가 작성한 값으로 입력 처리 
	@PostMapping("write.do")
	public String boardWritePost(Model model, HttpServletRequest req)
	{
	    BoardDTO dto = new BoardDTO();

        dto.setArchType(req.getParameter("archType"));
        dto.setArchTitle(req.getParameter("archTitle"));
        dto.setArchCtnt(req.getParameter("archCtnt"));


        // 현재 날짜, 시간 포맷
        String nowDate = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String nowTime = new SimpleDateFormat("HHmmss").format(new Date());

        // 기본값 세팅: 수정일자 = 등록일자 = 오늘, 수정자 = 등록자 (임시값 예: "admin" or 세션에서 가져오기)
        dto.setUdtDt(nowDate);
        dto.setUdtTm(nowTime);
        dto.setUdtUserId(req.getParameter("regUserId")); // TODO: 실제 로그인 사용자 아이디로 대체 필요

        dto.setRegDt(nowDate);
        dto.setRegTm(nowTime);
        dto.setRegUserId(req.getParameter("regUserId")); // TODO: 실제 로그인 사용자 아이디로 대체 필요     
        
	    int result = dao.write(dto);
	    return "redirect:list.do";
	}
	
	//열람 : 파라미터로 전달되는 idx를 커맨드객체를 통해 받음 
	@RequestMapping("view.do")
	public String boardView(Model model, BoardDTO boardDTO)
	{
		boardDTO = dao.view(boardDTO);
		//가져온 레코드에서 내용부분은 줄바꿈 처리한다. 
		boardDTO.setArchCtnt(boardDTO.getArchCtnt().replace("\r\n", "<br/>"));
		//모델에 저장 후 JSP로 포워드 
		model.addAttribute("boardDTO", boardDTO);
		return "docs/view";
	}
	
	//수정1 : 기존 내용을 읽어와서 수정폼에 설정 
	@GetMapping("/edit.do")
	public String boardEditGet(Model model, BoardDTO boardDTO)
	{
		//열람에서 사용했던 메서드를 그대로 호출 
		boardDTO = dao.view(boardDTO);
		model.addAttribute("boardDTO", boardDTO);
		return "docs/edit";
	}
	//수정2 : 사용자가 입력한 내용을 전송하여 update처리
	@PostMapping("/edit.do")
	public String boardEditPost(BoardDTO boardDTO)
	{
		//수정 후 결과는 int형으로 반환.
		int result = dao.edit(boardDTO);
//		System.out.println("글수정결과:"+result);
		//수정이 완료되면 열람페이지로 이동. 일련번호가 파라미터로 전달됨. 
		return "redirect:view.do?archId="+boardDTO.getArchId();
	}
	
	//삭제 : request 내장객체를 통해 폼값 받음 
	@PostMapping("delete.do")
	public String boardDeletePost(HttpServletRequest req)
	{
	    String archIdParam = req.getParameter("archId");

	    if (archIdParam == null || archIdParam.trim().isEmpty()) {
	        System.out.println("삭제 실패: archId 파라미터가 null 또는 빈 문자열입니다.");
	        return "redirect:list.do"; // 또는 오류 페이지로 처리
	    }

	    int archId = Integer.parseInt(archIdParam); 
	    int result = dao.delete(archId);

	    return "redirect:list.do";
	}

}