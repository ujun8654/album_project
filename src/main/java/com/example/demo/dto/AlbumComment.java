package com.example.demo.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data
@AllArgsConstructor
@NoArgsConstructor
public class AlbumComment {
    private int id;
    private String albumId;
    private int memberId;
    private String content;
    private LocalDateTime regDate;

    private String writerName;

}
