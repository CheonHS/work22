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
		border-collapse:collapse;
		width : 1000px;
		table-layout: fixed;
	}
	th, td{
		height: 50px;
		width: 150px;
		border : 1px solid black;
	}
	a{
		color: black;
		font-weight: bold;
		text-decoration: none;
	}
	ul{
		width: 450px;
		margin-left: auto
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
	.content{
		width: 320px;
	}
	.idx{
		width: 80px;
	}
	.button td{
		vertical-align: bottom;
		border: none;
	}
	.row{
		font-size :0.9em;
		text-align: center;
	}
	.row td{
		height: 30px;
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
			<th class="idx">No</th>
			<th>제목</th>
			<th class="content">내용</th>
			<th>조회수</th>
			<th>작성자</th>
			<th>작성일시</th>
		</tr>
		<c:forEach items="${boardlist}" var="board">
			 <tr class="row"
			 	 onclick="location.href='/lcomputerstudy/board-detail.do?b_idx=${board.b_idx}'">
				<td class="idx">${board.rownum}</td>
				<td><c:out value="${fn:length(board.b_title) gt 10 ? fn:substring(board.b_title,0,10) : board.b_title}"/></td>
				<td class="content">${fn:length(board.b_content) gt 20 ? fn:substring(board.b_content,0,10) : board.b_content}</td>
				<td>${board.b_views}</td>
				<td>${board.user.u_name}</td>
				<td>
					<fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/>
				</td>
		     <tr>
		</c:forEach>
		<tr>
			<td colspan="6" align="center" style="border : none;">
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
						<c:when test="${ pagination.nextPage gt pagination.lastPage}">
							<li style="display:none;">
								<a href="board-list.do?page=${pagination.nextPage}">▶</a>
							</li>
						</c:when>
					</c:choose> 
				</ul>
			</td>
		</tr>
		<tr class="button">
			<td colspan="5"/>
			<td align="center"><a href="/lcomputerstudy/board-write.do?u_idx=${user.u_idx}">글 등록</a></td>
		</tr>
	</table>
</body>
</html>