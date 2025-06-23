<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
  .want-albums-section {
    padding: 30px 60px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }

  .want-albums-header {
    font-size: 20px;
    font-weight: 900;
    margin-bottom: 70px;
    padding-left: 205px;
  }

  .sort-select-wrapper {
    padding-right: 200px;
    float: right;
    margin-top: -28px;
  }

  .sort-select {
    padding: 6px 10px;
    font-size: 14px;
  }

.album-list {
  padding-left: 205px;
  display: grid;
  grid-template-columns: repeat(8, 160px); 
  gap: 26px 16px; 
  padding-bottom: 12px;
}


  .album-card {
    position: relative;
    flex: 0 0 auto;
    width: 160px;
    cursor: pointer;
  }

  .album-card img {
    width: 100%;
    border-radius: 5px;
    display: block;
    box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  }

  .album-title {
    margin-top: 6px;
    font-size: 14px;
    font-weight: 600;
    line-height: 1.1;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  .album-rating {
    margin-top: 2px;
    color: #e91e63;
    font-weight: 700;
    font-size: 13px;
  }
</style>

<div class="want-albums-section">
  <div class="want-albums-header">듣고싶어요한 앨범</div>

  <div class="album-list" id="albumList">
    <c:forEach var="album" items="${wishAlbums}">
      <div class="album-card" onclick="location.href='/albums/${album.spotifyId}'" style="cursor:pointer;">
        <img src="${album.coverImgUrl}" alt="${album.title} 앨범 커버" />
        <div class="album-title" title="${album.title}">${album.title}</div>
      </div>
    </c:forEach>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
