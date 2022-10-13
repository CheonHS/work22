<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 등록</title>
</head>
<body>
<h2>댓글 처리 완료</h2>
<script>
setTimeout(function () {
	window.location.href = "/lcomputerstudy/board-detail.do?b_idx=${comment.b_idx}";
}, 1000)
</script>
</body>
</html>