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
import com.pj.springboot.docs.dto.OpsMnalDTO;
import com.pj.springboot.docs.srvc.OpsMnalService;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping
public class OpsMnalController {

    @Autowired
    OpsMnalService dao;
    
    // 운항매뉴얼 화면 리턴
    @RequestMapping("/docs/opsMnal.do")
    public String retrieveOpsMnal(Model model, HttpServletRequest req, OpsMnalDTO opsMnalDTO) {
    	
    	// 페이징 처리
		int totalCount = dao.getTotalCount(opsMnalDTO);
		int pageSize = 9; 
		int blockPage = 5;
		int pageNum = (req.getParameter("pageNum")==null 
			|| req.getParameter("pageNum").equals("")) 
			? 1 : Integer.parseInt(req.getParameter("pageNum"));		 
		int start = (pageNum-1) * pageSize + 1;
		int end = pageNum * pageSize;
		
		opsMnalDTO.setStart(start);
		opsMnalDTO.setEnd(end);
		
		// View에서 게시물의 가상번호 계산을 위한 값을 Map에 저장 
		Map<String, Object> pagingData = new HashMap<String, Object>();
		pagingData.put("totalCount", totalCount);
		pagingData.put("pageSize", pageSize);
		pagingData.put("pageNum", pageNum);
		model.addAttribute("pagingData", pagingData);
		
	    ArrayList<OpsMnalDTO> opsMnalList = dao.selectOpsMnalList(opsMnalDTO);
	    model.addAttribute("lists", opsMnalList);
	    model.addAttribute("srchType", opsMnalDTO.getSrchType());
	    model.addAttribute("srchWord", opsMnalDTO.getSrchWord());
		
	    //페이징 처리  
		String pagingImg =
			PagingUtil.pagingImg(totalCount, pageSize, 
				blockPage, pageNum,
				req.getContextPath()+"/docs/opsMnal.do?");
		model.addAttribute("pagingImg", pagingImg);
		
		return "docs/opsMnal";       
	}
	
	// 운항매뉴얼 상세화면 조회
	@RequestMapping("/docs/opsMnalSpec.do")
	public String retrieveOpsMnalSpec(@RequestParam("archId") int archId, Model model) {

		OpsMnalDTO opsMnalDto = new OpsMnalDTO();
		opsMnalDto.setArchId(archId);
	    
		OpsMnalDTO resultData = dao.selectOpsMnal(opsMnalDto);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        resultData.setUserId(authentication.getName());
        
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/opsMnalSpec";
	}

	// 운항매뉴얼 수정하기 화면 조회
	@RequestMapping("/docs/opsMnalEdit.do")
	public String retrieveOpsMnalEdit(@RequestParam("archId") int archId, Model model) {

		OpsMnalDTO opsMnalDto = new OpsMnalDTO();
		opsMnalDto.setArchId(archId);
	    
		OpsMnalDTO resultData = dao.selectOpsMnal(opsMnalDto);
	    model.addAttribute("modelData", resultData);
	    
	    return "docs/opsMnalEdit";
	}

	// 운항매뉴얼 등록 화면 조회
	@RequestMapping("/docs/opsMnalReg.do")
	public String opsMnalReg(@RequestParam("regUserId") String regUserId, @RequestParam("department") String department, Model model) {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getName();
        OpsMnalDTO userInfo = dao.selectUserInfo(userId); 
		
		model.addAttribute("modelData",userInfo);
		
		return "docs/opsMnalReg";
	}

	// 운항매뉴얼 등록
	@PostMapping("/docs/opsMnalInsert.do")
	public String insertOpsMnal(Model model, HttpServletRequest req, OpsMnalDTO opsMnalDTO) {
		
		dao.insertOpsMnal(opsMnalDTO);

		MultipartFile file = opsMnalDTO.getFileUpload();
	    if (file != null && !file.isEmpty()) {
	    	dao.insertAtchFile(uploadFileDTO(req, opsMnalDTO));
	    }

	    return "redirect:opsMnal.do";
	}

	// 운항매뉴얼 수정
	@PostMapping("/docs/opsMnalUpdate.do")
	public String updateOpsMnal(Model model, HttpServletRequest req, OpsMnalDTO opsMnalDTO) {

		dao.updateOpsMnal(opsMnalDTO);

		MultipartFile file = opsMnalDTO.getFileUpload();
		if(file != null && !file.isEmpty()) {
			dao.deleteAtchFile(opsMnalDTO.getArchId());
	        dao.insertAtchFile(uploadFileDTO(req, opsMnalDTO));
	    }
		
		if((file == null || file.isEmpty()) && opsMnalDTO.getFileId().isEmpty()) {
			dao.deleteAtchFile(opsMnalDTO.getArchId());
		}
		
	    return "redirect:opsMnal.do";
	}
	
	// 운항매뉴얼 삭제
	@PostMapping("/docs/opsMnalDel.do")
	public String deleteOpsMnal(HttpServletRequest req) {
		OpsMnalDTO opsMnalDto = new OpsMnalDTO();
		opsMnalDto.setArchId(Integer.parseInt(req.getParameter("archId")));
		
		dao.deleteOpsMnal(opsMnalDto);
		return "redirect:opsMnal.do";
	}
	
	// 파일 업로드
	private AtchFileDTO uploadFileDTO(HttpServletRequest req, OpsMnalDTO opsMnalDTO) {

        AtchFileDTO atchFileDTO = new AtchFileDTO();
        
		MultipartFile file = opsMnalDTO.getFileUpload();
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
            atchFileDTO.setRegUserId(opsMnalDTO.getRegUserId());         // 게시글 ID

        } catch (IOException e) {
            e.printStackTrace();
        }
	    return atchFileDTO;
	}
}