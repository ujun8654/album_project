package com.example.demo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.dto.AlbumComment;
import com.example.demo.dto.LoginedMember;
import com.example.demo.dto.Member;
import com.example.demo.dto.Req;
import com.example.demo.dto.ResultData;
import com.example.demo.service.AlbumCommentService;
import com.example.demo.service.MemberService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/usr/album/comment")
@RequiredArgsConstructor
public class UsrAlbumCommentController {
	
	@Autowired
	private MemberService memberService;

    private final AlbumCommentService albumCommentService;
    private final Req req;

    
    @PostMapping("/write")
    @ResponseBody
    public ResultData write(@RequestParam String albumId, @RequestParam String content) {
        LoginedMember loginedMember = req.getLoginedMember();

        if (loginedMember == null || loginedMember.getId() == 0) {
            return ResultData.from("F-1", "로그인이 필요합니다.");
        }

        Member member = memberService.getMemberById(loginedMember.getId());

        albumCommentService.writeComment(albumId, member.getId(), content);

        Map<String, Object> data = new HashMap<>();
        data.put("writerName", member.getLoginId());  //

        return ResultData.from("S-1", "코멘트가 작성되었습니다.", data);
    }
    
    @GetMapping("/list")
    @ResponseBody
    public List<AlbumComment> getComments(@RequestParam String albumId) {
        return albumCommentService.getComments(albumId);
    }


}
