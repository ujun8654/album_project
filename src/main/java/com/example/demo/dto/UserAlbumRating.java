package com.example.demo.dto;

import lombok.Data;

@Data
public class UserAlbumRating {
    private int id;
    private String regDate;
    private int memberId;
    private String albumId;
    private double rating;
}