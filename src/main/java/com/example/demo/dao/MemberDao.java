package com.example.demo.dao;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.example.demo.dto.Member;

@Mapper
public interface MemberDao {

	@Insert("""
		INSERT INTO `member`
		SET regDate = NOW(),
		    updateDate = NOW(),
		    loginId = #{loginId},
		    loginPw = #{loginPw},
		    email = #{email}
		""")
	void joinMember(@Param("loginId") String loginId, @Param("loginPw") String loginPw, @Param("email") String email);

	@Select("""
		SELECT *
		FROM `member`
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
}
