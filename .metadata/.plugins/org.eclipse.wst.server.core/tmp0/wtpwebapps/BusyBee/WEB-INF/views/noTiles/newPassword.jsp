<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- AJAX -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>

<!-- 비밀번호 암호화(SHA256) -->
<script	src="https://cdnjs.cloudflare.com/ajax/libs/js-sha256/0.9.0/sha256.min.js"></script>
</head>
<body>
<h3>비밀번호 재설정</h3>
<hr>
이름 : <input type="text" id="name">
아이디 : <input type="text" id="id">
<br>
등록 이메일 : <input type="text" id="email">
<button type="button" id="sendCert" onclick="isExist()">인증번호 발송</button>
인증번호 : <input type='text' id='certNum' disabled="disabled"> <button type='button' onclick='checkCert()' >확인</button>
<hr>

<br><br><br>
새 비밀번호 : <input type='password' id='pwd1' disabled="disabled">
<h3 id='pwdCheck1'></h3>
새 비밀번호 확인 : <input type='password' id='pwd2' disabled="disabled">
<h3 id='pwdCheck2'></h3>
<button type="button" onclick="changePwd()">비밀번호 재설정</button>

<br><br>
<br>
<button type="button" onclick="location.href='loginMain.do'">로그인하기</button>
<button type="button" onclick="location.href='findId.do'">아이디 찾기</button>

<input type="hidden" id="email_OK">
<input type="hidden" id="pwd1_OK">
<input type="hidden" id="pwd2_OK">

<table>
	<tbody id="tBody">
	</tbody>
</table>

<form action="updPwd.do" id="frm" method="post">
<input type="hidden" id="password" name="password">
<input type="hidden" id="c_id" name="id">
</form>

<script type="text/javascript">

var email_OK = document.getElementById("email_OK").value;
var pwd1_OK = document.getElementById("pwd1_OK").value;
var pwd2_OK = document.getElementById("pwd2_OK").value;

function isExist(){
	
	// 이메일 정규식
	var emailValid = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]{2,3}$/i;
	var userEmail = $("#email").val();
	if(!emailValid.test(userEmail)) {
		alert('유효한 이메일을 입력해주세요.');
		$("#email").val('');
		return;
	}
	
	$.ajax({
		url : "findforPwd.do",
		type : "post",
		data : {"id" : $("#id").val(), "name" : $("#name").val(), "email" : $("#email").val()},
		success : function(msg) {
			if(msg=="findforPwd_SUCCESS") {
				$("#id").attr('disabled', true);
				$("#name").attr('disabled', true);
				$("#email").attr('disabled', true);
				doCert();
			} else {
				alert('정보를 다시 확인해주세요');
			}
		},
		error : function(msg) {
			alert('error');
		}
	});
}

function doCert() {
	
	var userEmail = $("#email").val();
	var check3 = true;
	
	$.ajax({
		url : "select3.do",
		async:false,
		type : 'get',
		data : {"cert_email" : userEmail},
		success : function(msg) {
			if(msg=="cert3_FAIL"){
				alert('일일 최대 인증횟수 3회를 초과했습니다. 다음에 다시 시도해주세요.');
				location.href='loginMain.do';
				check3 = false;
			}
		},
		error : function(){
			alert('error');
		}
	});
	if (!check3) {
		return;
	}
	else {
	$.ajax({
			url : "mailCheck.do",
			type : 'get',
			data : {"email" : userEmail, "purpose" : "find"},
			success : function(data) {
				alert('인증번호가 전송되었습니다. 인증은 일일 3회까지 가능합니다.');
				$("#certNum").attr("disabled", false);
				authkey = data;
			},
			error : function(){
				alert('error');
			}
		});
	}
}

function checkCert(){
	
	var userEmail = $("#email").val();
	$.ajax({
		type : 'get',
		url : "selectCert.do",
		data : {"cert_email" : userEmail, "authkey" : $("#certNum").val()},
		success : function(msg) {
			if(msg!=null && msg!=""){
				if(msg=="cert_SUCCESS") {
					alert("인증되었습니다. 이어서 비밀번호를 재설정해주세요.");
					$("#certNum").attr('disabled', true);
					$("#sendCert").attr('disabled', true);
					$("#pwd1").attr('disabled', false);
					$("#pwd2").attr('disabled', false);
					email_OK=true;
				} else {
					$("certNum").val('');
					alert("잘못된 인증번호입니다. 다시 확인해주세요");
					email_OK=false;
				}
			}
		},
		error : function() {
			alert('error');
		}
	});
}

$("#pwd1").keyup(function(e){
	
	let key = e.key || e.keyCode;

	if($("#pwd1").val()=="") {
		$("#pwdCheck1").text('');
		$("#pwdCheck2").text('');
		pwd1_OK=false;
		pwd2_OK=false;
		return;
	}
	
	if(key==" " || key==32) {
		alert('비밀번호에는 공백이 들어갈 수 없습니다.');
		$("#pwd1").val('');
		$("#pwdCheck1").text('');
		pwd1_OK=false;
		return;
	}
	
	if($("#pwd1").val()==$("#pwd2").val()) {
		$("#pwdCheck2").text('동일합니다.');
		pwd2_OK=true;
	} else{
		$("#pwdCheck2").text('');
		pwd2_OK=false;
	}
	
	// PWD 유효성 검사
	var pwd1 = $("#pwd1").val();
	var numValid = pwd1.search(/[0-9]/g);
	var engValid = pwd1.search(/[a-z]/ig);
	var speValid = pwd1.search(/[`~!@@#$%^&*|₩₩₩'₩";:₩/?]/gi);
	
	if (pwd1.length<8 || pwd1.length>20) {
		$("#pwdCheck1").text('비밀번호는 6~20자로 설정해주세요.');
		pwd1_OK=false;
	} else if(numValid < 0 || engValid < 0 || speValid < 0 ){
		$("#pwdCheck1").text('비밀번호에는 숫자, 영문, 특수문자가 모두 포함되어있어야 합니다.');
		pwd1_OK=false;
	} else {
		$("#pwdCheck1").text('사용가능한 비밀번호입니다.');
		pwd1_OK=true;
	}
});
	

// PWD(2/2)

$("#pwd2").keyup(function(){
	
	if($("#pwd2").val()=="") {
		$("#pwdCheck2").text('');
		pwd2_OK=false;
		return;
	}
	
	if($("#pwd1").val()!=$("#pwd2").val()) {
		$("#pwdCheck2").text('동일한 비밀번호를 입력해주세요.');
		pwd2_OK=false;
	} else {
		$("#pwdCheck2").text('동일합니다.');
		pwd2_OK=true;
	}

});

function changePwd() {
	
	if(!email_OK) {
		alert('이메일 인증을 진행해주세요.');
		$("#email").focus();
	} else if((!pwd1_OK)) {
		alert('사용 가능한 비밀번호인지 확인해주세요.');
		$("#pwd1").focus();		
	} else if((!pwd2_OK)) {
		alert('동일한 비밀번호를 입력했는지 확인해주세요.');
		$("#pwd2").focus();
	} else {
		var userPwd = $("#pwd1").val();
		var saltpw = userPwd.substr(0,2) + userPwd + userPwd.substr(userPwd.length-2, userPwd.length);
		$("#c_id").val($("#id").val());
		$("#password").val(sha256(saltpw));
		$("#frm").submit();
	}
}
</script>


</body>
</html>