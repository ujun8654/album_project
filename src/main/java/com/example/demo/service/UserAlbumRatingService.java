package com.example.demo.service;

import com.example.demo.dao.UserAlbumRatingDao;
import com.example.demo.dto.UserAlbumRating;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserAlbumRatingService {

    @Autowired
    private UserAlbumRatingDao userAlbumRatingDao;

    public void saveOrUpdate(int memberId, String albumId, double rating) {
        UserAlbumRating existing = userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);

        if (existing != null) {
            // 🔥 수정: 더 이상 DTO 객체 넘기지 않고 파라미터 방식으로 넘긴다
            System.out.println("update >> albumId = " + albumId);
            System.out.println("update >> rating = " + rating);
            userAlbumRatingDao.update(memberId, albumId, rating);
        } else {
            // 🔥 디버깅 로그 유지
            System.out.println("insert >> albumId = " + albumId);
            System.out.println("insert >> rating = " + rating);
            userAlbumRatingDao.save(memberId, albumId, rating);
        }
    }


    public Double getAverageRating(String albumId) {
        return userAlbumRatingDao.getAverageRating(albumId);
    }

    public UserAlbumRating getUserRating(int memberId, String albumId) {
        return userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);
    }
}
