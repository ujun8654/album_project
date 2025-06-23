package com.example.demo.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.example.demo.dto.Member;

@Mapper
public interface MemberDao {

	@Insert("""
		    INSERT INTO `member`
		    SET regDate = NOW(),
		        updateDate = NOW(),
		        loginId = #{loginId},
		        loginPw = #{loginPw},
		        email = #{email},
		        publicId = #{publicId}
		""")
		void joinMember(@Param("loginId") String loginId,  @Param("loginPw") String loginPw,  @Param("email") String email, @Param("publicId") String publicId);


	@Select("""
		    SELECT id, regDate, email, updateDate, loginId, loginPw, 
		           is_spotify_connected AS isSpotifyConnected,
		           spotify_profile_url AS spotifyProfileUrl
		    FROM member
		    WHERE loginId = #{loginId}
		""")

	Member getMemberByLoginId(String loginId);


	@Select("""
		SELECT loginId
		FROM `member`
		WHERE id = #{id}
		""")
	String getLoginId(int id);

	@Select("""
		SELECT *
		FROM `member`
		WHERE email = #{email}
		""")
	Member getMemberByEmail(String email);
	
	@Update("UPDATE member SET is_spotify_connected = TRUE WHERE id = #{id}")
	void updateSpotifyConnected(@Param("id") int id);

	@Update("UPDATE member SET is_spotify_connected = false, updateDate = NOW() WHERE id = #{memberId}")
	void disconnectSpotify(@Param("memberId") int memberId);

	@Update("UPDATE member SET spotify_profile_url = #{profileUrl}, updateDate = NOW() WHERE id = #{id}")
	void updateSpotifyProfileUrl(@Param("id") int id, @Param("profileUrl") String profileUrl);

	
	@Select("""
		    SELECT id, regDate, email, updateDate, loginId, loginPw, 
		           is_spotify_connected AS isSpotifyConnected,
		           spotify_profile_url AS spotifyProfileUrl
		    FROM member
		    WHERE id = #{id}
		""")
		Member getMemberById(@Param("id") int id);
	
	@Select("""
		    SELECT *
		    FROM member
		    WHERE publicId = #{publicId}
		""")
		Member getMemberByPublicId(@Param("publicId") String publicId);
	
	@Update("UPDATE member SET loginId = #{loginId} WHERE id = #{memberId}")
	void updateLoginId(@Param("memberId") int memberId, @Param("loginId") String loginId);
	
	@Update("UPDATE member SET profileImage = #{profileImgUrl}, updateDate = NOW() WHERE id = #{memberId}")
	void updateProfileImg(@Param("memberId") int memberId, @Param("profileImgUrl") String profileImgUrl);
	
}








