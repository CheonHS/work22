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
		width: 600px;
		table-layout: fixed;
	}
	td {
		width: 100px;
		height: 30px;
		border: 1px solid black ;
		text-align: center;
	}
	a{
		color: black;
		font-weight: bold;
		font-size: 1.5em;
		text-decoration: none;
	}
	a:hover{
		color: blue;
	}
	.title{
		width: 300px;
	}
	.content{
		height: 300px;
		text-align: left;
		vertical-align: top;
	}
	.back td{
		border: none;
	}
	.type{
		background-color:#b4b4b4; 
	}
</style>
</head>
<body>
<h1 align="center">글 상세보기</h1>
<table>
	<tr>
		<td class="type">No</td>
		<td>${board.b_idx}</td>
		<td class="type">제목</td>
		<td class="title" colspan="3">${board.b_title}</td>


	</tr>
	<tr >
		<td class="content" colspan="6">
			${board.b_content}
		</td>
	</tr>
	<tr>
		<td class="type">조회수</td>
		<td>${board.b_views}</td>
		<td class="type">작성자</td>
		<td>${board.user.u_name}</td>
		<td  colspan="2">
			<fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/>
		</td>
	</tr>
	<tr  class="back">
		<td colspan="2">
			<a href="/lcomputerstudy/board-list.do">목록</a>
		</td>
		<td colspan="2">
			<a href="/lcomputerstudy/board-edit.do?b_idx=${board.b_idx}">수정</a>
		</td>
		<td colspan="2">
			<a href="/lcomputerstudy/board-delete.do?b_idx=${board.b_idx}">삭제</a>
		</td>
	</tr>
</table>
</body>
</html>