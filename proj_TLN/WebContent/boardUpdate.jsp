
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.user" %> 
<%@ page import="user.UserDAO"  %> 
<%@ page import="board.board" %> 
<%@ page import="board.boardDAO"  %> 
<%@ page import="java.io.PrintWriter" %> 
<% request.setCharacterEncoding("UTF-8"); %>
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
		String boardCode = null;
		if(request.getParameter("boardCode")!=null){
			boardCode = request.getParameter("boardCode");
			System.out.println("boardUpdate : " + boardCode);
		}
		int boardNO = 0;
		if(request.getParameter("boardNO")!=null){
			boardNO = Integer.parseInt(request.getParameter("boardNO"));
		}
		board board = new boardDAO().getBoard(boardNO, boardCode);
		if(userID!=board.getBoardWriter()){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert(권한이 없습니다.)");
			pw.println("history.back()");
			pw.println("</script>"); 
			
		}
		// 로그인 유지를 위한 파트, 파라미터 받아오기
	%>

	<div class="container">
		<div class="row">
		<form method="post" action="boardUpdateAction.jsp" enctype="multipart/form-data">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="2" style="background-color:#eeeeee; text-align:center;">게시판 글 수정 양식</th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td><input type="text" class="form-control" placeholder="글 제목" name="boardTitle" maxlength="50" value="<%=board.getBoardTitle()%>"></td>
					</tr>
					<tr>
					<%
						if(!boardCode.equals("게시판")){
					%>
						<td><input type="text" class="form-control" placeholder="주최" name="provider" maxlength="50"> </td>
					<%
						}else{
					%>
						<td><input type="text" class="form-control" placeholder="X" name="provider" maxlength="50" value="X" readonly> </td>
					<%
						}
					%>
					</tr>
					<tr>	
						<td><textarea type="text" class="form-control" placeholder="글 내용" name="boardContent" maxlength="2048" style="height:350px;"><%=board.getBoardContent() %></textarea></td>
					</tr>
					<tr>	
						<td><input type="file" name="fileName"><input type=hidden name="boardCode" value=<%=boardCode %>><input type=hidden name="boardNO" value=<%=boardNO%>></td>
						
					</tr>
					<tr>
						<td><input type="submit" class="btn btn-primary pull-right" value="수정하기"></td>
					</tr>
				</tbody>

			</table>
		</form>

		</div>
	</div>
	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>