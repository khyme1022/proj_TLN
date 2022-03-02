<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="user.UserDAO" %>    
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="user" class="user.user" scope="page" />    
<jsp:setProperty name="user" property="userID" />
<jsp:setProperty name="user" property="userPW" />

    
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
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(),user.getUserPW());
		if(result == 1){ // 로그인 성공
			session.setAttribute("userID", user.getUserID());
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("location.href = 'main.jsp'");
			pw.println("</script>");
		}
		else if(result == 0){ // 비밀번호 잘못됨
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('비밀번호가 틀립니다.')");
			pw.println("history.back()");
			pw.println("</script>");
		}
		else if(result == -1){ // 아이디 잘못됨 
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('존재하지 않는 아이디입니다.')");
			pw.println("history.back()");
			pw.println("</script>");
		}else if(result == -2){ // 기타오류
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('데이터베이스 오류가 발생했습니다..')");
			pw.println("history.back()");
			pw.println("</script>");
		}
	%>
</body>
</html>