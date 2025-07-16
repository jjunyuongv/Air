package com.pj.springboot;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@SpringBootApplication
public class AirApplication {

	public static void main(String[] args) {
		SpringApplication.run(AirApplication.class, args);
	
		// ★★★ 임시 코드: 관리자 비밀번호 인코딩 ★★★
//		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
//		String rawPassword = "1234"; // 당신이 사용할 관리자 비밀번호
//		String encodedPassword = encoder.encode(rawPassword);
//		System.out.println("인코딩된 관리자 비밀번호: " + encodedPassword);
//        // 이 애플리케이션을 실행하면 콘솔에 인코딩된 비밀번호가 출력됩니다.
//        // 출력된 값을 복사하여 다음 SQL INSERT 문에 사용하세요.
//        // ★★★ 사용 후에는 이 임시 코드를 다시 삭제하거나 주석 처리하는 것을 잊지 마세요! ★★★
	
	}

}
