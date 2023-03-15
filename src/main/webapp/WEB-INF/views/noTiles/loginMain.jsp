<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환영합니다</title>

<!-- AJAX -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
</head>
<body>

<form action="loginCheck.do" id="frm" method="post">
아이디 : <input type="text" id="id" name="id">
비밀번호 : <input type="password" id="password" name="password">
<button type="button" onclick="go_login()">로그인</button>
</form>
<button type="button" onclick="location.href='regi1.do'">회원가입</button>

<script type="text/javascript">
function go_login() {

	var id = document.getElementById("id").value;
	var password = document.getElementById("password").value;
	
	if(id==null || id.trim()=="") {
		alert('ID를 입력해주세요.');
	} else if(password==null || password.trim()==""){
		alert('비밀번호를 입력해주세요.');
	} else {
		$("#frm").submit();
	}
	
}
</script>
</body>
</html>