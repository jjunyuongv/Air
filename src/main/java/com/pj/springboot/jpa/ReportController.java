package com.pj.springboot.jpa;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.Optional;
import java.util.HashMap;

@Controller
@RequestMapping
public class ReportController {

    private final ReportService reportService;

    private static final String DAILY_WEEKLY_SAFETY = "DAILY_WEEKLY_SAFETY";
    private static final String AIRCRAFT_ANOMALY = "AIRCRAFT_ANOMALY";
    private static final String FLIGHT_GROUND_STATUS = "FLIGHT_GROUND_STATUS";

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    // 보고서 객체를 Map으로 변환하여 날짜 필드를 String으로 포맷팅하는 헬퍼 메서드
    private List<Map<String, Object>> convertReportsToDisplayMap(List<Report> reports) {
        return reports.stream().map(report -> {
            Map<String, Object> map = new HashMap<>();
            map.put("id", report.getId());
            map.put("title", report.getTitle());
            map.put("content", report.getContent());
            map.put("reportType", report.getReportType());
            map.put("authorId", report.getAuthorId());
            map.put("createdAt", report.getCreatedAt() != null ? report.getCreatedAt().format(DATE_TIME_FORMATTER) : null);
            map.put("updatedAt", report.getUpdatedAt() != null ? report.getUpdatedAt().format(DATE_TIME_FORMATTER) : null);
            return map;
        }).collect(Collectors.toList());
    }

