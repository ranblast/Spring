<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

  
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script type="text/javascript">
	function chk(){
		f = document.form1;
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
		if(!f.title.value || f.title.value.trim().length == 0) {
			alert('제목넣어!!!');
			f.title.value = "";
			f.title.focus();
			return false;
		}
		if(!f.content.value || f.title.value.trim().length == 0) {
			alert('내용넣어!!!');
			f.content.value = "";
			f.content.focus();
			return false;
		}
		return true;
	}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>답변형게시판 - 답변달기</title>
</head>
<body>
	<form action="replyOK" method="post" onsubmit="return chk();" name="form1">
		<input type="hidden" name="idx" value="${vo.getIdx()}"/>
		<input type="hidden" name="ref" value="${vo.getRef()}"/>
		<input type="hidden" name="lev" value="${vo.getLev()}"/>
		<input type="hidden" name="seq" value="${vo.getSeq()}"/>
		<input type="hidden" name="currentPage" value="${currentPage}"/>
		이름 : <input type="text" name="name"/><br/>
		비번 : <input type="password" name="password"/><br/>
		제목 : <input type="text" name="title" size="80"/><br/>
		내용 : <textarea rows="10" cols="80" name="content"></textarea><br/>
		<input type="submit" value="저장하기">
	</form>
</body>
</html>