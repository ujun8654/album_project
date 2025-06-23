package com.example.demo.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.dto.Req;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedLogoutInterceptor implements HandlerInterceptor {
	
	private Req req;
	
	public NeedLogoutInterceptor(Req req) {
		this.req = req;
	}

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
	        throws Exception {
//디버깅
//	    System.out.println("Interceptor 요청 URI: " + request.getRequestURI());
//	    System.out.println("Interceptor 현재 로그인 ID: " + req.getLoginedMember().getId());

	    if (req.getLoginedMember().getId() != 0) {
//디버깅
//System.out.println("Interceptor 로그인 상태이므로 접근 차단");
	        req.jsPrintReplace("로그아웃 후 이용해주세요", "/");
	        return false;
	    }

//디버깅
//System.out.println("Interceptor 비로그인 상태, 통과 허용");
	    return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
