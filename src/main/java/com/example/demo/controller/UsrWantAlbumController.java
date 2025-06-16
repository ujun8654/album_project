package com.example.demo.controller;

import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.demo.dto.Album;
import com.example.demo.dto.LoginedMember;
import com.example.demo.service.SpotifyService;
import com.example.demo.service.WantAlbumService;

@Controller
public class UsrWantAlbumController {

    @Autowired
    private WantAlbumService wantAlbumService;

    @Autowired
    private SpotifyService spotifyService;

    @GetMapping("/album/wishlist")
    public String showWishlist(HttpSession session, Model model) {
        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");

        if (loginedMember == null || loginedMember.getId() == 0) {
            return "redirect:/usr/member/login";
        }

        int memberId = loginedMember.getId();
        List<String> albumIds = wantAlbumService.getWantedAlbumIdsByMemberId(memberId);
        List<Album> albums = new ArrayList<>();

        for (String albumId : albumIds) {
            Album album = spotifyService.getAlbumDetailById(albumId);
            if (album != null) {
                albums.add(album);
            }
        }

        model.addAttribute("wishAlbums", albums);

        return "usr/album/wishlist";
    }
}
