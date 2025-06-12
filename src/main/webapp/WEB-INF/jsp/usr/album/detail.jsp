<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
  .album-detail-container {
    display: flex;
    justify-content: center;
    gap: 60px;
    padding: 40px;
    font-family: 'Segoe UI', sans-serif;
  }

  .album-info {
    max-width: 300px;
    text-align: center;
  }

  .album-info img {
    width: 100%;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  }

  .album-info h1 {
    font-size: 24px;
    margin-top: 20px;
  }

  .album-info h3 {
    font-size: 18px;
    color: #555;
  }

  .album-info p {
    margin-top: 10px;
    font-size: 14px;
    color: #888;
  }

  .tracklist {
    flex-grow: 1;
    max-width: 600px;
  }

  .tracklist h2 {
    font-size: 20px;
    margin-bottom: 16px;
  }

  .tracklist ol {
    padding-left: 20px;
  }

  .tracklist li {
    margin-bottom: 10px;
    font-size: 16px;
    padding: 8px 12px;
    background-color: #f7f7f7;
    border-radius: 6px;
    box-shadow: 0 1px 4px rgba(0,0,0,0.05);
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  /* ⭐ 별점 스타일 */
  .stars {
    display: flex;
    font-size: 42px;
    line-height: 1;
    user-select: none;
    margin-top: 20px;
  }

  .star {
    color: #e0e0e0; /* 회색 빈 별 */
    cursor: pointer;
    margin-right: 6px;
    transition: color 0.1s ease-in-out;
  }

  .star.hovered,
  .star.selected {
    color: #f5c518; /* 왓챠 노란 별 */
  }
</style>

<div class="album-detail-container">
  <div class="album-info">
    <img src="${album.coverImgUrl}" alt="Album Cover" />
    <h1>${album.title}</h1>
    <h3>by ${album.artist}</h3>
    <p>발매일: ${album.releaseDate}</p>
    <a href="${album.spotifyUrl}" target="_blank">Spotify에서 보기</a>

    <div class="rating-container" data-album-id="${album.id}" data-user-logged-in="${not empty sessionScope.loginedMemberId}">
      <div class="stars">
        <c:forEach begin="1" end="5" var="i">
          <span class="star" data-value="${i}">&#9733;</span>
        </c:forEach>
      </div>
    </div>
  </div>

  <div class="tracklist">
    <h2>트랙 리스트</h2>
    <ol>
      <c:forEach var="track" items="${album.tracks}" varStatus="status">
        <li>
          <span>${status.index + 1}. ${track.name}</span>
          <span>[${track.duration}]</span>
        </li>
      </c:forEach>
    </ol>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

<script>
  document.addEventListener("DOMContentLoaded", () => {
    const container = document.querySelector(".rating-container");
    if (!container) return;

    const stars = container.querySelectorAll(".star");
    const isLoggedIn = container.dataset.userLoggedIn === "true";
    let selectedRating = 0;

    stars.forEach(star => {
      const value = parseInt(star.dataset.value);

      star.addEventListener("mouseenter", () => {
        highlight(value);
      });

      star.addEventListener("mouseleave", () => {
        highlight(selectedRating);
      });

      star.addEventListener("click", () => {
        selectedRating = value;
        highlight(selectedRating);

        if (!isLoggedIn) return;

        fetch("/usr/album/rate", {
          method: "POST",
          headers: {
            "Content-Type": "application/json"
          },
          body: JSON.stringify({
            albumId: container.dataset.albumId,
            rating: selectedRating
          })
        }).then(res => {
          if (res.ok) {
            alert("평점이 저장되었습니다.");
          } else {
            alert("평점 저장 실패");
          }
        });
      });
    });

    function highlight(value) {
      stars.forEach(star => {
        const v = parseInt(star.dataset.value);
        star.classList.toggle("hovered", v <= value);
        star.classList.toggle("selected", v <= value);
      });
    }
  });
</script>
