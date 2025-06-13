package com.example.demo.dao;

import com.example.demo.dto.UserAlbumRating;
import org.apache.ibatis.annotations.*;

@Mapper
public interface UserAlbumRatingDao {

    @Insert("""
        INSERT INTO user_album_rating
        SET regDate = NOW(),
            memberId = #{memberId},
            albumId = #{albumId},
            rating = #{rating}
    """)
    void save(UserAlbumRating rating);

    @Update("""
        UPDATE user_album_rating
        SET rating = #{rating},
            updateDate = NOW()
        WHERE memberId = #{memberId} AND albumId = #{albumId}
    """)
    void update(UserAlbumRating rating);

    @Select("""
        SELECT *
        FROM user_album_rating
        WHERE memberId = #{memberId} AND albumId = #{albumId}
    """)
    UserAlbumRating findByMemberAndAlbum(@Param("memberId") int memberId,
                                          @Param("albumId") String albumId);

    @Select("""
        SELECT ROUND(AVG(rating), 1)
        FROM user_album_rating
        WHERE albumId = #{albumId}
    """)
    Double getAverageRating(@Param("albumId") int albumId);
}
