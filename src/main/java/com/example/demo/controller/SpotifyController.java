package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.dto.Album;
import com.example.demo.service.SpotifyService;

@Controller
public class SpotifyController {

    @Autowired
    private SpotifyService spotifyService;

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




    
    
}
