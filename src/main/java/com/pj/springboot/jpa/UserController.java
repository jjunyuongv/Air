package com.pj.springboot.jpa; 

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping 
public class UserController 
{

	// 로그인
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
        try 
        {
            if (user.getId() == null || user.getId().trim().isEmpty() ||
                user.getPassword() == null || user.getPassword().trim().isEmpty() ||
                user.getUsername() == null || user.getUsername().trim().isEmpty() ||
                user.getEmployeeNumber() == null || user.getEmployeeNumber().trim().isEmpty()) 
            {
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
    
    //chat
    @GetMapping("/chat/chatMain")
	public String chatMain()
	{
		return "chat/chatMain";
	}
	
	@GetMapping("/chat/chatWindow.do")
	public String chatWindow(@RequestParam("chatId") String chatId, Model model)
	{
		model.addAttribute("chatId", chatId);
		return "chat/chatWindow";
	}
}