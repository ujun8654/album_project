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
</style>

<c:choose>
  <c:when test="${req.getLoginedMember().getId() == 0 || !sessionScope.isSpotifyConnected}">
    <div style="padding: 100px 30px; text-align: center;">
      <h1 style="font-size: 36px; margin-bottom: 20px;">음악 평점 맥이기</h1>
      <p style="font-size: 18px; color: #666;">
        청취한 앨범을 기록하고 평점 남기기<br />
        추천, 듣고싶어요 등 다양한 기능을 사용할 수 있습니다.
      </p>
      <div style="margin-top: 40px;">
        <a href="/albums"
           style="background: #000000; color: white; padding: 14px 28px; border-radius: 6px;
                  text-decoration: none; font-size: 16px; font-weight: bold;">
          지금 시작하기
        </a>
      </div>
    </div>
  </c:when>

  <c:otherwise>
    <div class="album-slider-section">
      <h2>최근 들은 앨범</h2>
      <div class="slider-wrapper">
        <div class="slider-container">
          <button class="slider-btn left" onclick="scrollSlider(this, -1)">&#10094;</button>
          <div class="album-slider">
            <c:forEach var="album" items="${recentAlbums}" varStatus="status">
              <c:if test="${status.index < 15}">
                <a href="/albums/${album.spotifyId}" class="album-card">
                  <img src="${album.coverImgUrl}" alt="Cover" />
                  <div class="album-title">${album.title}</div>
                  <div class="album-artist">${album.artist}</div>
                </a>
              </c:if>
            </c:forEach>
          </div>
          <button class="slider-btn right" onclick="scrollSlider(this, 1)">&#10095;</button>
        </div>
      </div>
    </div>

    <div class="album-slider-section">
      <h2>자주 듣는 앨범</h2>
      <div class="slider-wrapper">
        <div class="slider-container">
          <button class="slider-btn left" onclick="scrollSlider(this, -1)">&#10094;</button>
          <div class="album-slider">
            <c:forEach var="album" items="${topAlbums}">
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
  </c:otherwise>
</c:choose>

<script>
function scrollSlider(button, direction) {
  const container = button.closest('.slider-container');
  const slider = container.querySelector('.album-slider');
  const scrollAmount = 216 * 5;
  slider.scrollBy({ left: direction * scrollAmount, behavior: 'smooth' });
}
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
