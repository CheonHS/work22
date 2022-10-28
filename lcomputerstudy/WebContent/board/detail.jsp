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
		<div id="commentList">
		
			<c:forEach items="${commentlist}" var="c">
				<div align="left" style="margin-left: 30px; margin-top: 10px;">
					<c:if test="${c.c_depth ne 0 }">
						<c:forEach var="var" begin="1" end="${c.c_depth}" step="1">└</c:forEach>
					</c:if>
					<b>${c.user.u_name}</b> / 
					<small><fmt:formatDate value="${c.c_date}" pattern="yyyy-MM-dd HH-mm-ss" type="date"/></small>
				</div>
				<div>
					<div class="cButtonDiv">
						<textarea readonly style="width: 700px; height: 50px">${c.c_content}</textarea>
						<input type="button" value="답글" style="height: 50px;" class="btnCommentReply">
						<input type="button" value="수정" style="height: 50px;" class="btnCommentEdit"
							uIdx="${c.user.u_idx}">
						<input type="button" value="삭제" style="height: 50px;" class="btnCommentDel"
							uIdx="${c.user.u_idx}" cIdx="${c.c_idx}" bIdx="${c.b_idx}">
					</div>
					<div class="cReplyDiv" style="margin-left:30px; display: none;">
						<textarea name="c_content" style="width: 750px; height: 50px;"></textarea>
						<input type="button" value="등록" style="height: 50px;" class="btnCommentReplyOn"
							bIdx="${c.b_idx}" uIdx="${sessionScope.user.u_idx}"
							cGroup="${c.c_group }"	cOrder="${c.c_order }" cDepth="${c.c_depth }">
						<input type="button" value="취소" style="height: 50px;" class="btnCommentReplyCancel">
					</div>
					<div class="cEditDiv" style="margin-left:30px; display: none;">	
						<input type="button" value="수정" style="height: 50px;" class="btnCommentEditOn"
							cIdx="${c.c_idx}" bIdx="${c.b_idx}">
						<input type="button" value="취소" style="height: 50px;" class="btnCommentEditCancel">
					</div>
				</div>
			</c:forEach>
			
		</div>
</div>
<br>
<div class="mainDiv" align="right">
	<a href="/lcomputerstudy/board-list.do">목록</a>
	<c:if test="${board.user.u_idx eq sessionScope.user.u_idx}">
		<a href="/lcomputerstudy/board-edit.do?b_idx=${board.b_idx}">수정</a>
	</c:if>
	<a href="/lcomputerstudy/board-reply.do?b_idx=${board.b_idx}">답글</a>
	<c:if test="${board.user.u_idx eq sessionScope.user.u_idx || sessionScope.user.u_level eq 9}">
		<a href="/lcomputerstudy/board-delete.do?b_idx=${board.b_idx}">삭제</a>
	</c:if>
</div>
</body>
<script>
	
	$(document).on('click', '#btnCommentWrite', function () {
		let content = $('#contentForm').val();
		let bIdx = '${board.b_idx}';
		let uIdx = '${sessionScope.user.u_idx}';
		console.log(content);
		console.log(bIdx);
		console.log(uIdx);

		if(uIdx==''){
			alert("로그인이 필요합니다");
			location.href='/lcomputerstudy/user-login.do';
		}
		
		$.ajax({
			  method: "POST",
			  url: "aj-insert-comment.do",
			  data: { b_idx: bIdx, u_idx: uIdx, c_content: content }
		})
		.done(function( msg ) {
		    $('#commentList').html(msg);
		});
	});
	
	$(document).on('click', '.btnCommentReply', function () {
		$(this).parent().next().next().css('display', 'none');
		let u_idx = '${sessionScope.user.u_idx}';
		if(u_idx  == ''){
			alert('로그인이 필요합니다');
			location.href='/lcomputerstudy/user-login.do';
		}
		else{
			$(this).parent().next().css('display', '');
		}
	});
	
	$(document).on('click', '.btnCommentReplyOn', function () {
		let c_content = $(this).prev().val();
		let u_idx = $(this).attr('uIdx');
		let b_idx = $(this).attr('bIdx');
		let c_group = $(this).attr('cGroup');
		let c_order = $(this).attr('cOrder');
		let c_depth = $(this).attr('cDepth');

		if(u_idx  == ''){
			alert('로그인이 필요합니다');
			location.href='/lcomputerstudy/user-login.do';
		}else{
			$.ajax({
				  method: "POST",
				  url: "aj-reply-comment.do",
				  data: { u_idx: u_idx, b_idx: b_idx, c_content: c_content, 
					  	  c_group: c_group, c_order: c_order, c_depth: c_depth }
			})
			.done(function( msg ) {
			    $('#commentList').html(msg);
			});
		}
	});

	$(document).on('click', '.btnCommentReplyCancel', function() {
		$(this).parent().css('display', 'none');
	});
	
	$(document).on('click', '.btnCommentEdit', function() {
		$(this).parent().next().css('display', 'none');
		let u_idx = $(this).attr('uIdx');
		let login_idx = '${sessionScope.user.u_idx}';
		let prev_c = $(this).prev().prev().val();

		if(login_idx  == ''){
			alert('로그인이 필요합니다');
			location.href='/lcomputerstudy/user-login.do';
		}else if(u_idx != login_idx){
			alert('작성자만 수정 가능합니다');
			location.reload();
		}else{
			
			$(this).parent().next().next().css('display', '');
			$(this).prev().prev().val('');
			$(this).prev().prev().attr('readonly', false);
			$(this).prev().prev().focus();		
		}
		$(document).on('click', '.btnCommentEditCancel', function() {
			console.log(prev_c);
			$(this).parent().css('display', 'none');
			$(this).parent().prev().prev().children('textarea').val(prev_c);
			$(this).parent().prev().prev().children('textarea').attr('readonly', true);
		});
	});
	
	$(document).on('click', '.btnCommentEditOn', function() {
		let c_idx = $(this).attr('cIdx');
		let b_idx = $(this).attr('bIdx');
		let c_content = $(this).parent().prev().prev().children('textarea').val();
		
		$.ajax({
			  method: "POST",
			  url: "aj-edit-comment.do",
			  data: { c_idx: c_idx, b_idx: b_idx, c_content: c_content }
		})
		.done(function( msg ) {
		    $('#commentList').html(msg);
		});
	});

	$(document).on('click', '.btnCommentDel', function() {
		let c_idx = $(this).attr('cIdx');
		let b_idx = $(this).attr('bIdx');
		let u_idx = $(this).attr('uIdx');
		let login_idx = '${sessionScope.user.u_idx}';

		if(login_idx  == ''){
			alert('로그인이 필요합니다');
			location.href='/lcomputerstudy/user-login.do';
		}else if(u_idx != login_idx){
			alert('작성자만 삭제 가능합니다');
			location.reload();
		}else{
			$.ajax({
				  method: "POST",
				  url: "aj-del-comment.do",
				  data: { c_idx: c_idx, b_idx: b_idx }
			})
			.done(function( msg ) {
			    $('#commentList').html(msg);
			});
		}
	});
	

	
</script>
</html>