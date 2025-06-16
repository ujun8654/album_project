package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.dao.WantAlbumDao;

@Service
public class WantAlbumService {

    @Autowired
    private WantAlbumDao wantAlbumDao;

    public boolean toggle(long memberId, String albumId) {
        if (wantAlbumDao.exists(memberId, albumId) > 0) {
            wantAlbumDao.delete(memberId, albumId);
            return false;
        } else {
            wantAlbumDao.insert(memberId, albumId);
            return true;
        }
    }

    public boolean isWanted(long memberId, String albumId) {
        return wantAlbumDao.exists(memberId, albumId) > 0;
    }
    
    public List<String> getWantedAlbumIdsByMemberId(long memberId) {
        return wantAlbumDao.findAlbumIdsByMemberId(memberId);
    }
}
