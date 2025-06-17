package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Member {
	private int id;
	private String regDate;
	private String updateDate;
	private String loginId;
	private String loginPw;
	private int authLevel;
	private boolean isSpotifyConnected;
	private String spotifyProfileUrl;
	private String email;
	private String publicId;
	
	
	public String getSpotifyProfileUrl() {
	    return spotifyProfileUrl;
	}
	
	public boolean isSpotifyConnected() {
	    return isSpotifyConnected;
	}
	
	public String getPublicId() {
	    return publicId;
	}

	public void setPublicId(String publicId) {
	    this.publicId = publicId;
	}
	
	

}
