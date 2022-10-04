<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 수정</title>
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
<h2> 글 수정 </h2>
<form action="board-edit-process.do" name="boardwrite" method="post">
	<input type="hidden" name="u_idx" value="${board.user.u_idx}">
	<input type="hidden" name="b_idx" value="${board.b_idx}">
	<p>
		<input type="text" name="title" value="${board.b_title}" class="title">
	</p>
	<p><textarea name="content">${board.b_content}</textarea></p>
	<p>
		<input type="button" value="돌아가기"
			   onclick="location.href='/lcomputerstudy/board-detail.do?b_idx=${board.b_idx}'">
		<input type="submit" value="수정">
	</p>

</form>
</div>
</body>
</html>