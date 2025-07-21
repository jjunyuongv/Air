package com.pj.springboot.docs.ctrl;

/*혜원*/

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
import com.pj.springboot.docs.dto.CbnSrvcDTO;
import com.pj.springboot.docs.srvc.CbnSrvcService;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
public class CbnSrvcController {

    @Autowired
    CbnSrvcService dao;
	
    // 기내서비스 화면 리턴
    @RequestMapping("/docs/cbnSrvc.do")
    public String retrieveCbnSrvc(Model model, HttpServletRequest req, CbnSrvcDTO cbnSrvcDTO) {
    	
    	// 페이징 처리
		int totalCount = dao.getTotalCount(cbnSrvcDTO);
		int pageSize = 9;
		int blockPage = 5;
		int pageNum = (req.getParameter("pageNum")==null 
			|| req.getParameter("pageNum").equals("")) 
			? 1 : Integer.parseInt(req.getParameter("pageNum"));		 
		int start = (pageNum-1) * pageSize + 1;
		int end = pageNum * pageSize;
		
		cbnSrvcDTO.setStart(start);
		cbnSrvcDTO.setEnd(end);
		
		// View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장 
		Map<String, Object> pagingData = new HashMap<String, Object>();
		pagingData.put("totalCount", totalCount);
		pagingData.put("pageSize", pageSize);
		pagingData.put("pageNum", pageNum);
		model.addAttribute("pagingData", pagingData);
		
	    ArrayList<CbnSrvcDTO> cbnSrvcList = dao.selectCbnSrvcList(cbnSrvcDTO);
	    model.addAttribute("lists", cbnSrvcList);
	    model.addAttribute("srchType", cbnSrvcDTO.getSrchType());
	    model.addAttribute("srchWord", cbnSrvcDTO.getSrchWord());
		
	    //페이징 처리  
		String pagingImg =
			PagingUtil.pagingImg(totalCount, pageSize, 
				blockPage, pageNum,
				req.getContextPath()+"/docs/cbnSrvc.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		return "docs/cbnSrvc";       
	}
	
	// 기내서비스 상세화면 조회
	@RequestMapping("/docs/cbnSrvcSpec.do")
	public String retrieveCbnSrvcSpec(@RequestParam("archId") int archId, Model model) {

		CbnSrvcDTO cbnSrvcDto = new CbnSrvcDTO();
		cbnSrvcDto.setArchId(archId);
	    
		CbnSrvcDTO resultData = dao.selectCbnSrvc(cbnSrvcDto);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        resultData.setUserId(authentication.getName());
        
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/cbnSrvcSpec";
	}

	// 기내서비스 수정하기 화면 조회
	@RequestMapping("/docs/cbnSrvcEdit.do")
	public String retrieveCbnSrvcEdit(@RequestParam("archId") int archId, Model model) {

		CbnSrvcDTO cbnSrvcDto = new CbnSrvcDTO();
		cbnSrvcDto.setArchId(archId);
	    
		CbnSrvcDTO resultData = dao.selectCbnSrvc(cbnSrvcDto);
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/cbnSrvcEdit";
	}

	// 기내서비스 등록 화면 조회
	@RequestMapping("/docs/cbnSrvcReg.do")
	public String cbnSrvcReg(@RequestParam("regUserId") String regUserId, @RequestParam("department") String department, Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName();
        CbnSrvcDTO userInfo = dao.selectUserInfo(userId); 
		
		model.addAttribute("modelData",userInfo);
		
		return "docs/cbnSrvcReg";
	}

	// 기내서비스 등록
	@PostMapping("/docs/cbnSrvcInsert.do")
	public String insertCbnSrvc(Model model, HttpServletRequest req, CbnSrvcDTO cbnSrvcDTO) {
		
		dao.insertCbnSrvc(cbnSrvcDTO);

		MultipartFile file = cbnSrvcDTO.getFileUpload();
	    if (file != null && !file.isEmpty()) {
	    	dao.insertAtchFile(uploadFileDTO(req, cbnSrvcDTO));
	    }

	    return "redirect:cbnSrvc.do";
	}

	// 기내서비스 수정
	@PostMapping("/docs/cbnSrvcUpdate.do")
	public String updateCbnSrvc(Model model, HttpServletRequest req, CbnSrvcDTO cbnSrvcDTO) {

		dao.updateCbnSrvc(cbnSrvcDTO);

		MultipartFile file = cbnSrvcDTO.getFileUpload();
		if(file != null && !file.isEmpty()) {
			dao.deleteAtchFile(cbnSrvcDTO.getArchId());
	        dao.insertAtchFile(uploadFileDTO(req, cbnSrvcDTO));
	    }
		
		if((file == null || file.isEmpty()) && cbnSrvcDTO.getFileId().isEmpty()) {
			dao.deleteAtchFile(cbnSrvcDTO.getArchId());
		}
		
	    return "redirect:cbnSrvc.do";
	}
	
	// 기내서비스 삭제
	@PostMapping("/docs/cbnSrvcDel.do")
	public String deleteCbnSrvc(HttpServletRequest req) {
		CbnSrvcDTO cbnSrvcDto = new CbnSrvcDTO();
		cbnSrvcDto.setArchId(Integer.parseInt(req.getParameter("archId")));
		
		dao.deleteCbnSrvc(cbnSrvcDto);
		return "redirect:cbnSrvc.do";
	}
	
	// 파일 업로드
	private AtchFileDTO uploadFileDTO(HttpServletRequest req, CbnSrvcDTO cbnSrvcDTO) {

        AtchFileDTO atchFileDTO = new AtchFileDTO();
        
		MultipartFile file = cbnSrvcDTO.getFileUpload();
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
            atchFileDTO.setRegUserId(cbnSrvcDTO.getRegUserId());         // 게시글 ID

        } catch (IOException e) {
            e.printStackTrace();
        }
	    return atchFileDTO;
	}
}