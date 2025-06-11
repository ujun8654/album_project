<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>AlbumRate</title>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

  <style>
    body {
      margin: 0;
      font-family: 'Segoe UI', sans-serif;
    }

    .navbar {
      display: flex;
      justify-content: space-between;
      align-items: center;
      background-color: #111;
      padding: 14px 30px;
    }

    .navbar .logo {
      color: #fff;
      font-size: 22px;
      font-weight: bold;
      text-decoration: none;
    }

    .navbar .menu a {
      margin-left: 30px;
      color: #ccc;
      text-decoration: none;
      font-size: 16px;
    }

    .navbar .menu a:hover {
      color: #fff;
    }

    .navbar .auth a {
      margin-left: 15px;
      color: #aaa;
      text-decoration: none;
      font-size: 14px;
    }

    .navbar .auth a:hover {
      color: #fff;
    }

    .navbar .auth span {
      color: #aaa;
      font-size: 14px;
      margin-right: 10px;
    }
  </style>
</head>
<body>

  <div class="navbar">
    <a href="/" class="logo">AlbumRate</a>

    <div class="menu">
      <a href="/albums">앨범</a>
      <a href="#">듣고싶어요</a>
      <a href="#">통계</a>
      <a href="#">친구</a>
    </div>

    <div class="auth">
		<c:if test="${req.getLoginedMember().getId() == 0 }">
			<a href="/usr/member/login">로그인</a>
			<a href="/usr/member/join">회원가입</a>
		</c:if>
		<c:if test="${req.getLoginedMember().getId() != 0 }">
			<a href="/usr/member/logout">로그아웃</a>
		</c:if>
    </div>
  </div>
