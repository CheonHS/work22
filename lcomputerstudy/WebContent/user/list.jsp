<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원목록2</title>
<style>
	h1 {
		text-align:center;
	}
	table {
		border-collapse:collapse;
		margin:40px auto;
	}
	table tr th {
		font-weight:700;
	}
	table tr td, table tr th {
		border:1px solid #818181;
		width:200px;
		text-align:center;
	}
	a {
		text-decoration:none;
		color:#000;
		font-weight:700;
	}
	ul {
		width:600px;
		height:50px;
		margin:10px auto;
	}
	li {
		list-style:none;
		width:50px;
		line-height:50px;
		border:1px solid #ededed;
		float:left;
		text-align:center;
		margin:0 5px;
		border-radius:5px;
	}
	.half{
		border:1px solid #818181;
		width:100px;
		text-align:center;
	}
</style>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<body>
<h1>회원 목록</h1>
<div id="userList">
	<table >
		<tr>
			<td colspan="5">전체 회원 수 : ${pagination.count}</td>
		<tr>
			<th>No</th>
			<th>ID</th>
			<th>이름</th>
			<th class="half">등급</th>
			<th>권한</th>
		</tr>
		<c:forEach items="${list}" var="item" varStatus="status">
		 <tr>
			<td><a href="user-detail.do?u_idx=${item.u_idx}">${item.rownum}</a></td>
			<td>${item.u_id}</td>
			<td>${item.u_name}</td>
			<td class="half">
				<c:choose>
					<c:when test="${item.u_level eq 0}">미정</c:when>
					<c:when test="${item.u_level eq 1}">회원</c:when>
					<c:when test="${item.u_level eq 9}">관리자</c:when>
				</c:choose>
			</td>
			<td>
				<input type="hidden" name="u_idx" value="${item.u_idx}">
				<select name="u_level">
					<option value="" selected disabled hidden=""></option>
					<option value="1">회원</option>
					<option value="9">관리자</option>
				</select>
				<input type="button" value="변경" class="btnLevel">
			</td>
	     <tr>
		</c:forEach>
	</table>
	<div>
		<ul>
			 <c:choose>
				<c:when test="${ pagination.prevPage lt 5 }">
					<li style="display:none;">
						<span>◀</span>
					</li>
				</c:when>
				<c:when test="${ pagination.prevPage ge 5}">
					<li>
						<a href="user-list.do?page=${pagination.prevPage}">
							◀
						</a>
					</li>
				</c:when>
			</c:choose> 
			<c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}" step="1">
				
					<c:choose>
						<c:when test="${ pagination.page eq i }">
							
							<li style="background-color:#ededed;">
								<span>${i}</span>
							</li>
						</c:when>
						<c:when test="${ pagination.page ne i }">
							<li>
								<a href="user-list.do?page=${i}">${i}</a>
							</li>
						</c:when>
					</c:choose>
			</c:forEach>
			 <c:choose>
				<c:when test="${ pagination.nextPage lt pagination.lastPage }">
					<li style="">
						<a href="user-list.do?page=${pagination.nextPage}">▶</a>
					</li>
				</c:when>
				<c:when test="${ pagination.nextPage ge pagination.lastPage}">
					<li style="display:none;">
						<a href="user-list.do?page=${pagination.nextPage}">▶</a>
					</li>
				</c:when>
			</c:choose> 
			<%--  <li>
				<a href="user-list.do?page=${pagination.nextPage}">▶</a>
			</li>  --%>
		</ul>
	</div>
</div>	
	<div style="width:800px; text-align: right;">
		<input type="button" value="회원정보" onclick="location.href='/lcomputerstudy/login-view.do'"/>
	</div>
</body>
<script>
$(document).on('click', '.btnLevel', function() {
	let u_idx = $(this).prev().prev().val();
	let u_level = $(this).prev().val();
	let page = ${pagination.page};

	
	console.log(u_idx);
	console.log(u_level);
	
	$.ajax({
		  method: "POST",
		  url: "user-level.do",
		  data: { u_idx: u_idx, u_level: u_level, page: page }
	})
	.done(function( msg ) {
	    $('#userList').html(msg);
	});
	if(${sessionScope.user.u_idx == u_idx}){
		
	}
	console.log(${sessionScope.user.u_idx});
	console.log(${sessionScope.user.u_level});
});
</script>
</html>