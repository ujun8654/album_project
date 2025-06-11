<%@ page contentType="text/html; charset=UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

<div style="padding: 40px;">
  <h1>${album.title}</h1>
  <h3>by ${album.artist}</h3>
  <img src="${album.coverImgUrl}" alt="cover" style="width:300px;">
  <p>발매일: ${album.releaseDate}</p>
  <a href="${album.spotifyUrl}" target="_blank">Spotify에서 보기</a>
</div>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
