package com.pj.springboot.jpa; 

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.UserDetailsService; 
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import java.util.stream.Collectors; 

@Configuration
@EnableWebSecurity
public class SecurityConfig 
{

    private final UserRepository userRepository; 

    public SecurityConfig(UserRepository userRepository) 
    {
        this.userRepository = userRepository;
    }

    @Bean
    public PasswordEncoder passwordEncoder() 
    {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public UserDetailsService userDetailsService() 
    {
        return username -> {
            User user = userRepository.findById(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
     
            return new org.springframework.security.core.userdetails.User(
                user.getId(),
                user.getPassword(),
                user.isEnabled(),
                true,
                true, 
                true, 
                user.getRoles().stream()
                    .map(role -> new org.springframework.security.core.authority.SimpleGrantedAuthority(role.getRoleName()))
                    .collect(Collectors.toSet())
            );
        };
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception 
    {
        http
            .authorizeHttpRequests(authorize -> authorize
                .requestMatchers("/admin/**").hasRole("ADMIN") 
                .requestMatchers("/employee/**").hasAnyRole("EMPLOYEE", "ADMIN") 
                .requestMatchers("/login", "/error", "/css/**", "/js/**", "/images/**", "/favicon.ico", "/WEB-INF/**").permitAll()
                .anyRequest().authenticated() 
            )
            .formLogin(form -> form
                .loginPage("/login") 
                .successHandler(customAuthenticationSuccessHandler()) 
                .permitAll() 
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout") 
                .permitAll() 
            )
            .exceptionHandling(exceptions -> exceptions
                .accessDeniedPage("/access-denied")
            )
            .csrf(csrf -> csrf.disable());

        return http.build();
    }

    @Bean
    public AuthenticationSuccessHandler customAuthenticationSuccessHandler() 
    {
        return (request, response, authentication) -> 
        {
            boolean isAdmin = authentication.getAuthorities().stream()
                    .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_ADMIN"));
            boolean isEmployee = authentication.getAuthorities().stream()
                    .anyMatch(grantedAuthority -> grantedAuthority.getAuthority().equals("ROLE_EMPLOYEE"));

            if (isAdmin) 
            {
                response.sendRedirect("/admin/dashboard");
            } else if (isEmployee) 
            {
                response.sendRedirect("/employee/dashboard");
            } else 
            {
                response.sendRedirect("/default/dashboard");
            }
        };
    }
}