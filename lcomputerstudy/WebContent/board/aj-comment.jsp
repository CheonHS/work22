<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
				<input type="button" value="답글" style="height: 50px;"
					id="cReplyButton${c.c_idx}" onclick="cReply(${c.c_idx})">
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