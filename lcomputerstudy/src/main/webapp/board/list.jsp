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
	a:hover{
		color: blue;
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
				<td class="idx">${board.b_idx}</td>
				<td><c:out value="${fn:length(board.b_title) gt 10 ? fn:substring(board.b_title,0,10) : board.b_title}"/></td>
				<td class="content">${board.b_content}</td>
				<td>${board.b_views}</td>
				<td>${fn:length(board.b_writer) gt 10 ? fn:substring(board.b_writer,0,10) : board.b_writer}</td>
				<td>
					<fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/>
				</td>
		     <tr>
		</c:forEach>
		<tr class="button">
			<td colspan="5"/>
			<td align="center"><a href="/lcomputerstudy/board-write.do">글 등록</a></td>
		</tr>
	</table>
</body>
</html>