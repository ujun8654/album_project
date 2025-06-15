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

#loginModal {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  z-index: 9999;
  display: none;
  align-items: center;
  justify-content: center;
  font-family: 'Segoe UI', sans-serif;
}

#loginModal .modal-content {
  background: white;
  padding: 32px 24px;
  border-radius: 6px;
  text-align: center;
  width: 320px;
  height: 480px;
  position: relative;
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
}

#loginModal .modal-logo {
  font-size: 32px;
  font-weight: bold;
  color: #000000;
  margin-bottom: 12px;
  padding-top: 50px;
}

#loginModal .modal-message {
  font-size: 16px;
  color: #4b4b4b;
  margin-bottom: 24px;
  padding-top: 80px;
  padding-bottom: 130px;
  line-height: 1.6;
  font-weight: bold;
}

#loginModal .modal-button {
  display: block;
  width: 100%;
  padding: 10px 0;
  margin-bottom: 10px;
  border-radius: 6px;
  font-size: 14px;
  font-weight: bold;
  cursor: pointer;
  transition: background 0.2s;
}

#loginModal .modal-button.login {
  background-color: #000000;
  color: white;
  border: none;
}


#loginModal .modal-button.join {
  background: white;
  color: #444;
  border: 1px solid #ccc;
}

#loginModal .modal-button.join:hover {
  background: #f5f5f5;
}

#loginModal .modal-close {
  position: absolute;
  top: 12px;
  right: 12px;
  font-size: 18px;
  color: #999;
  background: none;
  border: none;
  cursor: pointer;
}

#loginModal .modal-close:hover {
  color: #000;
}
</style>

<div class="album-detail-container">
  <div class="album-info">
    <img src="${album.coverImgUrl}" alt="Album Cover" />
    <h1>${album.title}</h1>
    <h3>by ${album.artist}</h3>
    <p>발매일: ${album.releaseDate}</p>
    <a href="${album.spotifyUrl}" target="_blank">Spotify에서 보기</a>

    <div class="star-wrap" data-album-id="${album.spotifyId}" data-user-logged-in="${req.loginedMember.id != 0}">
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

<div id="loginModal">
  <div class="modal-content">
    <button class="modal-close" onclick="document.getElementById('loginModal').style.display='none'">✕</button>
    <div class="modal-logo">AlbumRate</div>
    <div class="modal-message">회원가입 혹은 로그인이 필요한 기능이에요</div>
    <button class="modal-button login" onclick="location.href='/usr/member/login'">로그인</button>
    <button class="modal-button join" onclick="location.href='/usr/member/join'">회원가입</button>
  </div>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", () => {
  const wrap = document.querySelector(".star-wrap");
  const isLoggedIn = wrap.dataset.userLoggedIn === "true";
  const starBoxes = wrap.querySelectorAll(".star-box");
  const tooltip = document.getElementById("cancelTooltip");
  const loginModal = document.getElementById("loginModal");

  let currentRating = 0;

  // ⭐ 서버에서 받은 평점 초기화
  <c:if test="${userRating > 0}">
    currentRating = ${userRating};
    setRating(currentRating);
  </c:if>

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
    const hoveredRating = Math.round((offsetX / widthPerStar) * 2) / 2;
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
      loginModal.style.display = "flex";
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

      fetch("/usr/album/albums/" + wrap.dataset.albumId + "/rate", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "rating=0"
      });

      return;
    }

    currentRating = clickedRating;
    setRating(currentRating);

    fetch("/usr/album/albums/" + wrap.dataset.albumId + "/rate", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "rating=" + currentRating
    });
  });

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape") {
      loginModal.style.display = "none";
    }
  });

  loginModal.addEventListener("click", (e) => {
    const modalContent = loginModal.querySelector(".modal-content");
    if (!modalContent.contains(e.target)) {
      loginModal.style.display = "none";
    }
  });
});
</script>
