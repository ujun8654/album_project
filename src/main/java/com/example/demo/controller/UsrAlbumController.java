package com.example.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.ResultData;
import com.example.demo.service.UserAlbumRatingService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/usr/album")
public class UsrAlbumController {

    private final UserAlbumRatingService userAlbumRatingService;

    @PostMapping("/albums/{albumId}/rate")
    @ResponseBody
    public ResultData rateAlbum(@PathVariable String albumId, @RequestParam double rating, HttpSession session) {
        LoginedMember loginedMember = (LoginedMember) session.getAttribute("loginedMember");
//디버깅
//        System.out.println("albumId = " + albumId);
//        System.out.println("rating = " + rating);

        if (loginedMember == null) {
            return ResultData.from("F-AUTH", "로그인이 필요합니다.");
        }

        int memberId = loginedMember.getId();
        userAlbumRatingService.saveOrUpdate(memberId, albumId, rating);

        return ResultData.from("S-1", "평점이 저장되었습니다.");
    }
    




}




    
