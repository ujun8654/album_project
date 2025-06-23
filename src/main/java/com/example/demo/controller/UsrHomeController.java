package com.example.demo.controller;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.dto.Album;
import com.example.demo.dto.LoginedMember;
import com.example.demo.service.AlbumCommentService;
import com.example.demo.service.MemberService;
import com.example.demo.service.SpotifyAuthService;
import com.example.demo.service.SpotifyService;
import com.example.demo.service.UserAlbumRatingService;
import com.example.demo.service.WantAlbumService;

import jakarta.servlet.http.HttpSession;

@Controller
public class UsrHomeController {
	
	private final SpotifyService spotifyService;
	
    public UsrHomeController(SpotifyService spotifyService) {
        this.spotifyService = spotifyService;
    }
	
    @GetMapping("/usr/home/main")
    public String showMain(HttpSession session, Model model) {
        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");

        if (loginedMember != null && loginedMember.isConnectedToSpotify()) {
            String accessToken = spotifyService.ensureValidAccessToken(session);
            if (accessToken != null) {
                model.addAttribute("recentAlbums", spotifyService.getRecentlyPlayedAlbums(accessToken));
                model.addAttribute("topAlbums", spotifyService.getTopAlbums(accessToken));
            }
        } else {
            model.addAttribute("recentAlbums", Collections.emptyList());
            model.addAttribute("topAlbums", Collections.emptyList());
        }

        return "usr/home/main";
    }





	
	@GetMapping("/")
	public String showRoot() {
		return "redirect:/usr/home/main";
	}
	
	
}