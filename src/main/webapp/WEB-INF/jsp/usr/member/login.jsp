<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>로그인</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
    }

    .input-bordered {
      border: 1px solid #ccc;
      border-radius: 0.375rem;
      padding: 0.5rem;
      width: 100%;
    }

    .form-control {
      margin-bottom: 1.5rem;
    }

    .label-text {
      font-weight: 600;
      margin-bottom: 0.5rem;
      display: block;
      color: #111827;
    }

    .btn {
      background-color: #1f2937;
      color: white;
      padding: 0.5rem 1rem;
      border-radius: 0.375rem;
      text-align: center;
      transition: background-color 0.2s;
    }

    .btn:hover {
      background-color: #374151;
    }

    .error-msg {
      color: #dc2626;
      font-size: 0.875rem;
      margin-top: 0.5rem;
    }
  </style>
</head>
<body class="bg-gray-100 text-gray-800">
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="max-w-md mx-auto mt-12 bg-white p-8 rounded shadow-md">
  <h1 class="text-2xl font-bold mb-6 text-center">로그인</h1>

  <form action="/usr/member/doLogin" method="post">
    <div class="form-control">
      <label class="label-text">아이디</label>
      <input type="text" name="loginId" class="input-bordered" required>
    </div>

    <div class="form-control">
      <label class="label-text">비밀번호</label>
      <input type="password" name="loginPw" class="input-bordered" required>

      <c:if test="${not empty errorMsg}">
        <p class="error-msg">${errorMsg}</p>
      </c:if>
    </div>

    <div class="mt-6">
      <button type="submit" class="btn w-full">로그인</button>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
