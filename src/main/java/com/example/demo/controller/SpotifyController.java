package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Album;
import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Track;
import com.example.demo.service.SpotifyService;
import com.example.demo.service.UserAlbumRatingService;

import jakarta.servlet.http.HttpSession;

@Controller
public class SpotifyController {
	
    private final SpotifyService spotifyService;
    private final UserAlbumRatingService userAlbumRatingService;

    public SpotifyController(SpotifyService spotifyService, UserAlbumRatingService userAlbumRatingService) {
        this.spotifyService = spotifyService;
        this.userAlbumRatingService = userAlbumRatingService;
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
        if (loginedMember != null) {
            int memberId = loginedMember.getId();
            userRating = userAlbumRatingService.getUserRating(memberId, albumId);
        }
//디버깅
        //System.out.println("앨범 상세 진입 / 평점 = " + userRating);

        model.addAttribute("userRating", userRating);
        model.addAttribute("albumId", albumId);

        return "usr/album/detail";
    }


}
