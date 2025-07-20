package com.pj.springboot.approval;

import java.util.*;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.pj.springboot.jdbc.ParameterDTO;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/approval")
@RequiredArgsConstructor          // ⇒ 생성자 주입
public class ApprovalController {

    /* ① BoardService → ApprovalService   (인터페이스 이름 원하는 대로) */
    private final IApprovalService service;

    /*──────────────── 목록 ────────────────*/
    @GetMapping("/list")
    public String list(Model model,
                       HttpServletRequest req,
                       ParameterDTO param) {

        int totalCount = service.getTotalCount(param);

        final int pageSize = 10, blockPage = 5;
        int pageNum = Optional.ofNullable(req.getParameter("pageNum"))
                              .filter(s -> !s.isBlank())
                              .map(Integer::parseInt)
                              .orElse(1);

        param.setStart((pageNum - 1) * pageSize + 1);
        param.setEnd(pageNum * pageSize);

        /* ② BoardDTO → ApprovalDTO */
        List<ApprovalDTO> lists = service.listPage(param);

        model.addAttribute("maps", Map.of(
            "totalCount", totalCount,
            "pageSize",   pageSize,
            "pageNum",    pageNum));
        model.addAttribute("lists", lists);

        String pagingImg = PagingUtil.pagingImg(
            totalCount, pageSize, blockPage, pageNum,
            req.getContextPath() + "/approval/list?");
        model.addAttribute("pagingImg", pagingImg);

        return "approval/list";
    }

    /*──────────────── 작성 화면 ────────────*/
    @GetMapping("/write")
    public String writeForm() {
        return "approval/write";
    }

    /*──────────────── 작성 처리 ────────────*/
    @PostMapping("/write")
    public String write(HttpServletRequest req) {

        ApprovalDTO dto = new ApprovalDTO();
        dto.setDraftUserId(req.getParameter("draftUserId"));   // 로그인 ID
        dto.setTitle      (req.getParameter("title"));
        dto.setContent    (req.getParameter("content"));
        dto.setCategory   (req.getParameter("category"));
        dto.setStatus("DRAFT");

        service.create(dto);
        return "redirect:/approval/list";
    }

    /*──────────────── 상세 ────────────────*/
    @GetMapping("/view")
    public String view(@RequestParam Long approvalNo, Model model) {
        model.addAttribute("approval", service.view(approvalNo));
        return "approval/view";
    }

    /*──────────────── 수정 화면 ────────────*/
    @GetMapping("/edit")
    public String editForm(@RequestParam Long approvalNo, Model model) {
        model.addAttribute("approval", service.view(approvalNo));
        return "approval/edit";
    }

    /*──────────────── 수정 처리 ────────────*/
    @PostMapping("/edit")
    public String edit(ApprovalDTO dto) {
        service.update(dto);
        return "redirect:/approval/view?approvalNo=" + dto.getApprovalNo();
    }

    /*──────────────── 삭제 ────────────────*/
    @PostMapping("/delete")
    public String delete(@RequestParam Long approvalNo) {
        service.delete(approvalNo);
        return "redirect:/approval/list";
    }
}
