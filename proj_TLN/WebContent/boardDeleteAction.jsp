<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="board.board" %>
<%@ page import="board.boardDAO" %>    
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
    
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
		if(userID == null){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('로그인을 해주세요.')");
			pw.println("location.href = 'login.jsp'");
			pw.println("</script>");
		}
		int boardNO = 0;
		if(request.getParameter("boardNO")!=null){
			boardNO = Integer.parseInt(request.getParameter("boardNO"));
		}
		if(boardNO == 0){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('존재하지 않는 글입니다.')");
			pw.println("location.href = 'board.jsp'");
			pw.println("</script>");
		}
		String boardCode = null;
		if(request.getParameter("boardCode")!=null){
			boardCode = request.getParameter("boardCode");
		}
		
		
		if(boardNO == 0){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('존재하지 않는 글입니다.')");
			pw.println("location.href = 'board.jsp'");
			pw.println("</script>");
		}
		
		board board = new boardDAO().getBoard(boardNO,boardCode);
		if(!userID.equals(board.getBoardWriter())){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('수정 권한이 없습니다!')");
			pw.println("location.href = 'board.jsp'");
			pw.println("</script>");
		}else{

			boardDAO boardDAO = new boardDAO();
			int result = boardDAO.delete(boardCode,boardNO);
			if(result == -1){
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('삭제 실패했습니다')");
				pw.println("history.back()");
				pw.println("</script>");
			}
			else{
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