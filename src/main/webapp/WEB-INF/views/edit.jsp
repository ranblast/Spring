
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%	// 페이지번호 받기
	String t = request.getParameter("page");
	int currentPage = 1;
	if(t != null && !t.equals("") && t.trim().length() != 0) {
		try {
			currentPage = Integer.parseInt(t);
		} catch(Exception e){ }
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript">
	function chk(){
		f = document.form1;
		if(!f.password.value || f.password.value.trim().length == 0) {
			alert('암호넣어!!!');
			f.password.value = "";
			f.password.focus();
			return false;
		}
		if(!f.title.value || f.title.value.trim().length == 0) {
			alert('제목넣어!!!');
			f.title.value = "";
			f.title.focus();
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
</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답변형게시판 - 수정하기</title>
</head>
<body>
<form method="post" name="form1" action="editok.jsp?page=${currentpage}&idx=${vo.getIdx()}">
	이름 : <input type="text" name="name" value="${vo.getName()}" readonly="readonly"/><br/>
	암호 : <input type="password" name="password"/><br/>
	제목 : <input type="text" name="title" size="80" value="${vo.getTitle()}"/><br/>
	내용 : <textarea rows="10" cols="80" name="content">${vo.getContent()}</textarea><br/>
	<input type="submit" value="수정하기" />
	<input type="button" value="돌아가기" onclick="location.href='view?page=${currentpage}&idx=${vo.getIdx()}'"/>
</form>
</body>
</html>