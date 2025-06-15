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
		void save(@Param("memberId") int memberId,
		          @Param("albumId") String albumId,
		          @Param("rating") double rating);


	@Update("""
		    UPDATE user_album_rating
		    SET rating = #{rating}
		    WHERE memberId = #{memberId} AND albumId = #{albumId}
		""")
		void update(@Param("memberId") int memberId,
		            @Param("albumId") String albumId,
		            @Param("rating") double rating);


	@Select("""
		    SELECT *
		    FROM user_album_rating
		    WHERE memberId = #{memberId} AND albumId = #{albumId}
		""")
		UserAlbumRating findByMemberAndAlbum(@Param("memberId") int memberId, @Param("albumId") String albumId);


    @Select("""
        SELECT ROUND(AVG(rating), 1)
        FROM user_album_rating
        WHERE albumId = #{albumId}
    """)
    Double getAverageRating(@Param("albumId") String albumId);
    
    
    
    
    
    
    
    
}
