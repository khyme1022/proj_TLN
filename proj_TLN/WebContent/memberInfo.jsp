<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.user" %> 
<%@ page import="user.UserDAO"  %> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>이번 생은 처음이라</title>
</head>
<body>
	<%@ include file="/TitleBar.jsp" %>

	<%
		user user = new UserDAO().getUser(userID); 
		// 현재 아이디에 대한 정보를 불러옴
	%>
	
		
	<div class="container">
		<div class=:col-lg-4></div>
		<div class=:col-lg-4>
			<div class="jumbotron" style="padding-top:20px;">
				<form method="post" action="memberUpdateAction.jsp?userID=<%=user.getUserID() %>">
					<h3 style="text-align:center;">회원 정보</h3>
					<div class="form-group">
						<span class="label label-primary">아이디</span>
						<input type="text" class="form-control" placeholder="아이디" name="userID" value="<%=user.getUserID() %>" maxlength="20" readonly>
					</div>
					<div class="form-group">
						<span class="label label-primary">패스워드</span>
						<input type="password" class="form-control" placeholder="비밀번호" name="userPW" value="<%=user.getUserPW() %>" maxlength="20">
					</div>
					<div class="form-group">
						<span class="label label-primary">이름</span>
						<input type="text" class="form-control" placeholder="이름" name="userName" value="<%=user.getUserName() %>" maxlength="20">
					</div>
					<div class="form-group">
						<span class="label label-primary">핸드폰번호</span>
						<input type="text" class="form-control" placeholder="핸드폰번호" name="userPhone" value="<%=user.getUserPhone() %>"maxlength="20">
					</div>
					<div class="form-group">
						<span class="label label-primary">이메일</span>
						<input type="email" class="form-control" placeholder="이메일" value="<%=user.getUserEmail() %>"
							name="userEmail" maxlength="20">
					</div>
					<%
						//성별 가져와서 체크 다르게
					%>
					<div class="form-check">
						<span class="label label-primary">성별</span><br>
						<input class="form-check-input" type="radio" name="userGender" id="flexRadioDefault1" value="남자" <% if("남자".equals(user.getUserGender())){ %>checked<%} %>>
						<label class="form-check-label" for="flexRadioDefault1" > 남자 </label>
						<input class="form-check-input" type="radio" name="userGender" id="flexRadioDefault2" value="여자" <% if("여자".equals(user.getUserGender())){ %>checked<%} %>> 
						<label class="form-check-label" for="flexRadioDefault2"> 여자 </label>
					</div>
					<div class="form-group">
						<span class="label label-primary">짧은 소개글</span>
						<input type="text" class="form-control" placeholder="소개글" name="user_Intro" value="<%=user.getUser_Intro() %>" maxlength="200">
					</div>
					<div class="form-check">
						<span class="label label-primary">글 공개 여부</span><br>
						<input class="form-check-input" type="radio" name="user_INFM_YN" id="flexRadioDefault1" value="Y" <% if("Y".equals(user.getUser_INFM_YN())){ %>checked<%} %>>
						<label class="form-check-label" for="flexRadioDefault1" > 공개 </label>
						<input class="form-check-input" type="radio" name="user_INFM_YN" id="flexRadioDefault2" value="N" <% if("N".equals(user.getUser_INFM_YN())){ %>checked<%} %>> 
						<label class="form-check-label" for="flexRadioDefault2"> 비공개 </label>
					</div>

					<div class="row" style="text-align:center;">
					<input type="button" class="btn btn-success" value="내 글 목록 가기" onclick="location.href='userBoardList.jsp?boardWriter=<%=user.getUserID()%>'">
					<input type="submit" class="btn btn-primary" value="수정">
					<input type="button" class="btn btn-danger" value="회원탈퇴" onclick="location.href='memberDeleteAction.jsp?userID=<%=user.getUserID() %>'">
					</div>
					
				</form>
			</div>
		</div>
		<div class=:col-lg-4></div>
	</div>
	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>