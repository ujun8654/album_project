package com.example.demo.interceptor;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import com.example.demo.dto.Req;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Component
public class NeedLoginInterceptor implements HandlerInterceptor {
	
	private Req req;
	
	public NeedLoginInterceptor(Req req) {
		this.req = req;
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
	        throws Exception {
		//디버깅
		//System.out.println("컨트롤러 접근함");

	    String currentUri = request.getRequestURI();

	    if (req.getLoginedMember().getId() == 0) {
	        if (currentUri.equals("/usr/member/users")) {
	            response.sendRedirect("/");
	            return false;
	        }

	        req.jsPrintReplace("로그인 후 이용해주세요", "/usr/member/login");
	        return false;
	    }

	    return HandlerInterceptor.super.preHandle(request, response, handler);
	}
}
