package com.example.demo.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginedMember {
	private int id;
	private int authLevel;
	private String loginId;
	private String email;
	private boolean isConnectedToSpotify;
	private String spotifyProfileUrl;
	private String publicId;
	
	public LoginedMember(int id, int authLevel, String loginId, String email) {
	    this.id = id;
	    this.authLevel = authLevel;
	    this.loginId = loginId;
	    this.email = email;
	}
	
	public LoginedMember(int id, int authLevel, String loginId, String email, boolean isConnectedToSpotify) {
	    this.id = id;
	    this.authLevel = authLevel;
	    this.loginId = loginId;
	    this.email = email;
	    this.isConnectedToSpotify = isConnectedToSpotify;
	}
	
	public LoginedMember(int id, int authLevel, String loginId, String email, boolean isConnectedToSpotify, String publicId) {
	    this.id = id;
	    this.authLevel = authLevel;
	    this.loginId = loginId;
	    this.email = email;
	    this.isConnectedToSpotify = isConnectedToSpotify;
	    this.publicId = publicId;
	}
	
    public LoginedMember(Member member) {
        this.id = member.getId();
        this.authLevel = member.getAuthLevel();
        this.loginId = member.getLoginId();
        this.email = member.getEmail();
        this.isConnectedToSpotify = member.isSpotifyConnected();
        this.spotifyProfileUrl = member.getSpotifyProfileUrl();
    }

	public boolean isConnectedToSpotify() {
	    return isConnectedToSpotify;
	}

	public void setConnectedToSpotify(boolean connectedToSpotify) {
	    this.isConnectedToSpotify = connectedToSpotify;
	}
	
	public void setSpotifyProfileUrl(String spotifyProfileUrl) {
	    this.spotifyProfileUrl = spotifyProfileUrl;
	}

	public String getSpotifyProfileUrl() {
	    return spotifyProfileUrl;
	}
	
	public void setSpotifyConnected(boolean isSpotifyConnected) {
	    this.isConnectedToSpotify = isSpotifyConnected;
	}

	public String getPublicId() {
	    return publicId;
	}
	
}
