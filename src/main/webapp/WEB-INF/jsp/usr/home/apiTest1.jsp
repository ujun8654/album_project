<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<c:set var="pageTitle" value="API Test" />

<%@ include file="/WEB-INF/jsp/common/header.jsp" %>

	<section class="mt-8">
		<div class="container mx-auto">
			<div>API TEST 페이지 입니다</div>
			<div id="apiTest"></div>
		</div>
	</section>

<script>
	const api_key = 'sd2/w1FPMP7dCiLT1r8GNJatfwBCKhZfFVQAA3lNV55hr4o2tNP9B0NpNBn7iAGvAN8QwKTBfli73H/dq7xZBw==';
	const url = 'http://apis.data.go.kr/B552584/UlfptcaAlarmInqireSvc/getUlfptcaAlarmInfo';
	
	const apiTest = function () {
		$.ajax({
			url: url,
			type: 'GET',
			data: {
				serviceKey: api_key,
				year: 2025,
				returnType: 'json'
			},
			dataType: 'json',
			success: function (data) {
				$('#apiTest').html(data.response.body.items[0].districtName);
			},
			error: function (xhr, status, error) {
				console.log(error);
			}
		})
	}
	
	apiTest();
	
</script>

<%@ include file="/WEB-INF/jsp/common/footer.jsp" %>
