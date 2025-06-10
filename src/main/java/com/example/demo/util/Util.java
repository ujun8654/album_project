package com.example.demo.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class Util {
	public static String jsReplace(String msg, String uri) {
		
		if (msg == null) {
			msg = "";
		}
		
		if (uri == null || uri.length() == 0) {
			uri = "/usr/home/main";
		}
		
		return String.format("""
					<script>
						const msg = '%s'.trim();
						
						if (msg.length > 0) {
							requestAnimationFrame(() => {
								alert(msg);
							})
						}
						
						setTimeout(() => {
							location.replace('%s');
						}, 100);
					</script>
				""", msg, uri);
	}
	
	public static String encryptSHA256(String input) {
        try {
            // SHA-256 알고리즘을 사용하여 MessageDigest 인스턴스 생성
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            
            // 입력 문자열을 바이트 배열로 변환 후 해싱
            byte[] hash = digest.digest(input.getBytes());
            
            // 해싱된 결과를 16진수 문자열로 변환
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b); // 바이트 값을 16진수로 변환
                if (hex.length() == 1) {
                    hexString.append('0'); // 1자리 수인 경우 앞에 0 추가
                }
                hexString.append(hex);
            }
            
            return hexString.toString(); // 최종 16진수 문자열 반환
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 알고리즘을 지원하지 않습니다.", e);
        }
    }
}