    // 단일 보고서 객체를 Map으로 변환 (열람 페이지에서 사용)
    private Map<String, Object> convertReportToDisplayMap(Report report) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", report.getId());
        map.put("title", report.getTitle());
        map.put("content", report.getContent());
        map.put("reportType", report.getReportType());
        map.put("authorId", report.getAuthorId());
        map.put("createdAt", report.getCreatedAt() != null ? report.getCreatedAt().format(DATE_TIME_FORMATTER) : null);
        map.put("updatedAt", report.getUpdatedAt() != null ? report.getUpdatedAt().format(DATE_TIME_FORMATTER) : null);
        return map;
    }


    // --- 직원 보고서 기능 ---

    @GetMapping("/employee/reports/create")
    public String showCreateReportForm(Model model) {
        model.addAttribute("report", new Report());
        model.addAttribute("reportTypes", new String[][]{
            {"DAILY_WEEKLY_SAFETY", "일일/주간 안전 리포트"},
            {"AIRCRAFT_ANOMALY", "항공기 이상 보고서"},
            {"FLIGHT_GROUND_STATUS", "운항/지상 상황 보고"}
        });
        return "employee/createReport";
    }

    @PostMapping("/employee/reports/create")
    public String createReport(@ModelAttribute("report") Report report, RedirectAttributes redirectAttributes) {
        try {
            if (report.getTitle() == null || report.getTitle().trim().isEmpty() ||
                report.getContent() == null || report.getContent().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "제목과 내용을 입력해주세요.");
                return "redirect:/employee/reports/create";
            }
            reportService.createReport(report);
            redirectAttributes.addFlashAttribute("successMessage", "보고서가 성공적으로 작성되었습니다!");
            return "redirect:/employee/reports/my-reports/" + report.getReportType().toLowerCase().replace("_", "-");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/employee/reports/create";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 작성 중 오류 발생: " + e.getMessage());
            return "redirect:/employee/reports/create";
        }
    }

    @GetMapping("/employee/reports/my-reports")
    public String myReports(Model model) {
        List<Report> myReports = reportService.getMyReports();
        model.addAttribute("reports", convertReportsToDisplayMap(myReports));
        model.addAttribute("reportTypeDisplayName", "모든");
        return "employee/myReports";
    }

    @GetMapping("/employee/reports/my-reports/daily-weekly-safety")
    public String myDailyWeeklySafetyReports(Model model) {
        List<Report> reports = reportService.getMyReportsByType(DAILY_WEEKLY_SAFETY);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "일일/주간 안전");
        model.addAttribute("currentReportType", DAILY_WEEKLY_SAFETY);
        return "employee/myReportsByType";
    }

    @GetMapping("/employee/reports/my-reports/aircraft-anomaly")
    public String myAircraftAnomalyReports(Model model) {
        List<Report> reports = reportService.getMyReportsByType(AIRCRAFT_ANOMALY);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "항공기 이상");
        model.addAttribute("currentReportType", AIRCRAFT_ANOMALY);
        return "employee/myReportsByType";
    }

    @GetMapping("/employee/reports/my-reports/flight-ground-status")
    public String myFlightGroundStatusReports(Model model) {
        List<Report> reports = reportService.getMyReportsByType(FLIGHT_GROUND_STATUS);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "운항/지상 상황");
        model.addAttribute("currentReportType", FLIGHT_GROUND_STATUS);
        return "employee/myReportsByType";
    }

    // ★★★ 새로운 매핑: 보고서 열람 (직원용) ★★★
    @GetMapping("/employee/reports/view")
    public String viewReport(@RequestParam("id") Long reportId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Report report = reportService.getReportById(reportId)
                                        .orElseThrow(() -> new RuntimeException("보고서를 찾을 수 없습니다."));
            model.addAttribute("report", convertReportToDisplayMap(report)); // Map으로 변환하여 전달
            return "employee/viewReport"; // 새로운 JSP 파일
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 열람 중 오류 발생: " + e.getMessage());
            // 어떤 목록에서 왔는지 알 수 없으므로, 기본 내 보고서 목록으로 리다이렉트
            return "redirect:/employee/reports/my-reports";
        }
    }

    @GetMapping("/employee/reports/edit")
    public String showEditReportForm(@RequestParam("id") Long reportId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Report report = reportService.getReportById(reportId)
                                        .orElseThrow(() -> new RuntimeException("보고서를 찾을 수 없습니다."));

            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String currentUserId = authentication.getName();
            if (!report.getAuthorId().equals(currentUserId)) {
                redirectAttributes.addFlashAttribute("errorMessage", "다른 사용자의 보고서는 수정할 수 없습니다.");
                return "redirect:/employee/reports/my-reports";
            }

            model.addAttribute("report", report);
            model.addAttribute("reportTypes", new String[][]{
                {"DAILY_WEEKLY_SAFETY", "일일/주간 안전 리포트"},
                {"AIRCRAFT_ANOMALY", "항공기 이상 보고서"},
                {"FLIGHT_GROUND_STATUS", "운항/지상 상황 보고"}
            });
            return "employee/editReport";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 수정 폼 로드 중 오류 발생: " + e.getMessage());
            return "redirect:/employee/reports/my-reports";
        }
    }

    @PostMapping("/employee/reports/update")
    public String updateReport(@ModelAttribute("report") Report report, RedirectAttributes redirectAttributes) {
        try {
            if (report.getTitle() == null || report.getTitle().trim().isEmpty() ||
                report.getContent() == null || report.getContent().trim().isEmpty() ||
                report.getReportType() == null || report.getReportType().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "모든 필드를 입력해주세요.");
                return "redirect:/employee/reports/edit?id=" + report.getId();
            }
            reportService.updateReport(report);
            redirectAttributes.addFlashAttribute("successMessage", "보고서가 성공적으로 업데이트되었습니다!");
            return "redirect:/employee/reports/my-reports/" + report.getReportType().toLowerCase().replace("_", "-");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 업데이트 중 오류 발생: " + e.getMessage());
            return "redirect:/employee/reports/edit?id=" + report.getId();
        }
    }

    @PostMapping("/employee/reports/delete")
    public String deleteReport(@RequestParam("id") Long reportId, RedirectAttributes redirectAttributes) {
        try {
            reportService.deleteReport(reportId);
            redirectAttributes.addFlashAttribute("successMessage", "보고서가 성공적으로 삭제되었습니다!");
            return "redirect:/employee/reports/my-reports";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 삭제 중 오류 발생: " + e.getMessage());
            return "redirect:/employee/reports/my-reports";
        }
    }


    // --- 관리자 보고서 기능 ---

    @GetMapping("/admin/reports/all-reports")
    public String allReports(Model model) {
        List<Report> allReports = reportService.getAllReports();
        model.addAttribute("reports", convertReportsToDisplayMap(allReports));
        model.addAttribute("reportTypeDisplayName", "모든");
        return "admin/allReports";
    }

    @GetMapping("/admin/reports/all-reports/daily-weekly-safety")
    public String allDailyWeeklySafetyReports(Model model) {
        List<Report> reports = reportService.getAllReportsByType(DAILY_WEEKLY_SAFETY);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "일일/주간 안전");
        model.addAttribute("currentReportType", DAILY_WEEKLY_SAFETY);
        return "admin/allReportsByType";
    }

    @GetMapping("/admin/reports/all-reports/aircraft-anomaly")
    public String allAircraftAnomalyReports(Model model) {
        List<Report> reports = reportService.getAllReportsByType(AIRCRAFT_ANOMALY);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "항공기 이상");
        model.addAttribute("currentReportType", AIRCRAFT_ANOMALY);
        return "admin/allReportsByType";
    }

    @GetMapping("/admin/reports/all-reports/flight-ground-status")
    public String allFlightGroundStatusReports(Model model) {
        List<Report> reports = reportService.getAllReportsByType(FLIGHT_GROUND_STATUS);
        model.addAttribute("reports", convertReportsToDisplayMap(reports));
        model.addAttribute("reportTypeDisplayName", "운항/지상 상황");
        model.addAttribute("currentReportType", FLIGHT_GROUND_STATUS);
        return "admin/allReportsByType";
    }

    // ★★★ 새로운 매핑: 보고서 열람 (관리자용) ★★★
    @GetMapping("/admin/reports/view")
    public String viewAdminReport(@RequestParam("id") Long reportId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Report report = reportService.getReportById(reportId)
                                        .orElseThrow(() -> new RuntimeException("보고서를 찾을 수 없습니다."));
            model.addAttribute("report", convertReportToDisplayMap(report)); // Map으로 변환하여 전달
            return "admin/viewReport"; // 새로운 JSP 파일
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 열람 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/reports/all-reports";
        }
    }

    @GetMapping("/admin/reports/edit")
    public String showAdminEditReportForm(@RequestParam("id") Long reportId, Model model, RedirectAttributes redirectAttributes) {
        try {
            Report report = reportService.getReportById(reportId)
                                        .orElseThrow(() -> new RuntimeException("보고서를 찾을 수 없습니다."));
            model.addAttribute("report", report);
            model.addAttribute("reportTypes", new String[][]{
                {"DAILY_WEEKLY_SAFETY", "일일/주간 안전 리포트"},
                {"AIRCRAFT_ANOMALY", "항공기 이상 보고서"},
                {"FLIGHT_GROUND_STATUS", "운항/지상 상황 보고"}
            });
            return "admin/editReport";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 수정 폼 로드 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/reports/all-reports";
        }
    }

    @PostMapping("/admin/reports/update")
    public String updateAdminReport(@ModelAttribute("report") Report report, RedirectAttributes redirectAttributes) {
        try {
            if (report.getTitle() == null || report.getTitle().trim().isEmpty() ||
                report.getContent() == null || report.getContent().trim().isEmpty() ||
                report.getReportType() == null || report.getReportType().trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "모든 필드를 입력해주세요.");
                return "redirect:/admin/reports/edit?id=" + report.getId();
            }
            reportService.updateReport(report);
            redirectAttributes.addFlashAttribute("successMessage", "보고서가 성공적으로 업데이트되었습니다!");
            return "redirect:/admin/reports/all-reports/" + report.getReportType().toLowerCase().replace("_", "-");
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 업데이트 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/reports/edit?id=" + report.getId();
        }
    }

    @PostMapping("/admin/reports/delete")
    public String deleteAdminReport(@RequestParam("id") Long reportId, RedirectAttributes redirectAttributes) {
        try {
            reportService.deleteReport(reportId);
            redirectAttributes.addFlashAttribute("successMessage", "보고서가 성공적으로 삭제되었습니다!");
            return "redirect:/admin/reports/all-reports";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "보고서 삭제 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/reports/all-reports";
        }
    }
}