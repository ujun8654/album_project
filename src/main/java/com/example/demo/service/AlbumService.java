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
        System.out.println("✔ getAlbumById() 호출됨"); // ✅ 로그 찍기

        Album album = albumDao.getAlbumById(id);
        System.out.println("✔ album: " + album); // ✅ null 아닌지 확인

        List<Track> tracks = spotifyService.getTracksByAlbumId(album.getSpotifyId());
        System.out.println("✔ 트랙 불러오기 호출"); // ✅ 이거 찍히면 spotifyService 진입함

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