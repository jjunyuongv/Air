package com.pj.springboot.jpa;

import java.util.List;
import java.util.Optional;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ReportService 
{

    private final ReportRepository reportRepository;
    private final UserService userService;

    public ReportService(ReportRepository reportRepository, UserService userService) 
    {
        this.reportRepository = reportRepository;
        this.userService = userService;
    }

    @Transactional
    public Report createReport(Report report) 
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) 
        {
            throw new RuntimeException("로그인된 사용자만 보고서를 작성할 수 있습니다.");
        }
        String currentUserId = authentication.getName();
        report.setAuthorId(currentUserId);

        if (report.getReportType() == null || report.getReportType().trim().isEmpty()) 
        {
            throw new IllegalArgumentException("보고서 종류를 선택해야 합니다.");
        }

        return reportRepository.save(report);
    }

    public Optional<Report> getReportById(Long reportId) 
    {
        return reportRepository.findById(reportId);
    }

    public List<Report> getMyReports() 
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) 
        {
            throw new RuntimeException("로그인된 사용자 정보를 가져올 수 없습니다.");
        }
        String currentUserId = authentication.getName();
        return reportRepository.findByAuthorIdOrderByCreatedAtDesc(currentUserId);
    }

    public List<Report> getMyReportsByType(String reportType) 
    {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) 
        {
            throw new RuntimeException("로그인된 사용자 정보를 가져올 수 없습니다.");
        }
        String currentUserId = authentication.getName();
        return reportRepository.findByAuthorIdAndReportTypeOrderByCreatedAtDesc(currentUserId, reportType);
    }

    public List<Report> getAllReports() 
    {
        return reportRepository.findAll();
    }

    public List<Report> getAllReportsByType(String reportType) 
    {
        return reportRepository.findByReportTypeOrderByCreatedAtDesc(reportType);
    }

    @Transactional
    public Report updateReport(Report updatedReport) 
    {
        Report existingReport = reportRepository.findById(updatedReport.getId())
                                .orElseThrow(() -> new RuntimeException("보고서를 찾을 수 없습니다: " + updatedReport.getId()));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserId = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"));

        if (!existingReport.getAuthorId().equals(currentUserId) && !isAdmin) 
        {
            throw new RuntimeException("이 보고서를 수정할 권한이 없습니다.");
        }

        existingReport.setTitle(updatedReport.getTitle());
        existingReport.setContent(updatedReport.getContent());
        existingReport.setReportType(updatedReport.getReportType()); 
 
        return reportRepository.save(existingReport);
    }

    @Transactional
    public void deleteReport(Long reportId) 
    {
        Report reportToDelete = reportRepository.findById(reportId)
                                .orElseThrow(() -> new RuntimeException("삭제할 보고서를 찾을 수 없습니다: " + reportId));

        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentUserId = authentication.getName();
        boolean isAdmin = authentication.getAuthorities().stream()
                            .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"));

        if (!reportToDelete.getAuthorId().equals(currentUserId) && !isAdmin) 
        {
            throw new RuntimeException("이 보고서를 삭제할 권한이 없습니다.");
        }

        reportRepository.delete(reportToDelete);
    }
}