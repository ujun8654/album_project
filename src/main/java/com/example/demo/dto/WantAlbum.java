package com.example.demo.dto;

import java.time.LocalDateTime;

import lombok.Data;

@Data
public class WantAlbum {
    private long id;
    private long memberId;
    private String albumId;
    private LocalDateTime regDate;
}
