package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Album;
import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Member;
import com.example.demo.dto.Track;
import com.example.demo.service.MemberService;
import com.example.demo.service.SpotifyAuthService;
import com.example.demo.service.SpotifyService;
import com.example.demo.service.UserAlbumRatingService;
import com.example.demo.service.WantAlbumService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SpotifyController {
	
    private final SpotifyService spotifyService;
    private final UserAlbumRatingService userAlbumRatingService;
    private final WantAlbumService wantAlbumService;
    private final SpotifyAuthService spotifyAuthService;
    private final MemberService memberService;

    public SpotifyController(SpotifyService spotifyService, UserAlbumRatingService userAlbumRatingService, WantAlbumService wantAlbumService, SpotifyAuthService spotifyAuthService, MemberService memberService) {
        this.spotifyService = spotifyService;
        this.userAlbumRatingService = userAlbumRatingService;
        this.wantAlbumService = wantAlbumService;
        this.spotifyAuthService = spotifyAuthService;
        this.memberService = memberService;
    }
    @GetMapping("/albums")
    public String showAlbums(Model model) {
        List<Album> newReleases = spotifyService.getNewReleases();
        List<Album> hiphopAlbums = spotifyService.searchAlbumsByGenre("hip-hop");
        List<Album> rnbAlbums = spotifyService.searchAlbumsByGenre("rnb");

        model.addAttribute("newReleases", newReleases);
        model.addAttribute("hiphopAlbums", hiphopAlbums);
        model.addAttribute("rnbAlbums", rnbAlbums);

        return "usr/album/albums";
    }

    @GetMapping("/albums/search")
    public String searchAlbums(@RequestParam("keyword") String keyword,
                               @RequestParam("type") String type,
                               Model model) {
        model.addAttribute("albums", spotifyService.searchAlbumsByTypeWithOffset(keyword, type));
        model.addAttribute("keyword", keyword);
        model.addAttribute("type", type);
        return "usr/album/albums";
    }

    @GetMapping("/albums/{albumId}")
    public String showAlbumDetail(@PathVariable String albumId, HttpSession session, Model model) {
        Album album = spotifyService.getAlbumDetailById(albumId);
        List<Track> tracks = spotifyService.getTracksByAlbumId(albumId);
        album.setTracks(tracks);
        model.addAttribute("album", album);

        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");

        double userRating = 0.0;
        boolean isWanted = false;

        if (loginedMember != null && loginedMember.getId() != 0) {
            int memberId = loginedMember.getId();
            userRating = userAlbumRatingService.getUserRating(memberId, albumId);

            isWanted = wantAlbumService.isWanted(memberId, albumId);
        }

        Double avgRatingObj = userAlbumRatingService.getAverageRating(albumId);
        double avgRating = (avgRatingObj != null) ? avgRatingObj : 0.0;

//디버깅
        // System.out.println("앨범 상세 진입 / 평점 = " + userRating);
        // System.out.println("평균 평점 확인: " + avgRating);
        
        model.addAttribute("userRating", userRating);
        model.addAttribute("avgRating", avgRating);
        model.addAttribute("albumId", albumId);
        model.addAttribute("isWanted", isWanted); 

        return "usr/album/detail";
    }

    
    @PostMapping("/album/{id}/want-toggle")
    @ResponseBody
    public Map<String, Object> toggleWantAlbum(
            @PathVariable("id") String albumId,
            HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");

        if (loginedMember == null || loginedMember.getId() == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return result;
        }

        boolean added = wantAlbumService.toggle(loginedMember.getId(), albumId);
        result.put("success", true);
        result.put("added", added);
        return result;
    }

    @GetMapping("/spotify/login")
    public String redirectToSpotifyAuth() {
        return "redirect:" + spotifyAuthService.getAuthorizationUrl();
    }
    
//    @GetMapping("/spotify/disconnect")
//    public String disconnectSpotify(HttpSession session) {
//        // 세션에서 Spotify 관련 정보 제거
//        session.removeAttribute("spotifyAccessToken");
//        session.removeAttribute("spotifyProfileUrl");
//        session.setAttribute("isSpotifyConnected", false); // 세션에서 false로 설정
//
//        // 로그인된 사용자 정보 확인 후 DB 업데이트
//        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");
//        if (loginedMember != null) {
//            int memberId = loginedMember.getId();
//            memberService.disconnectSpotify(memberId);
//
//            // 기존 LoginedMember 갱신
//            loginedMember.setSpotifyConnected(false);
//            session.setAttribute("loginedMember", loginedMember);
//        }
//
//        // 메인 페이지로 이동
//        return "redirect:/usr/home/main";
//    }


    @GetMapping("/spotify/disconnect")
    public String disconnectSpotify(HttpSession session) {
        session.removeAttribute("spotifyAccessToken");
        session.removeAttribute("spotifyProfileUrl");
        session.setAttribute("isSpotifyConnected", false);

        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");
        if (loginedMember != null) {
            int memberId = loginedMember.getId();
            memberService.disconnectSpotify(memberId);

            Member freshMember = memberService.getMemberById(memberId);
            session.setAttribute("loginedMember", new LoginedMember(
                freshMember.getId(),
                freshMember.getAuthLevel(),
                freshMember.getLoginId(),
                freshMember.getEmail(),
                freshMember.isSpotifyConnected()
            ));
        }

        return "redirect:/usr/home/main";
    }




}
