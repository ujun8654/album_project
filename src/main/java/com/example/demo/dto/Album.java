package com.example.demo.dto;

import java.util.List;

import lombok.Data;

@Data
public class Album {
    private int id;
    private String title;
    private String artist;
    private String coverImgUrl;
    private String releaseDate;
    private String spotifyId;
    private String spotifyUrl;
    private String genre;
    private String artistName;
    private List<Track> tracks;
    private double userRating;

    public double getUserRating() {
        return userRating;
    }

    public void setUserRating(double userRating) {
        this.userRating = userRating;
    }

}