package com.example.demo.controller;

import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.ResultData;
import com.example.demo.service.MemberService;
import com.example.demo.util.Util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/usr/member")
public class UsrMemberController {

	private final MemberService memberService;
	private final Req req;

	@Autowired
	private JavaMailSender mailSender;

	public UsrMemberController(MemberService memberService, Req req) {
		this.memberService = memberService;
		this.req = req;
	}

	@GetMapping("/join")
	public String join() {
		return "usr/member/join";
	}

	@PostMapping("/doJoin")
	public String doJoin(String loginId, String loginPw, String loginPwConfirm, String email, String emailCode, HttpSession session, Model model) {
	    boolean hasError = false;

	    if (loginId == null || loginId.trim().isEmpty()) {
	        model.addAttribute("loginIdError", "아이디를 입력해주세요.");
	        hasError = true;
	    }

	    if (loginPw == null || loginPw.trim().isEmpty()) {
	        model.addAttribute("loginPwError", "비밀번호를 입력해주세요.");
	        hasError = true;
	    }

	    if (loginPwConfirm == null || !loginPw.equals(loginPwConfirm)) {
	        model.addAttribute("loginPwConfirmError", "비밀번호가 일치하지 않습니다.");
	        hasError = true;
	    }

	    if (email == null || email.trim().isEmpty()) {
	        model.addAttribute("emailError", "이메일을 입력해주세요.");
	        hasError = true;
	    }

	    if (emailCode == null || emailCode.trim().isEmpty()) {
	        model.addAttribute("emailCodeError", "인증코드를 입력해주세요.");
	        hasError = true;
	    }

	    if (hasError) {
	        model.addAttribute("loginId", loginId);
	        model.addAttribute("email", email);
	        return "usr/member/join";
	    }

	    String sessionCode = (String) session.getAttribute("emailAuthCode");
	    String sessionEmail = (String) session.getAttribute("emailAuthTarget");

	    if (sessionCode == null || sessionEmail == null || !sessionEmail.equals(email) || !sessionCode.equals(emailCode)) {
	        model.addAttribute("emailCodeError", "이메일 인증코드가 일치하지 않습니다.");
	        model.addAttribute("loginId", loginId);
	        model.addAttribute("email", email);
	        return "usr/member/join";
	    }

	    if (memberService.getMemberByLoginId(loginId) != null) {
	        model.addAttribute("loginIdError", "이미 사용 중인 아이디입니다.");
	        model.addAttribute("email", email);
	        return "usr/member/join";
	    }

	    if (memberService.getMemberByEmail(email) != null) {
	        model.addAttribute("emailError", "이미 사용 중인 이메일입니다.");
	        model.addAttribute("loginId", loginId);
	        return "usr/member/join";
	    }

	    String encryptedPw = Util.encryptSHA256(loginPw);
	    memberService.joinMember(loginId, encryptedPw, email);
	    
	    session.removeAttribute("emailAuthCode");
	    session.removeAttribute("emailAuthTarget");
//디버깅
	    //System.out.println("✅ 회원가입 후 로그아웃 직전 ID: " + req.getLoginedMember().getId());

	    req.logout();

	    //System.out.println("✅ 로그아웃 후 ID: " + req.getLoginedMember().getId());

	    
	    return "redirect:/usr/member/login";
	}






	@PostMapping("/sendEmailCode")
	@ResponseBody
	public Map<String, Object> sendEmailCode(@RequestParam String email, HttpSession session) {
		String code = String.format("%06d", new Random().nextInt(999999));
		session.setAttribute("emailAuthCode", code);
		session.setAttribute("emailAuthTarget", email);

		SimpleMailMessage message = new SimpleMailMessage();
		message.setTo(email);
		message.setSubject("AlbumRate 이메일 인증 코드");
		message.setText("인증코드는 [" + code + "] 입니다. 10분 내로 입력해주세요.");
		mailSender.send(message);

		return Map.of("success", true);
	}

	@GetMapping("/loginIdDupChk")
	@ResponseBody
	public ResultData loginIdDupChk(String loginId) {
		Member member = this.memberService.getMemberByLoginId(loginId);

		if (member != null) {
			return ResultData.from("F-1", String.format("[ %s ] 은(는) 이미 사용중인 아이디입니다", loginId));
		}

		return ResultData.from("S-1", String.format("[ %s ] 은(는) 사용가능한 아이디입니다", loginId));
	}

	@GetMapping("/login")
	public String login(HttpSession session, HttpServletRequest request) {
	    String referer = request.getHeader("Referer");

	    if (referer != null && !referer.contains("/login") && !referer.contains("/join")) {
	        session.setAttribute("redirectAfterLogin", referer);
	    }

	    return "usr/member/login";
	}




	@PostMapping("/doLogin")
	public String doLogin(String loginId, String loginPw, Model model, HttpSession session) {
	    Member member = memberService.getMemberByLoginId(loginId);

	    if (member == null || !member.getLoginPw().equals(Util.encryptSHA256(loginPw))) {
	        model.addAttribute("errorMsg", "아이디 또는 비밀번호가 잘못되었습니다.");
	        return "usr/member/login";
	    }

	    req.login(new LoginedMember(member.getId(), member.getAuthLevel()));

	    // ✅ 스포티파이 연동 여부 세션 저장
	    session.setAttribute("isSpotifyConnected", member.isSpotifyConnected());

	    // ✅ 프로필 URL 세션 저장
	    if (member.getSpotifyProfileUrl() != null) {
	        session.setAttribute("spotifyProfileUrl", member.getSpotifyProfileUrl());
	    }

	    String redirectUri = (String) session.getAttribute("redirectAfterLogin");
	    if (redirectUri != null) {
	        session.removeAttribute("redirectAfterLogin");
	        return "redirect:" + redirectUri;
	    }

	    return "redirect:/";
	}



 

	@GetMapping("/logout")
	public String logout(HttpSession session, HttpServletRequest request) {
	    String referer = request.getHeader("Referer");

	    session.invalidate();

	    if (referer != null && !referer.contains("/logout")) {
	        return "redirect:" + referer;
	    }

	    return "redirect:/usr/home/main";
	}


	@GetMapping("/getLoginId")
	@ResponseBody
	public String getLoginId() {
		return this.memberService.getLoginId(this.req.getLoginedMember().getId());
	}
	
	
}
