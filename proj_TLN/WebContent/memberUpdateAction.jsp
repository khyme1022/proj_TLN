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
		
		if(user.getUserID() ==null || user.getUserPW() == null || user.getUserName() == null
				|| user.getUserEmail() == null||user.getUserPhone() == null|| user.getUserGender() == null || user.getUser_INFM_YN() == null){
			PrintWriter pw = response.getWriter();
			System.out.println("ID : " + user.getUserID());
			System.out.println("PW : " + user.getUserPW());
			System.out.println("name : " + user.getUserName());
			System.out.println("Email : " + user.getUserEmail());
			System.out.println("phone : " + user.getUserPhone());
			System.out.println("gender : " + user.getUserGender());
			System.out.println("소개 : " + user.getUser_Intro());
			System.out.println("YN : " + user.getUser_INFM_YN());
			
			pw.println("<script>");
			pw.println("alert('모두 입력해주세요!');");
			pw.println("history.back();");
			pw.println("</script>");
			
		}else{ //회원 수정 진행
			UserDAO userDAO = new UserDAO();
			int result = userDAO.update(user);	
			if(result == -1){ //
				System.out.println("ID : " + user.getUserID());
				System.out.println("PW : " + user.getUserPW());
				System.out.println("name : " + user.getUserName());
				System.out.println("Email : " + user.getUserEmail());
				System.out.println("phone : " + user.getUserPhone());
				System.out.println("gender : " + user.getUserGender());
				System.out.println("소개 : " + user.getUser_Intro());
				System.out.println("YN : " + user.getUser_INFM_YN());
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('SQL 에러');");
				pw.println("history.back();");
				pw.println("</script>");
			}
			else if(result == 0){
				session.setAttribute("userID", user.getUserID());
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('수정이 완료 되었습니다 !');");
				pw.println("location.href = 'main.jsp';");
				pw.println("</script>");
			}
			
		}
			


	%>
</body>
</html>