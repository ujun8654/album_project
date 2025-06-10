<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="${board.getName() } 게시판" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

	<section class="mt-8">
		<div class="container mx-auto">
			<div class="ml-8 mb-2">
				<div><span>${board.getName() } 게시판</span></div>
				<div class="flex justify-between">
					<div><span>총 : ${articlesCnt }개</span></div>
					<div class="mr-10">
						<form>
							<input type="hidden" name="boardId" value="${board.getId() }" />
							<select style="width:100px;" class="select select-sm" name="searchType">
								<option value="title" <c:if test="${searchType == 'title' }">selected</c:if>>제목</option>
								<option value="content" <c:if test="${searchType == 'content' }">selected</c:if>>내용</option>
								<option value="title,content" <c:if test="${searchType == 'title,content' }">selected</c:if>>제목 + 내용</option>
							</select>
							<label style="width:200px;" class="input input-sm">
							  <svg class="h-[1em] opacity-50" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
							    <g
							      stroke-linejoin="round"
							      stroke-linecap="round"
							      stroke-width="2.5"
							      fill="none"
							      stroke="currentColor"
							    >
							      <circle cx="11" cy="11" r="8"></circle>
							      <path d="m21 21-4.3-4.3"></path>
							    </g>
							  </svg>
							  <input type="search" name="searchKeyword" placeholder="검색어를 입력하세요" maxlength="25" value="${searchKeyword }" />
							</label>
						</form>
					</div>
				</div>
			</div>
			<div class="table-box">
				<table class="table">
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>작성일</th>
							<th>추천수</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${articles }" var="article">
							<tr class="hover:bg-base-300">
								<td>${article.getId() }</td>
								<td class="hover:underline underline-offset-4"><a href="detail?id=${article.getId() }">${article.getTitle() }</a></td>
								<td>${article.getWriterName() }</td>
								<td>${article.getRegDate().substring(2, 16) }</td>
								<td>${article.getLikePoint() }</td>
								<td>${article.getViews() }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			
			<c:if test="${req.getLoginedMember().getId() != 0 }">
				<c:choose>
					<c:when test="${req.getLoginedMember().getAuthLevel() == 0 }">
						<div class="px-6 pt-6">
							<div class="text-right"><a class="btn btn-neutral btn-outline btn-xs" href="write">글쓰기</a></div>
						</div>
					</c:when>
					<c:otherwise>
						<c:if test="${board.getId() != 1 }">
							<div class="px-6 pt-6">
								<div class="text-right"><a class="btn btn-neutral btn-outline btn-xs" href="write">글쓰기</a></div>
							</div>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
			
			<div class="flex justify-center mb-8 mt-4">
				<div class="join">
					<c:set var="queryString" value="?boardId=${board.getId() }&searchType=${searchType }&searchKeyword=${searchKeyword }" />
					
					<c:if test="${begin != 1 }">
						<a class="join-item btn btn-sm" href="${queryString }&cPage=1"><i class="fa-solid fa-angles-left"></i></a>
						<a class="join-item btn btn-sm" href="${queryString }&cPage=${begin - 1 }"><i class="fa-solid fa-caret-left"></i></a>
					</c:if>
					<c:forEach begin="${begin }" end="${end }" var="i">
						<a class="join-item btn-sm btn ${cPage == i ? 'btn-active' : '' }" href="${queryString }&cPage=${i }">${i }</a>
					</c:forEach>
					<c:if test="${end != totalPagesCnt }">
						<a class="join-item btn btn-sm" href="${queryString }&cPage=${end + 1 }"><i class="fa-solid fa-caret-right"></i></a>
						<a class="join-item btn btn-sm" href="${queryString }&cPage=${totalPagesCnt }"><i class="fa-solid fa-angles-right"></i></a>
					</c:if>
				</div>
			</div>
		</div>
	</section>
	
<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>