package com.pj.springboot.jpa;

import java.util.HashSet;
import java.util.Set;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Table(name = "AIR_JOURNEY_USERS")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class User 
{
    @Id
    @Column(name = "ID")
    private String id; 

    @Column(name = "PASSWORD", nullable = false)
    private String password;

    @Column(name = "USERNAME", nullable = false)
    private String username;

    @Column(name = "EMPLOYEE_NUMBER", unique = true) 
    private String employeeNumber;

    @Column(name = "DEPARTMENT")
    private String department;

    @Column(name = "ENABLED", nullable = false)
    private boolean enabled = true;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "USER_ROLES",
        joinColumns = @JoinColumn(name = "USER_ID"),
        inverseJoinColumns = @JoinColumn(name = "ROLE_ID")
    )
    private Set<Role> roles = new HashSet<>();

    public void addRole(Role role) 
    {
    	if (this.roles == null)
    	{
    		this.roles = new HashSet<>();
    	}
    	this.roles.add(role);
    }
    public void removeRole(Role role) 
    {
    	if (this.roles != null)
    	{
    		this.roles.remove(role);
    	}
    }
}