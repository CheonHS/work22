<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 상세</title>
<style>
	table{
		margin-left : auto;
		margin-right : auto;
		border-collapse:collapse;
		width: 900px;
		height:500px;
		table-layout: fixed;
	}
	tr{
		text-align: center;
	}
	td {
		border: 1px solid black ;
	}
	th{
		border: 1px solid black ;
		background-color: #b4b4b4;
	}
	a{
		color: black;
		font-weight: bold;
		text-decoration: none;
	}
	a:hover{
		color: blue;
	}
</style>
</head>
<body>
<h1 align="center">글 상세</h1>
<table>
	<tr>
		<th>번호</th>
		<td>${board.rownum}</td>
		<th>제목</th>
		<td colspan="3">${board.b_title}</td>

	</tr>
	<tr>
		<td colspan="6" height="300px" align="left" valign="top" >
			${board.b_content}
		</td>
	</tr>
	<tr>
		<th>조회수</th>
		<td>${board.b_views}</td>
		<th>작성자</th>
		<td>${board.user.u_name}</td>
		<th colspan="2"><fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/></th>
	</tr>
	<tr>
		<td colspan="6" align="right">
			<a href="/lcomputerstudy/board-list.do">목록</a>
			<a href="/lcomputerstudy/board-edit.do?b_idx=${board.b_idx}">수정</a>
			<a href="/lcomputerstudy/board-insert.do?b_idx=${board.b_idx}">답글</a>
			<a href="/lcomputerstudy/board-delete.do?b_idx=${board.b_idx}">삭제</a>
		</td>
	</tr>
</table>
</body>
</html>