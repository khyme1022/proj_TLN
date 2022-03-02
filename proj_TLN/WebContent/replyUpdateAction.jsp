<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="board.replyDAO" %>   
<%@ page import="board.reply" %>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="reply" class="board.reply" scope="page" />
<jsp:useBean id="board" class="board.board" scope="page" />    
<jsp:setProperty name="board" property="boardTitle" />
<jsp:setProperty name="board" property="boardContent" />
<jsp:setProperty name="reply" property="replyContent" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제에에목</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) { 
			userID = (String) session.getAttribute("userID");
		} else {
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('로그인을 해주세요.')");
			pw.println("location.href = 'login.jsp'");
			pw.println("</script>");
		}
		
		String boardCode = null;
		if (request.getParameter("boardCode") != null) {
			boardCode = request.getParameter("boardCode");
		}
		int boardNO = 0;
		if (request.getParameter("boardNO") != null) {
			boardNO = Integer.parseInt(request.getParameter("boardNO"));
		}
		int updateReplyNO = 0;
		if (request.getParameter("replyNO") != null) {
			updateReplyNO = Integer.parseInt(request.getParameter("replyNO"));
		}
	
		if (reply.getReplyContent() == null || boardCode == null) {
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('모두 입력해주세요!')");
			pw.println("history.back()");
			pw.println("</script>");

		} else {
			replyDAO replyDAO = new replyDAO();
			int result = replyDAO.update(updateReplyNO,boardNO,boardCode,reply.getReplyContent());
			if (result == -1) {
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('글쓰기에 실패했습니다')");
				pw.println("history.back()");
				pw.println("</script>");
			} else {
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				switch (boardCode) {
				case "게시판":
					pw.println("location.href = 'board.jsp'");
					break;
				case "은행":
					pw.println("location.href = 'bank.jsp'");
					break;
				case "제도":
					pw.println("location.href = 'jedo.jsp'");
					break;
				}
				
				pw.println("</script>");
			}

		}
	%>
</body>
</html>