package com.example.demo.service;

import com.example.demo.dao.AlbumDao;
import com.example.demo.dto.Album;
import com.example.demo.dto.Track;
import com.example.demo.dto.UserAlbumRating;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AlbumService {
    private final AlbumDao albumDao;
    private final SpotifyService spotifyService;

    public List<Album> getAllAlbums() {
        return albumDao.getAllAlbums();
    }

    public Album getAlbumById(int id) {
       //디버깅
    	//System.out.println("getAlbumById() 호출됨");

        Album album = albumDao.getAlbumById(id);
      //디버깅
        //System.out.println("album: " + album);

        List<Track> tracks = spotifyService.getTracksByAlbumId(album.getSpotifyId());
      //디버깅
        //System.out.println("트랙 불러오기 호출");

        album.setTracks(tracks);
        return album;
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