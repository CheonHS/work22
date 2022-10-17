<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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