package com.example.demo.dto;

import lombok.Data;

@Data
public class UserAlbumRating {
    private int id;
    private int memberId;
    private int albumId;
    private int rating;
    private String comment;
    private String regDate;
}