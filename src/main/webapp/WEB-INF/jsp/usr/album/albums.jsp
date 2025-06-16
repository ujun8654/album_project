<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  a.album-card {
    text-decoration: none;
    color: inherit;
    display: block;
  }
  .album-slider-section {
    padding: 6px 60px;
    text-align: center;
  }
  .album-slider-section h2 {
    font-size: 18px;
    margin-bottom: 16px;
    padding-left: 0;
    width: 1080px;
    margin-left: auto;
    margin-right: auto;
    text-align: left;
  }
  .slider-wrapper {
    position: relative;
    width: 1080px;
    margin: 0 auto;
  }
  .slider-container {
    display: flex;
    align-items: center;
  }
  .album-slider {
    display: flex;
    gap: 17px;
    overflow-x: hidden;
    scroll-behavior: smooth;
  }
  .album-card {
    flex: 0 0 auto;
    width: 200px;
    text-align: center;
  }
  .album-card img {
    width: 100%;
    height: 200px;
    object-fit: cover;
    border-radius: 12px;
  }
  .album-card .album-title {
    font-size: 14px;
    font-weight: bold;
    margin-top: 6px;
  }
  .album-card .album-artist {
    font-size: 12px;
    color: #666;
  }
  .slider-btn {
    position: absolute;
    top: 40%;
    transform: translateY(-50%);
    background: rgba(255, 255, 255, 0.8);
    border: none;
    font-size: 24px;
    cursor: pointer;
    padding: 8px 12px;
    z-index: 10;
    transition: background 0.2s;
  }
  .slider-btn.left {
    left: -40px;
  }
  .slider-btn.right {
    right: -40px;
  }
  
.search-header-bar {
  height: 45px;
  display: flex;
  align-items: center;
  padding-left: 265px;
  background-color: #f4f4f4;
  font-size: 18px;
  font-weight: 500;
  color: #666;
  box-sizing: border-box;
  border-top: 1px solid #ddd;
  font-weight: bold;
  
}

  
</style>

<div>
<c:if test="${not empty keyword}">
  <div class="search-header-bar">
    “<span>${fn:escapeXml(keyword)}</span>” 검색결과
  </div>
</c:if>


</div>

<c:if test="${not empty keyword}">
  <div style="padding: 40px 60px 0 265px;">

    <div class="album-list" id="albumList" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px;">
      <c:forEach var="album" items="${albums}">
        <a href="/albums/${album.spotifyId}" style="text-decoration: none; color: inherit;">
          <div class="album-item" style="display: flex; align-items: flex-start; gap: 12px;">
            <img src="${album.coverImgUrl}" alt="Album Cover"
                 style="height: 90px; border-radius: 6px; object-fit: cover;" />
            <div class="album-info">
              <div class="album-title" style="font-size: 13px; font-weight: bold; margin-bottom: 4px;">
                ${album.title}
              </div>
              <div class="album-release" style="font-size: 11px; color: #999; margin-bottom: 4px;">
                ${album.releaseDate}
              </div>
              <div class="album-artist" style="font-size: 11px; color: #666;">
                ${album.artist}
              </div>
            </div>
          </div>
        </a>
      </c:forEach>
    </div>
  </div>
</c:if>

<c:if test="${empty keyword}">
  <div class="album-slider-section">
    <h2>최신 앨범</h2>
    <div class="slider-wrapper">
      <div class="slider-container">
        <button class="slider-btn left" onclick="scrollSlider(this, -1)">&#10094;</button>
        <div class="album-slider">
          <c:forEach var="album" items="${newReleases}">
            <a href="/albums/${album.spotifyId}" class="album-card">
              <img src="${album.coverImgUrl}" alt="Cover" />
              <div class="album-title">${album.title}</div>
              <div class="album-artist">${album.artist}</div>
            </a>
          </c:forEach>
        </div>
        <button class="slider-btn right" onclick="scrollSlider(this, 1)">&#10095;</button>
      </div>
    </div>
  </div>

  <div class="album-slider-section">
    <h2>힙합 추천 앨범</h2>
    <div class="slider-wrapper">
      <div class="slider-container">
        <button class="slider-btn left" onclick="scrollSlider(this, -1)">&#10094;</button>
        <div class="album-slider">
          <c:forEach var="album" items="${hiphopAlbums}">
            <a href="/albums/${album.spotifyId}" class="album-card">
              <img src="${album.coverImgUrl}" alt="Cover" />
              <div class="album-title">${album.title}</div>
              <div class="album-artist">${album.artist}</div>
            </a>
          </c:forEach>
        </div>
        <button class="slider-btn right" onclick="scrollSlider(this, 1)">&#10095;</button>
      </div>
    </div>
  </div>

  <div class="album-slider-section">
    <h2>R&B 추천 앨범</h2>
    <div class="slider-wrapper">
      <div class="slider-container">
        <button class="slider-btn left" onclick="scrollSlider(this, -1)">&#10094;</button>
        <div class="album-slider">
          <c:forEach var="album" items="${rnbAlbums}">
            <a href="/albums/${album.spotifyId}" class="album-card">
              <img src="${album.coverImgUrl}" alt="Cover" />
              <div class="album-title">${album.title}</div>
              <div class="album-artist">${album.artist}</div>
            </a>
          </c:forEach>
        </div>
        <button class="slider-btn right" onclick="scrollSlider(this, 1)">&#10095;</button>
      </div>
    </div>
  </div>
</c:if>

<script>
function scrollSlider(button, direction) {
  const container = button.closest('.slider-container');
  const slider = container.querySelector('.album-slider');
  const scrollAmount = 216 * 5;
  slider.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
}
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
