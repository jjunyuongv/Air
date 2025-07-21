package com.pj.springboot.docs.ctrl;

/*혜원*/

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.pj.springboot.docs.dto.AtchFileDTO;

import jakarta.servlet.http.HttpServletResponse;
import com.pj.springboot.docs.srvc.OpsMnalService;

@Controller
@RequestMapping
public class CommonController {

    @Autowired
    OpsMnalService dao;
	
//	@GetMapping("/")
//    public String home(Model model) {
//        return "home"; 
//    }
    
    // 대쉬보드 화면 리턴
    @GetMapping("/docs/dashboard.do")
    public String archDashboard() 
    {
        return "docs/dashboard";
    }

	@PostMapping("/docs/fileDownload.do")
	public void downloadFile(@RequestParam("fileId") int fileId,@RequestParam("fileNm") String fileNm, HttpServletResponse res) throws IOException {
	    AtchFileDTO atchFileDTO = dao.selectAtchFile(fileId); // 파일 ID로 정보 조회

	    if (atchFileDTO != null) {
			File file = new File(atchFileDTO.getPhysPath());
			
			if (!file.exists()) {
			    res.sendError(HttpServletResponse.SC_NOT_FOUND);
			    return;
			}
			res.setContentType("application/octet-stream");
			
			String encodedFileName = URLEncoder.encode(fileNm, "UTF-8").replaceAll("\\+", "%20");
			
			res.setHeader("Content-Disposition", "attachment; filename=\"" + encodedFileName + "\"");
			
			Files.copy(file.toPath(), res.getOutputStream());
			res.getOutputStream().flush();
        } 
	}
}
