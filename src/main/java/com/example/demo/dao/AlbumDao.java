package com.example.demo.dao;

import com.example.demo.dto.Album;
import com.example.demo.dto.UserAlbumRating;
import org.apache.ibatis.annotations.*;
import java.util.List;

@Mapper
public interface AlbumDao {

    @Select("SELECT * FROM album")
    List<Album> getAllAlbums();

    @Select("SELECT * FROM album WHERE id = #{id}")
    Album getAlbumById(int id);

    @Insert("INSERT INTO album (title, artist, coverImgUrl, releaseDate) VALUES (#{title}, #{artist}, #{coverImgUrl}, #{releaseDate})")
    void addAlbum(Album album);

    @Select("SELECT * FROM user_album_rating WHERE albumId = #{albumId}")
    List<UserAlbumRating> getRatingsByAlbumId(int albumId);

    @Insert("INSERT INTO user_album_rating (memberId, albumId, rating, comment) VALUES (#{memberId}, #{albumId}, #{rating}, #{comment})")
    void addRating(UserAlbumRating rating);
}