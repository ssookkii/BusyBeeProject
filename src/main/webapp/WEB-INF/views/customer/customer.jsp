<%@page import="mul.cam.a.dto.UserDto"%>
<%@page import="mul.cam.a.util.Utility"%>
<%@page import="mul.cam.a.dto.CustomerDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Customer View</title>

<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles" %>


<!-- 페이징 -->

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.3/dist/jquery.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>

<script type="text/javascript" src="./jquery/jquery.twbsPagination.min.js"></script>

<style>

.btn{
	height : 30px;
	width: 50px;
	
}

.table{
font-size: 14px;

}
.d-flex{
font-size: 14px;
float: right;
padding-right: 450px;
}


}

</style>

<!-- 부트스트랩 CSS -->
<link rel="stylesheet" href="https://bootswatch.com/5/minty/bootstrap.min.css">

</head>

<body>
<%
UserDto login = (UserDto)session.getAttribute("login");

List<CustomerDto> list = (List<CustomerDto>)request.getAttribute("customer");
int pageBbs = (Integer)request.getAttribute("pageBbs");
int pageNumber = (Integer)request.getAttribute("pageNumber");
String choice = (String)request.getAttribute("choice");
String search = (String)request.getAttribute("search");
%>

<br>
<img src = "./images/mark.png" width="70px" height="60px" style="float: left; margin-left: 30px"/>
<h1 style="font-weight: bold">&nbsp;&nbsp;&nbsp;고객센터</h1>
<small class="text-muted" style="font-size: 11pt">&nbsp;&nbsp;&nbsp;&nbsp;무엇이든 물어보세요</small>
<br><br>
<hr>


<div align="right">
<nav style="width: 1000px; text-align: right;">
  <div class="container-fluid">
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarColor01" aria-controls="navbarColor01" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarColor01">
      <div class="d-flex" >
	      	<select id="choice" style="color:black;">
				<option value="" selected="selected">검색</option>
				<option value="title">제목</option>
				<option value="content">내용</option>
				<option value="writer">작성자</option>
			</select>
  <input style="width: 100px; height: 30px;" class="form-control form-control-sm" type="text" id="search" name="search" onkeyup="enterKeyEvent()" placeholder="검색어" value="<%=search %>">
				<button type="button" class="btn btn-secondary my-2 my-sm-0" onclick="searchBtn()">검색</button>
      </div>
    </div>
  </div>
</nav>
</div>

<br>
<div align="center">
<table class="table table-hover" style="width: 1000px">
<col width="70"><col width="600"><col width="100"><col width="150">
<thead>
<tr class="table-warning" style="color: white;">
	<th>번호</th><th>제목</th><th>작성자</th>
</tr>
</thead>
<tbody>

<%
if(list == null || list.size() == 0){
	%>
	<tr>
		<td colspan="4">작성된 글이 없습니다</td>
	</tr>
	<%
}else{
	
	for(int i = 0;i < list.size(); i++)
	{
		CustomerDto dto = list.get(i);
		%>
		<tr>
			<th><%=i + 1 + (pageNumber * 10) %></th>
			
			<td style="text-align: left;">
			

<%if(dto.isSecret()){				// 비밀글 여부
	//
	if(dto.getId().equals(login.getId()) || login.getAuth()==3){		// 비밀글일때 본인, 관리자인지 여부
		%>
						<%=Utility.arrow(dto.getDepth()) %>
					<a href="customerDetail.do?seq=<%=dto.getSeq() %>&ref=<%=dto.getRef()%>">
						<%=dto.getTitle() %>
					</a>		
					<%=Utility.lock(dto.isSecret()) %>
		
		<% 
	}else{
		%>
						<%=Utility.arrow(dto.getDepth()) %>
					<a href="customerDetail.do?seq=<%=dto.getSeq() %>&ref=<%=dto.getRef()%>">
						<%=dto.getTitle() %>
					</a>		
					<%=Utility.lock(dto.isSecret()) %>	
					
		<% 
	}
	%>
	
					
	<% 
} else{
	%>
					<%=Utility.arrow(dto.getDepth()) %>
					<a href="customerDetail.do?seq=<%=dto.getSeq() %>&ref=<%=dto.getRef()%>">
						<%=dto.getTitle() %>
					</a>		
	
	<%
}
	
	%>
			
			</td>

			<td><%=dto.getId() %></td>
		</tr>
		<%
	}
}
%>

</tbody>
</table>

<br>

<div class="container">
    <nav aria-label="Page navigation">
        <ul class="pagination" id="pagination" style="justify-content:center;"></ul>
    </nav>
</div>

<br>
<button class="btn btn-warning" onclick="customerWrite()">문의하기</button>

<br><br>



</div>

<script type="text/javascript">

function customerWrite() {
	location.href="customerWrite.do";
}

let search = "<%=search %>";
console.log("search = " + search);
if(search != ""){
	let obj = document.getElementById("choice");
	obj.value = "<%=choice %>";
	obj.setAttribute("selected", "selected");
}

function enterKeyEvent() {
	if(window.event.keyCode==13){
		searchBtn();
	}
}

function searchBtn() {
	let choice = document.getElementById('choice').value;
	let search = document.getElementById('search').value;
	

	
	location.href = "customer.do?choice=" + choice + "&search=" + search;
}


$('#pagination').twbsPagination({
	startPage: <%=pageNumber+1 %>, 
    totalPages: <%=pageBbs %>,
    visiblePages: 10,
    first:'<span srid-hidden="true">«</span>',
    prev:"이전",
    next:"다음",
    last:'<span srid-hidden="true">»</span>',
    initiateStartPageClick:false,   // onPageClick 자동실행되지 않도록
    onPageClick: function (event, page) {
        // alert(page);
        let choice = document.getElementById('choice').value;
		let search = document.getElementById('search').value;
    	location.href = "customer.do?choice=" + choice + "&search=" + search + "&pageNumber=" + (page-1);
    }
});





</script>
</body>
</html>