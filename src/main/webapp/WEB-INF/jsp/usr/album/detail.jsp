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

/* 별점 스타일 */
.star-wrap {
  position: relative;
  display: flex;
  gap: 0px;
  margin: 20px auto 0;
  cursor: pointer;
  width: fit-content;
}

.star-box {
  position: relative;
  width: 36px;
  height: 36px;
}

.star-box svg {
  position: absolute;
  top: 0;
  left: 0;
  width: 36px;
  height: 36px;
}

.star-base svg path {
  fill: #c0c0c0;
}

.star-fill {
  position: absolute;
  top: 0;
  left: 0;
  height: 100%;
  overflow: hidden;
  z-index: 2;
  width: 0%;
}

.star-fill svg path {
  fill: #f5c518;
}

.cancel-tooltip {
  position: absolute;
  background: #fff;
  color: #333;
  font-size: 13px;
  padding: 5px 10px;
  border-radius: 6px;
  white-space: nowrap;
  transform: translate(-50%, -120%);
  z-index: 10;
  display: none;
  box-shadow: 0 2px 8px rgba(0,0,0,0.2);
  border: 1px solid #ccc;
}

</style>

<div class="album-detail-container">
  <div class="album-info">
    <img src="${album.coverImgUrl}" alt="Album Cover" />
    <h1>${album.title}</h1>
    <h3>by ${album.artist}</h3>
    <p>발매일: ${album.releaseDate}</p>
    <a href="${album.spotifyUrl}" target="_blank">Spotify에서 보기</a>

    <div class="star-wrap" data-album-id="${album.spotifyId}" data-user-logged-in="${not empty req.loginedMember}">
      <c:forEach begin="1" end="5" var="i">
        <div class="star-box" data-index="${i}">
          <div class="star-fill">
            <svg viewBox="0 0 24 24">
              <path d="M11.3 2.6a.75.75 0 0 1 1.3 0l2.7 5.5 6.1.9a.75.75 0 0 1 .4 1.3l-4.4 4.3 1 6.1a.75.75 0 0 1-1.1.8l-5.4-2.9-5.4 2.9a.75.75 0 0 1-1.1-.8l1-6.1-4.4-4.3a.75.75 0 0 1 .4-1.3l6.1-.9 2.7-5.5z"/>
            </svg>
          </div>
          <div class="star-base">
            <svg viewBox="0 0 24 24">
              <path d="M11.3 2.6a.75.75 0 0 1 1.3 0l2.7 5.5 6.1.9a.75.75 0 0 1 .4 1.3l-4.4 4.3 1 6.1a.75.75 0 0 1-1.1.8l-5.4-2.9-5.4 2.9a.75.75 0 0 1-1.1-.8l1-6.1-4.4-4.3a.75.75 0 0 1 .4-1.3l6.1-.9 2.7-5.5z"/>
            </svg>
          </div>
        </div>
      </c:forEach>
      <div class="cancel-tooltip" id="cancelTooltip">취소하기</div>
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
  const wrap = document.querySelector(".star-wrap");
  const isLoggedIn = wrap.dataset.userLoggedIn === "true";
  const starBoxes = wrap.querySelectorAll(".star-box");
  const tooltip = document.getElementById("cancelTooltip");

  let currentRating = 0;

  function setRating(rating) {
    starBoxes.forEach((box, i) => {
      const fill = box.querySelector(".star-fill");
      if (i < Math.floor(rating)) {
        fill.style.width = "100%";
      } else if (i === Math.floor(rating)) {
        fill.style.width = ((rating % 1) * 100) + "%";
      } else {
        fill.style.width = "0%";
      }
    });
  }

  wrap.addEventListener("mousemove", (e) => {
    const rect = wrap.getBoundingClientRect();
    const offsetX = e.clientX - rect.left;
    const widthPerStar = rect.width / 5;
    const rawRating = offsetX / widthPerStar;
    const hoveredRating = Math.round(rawRating * 2) / 2;
    setRating(hoveredRating);

    if (hoveredRating === currentRating && currentRating > 0) {
      const box = starBoxes[Math.floor(currentRating) - 1];
      const boxRect = box.getBoundingClientRect();
      tooltip.style.left = (boxRect.left + boxRect.width / 2 - rect.left) + "px";
      tooltip.style.display = "block";
    } else {
      tooltip.style.display = "none";
    }
  });

  wrap.addEventListener("mouseleave", () => {
    setRating(currentRating);
    tooltip.style.display = "none";
  });

  wrap.addEventListener("click", (e) => {
    if (!isLoggedIn) {
      alert("로그인 후 평점을 남길 수 있습니다.");
      return;
    }

    const rect = wrap.getBoundingClientRect();
    const offsetX = e.clientX - rect.left;
    const widthPerStar = rect.width / 5;
    const clickedRating = Math.round(offsetX / widthPerStar * 2) / 2;

    if (clickedRating === currentRating) {
      currentRating = 0;
      setRating(0);
      tooltip.style.display = "none";

      fetch("http://localhost:8080/usr/album/albums/" + wrap.dataset.albumId + "/rate", {


        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "rating=0"
      }).then(res => {
        if (res.ok) alert("평점이 취소되었습니다.");
        else alert("취소 실패");
      });

      return;
    }

    currentRating = clickedRating;
    setRating(currentRating);

    fetch("http://localhost:8080/usr/album/albums/" + wrap.dataset.albumId + "/rate", {


      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "rating=" + currentRating
    }).then(res => {
      if (res.ok) alert("평점 저장됨: " + currentRating.toFixed(1));
      else alert("평점 저장 실패");
    });
  });
});
</script>







