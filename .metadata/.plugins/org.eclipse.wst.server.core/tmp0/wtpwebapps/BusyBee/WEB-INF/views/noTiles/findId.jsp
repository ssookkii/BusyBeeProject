<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- AJAX -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>
</head>
<body>
<h3>ID 찾기</h3>
<hr>
이름 : <input type="text" id="name">
등록 이메일 : <input type="text" id="email">
<button type="button" id="doFind">검색</button>
<br><br><br>


등록된 정보
<hr>
<h4 id="foundInfo"></h4>

<button type="button" onclick="location.href='loginMain.do'">로그인하기</button>
<button type="button" onclick="location.href='newPassword.do'">비밀번호 재설정</button>
<script type="text/javascript">

$("#doFind").click(function(){
	
	$.ajax({
		url:"findId.do",
		type:"post",
		data:{"name":$("#name").val(), "email":$("#email").val()},
	
		success:function(data) {
			if(data==null || data=="") {
				$("#info").html('');
				$("#foundInfo").text("등록된 정보가 없습니다.")
			} else {
				var found1 = data.id
				var found2 = data.regidate
				var tableTd = "";
				
				var star = '*';
				for(var i=0; i<data.id.length-4; i++) {
					star += '*';
				}
				
				$("#foundInfo").text(found1.substr(0,3) + star + "[가입일 : " + found2.substr(0,10) +"]");
			}
		},
		error:function(){
			alert('error');
		}
		
	});
});

function go_newPassword(){
	location.href="newPassword.do";
}
</script>

</body>
</html>