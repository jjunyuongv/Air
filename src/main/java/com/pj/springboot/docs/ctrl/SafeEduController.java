package com.pj.springboot.docs.ctrl;

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
import com.pj.springboot.docs.dto.SafeEduDTO;
import com.pj.springboot.docs.srvc.SafeEduService;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
public class SafeEduController {

    @Autowired
    SafeEduService dao;
    
    // 운항매뉴얼 화면 리턴
    @RequestMapping("/docs/safeEdu.do")
    public String retrieveSafeEdu(Model model, HttpServletRequest req, SafeEduDTO safeEduDTO) {
    	
    	// 페이징 처리
		int totalCount = dao.getTotalCount(safeEduDTO);
		int pageSize = 9; 
		int blockPage = 5;
		int pageNum = (req.getParameter("pageNum")==null 
			|| req.getParameter("pageNum").equals("")) 
			? 1 : Integer.parseInt(req.getParameter("pageNum"));		 
		int start = (pageNum-1) * pageSize + 1;
		int end = pageNum * pageSize;
		
		safeEduDTO.setStart(start);
		safeEduDTO.setEnd(end);
		
		// View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장 
		Map<String, Object> pagingData = new HashMap<String, Object>();
		pagingData.put("totalCount", totalCount);
		pagingData.put("pageSize", pageSize);
		pagingData.put("pageNum", pageNum);
		model.addAttribute("pagingData", pagingData);
		
	    ArrayList<SafeEduDTO> safeEduList = dao.selectSafeEduList(safeEduDTO);
	    model.addAttribute("lists", safeEduList);
	    model.addAttribute("srchType", safeEduDTO.getSrchType());
	    model.addAttribute("srchWord", safeEduDTO.getSrchWord());
		
	    //페이징 처리  
		String pagingImg =
			PagingUtil.pagingImg(totalCount, pageSize, 
				blockPage, pageNum,
				req.getContextPath()+"/docs/safeEdu.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		return "docs/safeEdu";       
	}
	
	// 운항매뉴얼 상세화면 조회
	@RequestMapping("/docs/safeEduSpec.do")
	public String retrieveSafeEduSpec(@RequestParam("archId") int archId, Model model) {

		SafeEduDTO safeEduDto = new SafeEduDTO();
		safeEduDto.setArchId(archId);
	    
		SafeEduDTO resultData = dao.selectSafeEdu(safeEduDto);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        resultData.setUserId(authentication.getName());
        
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/safeEduSpec";
	}

	// 운항매뉴얼 수정하기 화면 조회
	@RequestMapping("/docs/safeEduEdit.do")
	public String retrieveSafeEduEdit(@RequestParam("archId") int archId, Model model) {

		SafeEduDTO safeEduDto = new SafeEduDTO();
		safeEduDto.setArchId(archId);
	    
		SafeEduDTO resultData = dao.selectSafeEdu(safeEduDto);
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/safeEduEdit";
	}

	// 운항매뉴얼 등록 화면 조회
	@RequestMapping("/docs/safeEduReg.do")
	public String safeEduReg(@RequestParam("regUserId") String regUserId, @RequestParam("department") String department, Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName();
        SafeEduDTO userInfo = dao.selectUserInfo(userId); 
		
		model.addAttribute("modelData",userInfo);
		
		return "docs/safeEduReg";
	}

	// 운항매뉴얼 등록
	@PostMapping("/docs/safeEduInsert.do")
	public String insertSafeEdu(Model model, HttpServletRequest req, SafeEduDTO safeEduDTO) {
		
		dao.insertSafeEdu(safeEduDTO);

		MultipartFile file = safeEduDTO.getFileUpload();
	    if (file != null && !file.isEmpty()) {
	    	dao.insertAtchFile(uploadFileDTO(req, safeEduDTO));
	    }

	    return "redirect:safeEdu.do";
	}

	// 운항매뉴얼 수정
	@PostMapping("/docs/safeEduUpdate.do")
	public String updateSafeEdu(Model model, HttpServletRequest req, SafeEduDTO safeEduDTO) {

		dao.updateSafeEdu(safeEduDTO);

		MultipartFile file = safeEduDTO.getFileUpload();
		if(file != null && !file.isEmpty()) {
			dao.deleteAtchFile(safeEduDTO.getArchId());
	        dao.insertAtchFile(uploadFileDTO(req, safeEduDTO));
	    }
		
		if((file == null || file.isEmpty()) && safeEduDTO.getFileId().isEmpty()) {
			dao.deleteAtchFile(safeEduDTO.getArchId());
		}
		
	    return "redirect:safeEdu.do";
	}
	
	// 운항매뉴얼 삭제
	@PostMapping("/docs/safeEduDel.do")
	public String deleteSafeEdu(HttpServletRequest req) {
		SafeEduDTO safeEduDto = new SafeEduDTO();
		safeEduDto.setArchId(Integer.parseInt(req.getParameter("archId")));
		
		dao.deleteSafeEdu(safeEduDto);
		return "redirect:safeEdu.do";
	}
	
	// 파일 업로드
	private AtchFileDTO uploadFileDTO(HttpServletRequest req, SafeEduDTO safeEduDTO) {

        AtchFileDTO atchFileDTO = new AtchFileDTO();
        
		MultipartFile file = safeEduDTO.getFileUpload();
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
            atchFileDTO.setRegUserId(safeEduDTO.getRegUserId());         // 게시글 ID

        } catch (IOException e) {
            e.printStackTrace();
        }
	    return atchFileDTO;
	}
}