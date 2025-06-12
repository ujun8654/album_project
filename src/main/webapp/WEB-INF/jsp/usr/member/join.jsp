<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>회원가입</title>
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

    .btn-outline {
      background-color: transparent;
      color: #1f2937;
      border: 1px solid #1f2937;
    }

    .btn:hover {
      background-color: #374151;
    }

    .btn-outline:hover {
      background-color: #1f2937;
      color: white;
    }

    .btn:disabled {
      background-color: #d1d5db;
      cursor: not-allowed;
    }

    .text-green {
      color: #16a34a;
    }

    .text-red {
      color: #dc2626;
    }
  </style>

  <script>
    $(document).ready(function () {
      $("input[name='loginId']").on('input', function () {
        const loginId = $(this).val().trim();

        if (loginId.length === 0) {
          $('#loginIdMsg').text('');
          return;
        }

        $.get('/usr/member/loginIdDupChk', { loginId: loginId }, function (data) {
          if (data.rsCode === 'S-1') {
            $('#loginIdMsg').text('사용 가능한 아이디입니다.').css('color', 'green');
          } else {
            $('#loginIdMsg').text('이미 사용 중인 아이디입니다.').css('color', 'red');
          }
        });
      });

      $("#joinForm").on("submit", function (e) {
        const pw = $("input[name='loginPw']").val().trim();
        const pwConfirm = $("input[name='loginPwConfirm']").val().trim();

        if (pw !== pwConfirm) {
          e.preventDefault();
          $(".pwConfirmErrorMsg").text("비밀번호가 일치하지 않습니다.");
        } else {
          $(".pwConfirmErrorMsg").text("");
        }
      });

      $('#sendCodeBtn').click(function () {
        const emailId = $('#emailId').val().trim();
        const emailDomain = $('#emailDomain').val();
        const email = emailId + emailDomain;

        if (!emailId) {
          $('#emailMsg').text('이메일 아이디를 입력해주세요.').css('color', 'red');
          return;
        }

        $('#sendCodeBtn').prop('disabled', true);
        $('#emailMsg').text('전송 중...').css('color', '#333');

        $.post('/usr/member/sendEmailCode', { email: email }, function (data) {
          if (data.success) {
            $('#emailMsg').text('인증코드가 전송되었습니다.').css('color', 'green');
          } else {
            $('#emailMsg').text('전송 실패: ' + data.message).css('color', 'red');
            $('#sendCodeBtn').prop('disabled', false);
          }
        });
      });
    });
  </script>

</head>
<body class="bg-gray-100 text-gray-800">
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<c:if test="${not empty errorMsg}">
  <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4 text-sm text-center">
    ${errorMsg}
  </div>
</c:if>

<div class="max-w-md mx-auto mt-12 bg-white p-8 rounded shadow-md">
  <h1 class="text-2xl font-bold mb-6 text-center">회원가입</h1>
  <form id="joinForm" action="/usr/member/doJoin" method="post">

    <div class="form-control">
      <label class="label-text">아이디</label>
      <input type="text" name="loginId" class="input-bordered" value="${loginId}" required>
      <p id="loginIdMsg" class="text-sm mt-1">
        <c:if test="${not empty loginIdError}">
          <span class="text-red-500">${loginIdError}</span>
        </c:if>
      </p>
    </div>

    <div class="form-control">
      <label class="label-text">비밀번호</label>
      <input type="password" name="loginPw" class="input-bordered" value="${loginPw}" required>
      <p class="text-sm mt-1">
        <c:if test="${not empty loginPwError}">
          <span class="text-red-500">${loginPwError}</span>
        </c:if>
      </p>
    </div>

    <div class="form-control">
      <label class="label-text">비밀번호 확인</label>
      <input type="password" name="loginPwConfirm" class="input-bordered" required>
      <p class="pwConfirmErrorMsg text-sm mt-1 text-red-500">
        <c:if test="${not empty loginPwConfirmError}">
          ${loginPwConfirmError}
        </c:if>
      </p>
    </div>

    <div class="form-control">
      <label class="label-text">이메일</label>
      <div class="flex space-x-2">
        <input type="text" id="emailId" class="input-bordered w-2/3" value="${fn:split(email, '@')[0]}" placeholder="이메일 아이디 입력" required>
        <select id="emailDomain" class="input-bordered w-1/3">
          <option value="@gmail.com" ${email != null && email.endsWith("@gmail.com") ? "selected" : ""}>@gmail.com</option>
          <option value="@naver.com" ${email != null && email.endsWith("@naver.com") ? "selected" : ""}>@naver.com</option>
        </select>
      </div>
      <p id="emailErrorMsg" class="text-sm mt-1 text-red-500">
        <c:if test="${not empty emailError}">
          ${emailError}
        </c:if>
      </p>
      <input type="hidden" name="email" id="emailHidden" value="${email}">
      <button type="button" id="sendCodeBtn" class="btn btn-outline mt-2">인증코드 전송</button>
      <p id="emailMsg" class="text-sm mt-1"></p>
    </div>

    <div class="form-control">
      <label class="label-text">인증코드</label>
      <input type="text" name="emailCode" class="input-bordered" required>
      <p class="text-sm mt-1">
        <c:if test="${not empty emailCodeError}">
          <span class="text-red-500">${emailCodeError}</span>
        </c:if>
      </p>
    </div>

    <div class="mt-6">
      <button type="submit" class="btn w-full" onclick="
        document.getElementById('emailHidden').value = 
          document.getElementById('emailId').value + 
          document.getElementById('emailDomain').value;
      ">가입하기</button>
    </div>
  </form>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
