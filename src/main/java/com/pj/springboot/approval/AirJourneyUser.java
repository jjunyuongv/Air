package com.pj.springboot.approval;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "AIR_JOURNEY_USERS")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AirJourneyUser {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "PASSWORD")
    private String password;

    @Column(name = "USERNAME")
    private String username;

    @Column(name = "EMPLOYEE_NUMBER")
    private String employeeNumber;

    @Column(name = "DEPARTMENT")
    private String department;

    @Column(name = "ENABLED")
    private Integer enabled;
}
