<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 작성</title>
<style>
	div{
		width:500px;
		margin-left : auto;
		margin-right : auto;
	}
	p, h2{
		text-align: center;
	}
	input{
		width: 220px;
		height: 50px;
	}
	textarea{
		width: 455px;
		height: 300px;
		resize: none;
	}
	.title{
		width: 455px;
	}
</style>
</head>
<body>
<div>
<h2> 글 작성 </h2>
<form action="board-write-process.do" name="boardwrite" method="post">
	<input type="hidden" name="u_idx" value="${user.u_idx}">
	<p>
		<input type="text" name="title" placeholder="글 제목" class="title">
	</p>
	<p><textarea name="content" placeholder="내용"></textarea></p>
	<p>
		<input type="button" value="돌아가기"
			   onclick="location.href='/lcomputerstudy/board-list.do'">
		<input type="submit" value="작성">
	</p>

</form>
</div>
</body>
</html>