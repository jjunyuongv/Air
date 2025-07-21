package com.pj.springboot.voc.ctrl;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.pj.springboot.docs.dto.AtchFileDTO;
import com.pj.springboot.voc.dto.VocDTO;
import com.pj.springboot.voc.srvc.VocService;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
public class VocController {

    @Autowired
    VocService dao;
	
    // 고객응대 화면 리턴
    @RequestMapping("/voc/voc.do")
    public String retrieveVoc(Model model, HttpServletRequest req, VocDTO vocDTO) {
    	
    	// 페이징 처리
		int totalCount = dao.getTotalCount(vocDTO);
		int pageSize = 9;
		int blockPage = 5;
		int pageNum = (req.getParameter("pageNum")==null 
			|| req.getParameter("pageNum").equals("")) 
			? 1 : Integer.parseInt(req.getParameter("pageNum"));		 
		int start = (pageNum-1) * pageSize + 1;
		int end = pageNum * pageSize;
		
		vocDTO.setStart(start);
		vocDTO.setEnd(end);
		
		// View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장 
		Map<String, Object> pagingData = new HashMap<String, Object>();
		pagingData.put("totalCount", totalCount);
		pagingData.put("pageSize", pageSize);
		pagingData.put("pageNum", pageNum);
		model.addAttribute("pagingData", pagingData);
		
	    ArrayList<VocDTO> vocList = dao.selectVocList(vocDTO);
	    model.addAttribute("lists", vocList);
	    model.addAttribute("srchType", vocDTO.getSrchType());
	    model.addAttribute("srchWord", vocDTO.getSrchWord());
		
	    //페이징 처리  
		String pagingImg =
			PagingUtil.pagingImg(totalCount, pageSize, 
				blockPage, pageNum,
				req.getContextPath()+"/docs/voc.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		return "/voc/voc";       
	}
	
	// 고객응대 상세화면 조회
	@RequestMapping("/docs/vocSpec.do")
	public String retrieveVocSpec(@RequestParam("archId") int archId, Model model) {

		VocDTO vocDto = new VocDTO();
		vocDto.setArchId(archId);
	    
		VocDTO resultData = dao.selectVoc(vocDto);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        resultData.setUserId(authentication.getName());
        
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/vocSpec";
	}

	// 고객응대 수정하기 화면 조회
	@RequestMapping("/docs/vocEdit.do")
	public String retrieveVocEdit(@RequestParam("archId") int archId, Model model) {

		VocDTO vocDto = new VocDTO();
		vocDto.setArchId(archId);
	    
		VocDTO resultData = dao.selectVoc(vocDto);
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/vocEdit";
	}

	// 고객응대 등록 화면 조회
	@RequestMapping("/docs/vocReg.do")
	public String vocReg(@RequestParam("regUserId") String regUserId, @RequestParam("department") String department, Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName();
        VocDTO userInfo = dao.selectUserInfo(userId); 
		
		model.addAttribute("modelData",userInfo);
		
		return "docs/vocReg";
	}

	// 고객응대 등록
	@PostMapping("/docs/vocInsert.do")
	public String insertVoc(Model model, HttpServletRequest req, VocDTO vocDTO) {
		
		dao.insertVoc(vocDTO);

		MultipartFile file = vocDTO.getFileUpload();
	    if (file != null && !file.isEmpty()) {
	    	dao.insertAtchFile(uploadFileDTO(req, vocDTO));
	    }

	    return "redirect:voc.do";
	}

	// 고객응대 수정
	@PostMapping("/docs/vocUpdate.do")
	public String updateVoc(Model model, HttpServletRequest req, VocDTO vocDTO) {

		dao.updateVoc(vocDTO);

		MultipartFile file = vocDTO.getFileUpload();
		if(file != null && !file.isEmpty()) {
			dao.deleteAtchFile(vocDTO.getArchId());
	        dao.insertAtchFile(uploadFileDTO(req, vocDTO));
	    }
		
		if((file == null || file.isEmpty()) && vocDTO.getFileId().isEmpty()) {
			dao.deleteAtchFile(vocDTO.getArchId());
		}
		
	    return "redirect:voc.do";
	}
	
	// 고객응대 삭제
	@PostMapping("/docs/vocDel.do")
	public String deleteVoc(HttpServletRequest req) {
		VocDTO vocDto = new VocDTO();
		vocDto.setArchId(Integer.parseInt(req.getParameter("archId")));
		
		dao.deleteVoc(vocDto);
		return "redirect:voc.do";
	}
	
	// 파일 업로드
	private AtchFileDTO uploadFileDTO(HttpServletRequest req, VocDTO vocDTO) {

        AtchFileDTO atchFileDTO = new AtchFileDTO();
        
		MultipartFile file = vocDTO.getFileUpload();
        try {
            // 원본 파일명
            String originalName = file.getOriginalFilename();

            // 파일 확장자
            String ext = originalName.substring(originalName.lastIndexOf(".") + 1);

            // 저장할 파일명 (UUID + 확장자)
            String saveName = UUID.randomUUID() + "." + ext;

            // 논리경로 (DB 기준), 물리경로 (서버 파일시스템 기준)
            String logiPath = "/upload/" + saveName;
            String physPath = req.getServletContext().getRealPath(logiPath + "+++" + originalName);

            // 저장 디렉토리 없으면 생성
            File uploadDir = new File(req.getServletContext().getRealPath("/upload"));
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // 실제 파일 저장
            file.transferTo(new File(physPath));
            
            int maxArchId = dao.getMaxArchId();
            
            atchFileDTO.setArchId(maxArchId);        
            atchFileDTO.setLogiPath(logiPath);        
            atchFileDTO.setPhysPath(physPath);        
            atchFileDTO.setRegUserId(vocDTO.getRegUserId());         // 게시글 ID

        } catch (IOException e) {
            e.printStackTrace();
        }
	    return atchFileDTO;
	}
}