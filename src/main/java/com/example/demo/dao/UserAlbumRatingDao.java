package com.example.demo.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.UserAlbumRating;

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
    
    @Select("SELECT COUNT(*) FROM album_rating WHERE memberId = #{memberId}")
    int countByMemberId(@Param("memberId") int memberId);

    @Select("""
    	    SELECT albumId, rating
    	    FROM user_album_rating
    	    WHERE memberId = #{userId}
    	    ORDER BY regDate DESC
    	""")
    List<Map<String, Object>> getRatingsByUserId(@Param("userId") int userId);

}
