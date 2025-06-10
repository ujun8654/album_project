<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="작성" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>
<%@ include file="/WEB-INF/jsp/common/toastUiEditorLib.jsp" %>

	<section class="mt-8">
		<div class="container mx-auto">
			<form action="doWrite" method="post" onsubmit="return submitForm(this);">
				<input type="hidden" name="content" />
				<div class="table-box">
					<table class="table">
						<tr>
							<th>게시판</th>
							<td>
								<c:if test="${req.getLoginedMember().getAuthLevel() == 0 }">
									<label>
										<input class="radio radio-neutral radio-xs" name="boardId" type="radio" value="1" />
										공지사항
									</label>
									&nbsp;&nbsp;&nbsp;
								</c:if>
								<label>
									<input class="radio radio-neutral radio-xs" name="boardId" type="radio" value="2" checked />
									자유
								</label>
								&nbsp;&nbsp;&nbsp;
								<label>
									<input class="radio radio-neutral radio-xs" name="boardId" type="radio" value="3" />
									질문과 답변
								</label>
							</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input class="input input-neutral" name="title" type="text" /></td>
						</tr>
						<tr>
							<th>내용</th>
							<td>
								<div id="toast-ui-editor"></div>
							</td>
						</tr>
						<tr>
							<td colspan="2"><button class="btn btn-neutral btn-outline btn-sm btn-wide">저장</button></td>
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