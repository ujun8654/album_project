package com.example.demo.controller;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.example.demo.dto.LoginedMember;
import com.example.demo.service.MemberService;
import com.example.demo.service.SpotifyAuthService;
import com.example.demo.service.SpotifyService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsrSpotifyController {
	
	private final SpotifyAuthService spotifyAuthService;
	private final SpotifyService spotifyService;
	private final MemberService memberService;
	
    public UsrSpotifyController(SpotifyAuthService spotifyAuthService, SpotifyService spotifyService,MemberService memberService) {
    	this.spotifyAuthService = spotifyAuthService;
        this.spotifyService = spotifyService;
        this.memberService = memberService;
    }

    @GetMapping("/spotify/callback")
    public String handleSpotifyCallback(@RequestParam("code") String code,
                                        @RequestParam(value = "state", required = false) String state,
                                        HttpSession session) {
        String accessToken = spotifyService.exchangeCodeForAccessToken(code);
        session.setAttribute("spotifyAccessToken", accessToken);

        try {
            // 사용자 정보 조회
            String userInfoUrl = "https://api.spotify.com/v1/me";
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(accessToken);
            HttpEntity<String> entity = new HttpEntity<>(headers);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.exchange(userInfoUrl, HttpMethod.GET, entity, String.class);

            ObjectMapper mapper = new ObjectMapper();
            JsonNode json = mapper.readTree(response.getBody());
            String profileUrl = json.get("external_urls").get("spotify").asText();

            session.setAttribute("spotifyProfileUrl", profileUrl);

            // ✅ 연동 여부 DB 업데이트
            LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");
            if (loginedMember != null) {
                int memberId = loginedMember.getId();
                memberService.updateSpotifyConnected(memberId); // 연동 여부 true로 저장
                memberService.updateSpotifyProfileUrl(memberId, profileUrl); // 프로필 URL도 DB에 저장
            }

            // 디버깅
            //System.out.println("세션 저장된 토큰: " + accessToken);
            //System.out.println("저장된 프로필 링크: " + profileUrl);

            session.setAttribute("isSpotifyConnected", true);
            session.setAttribute("justConnectedSpotify", true);
            return "redirect:/usr/home/main";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return "redirect:/usr/home/main";
    }

    @GetMapping("/spotify/recent")
    @ResponseBody
    public String getRecentTracks(HttpSession session) {
        String token = (String) session.getAttribute("spotifyAccessToken");

        if (token == null) return "토큰 없음. 연동 안됨";

        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);

        HttpEntity<String> request = new HttpEntity<>(headers);
        RestTemplate restTemplate = new RestTemplate();

        ResponseEntity<String> response = restTemplate.exchange(
            "https://api.spotify.com/v1/me/player/recently-played",
            HttpMethod.GET,
            request,
            String.class
        );

        return response.getBody();
    }
    
    @GetMapping("/spotify/resetPopupFlag")
    @ResponseBody
    public void resetSpotifyPopupFlag(HttpSession session) {
        session.removeAttribute("justConnectedSpotify");
    }



}
