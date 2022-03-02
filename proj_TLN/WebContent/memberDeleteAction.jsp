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
			int result = userDAO.delete(userID);
			if(result == -1){ // 삭제 실패
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('존재하지 않는 아이디입니다.');");
				pw.println("history.back();");
				pw.println("</script>");
			}
			else if(result == 0){  // 삭제 완료
				session.setAttribute("userID", user.getUserID());
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('삭제가 완료되었습니다.');");
				pw.println("location.href = 'main.jsp';");
				pw.println("</script>");
				session.invalidate();
			}

			


	%>
</body>
</html>