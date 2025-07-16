package com.pj.springboot.jpa;


import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


@Service
public class UserService 
{
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, RoleRepository roleRepository, PasswordEncoder passwordEncoder) 
    {
        this.userRepository = userRepository;
        this.roleRepository = roleRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User registerEmployee(User employee) 
    {
        if (userRepository.existsById(employee.getId())) 
        {
            throw new RuntimeException("이미 존재하는 직원 ID입니다: " + employee.getId());
        }

        if (employee.getEmployeeNumber() != null && userRepository.findByEmployeeNumber(employee.getEmployeeNumber()).isPresent()) 
        {
            throw new RuntimeException("이미 존재하는 사원 번호입니다: " + employee.getEmployeeNumber());
        }

        employee.setPassword(passwordEncoder.encode(employee.getPassword()));

        Role employeeRole = roleRepository.findByRoleName("ROLE_EMPLOYEE")
                                .orElseThrow(() -> new IllegalStateException("필수 역할 'ROLE_EMPLOYEE'가 데이터베이스에 존재하지 않습니다. ROLES 테이블에 해당 역할을 추가해야 합니다."));
        employee.addRole(employeeRole);

        employee.setEnabled(true);

        return userRepository.save(employee);
    }
}