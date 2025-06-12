<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div style="padding: 40px;">
  <h1>${album.title}</h1>
  <h3>by ${album.artist}</h3>
  <p>발매일: ${album.releaseDate}</p>

  <img src="${album.coverImgUrl}" alt="cover" style="width:300px; margin: 20px 0;">


	<h3>트랙 리스트</h3>

	<c:forEach var="track" items="${album.tracks}">
		<li>${track.name}(${track.duration})</li>
	</c:forEach>



</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
