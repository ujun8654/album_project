package com.example.demo.controller;

import com.example.demo.dto.Album;
import com.example.demo.dto.UserAlbumRating;
import com.example.demo.service.AlbumService;
import com.example.demo.service.SpotifyService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/album")
public class UsrAlbumController {

    private final AlbumService albumService;
    private final SpotifyService spotifyService;

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
    

        

	@PostMapping("/rate")
	@ResponseBody
	public ResponseEntity<?> saveRating(@RequestBody UserAlbumRating rating, HttpSession session) {
		Integer memberId = (Integer) session.getAttribute("loginedMemberId");
		if (memberId == null)
			return ResponseEntity.status(401).build();

		rating.setMemberId(memberId);
		albumService.addRating(rating);
		return ResponseEntity.ok().build();
	}



    
}