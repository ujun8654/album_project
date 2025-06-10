<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="상세보기" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

	<script>
		$(function(){
			getLikePoint();
			getReplies();
			getLoginId();
			
			$('#replyArea').on('click', '.modifyBtn', function () {
				const id = $(this).data('id');
				const content = $(this).data('content');
				
				replyModifyForm(id, content);
			})
			
			$('#replyArea').on('click', '.deleteBtn', function () {
				const id = $(this).data('id');
				
				if (confirm('정말로 삭제하시겠습니까?') == false) {
					return;
				}
				
				deleteReply(id);
			})
			
			$('#replyArea').on('click', '#replyModifyCancleBtn', function () {
				const id = $(this).data('id');
				
				replyModifyCancle(id);
			})
			
			$('#replyArea').on('click', '#modifyReplyBtn', function () {
				const id = $(this).data('id');
				
				modifyReply(id);
			})
		})
		
		const getLoginId = function() {
			$.ajax({
				url : '/usr/member/getLoginId',
				type : 'GET',
				dataType : 'text',
				success : function(data) {
					$('.loginedMemberLoginId').html(data);
				},
				error : function(xhr, status, error) {
					console.log(error);
				}
			})
		}
		
		const clickLikePoint = async function () {
			let likePointBtn = $('#likePointBtn > i').hasClass('fa-solid');
			
			await $.ajax({
				url : '/usr/likePoint/clickLikePoint',
				type : 'POST',
				data : {
					relTypeCode : 'article',
					relId : ${article.getId() },
					likePointBtn : likePointBtn
				},
			})
			await getLikePoint();
		}
		
		const getLikePoint = function () {
			$.ajax({
				url : '/usr/likePoint/getLikePoint',
				type : 'GET',
				data : {
					relTypeCode : 'article',
					relId : ${article.getId() },
				},
				dataType : 'json',
				success : function (data) {
					$('#likePointCnt').html(data.rsData);
					
					if (data.success) {
						$('#likePointBtn').html(`<i class="fa-solid fa-thumbs-up"></i>`);
					} else {
						$('#likePointBtn').html(`<i class="fa-regular fa-thumbs-up"></i>`);
					}
				},
				error : function (xhr, status, error) {
					console.log(error);
				}
			})
		}
		
		const writeReply = async function () {
			let replyContent = $('#replyContent');
			
			if (replyContent.val().length == 0) {
				alert('내용이 없는 댓글은 작성할 수 없습니다');
				replyContent.focus();
				return;
			}
			
			let replyId = '';
			
			await $.ajax({
				url : '/usr/reply/doWrite',
				type : 'POST',
				data : {
					relTypeCode : 'article',
					relId : ${article.getId() },
					content : replyContent.val()
				},
				success : function (data) {
					replyId = data;
				},
				error : function (xhr, status, error) {
					console.log(error);
				}
			})
			
			await addReply(replyId, 'write');
			
			replyContent.val('');
		}
		
		const getReplies = function () {
			$.ajax({
				url : '/usr/reply/list',
				type : 'GET',
				data : {
					relTypeCode : 'article',
					relId : ${article.getId() },
				},
				dataType : 'json',
				success : function (data) {
					for (idx in data) {
						let btnHtml = '';
						
						if (data[idx].memberId == ${req.getLoginedMember().getId() }) {
							btnHtml = `
								<div class="dropdown dropdown-bottom dropdown-end mr-4">
								  <button tabindex="0" class="btn btn-circle btn-ghost btn-xs">
							        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block h-5 w-5 stroke-current"> <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path> </svg>
							      </button>
								  <ul tabindex="0" class="dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm">
								    <li class="w-14"><button class="modifyBtn" data-id="\${data[idx].id }" data-content="\${data[idx].content}">수정</button></li>
								    <li class="w-14"><button class="deleteBtn" data-id="\${data[idx].id }">삭제</button></li>
								  </ul>
								</div>
							`;
						}
						
						let addHtml = `
							<div id="\${data[idx].id }" class="py-2 border-b-2 border-gray-200 pl-20">
								<div class="flex justify-between items-center">
									<div class="font-semibold">\${data[idx].writerName }</div>
									\${btnHtml }
								</div>
								<div class="text-lg my-1 ml-2">\${data[idx].content }</div>
								<div class="text-xs text-gray-400">\${data[idx].updateDate }</div>
							</div>
						`;
						
						$('#replyArea').append(addHtml);
					}
				},
				error : function (xhr, status, error) {
					console.log(error);
				}
			})
		}
		
		const addReply = function (id, method) {
			$.ajax({
				url : '/usr/reply/getReply',
				type : 'GET',
				data : {
					id : id
				},
				dataType : 'json',
				success : function (data) {
						let addHtml = `
							<div id="\${data.id }" class="py-2 border-b-2 border-gray-200 pl-20">
								<div class="flex justify-between items-center">
									<div class="font-semibold">\${data.writerName }</div>
									<div class="dropdown dropdown-bottom dropdown-end mr-4">
									  <button tabindex="0" class="btn btn-circle btn-ghost btn-xs">
								        <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block h-5 w-5 stroke-current"> <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path> </svg>
								      </button>
									  <ul tabindex="0" class="dropdown-content menu bg-base-100 rounded-box z-1 w-52 p-2 shadow-sm">
									    <li class="w-14"><button class="modifyBtn" data-id="\${data.id }" data-content="\${data.content}">수정</button></li>
									    <li class="w-14"><button class="deleteBtn" data-id="\${data.id }">삭제</button></li>
									  </ul>
									</div>
								</div>
								<div class="text-lg my-1 ml-2">\${data.content }</div>
								<div class="text-xs text-gray-400">\${data.updateDate }</div>
							</div>
						`;
						
						if (method == 'write') {
							$('#replyArea').append(addHtml);
						} else if (method == 'modify') {
							$('#' + id).replaceWith(addHtml);
							
							originalForm = $('#' + id).html();
						}
						
				},
				error : function (xhr, status, error) {
					console.log(error);
				}
			})
		}
		
		const deleteReply = function (id) {
			$.ajax({
				url : '/usr/reply/delete',
				type : 'POST',
				data : {
					id : id
				},
			})
			
			$('#' + id).remove();
		}
		
		const modifyReply = async function (id) {
			let replyModifyContent = $('#replyModifyContent');
			
			if (replyModifyContent.val().length == 0) {
				alert('내용이 없는 댓글로 수정할 수 없습니다');
				replyModifyContent.focus();
				return;
			}
			
			await $.ajax({
				url : '/usr/reply/modify',
				type : 'POST',
				data : {
					id : id,
					content : replyModifyContent.val()
				},
			})
			
			await addReply(id, 'modify');
		}
		
		let originalForm = null;
		let originalId = null;
		
		const replyModifyForm = function (id, content) {
			
			if (originalForm != null) {
				replyModifyCancle(originalId);
			}
			
			let replyForm = $('#' + id);
			
			originalForm = replyForm.html();
			originalId = id;
			
			let addHtml = `
				<div>
					<div class="border-2 border-gray-200 rounded-xl px-4 mt-2">
						<div class="mt-3 mb-2 font-semibold text-sm loginedMemberLoginId"></div>
						<textarea style="width: 100%; resize: none;" id="replyModifyContent" class="textarea">\${content}</textarea>
						<div class="flex justify-end my-2">
							<button id="replyModifyCancleBtn" data-id="\${id}" class="btn btn-neutral btn-outline btn-xs mr-2">취소</button>
							<button id="modifyReplyBtn" data-id="\${id}" class="btn btn-neutral btn-outline btn-xs">수정</button>
						</div>
					</div>
				</div>
			`;
			
			replyForm.html(addHtml);
			
			getLoginId();
		}
		
		const replyModifyCancle = function(id) {
			let replyForm = $('#' + id);
			
			replyForm.html(originalForm);
			
			originalForm = null;
			originalId = null;
		}
	</script>

	<section class="mt-8">
		<div class="container mx-auto">
			<div class="table-box">
				<table class="table">
					<tr>
						<th>번호</th>
						<td>${article.getId() }</td>
					</tr>
					<tr>
						<th>작성일</th>
						<td>${article.getRegDate().substring(2, 16) }</td>
					</tr>
					<tr>
						<th>수정일</th>
						<td>${article.getUpdateDate().substring(2, 16) }</td>
					</tr>
					<tr>
						<th>추천수</th>
						<td>
							<c:if test="${req.getLoginedMember().getId() == 0 }">
								<span id="likePointCnt"></span>
							</c:if>
							<c:if test="${req.getLoginedMember().getId() != 0 }">
								<button class="btn btn-neutral btn-outline btn-xs" onclick="clickLikePoint();">
									<span id="likePointCnt"></span>
									<span id="likePointBtn"></span>
								</button>
							</c:if>
						</td>
					</tr>
					<tr>
						<th>조회수</th>
						<td>${article.getViews() }</td>
					</tr>
					<tr>
						<th>작성자</th>
						<td>${article.getWriterName() }</td>
					</tr>
					<tr>
						<th>제목</th>
						<td>${article.getTitle() }</td>
					</tr>
					<tr>
						<th>내용</th>
						<td>${article.getForPrintContent() }</td>
					</tr>
				</table>
			</div>
			
			<div class="p-6 flex justify-between">
				<div><button class="btn btn-neutral btn-outline btn-xs" onclick="history.back();">뒤로가기</button></div>
				<c:if test="${article.getMemberId() == req.getLoginedMember().getId() }">
					<div class="flex">
						<div class="mr-2"><a class="btn btn-neutral btn-outline btn-xs" href="modify?id=${article.getId() }">수정</a></div>
						<div><a class="btn btn-neutral btn-outline btn-xs" href="delete?id=${article.getId() }&boardId=${article.getBoardId() }" onclick="if(confirm('정말로 삭제하시겠습니까?') == false) return false;">삭제</a></div>
					</div>
				</c:if>
			</div>
		</div>
	</section>
	
	<section class="my-4">
		<div class="container mx-auto">
			<div id="replyArea">
				<div class="text-lg">댓글</div>
			</div>
			
			<div>
				<c:if test="${req.getLoginedMember().getId() != 0 }">
					<div class="border-2 border-gray-200 rounded-xl px-4 mt-2">
						<div class="mt-3 mb-2 font-semibold text-sm loginedMemberLoginId"></div>
						<textarea style="width: 100%; resize: none;" id="replyContent" class="textarea"></textarea>
						<div class="flex justify-end my-2">
							<button class="btn btn-neutral btn-outline btn-xs" onclick="writeReply();">등록</button>
						</div>
					</div>
				</c:if>
			</div>
		</div>
	</section>
	
<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>