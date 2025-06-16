package com.example.demo.service;

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
		memberDao.joinMember(loginId, loginPw, email);
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
	
	

	



}
