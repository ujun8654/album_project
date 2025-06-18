package com.example.demo.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Service;

import com.example.demo.dao.UserAlbumRatingDao;
import com.example.demo.dto.UserAlbumRating;

@Service
public class UserAlbumRatingService {

    @Autowired
    private UserAlbumRatingDao userAlbumRatingDao;
    

    public void saveOrUpdate(int memberId, String albumId, double rating) {
        UserAlbumRating existing = userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);

        if (existing != null) {
//디버깅
//            System.out.println("update >> albumId = " + albumId);
//            System.out.println("update >> rating = " + rating);
            userAlbumRatingDao.update(memberId, albumId, rating);
        } else {
//디버깅
//            System.out.println("insert >> albumId = " + albumId);
//            System.out.println("insert >> rating = " + rating);
            userAlbumRatingDao.save(memberId, albumId, rating);
        }
    }


    public Double getAverageRating(String albumId) {
        return userAlbumRatingDao.getAverageRating(albumId);
    }
    
    public double getUserRating(int memberId, String albumId) {
        UserAlbumRating rating = userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);
        return (rating != null) ? rating.getRating() : 0.0;
    }
    
    public int getRatingCountByMemberId(int memberId) {
        return userAlbumRatingDao.countByMemberId(memberId);
    }
    
    public List<Map<String, Object>> getRatingsByUserId(int userId) {
        return userAlbumRatingDao.getRatingsByUserId(userId);
    }






}
