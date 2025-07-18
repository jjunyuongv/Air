package com.pj.springboot.approval;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.security.Principal;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/approval")
@RequiredArgsConstructor
public class ApprovalController {

    private final ApprovalService approvalService;
    private final AirJourneyUserRepository airJourneyUserRepository;

    @GetMapping("/list")
    public String list(Model model) {
        List<Approval> approvals = approvalService.getAllApprovals();
        model.addAttribute("approvals", approvals);
        return "approval/approvalList";
    }

    @GetMapping("/{approvalNo}")
    public String detail(@PathVariable Long approvalNo, Model model, Principal principal) {
        Approval approval = approvalService.getApproval(approvalNo);
        List<ApprovalLine> approvalLines = approvalService.getApprovalLines(approvalNo);

        model.addAttribute("approval", approval);
        model.addAttribute("approvalLines", approvalLines);
        return "approval/approvalDetail";
    }

    @GetMapping("/form")
    public String form(Model model) {
        model.addAttribute("approval", new Approval());
        return "approval/approvalForm";
    }

    @PostMapping("/form")
    public String save(@ModelAttribute Approval approval, Principal principal) {
        String loginUserId = principal != null ? principal.getName() : "testuser";
        AirJourneyUser user = airJourneyUserRepository.findById(loginUserId)
                .orElseThrow(() -> new IllegalArgumentException("사용자 없음: " + loginUserId));
        approval.setDraftUser(user);
        approval.setCreatedAt(new Date()); // 현재 시간 저장!
        approval.setStatus("DRAFT");
        approvalService.createApproval(approval);
        return "redirect:/approval/list";
    }
}
