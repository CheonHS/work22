<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<style>
	table {
		margin-left : auto;
		margin-right : auto;
		margin-bottom : 20px;
		border-collapse:collapse;
		width : 700px;
	}
	td, th{
		border : 1px solid black;
		height: 30px;
	}
	a{
		color: black;
		font-weight: bold;
		text-decoration: none;
	}
	ul{
		width: 300px;
		margin-left: auto;
		margin-right: auto;
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
	.row{
		font-size :0.9em;
		text-align: center;
	}
	.row:hover{
		background-color: #b4b4b4;
	}
</style>
</head>
<body>
<h1 align="center">게시판 목록</h1>
	<table>
		<tr>
			<th>No</th>
			<th width="300px">제목</th>
			<th>조회수</th>
			<th>작성자</th>
			<th>작성일시</th>
		</tr>
		<c:forEach items="${boardlist}" var="board">
		 <tr class="row" onclick="location.href='/lcomputerstudy/board-detail.do?b_idx=${board.b_idx}'">
			<td>${board.rownum}</td>
			<td  align="left">
				<c:forEach var="var" begin="0" end="${board.b_depth}" step="1">&nbsp&nbsp</c:forEach>
				<c:if test="${board.b_depth ne 0 }">└</c:if>
				<c:out value="${fn:length(board.b_title) gt 10 ? fn:substring(board.b_title,0,10) : board.b_title}"/>
			</td>
			<td>${board.b_views}</td>
			<td>${board.user.u_name}</td>
			<td><fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/></td>
	     <tr>
		</c:forEach>
	</table>
	<div style="width: 300px; margin-left: 35%;">
	<ul>
		<c:choose>
		<c:when test="${ pagination.prevPage lt 5 }">
			<li style="display:none;">
				<span>◀</span>
			</li>
		</c:when>
		<c:when test="${ pagination.prevPage ge 5}">
			<li>
				<a href="board-list.do?page=${pagination.prevPage}">
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
						<a href="board-list.do?page=${i}">${i}</a>
					</li>
				</c:when>
			</c:choose>
		</c:forEach>
		<c:choose>
			<c:when test="${ pagination.nextPage le pagination.lastPage }">
				<li style="">
					<a href="board-list.do?page=${pagination.nextPage}">▶</a>
				</li>
			</c:when>
			<c:when test="${ pagination.nextPage ge pagination.lastPage}">
				<li style="display:none;">
					<a href="board-list.do?page=${pagination.nextPage}">▶</a>
				</li>
			</c:when>
		</c:choose> 
	</ul>
	</div>
	<div style="text-align: center;">
		<p><a href="/lcomputerstudy/board-write.do?u_idx=${user.u_idx}">글 등록</a></p>
	</div>
</body>
</html>