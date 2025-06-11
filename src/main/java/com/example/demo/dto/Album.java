package com.example.demo.dto;

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

}