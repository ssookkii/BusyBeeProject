<%@page import="mul.cam.a.dto.GroupDto"%>
<%@page import="mul.cam.a.util.Utility"%>
<%@page import="mul.cam.a.dto.UserDto"%>
<%@page import="mul.cam.a.dto.CustomerDto"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    <%
    
    UserDto login = (UserDto)session.getAttribute("login");
	GroupDto dto = (GroupDto)request.getAttribute("dto");
	String group_code = (String)request.getAttribute("group_code");
	String group_name = (String)request.getAttribute("group_name");

    %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main View</title>


<style type="text/css">





.flex-container {
  display: flex;
  justify-content: center;
 
  
}

.flex-item {
  margin: 15px;
  width: 500px;
  margin: 15px;
  text-align: center;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

}

.card-body {
	width : 500px;
  height: 500px;
  font-size: 14px;

}

#notice{
  display: flex;
  justify-content: center;
  text-align: center;
  font-size: 15px;
  margin-top:40px;
  margin-left: auto;
  margin-right: auto;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);

}

.card-header{
font-size: 15px;

}
</style>


</head>
<body>

<br>
<img src = "./images/mark.png" width="70px" height="60px" style="float: left; margin-left: 30px"/>
<h1 style="font-weight: bold; font-size: 48px;">&nbsp;&nbsp;&nbsp;<%=group_name %></h1>
<br><br>
<hr>

<div class="flex-container" >

<div class="card text-white bg-warning mb-3" >
  <div class="card-header" >
  
  <a class="nav-link active" style="font-size: 40px; color:black"
  href="goBbslist.do?group_code=<%=group_code %>&group_name=<%=group_name %>">그룹 게시판</a>
  </div>

  <div class="card-body">
<table class="table table-hover">
    <thead>
    <tr>
        <th style="font-size: 20px; color:black">제목</th>
        <th style="font-size: 20px; color:black">작성자</th>
    </tr>
    </thead>
    <tbody id="bbsBody">
    </tbody>
</table>
  </div>
</div>

<div class="card text-white bg-danger mb-3">
  <div class="card-header">
  <a class="nav-link active" style="font-size: 40px; color:black;"
  href="goCalendar.do?group_code=<%=group_code %>&group_name=<%=group_name %>">일정관리</a></div>
  <div class="card-body">
<table class="table table-hover">
    <thead>
    <tr>
        <th style="font-size: 20px;  color:black;">제목</th>
        <th style="font-size: 20px; color:black;">시작일</th>
        <th style="font-size: 20px; color:black;">종료일</th>
    </tr>
    </thead>
    <tbody id="calBody">
    </tbody>
</table>
    
  </div>
</div>


</div>


<script type="text/javascript">

//게시판 미리보기
$.ajax({
       url: 'preBbsList.do',
       type: 'get',
       data:{"group_code" : '<%=group_code %>'},
       success: function(data) {
           var tableTd = "";

         if (data != null && data.length > 0) {
                $("#bbsBody").html('');
           for (var i = 0; i < 10; i++) {
                tableTd = '<tr>';

                	
               if(data[i].title.length > 10){
               	
               tableTd += '<td style="font-size: 20px; font-weight: 300; color:black;"><a href=bbsdetail.do?seq='+ data[i].seq+'>' + data[i].title.substr(0, 10)+'...' + '</a></td>';
               }else{
               	tableTd += '<td style="font-size: 20px; font-weight: 300; color:black;"><a href=bbsdetail.do?seq='+ data[i].seq+'>' + data[i].title + '</td>';
               }
               tableTd += '<td style="font-size: 20px; font-weight: 300; color:black;">' + data[i].id + '</td>'
                          + '</tr>';
                  $("#bbsBody").append(tableTd);
                  
                 
           }
         }else{
       	  tableTd += '<tr>' 
        	  + '<td style="font-size: 20px; font-weight: 300; color:black;">게시글이 없습니다</td>'
        	  +'</tr>';
              $("#bbsBody").append(tableTd);

          }
                
       },
       error: function(){
           alert('error');
       }

});


//일정 미리보기
$.ajax({
       url: 'preScheduleList.do',
       type: 'get',
       data:{"id": '<%=login.getId() %>', "groupCode" : '<%=group_code %>'},
       success: function(data) {
           var tableTd = "";
         if (data != null && data.length > 0) {
                $("#calBody").html('');
           for (var i = 0; i < data.length; i++) {
                tableTd = '<tr>';
               if(data[i].title.length > 7){
               	
               tableTd += '<td style="font-size: 20px; font-weight: 300; color:black;">' + data[i].title.substr(0, 6)+'...' + '</td>';
               }else{
               	tableTd += '<td style="font-size: 20px; font-weight: 300;   color:black;">' + data[i].title + '</td>';
               }
               tableTd += '<td style="font-size: 20px; font-weight: 300;  color:black;">' + data[i].startDate + '</td>'
                       + '<td style="font-size: 20px; font-weight: 300;  color:black;">' + data[i].endDate + '</td>'
                          + '</tr>';
                  $("#calBody").append(tableTd);
           }
         }else{
          	  tableTd += '<tr>' 
            	  + '<td style="font-size: 20px; font-weight: 300;   color:black;">일정이 없습니다</td>'
            	  +'</tr>';
                  $("#calBody").append(tableTd);

              }
       },
       error: function(){
    	   console.log(group_code);
           alert('error');
       }
});



</script>
</body>
</html>