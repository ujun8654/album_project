package com.example.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.demo.dao.AlbumCommentDao;
import com.example.demo.dto.AlbumComment;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AlbumCommentService {

    private final AlbumCommentDao albumCommentDao;

    public void writeComment(String albumId, int memberId, String content) {
        albumCommentDao.insertComment(albumId, memberId, content);
    }

    public List<AlbumComment> getComments(String albumId) {
        return albumCommentDao.getCommentsByAlbumId(albumId);
    }
}
