<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
.table { border: 1px solid; border-color: rgba(0,0,0,0.5); }
	.button {
	    background-color: #4CAF50; /* Green */
	    border: none;
	    color: white;
	    padding: 5px 10px;
	    text-align: center;
	    text-decoration: none;
	    display: inline-block;
	    font-size: 14px;
	    margin: 2px 1px;
	    -webkit-transition-duration: 0.4s; /* Safari */
	    transition-duration: 0.4s;
	    cursor: pointer;
	}
	.button1 {background-color: white; color: black; border: 2px solid #4CAF50;}
	.button1:hover {background-color: #4CAF50; color: white;}
	.button2 {background-color: white; color: black; border: 2px solid navy;}
	.button2:hover {background-color: navy; color: white;}
	a { text-decoration: none; color: black; text-shadow: }
	a:visited { text-decoration: none; color: black;}
	a:hover {text-decoration: none; cursor: pointer;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답변형게시판 목록보기</title>
</head>
<body>
<table width="800" align="center" border="1">
	<tr>
		<th colspan="5">게시글 목록</th>
	</tr>
	<tr>
		<td width="80" align="center">글번호</td>
		<td width="100" align="center">작성자</td>
		<td width="400" align="center">제목</td>
		<td width="140" align="center">작성일</td>
		<td width="80" align="center">조회수</td>
	</tr>
	<jsp:useBean id="date" class="java.util.Date" />
	<c:if test="${list.list.size() > 0 }">
	<c:forEach var="vo" items="${list.list}">
		<tr>
					<td align="center">${vo.idx}</td>
					<td>
					<c:set var="name" value="${fn:replace(vo.name, '<', '&lt') }" />
					<c:set var="name" value="${fn:replace(name, '>', '&gt') }" />
					${name}
					</td>
					<td>
					
					<c:if test="${vo.lev > 0}">
						<c:forEach var="i" begin="1" end="${vo.lev}" step="1">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</c:forEach>
						Re.
					</c:if>
					<c:set var="title" value="${fn:replace(vo.title, '<', '&lt')}" />
					<c:set var="title" value="${fn:replace(title, '>', '&gt')}" />					
					<a href="increment?idx=${vo.idx}&currentPage=${currentPage}">${title} (${vo.count})</a>				
					</td>
					
					<td>
					${vo.wdate}
					</td>
					
					<td>
						${vo.hit}
					</td>
				</tr>		
	</c:forEach>
	</c:if>
	<c:if test="${list.list.size() == 0 }">
	<tr>
		<td colspan="5" align="center">게시글이 없습니다.</td>
	</tr>	
	</c:if>
	
	<tr>
		<td align="center" colspan="6">
		<c:if test="${list.currentPage > 1}">
		<input class="button button1" type="button" value="처음으로" onclick="location.href='list?currentPage=${1}'"/>
		</c:if>
		<c:if test="${list.startPage > 1}">
		<input class="button button1" type="button" value="&lt;10" onclick="location.href='list?currentPage=${list.startPage - 1}'"/>
		</c:if>
		<c:if test="${list.currentPage > 1}">
		<input class="button button1" type="button" value="&lt;1" onclick="location.href='list?currentPage=${list.currentPage - 1}'"/>
		</c:if>
	
		<c:forEach var="i" begin="${list.startPage}" end="${list.endPage}" step="1">
		<input class="button button1" type="button" value="${i}" onclick="location.href='list?currentPage=${i}'">
		</c:forEach>
		
		<c:if test="${list.currentPage < list.totalPage}">
		<input class="button button1" type="button" value="1&gt" onclick="location.href='list?currentPage=${list.currentPage + 1}'"/>
		</c:if>
		<c:if test="${list.endPage < list.totalPage}">
		<input class="button button1" type="button" value="10&gt" onclick="location.href='list?currentPage=${list.startPage + 10}'"/>
		</c:if>
		<c:if test="${list.endPage < list.totalPage}">
		<input class="button button1" type="button" value="끝으로" onclick="location.href='list?currentPage=${list.totalPage}'"/>
		</c:if>
		
		</td>
	</tr>		
		<tr>
			<td colspan="5" align="right">
				<input type="button" value="글쓰기" onclick="location.href='insertform'">
			</td>
		</tr>	
</table>
</body>
</html>