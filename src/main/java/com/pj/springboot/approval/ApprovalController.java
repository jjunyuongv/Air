package com.pj.springboot.approval;

/*준영*/

import java.util.*;
import java.security.Principal;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.pj.springboot.jdbc.ParameterDTO;
import com.pj.springboot.utils.PagingUtil;

import jakarta.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/approval")
@RequiredArgsConstructor
public class ApprovalController {

    private final ApprovalService service;    

    @GetMapping("/list")
    public String list(Model model,
                       @RequestParam(defaultValue = "1") int pageNum,
                       ParameterDTO param,
                       HttpServletRequest req) {

        final int pageSize = 10, blockPage = 5;
        param.setStart((pageNum - 1) * pageSize + 1);
        param.setEnd(pageNum * pageSize);

        int total              = service.getTotalCount(param);
        List<ApprovalDTO> list = service.listPage(param);

        model.addAttribute("maps", Map.of(
                "totalCount", total,
                "pageSize",   pageSize,
                "pageNum",    pageNum));
        model.addAttribute("lists", list);
        model.addAttribute("pagingImg",
                PagingUtil.pagingImg(total, pageSize, blockPage, pageNum,
                        req.getContextPath() + "/approval/list?"));

        return "approval/list";
    }

    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("approval", new ApprovalDTO());
        return "approval/write";
    }

    @PostMapping("/write")
    public String write(@ModelAttribute ApprovalDTO dto, Principal principal) {
        dto.setDraftUserId(principal.getName());
        dto.setStatus("DRAFT");
        service.create(dto);
        return "redirect:/approval/list";
    }

    @GetMapping("/view")
    public String view(@RequestParam Long approvalNo, Model model) {
        model.addAttribute("approval", service.view(approvalNo));
        return "approval/view";
    }

    @GetMapping("/edit")
    public String editForm(@RequestParam Long approvalNo, Model model) {
        model.addAttribute("approval", service.view(approvalNo));
        return "approval/edit";
    }

    @PostMapping("/edit")
    public String edit(@ModelAttribute ApprovalDTO dto, Principal principal) {
        dto.setDraftUserId(principal.getName());
        service.update(dto);
        return "redirect:/approval/view?approvalNo=" + dto.getApprovalNo();
    }

    @PostMapping("/approve")
    public String approve(@RequestParam Long approvalNo, Principal principal) {
        service.changeStatus(approvalNo, "APPROVED", principal.getName());
        return "redirect:/approval/list";
    }

    @PostMapping("/reject")
    public String reject(@RequestParam Long approvalNo, Principal principal) {
        service.changeStatus(approvalNo, "REJECTED", principal.getName());
        return "redirect:/approval/list";
    }

    @PostMapping("/delete")
    public String delete(@RequestParam Long approvalNo) {
        service.delete(approvalNo);
        return "redirect:/approval/list";
    }
}
