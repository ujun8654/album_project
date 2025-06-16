package com.example.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface WantAlbumDao {

    @Select("""
        SELECT COUNT(*)
        FROM want_album
        WHERE memberId = #{memberId}
          AND albumId = #{albumId}
        """)
    int exists(@Param("memberId") long memberId, @Param("albumId") String albumId);

    @Insert("""
        INSERT INTO want_album
        SET memberId = #{memberId},
            albumId = #{albumId},
            regDate = NOW()
        """)
    void insert(@Param("memberId") long memberId, @Param("albumId") String albumId);

    @Delete("""
        DELETE FROM want_album
        WHERE memberId = #{memberId}
          AND albumId = #{albumId}
        """)
    void delete(@Param("memberId") long memberId, @Param("albumId") String albumId);
    
    @Select("""
            SELECT albumId
            FROM want_album
            WHERE memberId = #{memberId}
            """)
        List<String> findAlbumIdsByMemberId(@Param("memberId") long memberId);
}
