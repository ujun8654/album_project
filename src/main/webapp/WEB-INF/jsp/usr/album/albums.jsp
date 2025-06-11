<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
  .album-list {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 24px;
    padding: 40px 60px;
  }
  .album-item {
    display: flex;
    align-items: flex-start;
    gap: 12px;
  }
  .album-item img {
    height: 90px;
    border-radius: 6px;
    object-fit: cover;
  }
  .album-info {
    display: flex;
    flex-direction: column;
    justify-content: center;
  }
  .album-title {
    font-size: 13px;
    font-weight: bold;
    margin-bottom: 4px;
  }
  .album-release {
    font-size: 11px;
    color: #999;
    margin-bottom: 4px;
  }
  .album-artist {
    font-size: 11px;
    color: #666;
  }
  #loadMoreBtn {
    padding: 8px 24px;
    font-size: 13px;
    background-color: white;
    color: #333;
    border: 1px solid #ccc;
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.2s ease;
  }
  #loadMoreBtn:hover {
    background-color: #f2f2f2;
  }
  .album-slider-section {
    padding: 40px 60px;
  }
  .album-slider-section h2 {
    font-size: 18px;
    margin-bottom: 16px;
  }
  .album-slider {
    display: flex;
    overflow-x: auto;
    gap: 16px;
  }
  .album-card {
    flex: 0 0 auto;
    width: 160px;
    text-align: center;
  }
  .album-card img {
    width: 100%;
    border-radius: 8px;
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
</style>

<div style="padding: 20px 60px;">
  <c:if test="${not empty keyword}">
    <h3 style="font-size: 16px; margin-bottom: 20px;">
      "<span style="color: #222; font-weight: bold;">${keyword}</span>" 검색결과
    </h3>
  </c:if>

  <form action="/albums/search" method="get" style="display: flex; gap: 10px; margin-bottom: 20px;">
    <select name="type" style="padding: 8px; border-radius: 4px; border: 1px solid #ccc;">
    
      <option value="artist" <c:if test="${type == 'artist'}">selected</c:if>>아티스트</option>
      <option value="album" <c:if test="${type == 'album'}">selected</c:if>>제목</option>
    </select>
    <input type="text" name="keyword" placeholder="검색어 입력" value="${keyword}"
      style="width: 300px; padding: 8px; border-radius: 4px; border: 1px solid #ccc;" />
    <button type="submit" style="padding: 8px 16px; border: none; background-color: black; color: white; border-radius: 4px;">
      검색
    </button>
  </form>
</div>

<c:if test="${not empty keyword}">
  <div class="album-list">
    <c:forEach var="album" items="${albums}" varStatus="status">
      <div class="album-item" data-index="${status.index}" style="${status.index >= 10 ? 'display:none;' : ''}">
        <img src="${album.coverImgUrl}" alt="Album Cover" />
        <div class="album-info">
          <div class="album-title">${album.title}</div>
          <div class="album-release">${album.releaseDate}</div>
          <div class="album-artist">${album.artist}</div>
        </div>
      </div>
    </c:forEach>
  </div>
  <div style="text-align: center; margin-top: 30px;">
    <button id="loadMoreBtn">더보기 ▼</button>
  </div>
</c:if>

<c:if test="${empty keyword}">
  <div class="album-slider-section">
    <h2>	최신 앨범</h2>
    <div class="album-slider">
      <c:forEach var="album" items="${newReleases}">
        <div class="album-card">
          <img src="${album.coverImgUrl}" alt="Cover">
          <div class="album-title">${album.title}</div>
          <div class="album-artist">${album.artist}</div>
        </div>
      </c:forEach>
    </div>
  </div>
  <div class="album-slider-section">
    <h2>힙합 추천 앨범</h2>
    <div class="album-slider">
      <c:forEach var="album" items="${hiphopAlbums}">
        <div class="album-card">
          <img src="${album.coverImgUrl}" alt="Cover">
          <div class="album-title">${album.title}</div>
          <div class="album-artist">${album.artist}</div>
        </div>
      </c:forEach>
    </div>
  </div>
  <div class="album-slider-section">
    <h2>R&B 추천 앨범</h2>
    <div class="album-slider">
      <c:forEach var="album" items="${rnbAlbums}">
        <div class="album-card">
          <img src="${album.coverImgUrl}" alt="Cover">
          <div class="album-title">${album.title}</div>
          <div class="album-artist">${album.artist}</div>
        </div>
      </c:forEach>
    </div>
  </div>
</c:if>

<script>
  let shown = 10;
  const step = 10;
  const allItems = document.querySelectorAll('.album-item');
  const loadMoreBtn = document.getElementById('loadMoreBtn');

  loadMoreBtn?.addEventListener('click', () => {
    let next = shown + step;
    for (let i = shown; i < next && i < allItems.length; i++) {
      allItems[i].style.display = 'flex';
    }
    shown = next;
    if (shown >= allItems.length) {
      loadMoreBtn.style.display = 'none';
    }
  });

  if (allItems.length <= shown && loadMoreBtn) {
    loadMoreBtn.style.display = 'none';
  }
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
