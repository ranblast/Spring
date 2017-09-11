
<%@page import="java.util.List"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>  
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답변형게시판 - 내용보기</title>
<script type="text/javascript">
	function commentChk() {
		f = document.commentform;
		if(!f.name.value || f.name.value.trim().length == 0) {
			alert('이름넣어!!!');
			f.name.value = "";
			f.name.focus();
			return false;
		}
		if(!f.password.value || f.password.value.trim().length == 0) {
			alert('암호넣어!!!');
			f.password.value = "";
			f.password.focus();
			return false;
		}
		if(!f.content.value || f.content.value.trim().length == 0) {
			alert('내용넣어!!!');
			f.content.value = "";
			f.content.focus();
			return false;
		}
		return true;
	}
	
	function setting(mode, idx, title, name, content) {
		f = document.commentform;
		f.mode.value = mode;
		f.idx.value = idx;
		f.commentBtn.value = title;
		f.name.value = name;
		while(content.indexOf("<br/>") != -1) {
			content = content.replace("<br/>", "\r\n");
		}
		
		f.content.value = content;
	}
</script>
<style type="text/css">
	.inbutton { border: 0; background-color: silver; color: white; width: 35px; height:35px;}
</style>
</head>
<body>
<form method="post" name="form1">
	이름 : <input type="text" name="name" value="${vo.name}" readonly="readonly"/><br/>
	작성일 : <input type="text" name="wdate" value="${vo.getWdate()}" readonly="readonly"/><br/>
	IP : <input type="text" name="ip" value="${vo.getIp()}" readonly="readonly"/><br/>
	제목 : <input type="text" name="title" size="80" value="${vo.gettitle()}" readonly="readonly"/><br/>
	내용 : <textarea rows="10" cols="80" name="content" readonly="readonly">${vo.getContent()}</textarea><br/>
</form>
	<input type="button" onclick="location.href='list?currentPage=${currentPage}'" value="리스트로"/>
	<input type="button" onclick="location.href='reply?currentPage=${currentPage}&idx=${vo.getIdx()}'" value="답변달기"/>
	<input type="button" onclick="location.href='edit?currentPage=${currentPage}&idx=${vo.getIdx()}'" value="수정하기"/>
	<input type="button" onclick="location.href='delete?currentPage=${currentPage}&idx=${vo.getIdx()}'" value="삭제하기"/>
	<br/>
<!--  댓글폼 -->
<form method="post" name="commentform" action="commentOK" onsubmit="return commentChk();">
	<input type="hidden" name="idx" value="${vo.getIdx()}"/>   
	<input type="hidden" name="ref" value="${vo.getIdx()}"/> 
	<input type="hidden" name="mode" value="1"/>  
	<input type="hidden" name="currentPage" value="${currentPage}"/> 
	<input type="hidden" name="ip" value="${request.getRemoteAddr()}"/>
<table width="800" border="1">
	
	<tr>
		<td>이름</td>
		<td><input type="text" name="name"></td>
		<td>비밀번호</td>
		<td><input type="password" name="password"></td>
	</tr>

	<tr>
		<td colspan="3">
		<textarea rows="5" cols="85" name="content"></textarea>
		</td>
		<td align="center"><input type="submit" value="등록" class="submit" name="commentBtn"></td>
	</tr>	
</table>
</form>
<!-- 댓글 리스트 -->

<table width="800" border="1">
	
	<c:if test="${comment.list.size() > 0}">
	<c:forEach var="comment" items="${comment.list}">
	<tr>
		<td class="comment retop" width="100">
		${comment.name}
		</td>
		<td class="commentDate">
		<%-- <fmt:formatDate value="${comment.wdate}" pattern="yyyy.MM.dd. hh:mm"/> --%>
		${comment.wdate}
		<c:set var="content" value="${fn:replace(comment.content, '<', '&lt;')}" />
		<c:set var="content" value="${fn:replace(content, '>', '&gt;')}" />
		<c:set var="content" value="${fn:replace(content, rn, '<br/>')}" />
		<input class="inbutton" type="button" value="수정" onclick="setting(2, ${comment.idx}, '수정', '${comment.name}', '${content}')"/>
		<input class="inbutton" type="button" value="삭제" onclick="setting(3, ${comment.idx}, '삭제', '${comment.name}', '${content}')"/>		
		<input class="inbutton" type="button" value="취소" onclick="setting(1, 0, '등록', '', '')" />
		
		</td>	
	</tr>
	<tr>
		<td colspan="3" class="rebot">
			
			${content}
		</td>
	</tr>
	</c:forEach>
	</c:if>	
	
		<c:if test="${comment.list.size() == 0}">
		<tr>
			<td colspan="4">
			댓글이 없습니다.
			</td>
		</tr>	
	</c:if>
</table>
</body>
</html>