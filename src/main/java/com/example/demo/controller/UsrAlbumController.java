package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.Album;
import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.ResultData;
import com.example.demo.service.AlbumService;
import com.example.demo.service.SpotifyService;
import com.example.demo.service.UserAlbumRatingService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/album")
public class UsrAlbumController {

    private final AlbumService albumService;
    private final SpotifyService spotifyService;
    private UserAlbumRatingService userAlbumRatingService;

    @GetMapping("/list")
    public String showList(Model model) {
        model.addAttribute("albums", albumService.getAllAlbums());
        return "album/list";
    }

    @GetMapping("/detail")
    public String showDetail(@RequestParam int id, Model model) {
        model.addAttribute("album", albumService.getAlbumById(id));
        model.addAttribute("ratings", albumService.getRatingsByAlbumId(id));
        return "album/detail";
    }

    @GetMapping("/add")
    public String showAddForm() {
        return "album/add";
    }

    @PostMapping("/add")
    public String addAlbum(@ModelAttribute Album album) {
        albumService.addAlbum(album);
        return "redirect:/usr/album/list";
    }
    
    @GetMapping("/spotify/{spotifyId}")
    public String showDetailBySpotifyId(@PathVariable String spotifyId, Model model) {
        Album album = spotifyService.getAlbumDetail(spotifyId);  
        album.setTracks(spotifyService.getTracksByAlbumId(spotifyId));
        model.addAttribute("album", album);
        return "usr/album/detail";
    }

    @PostMapping("/albums/{albumId}/rate")
    @ResponseBody
    public ResultData rateAlbum(@PathVariable String  albumId,
                                @RequestParam int rating,
                                HttpSession session) {
        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");

        if (loginedMember == null) {
            return ResultData.from("F-AUTH", "로그인이 필요합니다.");
        }

        int memberId = loginedMember.getId();

        userAlbumRatingService.saveOrUpdate(memberId, albumId, rating);

        return ResultData.from("S-1", "평점이 저장되었습니다.");
    }



    
}