package com.example.demo.service;

import com.example.demo.dao.AlbumDao;
import com.example.demo.dto.Album;
import com.example.demo.dto.UserAlbumRating;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AlbumService {
    private final AlbumDao albumDao;

    public List<Album> getAllAlbums() {
        return albumDao.getAllAlbums();
    }

    public Album getAlbumById(int id) {
        return albumDao.getAlbumById(id);
    }

    public void addAlbum(Album album) {
        albumDao.addAlbum(album);
    }

    public List<UserAlbumRating> getRatingsByAlbumId(int albumId) {
        return albumDao.getRatingsByAlbumId(albumId);
    }

    public void addRating(UserAlbumRating rating) {
        albumDao.addRating(rating);
    }
}