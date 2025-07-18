package com.pj.springboot.jpa;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam; 
import org.springframework.web.servlet.mvc.support.RedirectAttributes; 
import java.util.List;

@Controller
@RequestMapping
public class UserController 
{

    private final UserService userService;
    private final UserRepository userRepository;

    public UserController(UserService userService, UserRepository userRepository) 
    {
        this.userService = userService;
        this.userRepository = userRepository;
    }

    @GetMapping("/login")
    public String login() 
    {
        return "login";
    }

    @GetMapping("/admin/dashboard")
    public String adminDashboard() 
    {
        return "admin/dashboard";
    }

    @GetMapping("/admin/register-employee")
    public String showRegisterEmployeeForm(Model model) 
    {
        model.addAttribute("user", new User());
        return "admin/registerEmployee";
    }

    @PostMapping("/admin/register-employee")
    public String registerEmployee(@ModelAttribute("user") User user, Model model) 
    {
        try {
            if (user.getId() == null || user.getId().trim().isEmpty() ||
                user.getPassword() == null || user.getPassword().trim().isEmpty() ||
                user.getUsername() == null || user.getUsername().trim().isEmpty() ||
                user.getEmployeeNumber() == null || user.getEmployeeNumber().trim().isEmpty()) {
                model.addAttribute("errorMessage", "직원 ID, 비밀번호, 이름, 사원 번호는 필수 입력 항목입니다.");
                return "admin/registerEmployee";
            }

            userService.registerEmployee(user);
            model.addAttribute("successMessage", "직원 계정이 성공적으로 등록되었습니다!");
            model.addAttribute("user", new User());
            return "admin/registerEmployee";
        } catch (RuntimeException e) 
        {
            model.addAttribute("errorMessage", "직원 등록 중 오류 발생: " + e.getMessage());
            return "admin/registerEmployee";
        }
    }

    @GetMapping("/admin/manage-users")
    public String manageUsers(Model model) 
    {
        List<User> users = userRepository.findAll();
        model.addAttribute("users", users);
        return "admin/manageUsers";
    }

    @GetMapping("/admin/edit-user")
    public String showEditUserForm(@RequestParam("id") String userId, Model model, RedirectAttributes redirectAttributes) 
    {
        try 
        {
            User user = userService.findUserById(userId)
                                  .orElseThrow(() -> new RuntimeException("수정할 사용자를 찾을 수 없습니다."));

            if (userService.isUserAdmin(user)) 
            {
                redirectAttributes.addFlashAttribute("errorMessage", "관리자 계정은 이 화면에서 수정할 수 없습니다.");
                return "redirect:/admin/manage-users";
            }

            model.addAttribute("user", user);
            return "admin/editUser";
        } catch (RuntimeException e) 
        {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/manage-users";
        }
    }

    @PostMapping("/admin/update-user")
    public String updateUser(@ModelAttribute("user") User user, RedirectAttributes redirectAttributes) 
    {
        try 
        {
            if (user.getId() == null || user.getId().trim().isEmpty() ||
                user.getUsername() == null || user.getUsername().trim().isEmpty() ||
                user.getEmployeeNumber() == null || user.getEmployeeNumber().trim().isEmpty()) 
            {
                redirectAttributes.addFlashAttribute("errorMessage", "직원 ID, 이름, 사원 번호는 필수 입력 항목입니다.");
                return "redirect:/admin/edit-user?id=" + user.getId();
            }

            userService.updateUser(user); 
            redirectAttributes.addFlashAttribute("successMessage", "사용자 정보가 성공적으로 업데이트되었습니다!");
            return "redirect:/admin/manage-users";
        } catch (RuntimeException e) 
        {
            redirectAttributes.addFlashAttribute("errorMessage", "사용자 정보 업데이트 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/edit-user?id=" + user.getId();
        }
    }

    @PostMapping("/admin/delete-user")
    public String deleteUser(@RequestParam("id") String userId, RedirectAttributes redirectAttributes) 
    {
        try 
        {
            userService.deleteUser(userId); 
            redirectAttributes.addFlashAttribute("successMessage", "사용자 계정이 성공적으로 삭제되었습니다!");
            return "redirect:/admin/manage-users";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "사용자 삭제 중 오류 발생: " + e.getMessage());
            return "redirect:/admin/manage-users";
        }
    }
    
    @GetMapping("/employee/dashboard")
    public String employeeDashboard() 
    {
        return "employee/dashboard";
    }

    @GetMapping("/access-denied")
    public String accessDenied() 
    {
        return "accessDenied";
    }
}