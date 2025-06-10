package com.example.demo.controller;

import com.example.demo.dto.Album;
import com.example.demo.dto.UserAlbumRating;
import com.example.demo.service.AlbumService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/album")
public class UsrAlbumController {

    private final AlbumService albumService;

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

    @PostMapping("/rate")
    public String addRating(@ModelAttribute UserAlbumRating rating, HttpSession session) {
        int memberId = (int) session.getAttribute("loginedMemberId");
        rating.setMemberId(memberId);
        albumService.addRating(rating);
        return "redirect:/usr/album/detail?id=" + rating.getAlbumId();
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
}