package com.example.demo.service;

import com.example.demo.dao.UserAlbumRatingDao;
import com.example.demo.dto.UserAlbumRating;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserAlbumRatingService {

    @Autowired
    private UserAlbumRatingDao userAlbumRatingDao;

    public void saveOrUpdate(int memberId, String albumId, int rating) {
        UserAlbumRating existing = userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);

        if (existing != null) {
            existing.setRating(rating);
            userAlbumRatingDao.update(existing);
        } else {
            UserAlbumRating newRating = new UserAlbumRating();
            newRating.setMemberId(memberId);
            newRating.setAlbumId(albumId);
            newRating.setRating(rating);
            userAlbumRatingDao.save(newRating);
        }
    }

    public Double getAverageRating(int albumId) {
        return userAlbumRatingDao.getAverageRating(albumId);
    }

    public UserAlbumRating getUserRating(int memberId, String albumId) {
        return userAlbumRatingDao.findByMemberAndAlbum(memberId, albumId);
    }
}
