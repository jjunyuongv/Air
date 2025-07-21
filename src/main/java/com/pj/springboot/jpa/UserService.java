package com.pj.springboot.jpa;

/*현석*/


import java.util.Optional;

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

    @Transactional
    public User updateUser(User updatedUser) 
    {
        User existingUser = userRepository.findById(updatedUser.getId())
                                .orElseThrow(() -> new RuntimeException("사용자를 찾을 수 없습니다: " + updatedUser.getId()));

        if (isUserAdmin(existingUser)) 
        {
            throw new RuntimeException("관리자 계정은 이 화면에서 수정할 수 없습니다.");
        }

        if (updatedUser.getPassword() != null && !updatedUser.getPassword().isEmpty()) 
        {
            existingUser.setPassword(passwordEncoder.encode(updatedUser.getPassword()));
        }

        existingUser.setUsername(updatedUser.getUsername());
        existingUser.setEmployeeNumber(updatedUser.getEmployeeNumber());
        existingUser.setDepartment(updatedUser.getDepartment());
        existingUser.setEnabled(updatedUser.isEnabled());

        if (!existingUser.getEmployeeNumber().equals(updatedUser.getEmployeeNumber())) 
        {
            if (userRepository.findByEmployeeNumber(updatedUser.getEmployeeNumber()).isPresent()) 
            {
                throw new RuntimeException("이미 존재하는 사원 번호입니다: " + updatedUser.getEmployeeNumber());
            }
        }
        
        return userRepository.save(existingUser);
    }

    @Transactional
    public void deleteUser(String userId) 
    {
        User userToDelete = userRepository.findById(userId)
                                .orElseThrow(() -> new RuntimeException("삭제할 사용자를 찾을 수 없습니다."));
        
        if (isUserAdmin(userToDelete)) 
        {
            throw new RuntimeException("관리자 계정은 삭제할 수 없습니다.");
        }
        
        userRepository.deleteById(userId);
    }

    public Optional<User> findUserById(String userId) 
    {
        return userRepository.findById(userId);
    }


    public boolean isUserAdmin(User user) 
    {
        return user.getRoles() != null && user.getRoles().stream()
                   .anyMatch(role -> "ROLE_ADMIN".equals(role.getRoleName()));
    }
}