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
		margin-left: 20px;
	}
	a:hover{
		color: blue;
	}
	.mainDiv{
		width: 900px;
		margin-left: auto;
		margin-right: auto;
		border: 1px solid black;
	}
	textarea{
		resize: none;
		vertical-align: middle;
	}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</head>
<body>
<h1 align="center">글 상세</h1>
<table>
	<tr>
		<th>제목</th>
		<td colspan="2">${board.b_title}</td>
		<td><fmt:formatDate value="${board.b_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/></td>
	</tr>
	<tr>
		<td colspan="4" height="300px" align="left" valign="top" >
			${board.b_content}
		</td>
	</tr>
	<tr>
		<th>조회수</th>
		<td>${board.b_views}</td>
		<th>작성자</th>
		
		<td>${board.user.u_name}</td>
	</tr>
</table>
<div class="mainDiv" align="center" style="vertical-align: top; ">
	<b>댓글 작성</b>
	<form name="commentInsert" action="comment-insert.do" method="post">
		<input type="hidden" id="bIdxForm"  name="b_idx" value="${board.b_idx}">
		<input type="hidden" id="uIdxForm" name="u_idx" value="${sessionScope.user.u_idx}">
		<textarea id="contentForm" name="c_content" style="width: 800px; height: 50px;"></textarea>
		<input type="button" id="btnCommentWrite" value="등록" style="height: 50px;">
	</form>
	<c:if test="${empty commentlist}"><br><b>댓글이 없습니다</b></c:if>
	<c:if test="${not empty commentlist}"><br><b>댓글 목록</b></c:if>
	<div id=commentList>
		<c:forEach items="${commentlist}" var="c">
	<div align="left" style="margin-left: 30px;">
		<c:if test="${c.c_depth ne 0 }">
			<c:forEach var="var" begin="1" end="${c.c_depth}" step="1">└</c:forEach>
		</c:if>
		<b>${c.user.u_name}</b> / 
		<small><fmt:formatDate value="${c.c_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/></small>
	</div>
	<div>
		<c:choose>
		<c:when test="${sessionScope.user.u_idx eq c.user.u_idx}">
			<div>
				<textarea readonly style="width: 700px; height: 50px">${c.c_content}</textarea>
				<input type="button" value="답글" style="height: 50px;" class="btnReply" cidx="${c.c_idx}">
				<input type="button" value="수정" style="height: 50px;"
					id="cEditButton${c.c_idx}" onclick="cEdit(${c.c_idx})">
				<input type="button" value="삭제" style="height: 50px;"
					onclick="location.href='/lcomputerstudy/comment-delete.do?c_idx=${c.c_idx}&&b_idx=${c.b_idx}'">
			</div>
			<div id="cReplyDiv${c.c_idx}" style="margin-left:30px; display: none;">
				<form name="commentReply${c.c_idx}" action="comment-reply.do" method="post">
					<input type="hidden" name="b_idx" value="${c.b_idx}">
					<input type="hidden" name="u_idx" value="${sessionScope.user.u_idx}">
					<input type="hidden" name="c_group" value="${c.c_group }">
					<input type="hidden" name="c_order" value="${c.c_order }">
					<input type="hidden" name="c_depth" value="${c.c_depth }">
					<textarea name="c_content" style="width: 750px; height: 50px;"></textarea>
					<input type="submit" value="답글등록" style="height: 50px;">
				</form>
			</div>
			<div id="cEditDiv${c.c_idx}" style="margin-left:30px; display: none;">
				<form name="commentReply${c.c_idx}" action="comment-edit.do" method="post">
					<input type="hidden" name="c_idx" value="${c.c_idx}">
					<input type="hidden" name="b_idx" value="${c.b_idx}">
					<textarea name="c_content" style="width: 750px; height: 50px;"></textarea>
					<input type="submit" value="답글수정" style="height: 50px;">
				</form>
			</div>
		</c:when>
		<c:when test="${sessionScope.user.u_idx ne c.user.u_idx}">
			<div>
				<textarea readonly style="width: 800px; height: 50px">${c.c_content}</textarea>
			</div>
		</c:when>
		</c:choose>
	</div>
</c:forEach>
	</div>
</div>
<br>
<div class="mainDiv" align="right">
	<a href="/lcomputerstudy/board-list.do">목록</a>
	<a href="/lcomputerstudy/board-edit.do?b_idx=${board.b_idx}">수정</a>
	<a href="/lcomputerstudy/board-reply.do?b_idx=${board.b_idx}">답글</a>
	<a href="/lcomputerstudy/board-delete.do?b_idx=${board.b_idx}">삭제</a>
</div>
</body>
<script type="text/javascript">
	function cReply(x){
		var a = 'cReplyDiv' + x.toString();
		var b = 'cReplyButton' + x.toString();
		const t = document.getElementById(a);
		if(t.style.display !== 'none') {
		    t.style.display = 'none';
		    document.getElementById(b).value = '답글';
		  }
		  else {
		    t.style.display = 'block';
		    document.getElementById(b).value = '취소';
		  }
	}
	function cEdit(x){
		var a = 'cEditDiv' + x.toString();
		var b = 'cEditButton' + x.toString();
		const t = document.getElementById(a);
		if(t.style.display !== 'none') {
		    t.style.display = 'none';
		    document.getElementById(b).value = '수정';
		  }
		  else {
		    t.style.display = 'block';
		    document.getElementById(b).value = '취소';
		  }
	}

	$(document).on('click', '#btnCommentWrite', function () {
		let content = $('#contentForm').val();
		let bIdx = '${board.b_idx}';
		let uIdx = '${sessionScope.user.u_idx}';
		console.log(content);
		console.log(bIdx);
		console.log(uIdx);

		$.ajax({
			  method: "POST",
			  url: "aj-insert-comment.do",
			  data: { b_idx: bIdx, u_idx: uIdx, c_content: content }
		})
		.done(function( msg ) {
		    $('#commentList').html(msg);
		});

		
	});

	$(document).on('click', '.btnReply', function () {
		let c_idx = $(this).attr('cidx');
		console.log(c_idx);
		$(this).parent().next().css('display', '');
	});
</script>
</html>