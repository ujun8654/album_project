<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div class="min-h-screen flex items-center justify-center">
  <div class="card w-full max-w-md bg-white shadow-xl">
    <div class="card-body">
      <h2 class="card-title text-center mb-4">회원가입</h2>

      <c:if test="${not empty errorMsg}">
        <div class="text-red-500 text-center mb-2">${errorMsg}</div>
      </c:if>

      <form action="/usr/member/doJoin" method="POST" class="space-y-4">

        <!-- 아이디 -->
        <div class="form-control">
          <label class="label"><span class="label-text">아이디</span></label>
          <div class="flex gap-2">
            <input type="text" name="loginId" id="loginId" class="input input-bordered w-full" required>
            <button type="button" onclick="checkLoginIdDup()" class="btn btn-outline">중복확인</button>
          </div>
          <div id="loginIdDupMsg" class="text-sm text-gray-600 mt-1"></div>
        </div>

        <!-- 비밀번호 -->
        <div class="form-control">
          <label class="label"><span class="label-text">비밀번호</span></label>
          <input type="password" name="loginPw" class="input input-bordered" required>
        </div>

        <!-- 이름 -->
        <div class="form-control">
          <label class="label"><span class="label-text">이름</span></label>
          <input type="text" name="name" class="input input-bordered" required>
        </div>

        <!-- 이메일 -->
        <div class="form-control">
          <label class="label"><span class="label-text">이메일</span></label>
          <div class="flex gap-2">
            <input type="email" name="email" id="email" class="input input-bordered w-full" required>
            <button type="button" onclick="sendEmailCode()" class="btn btn-outline">인증코드 전송</button>
          </div>
          <div id="emailSendMsg" class="text-sm text-gray-600 mt-1"></div>
        </div>

        <!-- 인증코드 -->
        <div class="form-control">
          <label class="label"><span class="label-text">인증코드</span></label>
          <input type="text" name="emailCode" placeholder="6자리 코드 입력" class="input input-bordered" required>
        </div>

        <!-- 가입 버튼 -->
        <div class="form-control mt-6">
          <button type="submit" class="btn btn-primary w-full">가입하기</button>
        </div>

        <p class="text-center text-sm mt-4 text-gray-600">
          이미 계정이 있으신가요?
          <a href="/usr/member/login" class="text-blue-500 underline ml-1">로그인</a>
        </p>
      </form>
    </div>
  </div>
</div>

<script>
  function checkLoginIdDup() {
    const loginId = $('#loginId').val();
    if (!loginId.trim()) {
      alert('아이디를 입력해주세요.');
      return;
    }

    $.get('/usr/member/loginIdDupChk', { loginId }, function(res) {
      if (res.success) {
        $('#loginIdDupMsg').text('사용 가능한 아이디입니다.').css('color', 'green');
      } else {
        $('#loginIdDupMsg').text('이미 사용 중인 아이디입니다.').css('color', 'red');
      }
    });
  }

  function sendEmailCode() {
    const email = $('#email').val();
    if (!email.trim()) {
      alert('이메일을 입력해주세요.');
      return;
    }

    $.post('/usr/member/sendEmailCode', { email }, function(res) {
      if (res.success) {
        $('#emailSendMsg').text('이메일로 인증코드를 전송했습니다.').css('color', 'green');
      } else {
        $('#emailSendMsg').text('인증코드 전송에 실패했습니다.').css('color', 'red');
      }
    });
  }
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
