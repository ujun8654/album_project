package com.example.demo.service;

import java.util.UUID;

import org.springframework.stereotype.Service;

import com.example.demo.dao.MemberDao;
import com.example.demo.dto.Member;

@Service
public class MemberService {

	private MemberDao memberDao;
	
	public MemberService(MemberDao memberDao) {
		this.memberDao = memberDao;
	}

	public Member getMemberByLoginId(String loginId) {
		return this.memberDao.getMemberByLoginId(loginId);
	}
	
	public void joinMember(String loginId, String loginPw, String email) {
	    String publicId = UUID.randomUUID().toString();
	    memberDao.joinMember(loginId, loginPw, email, publicId);
	}

	public Member getMemberByEmail(String email) {
		return memberDao.getMemberByEmail(email);
	}


	public String getLoginId(int id) {
		return this.memberDao.getLoginId(id);
	}
	
	public void updateSpotifyConnected(int memberId) {
	    memberDao.updateSpotifyConnected(memberId);
	}
	
	public void disconnectSpotify(int memberId) {
	    memberDao.disconnectSpotify(memberId);
	}
	
	public void updateSpotifyProfileUrl(int memberId, String profileUrl) {
	    memberDao.updateSpotifyProfileUrl(memberId, profileUrl);
	}
	
	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}

	public Member getMemberByPublicId(String publicId) {
	    return memberDao.getMemberByPublicId(publicId);
	}

	public void updateLoginId(int memberId, String loginId) {
	    memberDao.updateLoginId(memberId, loginId);
	}

	public boolean isLoginIdDuplicate(String loginId) {
	    return memberDao.getMemberByLoginId(loginId) != null;
	}

	public void updateProfileImg(int memberId, String profileImgUrl) {
	    memberDao.updateProfileImg(memberId, profileImgUrl);
	}
	
	public void updateSpotifyRefreshToken(int memberId, String refreshToken) {
	    memberDao.updateSpotifyRefreshToken(memberId, refreshToken);
	}

	
	
}
