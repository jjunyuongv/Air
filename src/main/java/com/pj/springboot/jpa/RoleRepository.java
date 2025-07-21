package com.pj.springboot.jpa;

/*현석*/


import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional; 

public interface RoleRepository extends JpaRepository<Role, Long> 
{ 
    Optional<Role> findByRoleName(String roleName);
}