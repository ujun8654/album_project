package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.*;

import com.example.demo.dto.AlbumComment;

@Mapper
public interface AlbumCommentDao {

    @Insert("""
        INSERT INTO album_comment
        SET album_id = #{albumId},
            member_id = #{memberId},
            content = #{content},
            reg_date = NOW()
    """)
    void insertComment(@Param("albumId") String albumId,
                       @Param("memberId") int memberId,
                       @Param("content") String content);


    @Select("""
        SELECT AC.id, AC.album_id AS albumId, AC.member_id AS memberId,
               AC.content, AC.reg_date AS regDate,
               M.loginId AS writerName
        FROM album_comment AS AC
        INNER JOIN member AS M ON AC.member_id = M.id
        WHERE AC.album_id = #{albumId}
        ORDER BY AC.reg_date DESC
    """)
    List<AlbumComment> getCommentsByAlbumId(@Param("albumId") String albumId);
}
