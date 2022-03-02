<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="user.UserDAO" %>    
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.user" scope="page" />    
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPW" />
<jsp:setProperty name="user" property="userName" />
<jsp:setProperty name="user" property="userPhone" />    
<jsp:setProperty name="user" property="userEmail" />
<jsp:setProperty name="user" property="userGender" />
<jsp:setProperty name="user" property="user_Intro" />
<jsp:setProperty name="user" property="user_INFM_YN" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제에에목</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){
			userID = (String) session.getAttribute("userID");
		}
		if(userID !=null){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('이미 로그인이 되어있습니다.')");
			pw.println("location.href = 'main.jsp");
			pw.println("</script>");
		}
		
		if(user.getUserID() ==null || user.getUserPW() == null || user.getUserName() == null
				|| user.getUserEmail() == null||user.getUserPhone() == null|| user.getUserGender() == null){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('모두 입력해주세요!')");
			pw.println("history.back()");
			pw.println("</script>");
			
		}else{ //가입 진행 파트
			UserDAO userDAO = new UserDAO();
			int result = userDAO.join(user);
			if(result == -1){ // 가입 실패
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('이미 존재하는 아이디입니다.')");
				pw.println("history.back()");
				pw.println("</script>");
			}
			else if(result == 0){  // 가입 완료
				session.setAttribute("userID", user.getUserID());
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("location.href = 'main.jsp'");
				pw.println("</script>");
			}
			
		}
			


	%>
</body>
</html>