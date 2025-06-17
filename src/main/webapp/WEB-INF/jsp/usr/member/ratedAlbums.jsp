<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<style>
  .want-albums-section {
    padding: 30px 60px;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  }

  .want-albums-header {
    font-size: 20px;
    font-weight: 900;
    margin-bottom: 30px;
    padding-left: 205px;
  }

  .tab-bar-wrapper {
    display: flex;
    justify-content: center;
    position: relative;
    margin-bottom: 50px;
  }

  .tab-bar {
    position: relative;
    width: 1400px;
    border-bottom: 1px solid #d1d5db;
  }

  .tab-buttons {
    position: absolute;
    bottom: -1px;
    display: flex;
    width: 100%;
    justify-content: space-between;
  }

  .tab-button {
    width: 50%;
    text-align: center;
    padding: 8px 0;
    font-size: 15px;
    font-weight: 600;
    color: #6b7280;
    cursor: pointer;
    position: relative;
  }

  .tab-button.active {
    color: black;
  }

  .tab-underline {
    position: absolute;
    bottom: -1px;
    height: 3px;
    width: 50%;
    background-color: black;
    left: 0;
    transition: all 0.3s ease;
  }

  .album-list {
    padding-left: 205px;
    width: 1080px;
    display: grid;
    grid-template-columns: repeat(8, 160px);
    gap: 26px 16px;
    padding-bottom: 12px;
  }

  .album-card {
    width: 160px;
    cursor: pointer;
  }

  .album-card img {
    width: 100%;
    border-radius: 5px;
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  }

  .album-title {
    margin-top: 6px;
    font-size: 14px;
    font-weight: 600;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }

  .album-rating {
    margin-top: 2px;
    color: #4b5563;
    font-weight: 700;
    font-size: 13px;
  }
</style>

<div class="want-albums-section">
  <div class="want-albums-header">내가 평가한 앨범</div>

  <div class="tab-bar-wrapper">
    <div class="tab-bar">
      <div class="tab-buttons">
        <div class="tab-button active" onclick="selectTab(0)">전체</div>
        <div class="tab-button" onclick="selectTab(1)">별점 순</div>
        <div id="tabUnderline" class="tab-underline"></div>
      </div>
    </div>
  </div>

  <div class="album-list" id="albumList">
    <c:forEach var="album" items="${ratedAlbums}">
      <div class="album-card" onclick="location.href='/albums/${album.spotifyId}'">
        <img src="${album.coverImgUrl}" alt="${album.title} 앨범 커버" />
        <div class="album-title" title="${album.title}">${album.title}</div>
        <div class="album-rating">평가함 ★ ${album.userRating}점</div>
      </div>
    </c:forEach>
  </div>

  <div id="groupedAlbumSection" style="display:none;">
    <c:forEach var="entry" items="${groupedAlbums}">
      <c:set var="rating" value="${entry.key}" />
      <c:set var="albums" value="${entry.value}" />
      <c:set var="groupId" value="group_${rating}" />

      <div class="group-header" style="display:flex; justify-content:space-between; align-items:center; padding:0 205px; margin-top:40px; margin-bottom:14px;">
        <div class="group-title" style="font-size:18px; font-weight:bold;">${rating} 평가함 <span style="color:#9ca3af;">${fn:length(albums)}</span></div>
		<div class="group-more user-select-none" style="font-size:13px; color:#6b7280; cursor:pointer;" onclick="toggleGroup('${groupId}', this)">더보기</div>
      </div>
      <div id="${groupId}" class="album-list" data-expanded="false">
	  <c:forEach var="album" items="${albums}" varStatus="status">
	    <div class="album-card" style="${status.index >= 8 ? 'display:none;' : ''}" data-index="${status.index}">
	      <img src="${album.coverImgUrl}" alt="${album.title} 앨범 커버" />
	      <div class="album-title">${album.title}</div>
	      <div class="album-rating">★ ${album.userRating}점</div>
	    </div>
	  </c:forEach>

      </div>
    </c:forEach>
  </div>
</div>

<script>
  function selectTab(index) {
    const underline = document.getElementById('tabUnderline');
    underline.style.left = index === 0 ? '0%' : '50%';

    const buttons = document.querySelectorAll('.tab-button');
    buttons.forEach(btn => btn.classList.remove('active'));
    buttons[index].classList.add('active');

    const simpleList = document.getElementById('albumList');
    const groupedList = document.getElementById('groupedAlbumSection');

    if (index === 0) {
      simpleList.style.display = 'grid';
      groupedList.style.display = 'none';
      history.replaceState(null, '', '?tab=all');
    } else {
      simpleList.style.display = 'none';
      groupedList.style.display = 'block';
      history.replaceState(null, '', '?tab=rating');
    }
  }

  function toggleGroup(groupId, button) {
    const group = document.getElementById(groupId);
    const expanded = group.getAttribute('data-expanded') === 'true';
    const cards = group.querySelectorAll('.album-card');

    if (expanded) {
      cards.forEach((el, i) => {
        el.style.display = i < 8 ? 'block' : 'none';
      });
      button.innerText = '더보기';
      group.setAttribute('data-expanded', 'false');
    } else {
      cards.forEach(el => {
        el.style.display = 'block';
      });
      button.innerText = '닫기';
      group.setAttribute('data-expanded', 'true');
    }
  }

  window.addEventListener('DOMContentLoaded', () => {
    const urlParams = new URLSearchParams(window.location.search);
    const tab = urlParams.get('tab');

    if (tab === 'rating') {
      selectTab(1);
    } else {
      selectTab(0);
    }
  });
</script>




<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
