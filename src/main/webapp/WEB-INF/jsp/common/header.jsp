<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>AlbumRate</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  
  <style>
  
  .user-select-none {
  user-select: none;
  -webkit-user-select: none;
  -moz-user-select: none;   
  -ms-user-select: none;
}
  
    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
    }
    
::-webkit-scrollbar {
  width: 0px;
  height: 0px;
  background: transparent;
}

body {
  scrollbar-width: none; 
  -ms-overflow-style: none; 
}


.navbar {
  height: 60px;
  padding: 14px 30px;
  display: flex;
  align-items: center;
  background-color: #111;
  justify-content: space-between;
  box-sizing: border-box;
  border-bottom: 1px solid #666;
}

.navbar .logo {
  color: #fff;
  font-size: 28px;
  font-weight: bold;
  text-decoration: none;
  flex-shrink: 0;
  margin-right: 24px;
  margin-left: 240px;
  line-height: 60px;
}

    .navbar .menu {
      display: flex;
      gap: 30px;
      flex-grow: 1;
      align-items: center;
    }

    .navbar .menu a {
      color: #ccc;
      text-decoration: none;
      font-size: 12px;
      white-space: nowrap;
    }

    .navbar .menu a:hover {
      color: #fff;
    }

    .search-form {
      display: flex;
      align-items: center;
      background: #222;
      border-radius: 4px;
      overflow: hidden;
      height: 34px;
      margin-left: 450px;
    }

    .search-form input[type="text"] {
      border: none;
      padding: 0 10px;
      background: transparent;
      color: white;
      font-size: 14px;
      width: 220px;
      outline: none;
      line-height: 34px;
      box-sizing: border-box;
    }

    .search-form input[type="text"]::placeholder {
      color: #bbb;
    }

    .search-form select {
      border: none;
      background: #555;
      color: #ccc;
      font-weight: normal;
      padding: 0 12px;
      cursor: pointer;
      font-size: 14px;
      height: 34px;
      outline: none;
      appearance: none;
      -webkit-appearance: none;
      -moz-appearance: none;
      line-height: 34px;
      box-sizing: border-box;
    }

.navbar .auth {
  display: flex;
  gap: 15px;
  align-items: center;
  flex-shrink: 0;
  margin-left: 24px;
  padding-right: 240px;
  line-height: 60px;
}

    .navbar .auth a {
      color: #aaa;
      text-decoration: none;
      font-size: 14px;
      white-space: nowrap;
    }

    .navbar .auth a:hover {
      color: #fff;
    }

    .navbar .auth span {
      color: #aaa;
      font-size: 14px;
      margin-right: 10px;
    }

.search-form select {
  background: #222;
  color: #eee;
  border: 1px solid #444;
  font-size: 13px;
  line-height: 1;
  height: 34px;
  padding: 0 12px 0 12px;
  border-radius: 4px;
  appearance: none;
  -webkit-appearance: none;
  -moz-appearance: none;
  outline: none;
  cursor: pointer;
  margin-left: 8px;
  background-image: url("data:image/svg+xml,%3Csvg fill='%23ccc' height='16' viewBox='0 0 24 24' width='16' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M7 10l5 5 5-5z'/%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 12px;
  padding-right: 32px;
  display: flex;
  align-items: center;
}

.search-form select:focus {
  border-color: #3b82f6;
  background: #2f2f2f;
}

.profile-icon-btn {
  display: flex;
  align-items: center;
  margin-left: 10px;
}

.profile-icon {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  object-fit: cover;
  cursor: pointer;
  transition: opacity 0.2s;
}

.profile-icon:hover {
  opacity: 0.8;
}

  </style>
  
</head>
<body>
  <div class="navbar">
    <a href="/" class="logo user-select-none">AlbumRate</a>
    <div class="menu">
      <a href="/albums">앨범</a>
      <a href="/album/wishlist">듣고싶어요</a>
      <a href="/usr/member/users">통계</a>
      <a href="#">친구</a>
<form action="/albums/search" method="get" class="search-form" onsubmit="return !!this.keyword.value.trim();">
  <input
    type="text"
    name="keyword"
    placeholder="검색어 입력"
    required
    autocomplete="off"
    value="${fn:escapeXml(param.keyword)}" />
  <select name="type">
    <option value="album" <c:if test="${param.type == 'album'}">selected</c:if>>앨범</option>
    <option value="artist" <c:if test="${param.type == 'artist'}">selected</c:if>>아티스트</option>
  </select>
</form>
    </div>

<div class="auth">
  <c:if test="${req.getLoginedMember().getId() == 0}">
    <a href="/usr/member/login">로그인</a>
    <a href="/usr/member/join">회원가입</a>
  </c:if>

  <c:if test="${req.getLoginedMember().getId() != 0}">
    <a href="/usr/member/logout">로그아웃</a>

	<c:choose>
	  <c:when test="${sessionScope.isSpotifyConnected}">
	    <a href="${sessionScope.spotifyProfileUrl}" class="spotify-connect-btn" target="_blank">
	      Spotify로 이동
	    </a>
	  </c:when>
	  <c:otherwise>
	    <a href="/spotify/login" class="spotify-connect-btn">Spotify 연동</a>

	  </c:otherwise>
	</c:choose>
	
	<a href="/usr/member/users" class="profile-icon-btn">
	  <img src="https://an2-glx.amz.wtchn.net/assets/default/user/photo_file_name_small-ab0a7f6a92a282859192ba17dd4822023e22273e168c2daf05795e5171e66446.jpg"
	       alt="프로필"
	       class="profile-icon" />
	</a>
  </c:if>
</div>
  </div>
  
<c:if test="${sessionScope.justConnectedSpotify}">
  <script>
    window.open("${sessionScope.spotifyProfileUrl}", "_blank");
    fetch("/spotify/resetPopupFlag");
    location.reload();
  </script>
</c:if>


<script>
	function connectSpotify() {
		  window.open("/spotify/login", "_blank");
		}
</script>

