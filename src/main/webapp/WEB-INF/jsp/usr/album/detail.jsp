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
  text-align: left;
}

.album-info img {
  width: 100%;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.album-title-rating-wrap {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  margin-top: 20px;
  margin-bottom: 8px;
}

.album-title-rating-wrap h1 {
  font-size: 24px;
  margin: 0;
}

.album-info h3 {
  font-size: 18px;
  color: #555;
  margin-bottom: 4px;
}

.album-info p {
  margin-top: 6px;
  font-size: 14px;
  color: #888;
}

.album-info a {
  font-size: 14px;
  color: #3b82f6;
  text-decoration: underline;
  display: block;
  margin-top: 10px;
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
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.star-wrap {
  position: relative;
  display: flex;
  gap: 0;
  cursor: pointer;
  width: fit-content;
  margin: 0;
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
  fill: #4b5563; 
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
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
  border: 1px solid #ccc;
}


.want-toggle-btn,
.spotify-btn {
  display: inline-flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  font-size: 13px;
  transition: color 0.2s;
}

.want-toggle-btn svg,
.spotify-btn svg {
  width: 24px;
  height: 24px;
  margin-bottom: 2px;
  transition: transform 0.2s ease, fill 0.2s;
}

.want-toggle-btn:hover svg,
.spotify-btn:hover svg {
  transform: scale(1.2);
}


.want-toggle-btn.want-inactive svg {
  fill: #888;
}

.want-toggle-btn.want-inactive:hover svg {
  fill: #444;
}

.want-toggle-btn.want-inactive span {
  color: #888;
  transition: color 0.2s;
}

.want-toggle-btn.want-inactive:hover span {
  color: #111;
}

.want-toggle-btn span {
  color: #888;
  transition: color 0.2s;
}

.want-toggle-btn:hover span {
  color: #111;
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
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

#loginModal .modal-logo {
  font-size: 32px;
  font-weight: bold;
  color: #000;
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
  background-color: #000;
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

    <div class="album-title-rating-wrap">
      <h1>${album.title}</h1>
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

    <h3>by ${album.artist}</h3>
    <p>발매일: ${album.releaseDate}</p>
    <div class="avg-rating" style="margin-top: 10px; font-size: 14px; color: #666;">
      평균 별점: <c:out value="${avgRating}" />점
    </div>

    <hr style="margin: 16px 0; border: none; border-top: 1px solid #ddd;" />

    <div style="display: flex; align-items: center; gap: 16px; margin-top: 10px;">
	  <div id="wantToggleBtn"
	     class="want-toggle-btn ${isWanted ? 'want-active' : 'want-inactive'}"
	     data-album-id="${album.spotifyId}"
	     data-logged-in="${req.loginedMember.id != 0}">

        <c:choose>
          <c:when test="${isWanted}">
            <svg viewBox="0 0 24 24"><path d="M6 4a2 2 0 0 0-2 2v14l8-3.5L20 20V6a2 2 0 0 0-2-2H6z"/></svg>
            <span>듣고싶어요</span>
          </c:when>
          <c:otherwise>
            <svg viewBox="0 0 24 24">
              <path d="M12 5v14m7-7H5" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round"/>
            </svg>
            <span>듣고싶어요</span>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="want-toggle-btn spotify-btn want-inactive"
           onclick="window.open('${album.spotifyUrl}', '_blank')"
           style="cursor: pointer;">
        <svg viewBox="0 0 168 168" xmlns="http://www.w3.org/2000/svg" style="width: 24px; height: 24px;">
          <path d="M84,0C37.7,0,0,37.7,0,84s37.7,84,84,84s84-37.7,84-84S130.3,0,84,0z M122.9,121.5c-2.3,4.4-7.7,6.1-12.1,3.8c-19.1-10.1-40.6-13.1-64.4-8.5c-4.9,1-9.6-2-10.6-6.9c-1-4.8,2-9.5,6.8-10.5c26.6-5.1,50.7-1.6,71.6,9.6C124.4,114.1,125.7,117.1,122.9,121.5z M130.7,95.7c-2.6,5-8.8,6.9-13.7,4.3c-22.5-13.2-52.5-16.5-74.4-9.9c-5.3,1.5-10.9-1.6-12.4-6.9c-1.5-5.2,1.6-10.8,6.9-12.3c26.7-7.9,61.4-4.2,87.9,11.4C130.7,85,133.3,90.7,130.7,95.7z M131.3,69.1C103.5,52.9,63.1,51.5,38.3,58.3c-5.6,1.6-11.6-1.8-13.2-7.4c-1.6-5.6,1.8-11.6,7.4-13.2c30.2-8.3,75.7-6.8,109.1,12.5c5.1,3,6.8,9.4,3.8,14.5C140.3,71.2,134.9,72.9,131.3,69.1z" fill="#1DB954"/>
        </svg>
        <span>Spotify에서 보기</span>
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

<div id="loginModal">
  <div class="modal-content">
    <button class="modal-close">✕</button>
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
  const isLoggedIn = wrap?.dataset.userLoggedIn === "true";
  const starBoxes = wrap?.querySelectorAll(".star-box") || [];
  const tooltip = document.getElementById("cancelTooltip");
  const loginModal = document.getElementById("loginModal");

  let currentRating = 0;
  <c:if test="${userRating > 0}">
    currentRating = ${userRating};
    setRating(currentRating);
  </c:if>

  function setRating(rating) {
    starBoxes.forEach((box, i) => {
      const fill = box.querySelector(".star-fill");
      fill.style.width = i < Math.floor(rating) ? "100%" : i === Math.floor(rating) ? ((rating % 1) * 100) + "%" : "0%";
    });
  }

  wrap?.addEventListener("mousemove", (e) => {
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

  wrap?.addEventListener("mouseleave", () => {
    setRating(currentRating);
    tooltip.style.display = "none";
  });

  wrap?.addEventListener("click", (e) => {
    if (!isLoggedIn) {
      loginModal.style.display = "flex";
      return;
    }

    const rect = wrap.getBoundingClientRect();
    const offsetX = e.clientX - rect.left;
    const widthPerStar = rect.width / 5;
    const clickedRating = Math.round(offsetX / widthPerStar * 2) / 2;

    currentRating = clickedRating === currentRating ? 0 : clickedRating;
    setRating(currentRating);
    tooltip.style.display = "none";

    fetch("/usr/album/albums/" + wrap.dataset.albumId + "/rate", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: "rating=" + currentRating
    });
  });

  const wantBtn = document.getElementById("wantToggleBtn");
  if (wantBtn) {
    wantBtn.addEventListener("click", () => {
      if (!isLoggedIn) {
        loginModal.style.display = "flex";
        return;
      }

      const albumId = wantBtn.dataset.albumId;
      fetch(`/album/${albumId}/want-toggle`, { method: "POST" })
        .then(res => res.json())
        .then(data => {
          if (data.success) {
            wantBtn.classList.toggle("want-active", data.added);
            wantBtn.classList.toggle("want-inactive", !data.added);
            const svg = wantBtn.querySelector("svg path");
            const span = wantBtn.querySelector("span");
            if (data.added) {
              svg.setAttribute("d", "M6 4a2 2 0 0 0-2 2v14l8-3.5L20 20V6a2 2 0 0 0-2-2H6z");
              svg.removeAttribute("stroke");
              svg.removeAttribute("stroke-width");
              svg.removeAttribute("fill");
              svg.removeAttribute("stroke-linecap");
              span.textContent = "듣고싶어요";
            } else {
              svg.setAttribute("d", "M12 5v14m7-7H5");
              svg.setAttribute("stroke", "currentColor");
              svg.setAttribute("stroke-width", "2");
              svg.setAttribute("fill", "none");
              svg.setAttribute("stroke-linecap", "round");
              span.textContent = "듣고싶어요";
            }
          } else {
            alert(data.msg || "요청 실패");
          }
        });
    });
  }

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

  const closeBtn = loginModal.querySelector(".modal-close");
  closeBtn.addEventListener("click", () => {
    loginModal.style.display = "none";
  });
});
</script>

