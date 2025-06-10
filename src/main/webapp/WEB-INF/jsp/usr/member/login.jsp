<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="로그인" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

	<script>
		const loginFormChk = function (form) {
			form.loginId.value = form.loginId.value.trim();
			form.loginPw.value = form.loginPw.value.trim();
			
			if (form.loginId.value.length == 0) {
				alert('아이디는 필수 입력 정보입니다');
				form.loginId.focus();
				return false;
			}
			
			if (form.loginPw.value.length == 0) {
				alert('비밀번호는 필수 입력 정보입니다');
				form.loginPw.focus();
				return false;
			}
			
			return true;
		}
	</script>

	<section class="mt-8">
		<div class="container mx-auto">
			<form action="doLogin" method="post" onsubmit="return loginFormChk(this);">
				<div class="table-box">
					<table class="table">
						<tr>
							<td colspan="2">
								<label class="input">
								  <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
								    <g
								      stroke-linejoin="round"
								      stroke-linecap="round"
								      stroke-width="2.5"
								      fill="none"
								      stroke="currentColor"
								    >
								      <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"></path>
								      <circle cx="12" cy="7" r="4"></circle>
								    </g>
								  </svg>
								  <input
								    type="text"
								    name="loginId"
								  />
								</label>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<label class="input">
								  <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
								    <g
								      stroke-linejoin="round"
								      stroke-linecap="round"
								      stroke-width="2.5"
								      fill="none"
								      stroke="currentColor"
								    >
								      <path
								        d="M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z"
								      ></path>
								      <circle cx="16.5" cy="7.5" r=".5" fill="currentColor"></circle>
								    </g>
								  </svg>
								  <input
								    type="password"
								    name="loginPw"
								  />
							</td>
						</tr>
						<tr>
							<td colspan="2"><button class="btn btn-neutral btn-outline btn-sm btn-wide">로그인</button></td>
						</tr>
					</table>
				</div>
			</form>
			
			<div class="p-6">
				<div><button class="btn btn-neutral btn-outline btn-xs" onclick="history.back();">뒤로가기</button></div>
			</div>
		</div>
	</section>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>