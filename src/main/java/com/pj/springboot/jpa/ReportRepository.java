package com.pj.springboot.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.Optional;

public interface ReportRepository extends JpaRepository<Report, Long> 
{
    List<Report> findByAuthorIdOrderByCreatedAtDesc(String authorId);

    Optional<Report> findByIdAndAuthorId(Long id, String authorId);

    List<Report> findByAuthorIdAndReportTypeOrderByCreatedAtDesc(String authorId, String reportType);

    List<Report> findByReportTypeOrderByCreatedAtDesc(String reportType);
}