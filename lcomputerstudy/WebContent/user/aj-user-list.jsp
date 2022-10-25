<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<table >
	<tr>
		<td colspan="5">전체 회원 수 : ${pagination.count}</td>
	<tr>
		<th>No</th>
		<th>ID</th>
		<th>이름</th>
		<th class="half">등급</th>
		<th>권한</th>
	</tr>
	<c:forEach items="${list}" var="item" varStatus="status">
	 <tr>
		<td><a href="user-detail.do?u_idx=${item.u_idx}">${item.rownum}</a></td>
		<td>${item.u_id}</td>
		<td>${item.u_name}</td>
		<td class="half">
			<c:choose>
				<c:when test="${item.u_level eq 0}">미정</c:when>
				<c:when test="${item.u_level eq 1}">회원</c:when>
				<c:when test="${item.u_level eq 9}">관리자</c:when>
			</c:choose>
		</td>
		<td>
			<form action="user-level.do" method="post">
				<input type="hidden" name="u_idx" value="${item.u_idx}">
				<select name="u_level">
					<option value="" selected disabled hidden=""></option>
					<option value="1">회원</option>
					<option value="9">관리자</option>
				</select>
				<input type="button" value="변경" class="btnLevel">
			</form>
		</td>
     <tr>
	</c:forEach>
</table>
<div>
	<ul>
		 <c:choose>
			<c:when test="${ pagination.prevPage lt 5 }">
				<li style="display:none;">
					<span>◀</span>
				</li>
			</c:when>
			<c:when test="${ pagination.prevPage ge 5}">
				<li>
					<a href="user-list.do?page=${pagination.prevPage}">
						◀
					</a>
				</li>
			</c:when>
		</c:choose> 
		<c:forEach var="i" begin="${pagination.startPage}" end="${pagination.endPage}" step="1">
			
				<c:choose>
					<c:when test="${ pagination.page eq i }">
						
						<li style="background-color:#ededed;">
							<span>${i}</span>
						</li>
					</c:when>
					<c:when test="${ pagination.page ne i }">
						<li>
							<a href="user-list.do?page=${i}">${i}</a>
						</li>
					</c:when>
				</c:choose>
		</c:forEach>
		 <c:choose>
			<c:when test="${ pagination.nextPage lt pagination.lastPage }">
				<li style="">
					<a href="user-list.do?page=${pagination.nextPage}">▶</a>
				</li>
			</c:when>
			<c:when test="${ pagination.nextPage ge pagination.lastPage}">
				<li style="display:none;">
					<a href="user-list.do?page=${pagination.nextPage}">▶</a>
				</li>
			</c:when>
		</c:choose> 
		<%--  <li>
			<a href="user-list.do?page=${pagination.nextPage}">▶</a>
		</li>  --%>
	</ul>
</div>