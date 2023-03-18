<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>환영합니다</title>

<!-- AJAX -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>

<!-- 비밀번호 암호화(SHA256) -->
<script	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>
</head>
<body>

<form action="loginCheck.do" id="frm" method="post">
아이디 : <input type="text" id="id" name="id">
비밀번호 : <input type="password" id="password" name="password">
<button type="button" onclick="go_login()">로그인</button>
</form>
<button type="button" onclick="location.href='regi1.do'">회원가입</button>
<button type="button" onclick="location.href='findId.do'">ID찾기</button>
<button type="button" onclick="location.href='newPassword.do'">PW재설정</button>
<script type="text/javascript">
function go_login() {

	var id = document.getElementById("id").value;
	var password = document.getElementById("password").value;
	
	if(id==null || id.trim()=="") {
		alert('ID를 입력해주세요.');
	} else if(password==null || password.trim()==""){
		alert('비밀번호를 입력해주세요.');
	} else {
		var saltpw = password.substr(0,2) + password + password.substr(password.length-2, password.length);
		$("#password").val(sha256(saltpw));
		$("#frm").submit();
	}
	
}

</script>
</body>
</html>