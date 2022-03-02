
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.user" %> 
<%@ page import="user.UserDAO"  %> 
<%@ page import="board.board" %> 
<%@ page import="board.boardDAO"  %> 
<%@ page import="board.reply"  %> 
<%@ page import="board.replyDAO"  %> 
<%@ page import="java.util.ArrayList"%>
<%@page import="java.io.PrintWriter"%>
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

		int pageNumber = 1;
		if(request.getParameter("pageNumber")!=null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		String boardCode = null;
		if(request.getParameter("boardCode")!=null){
			boardCode = request.getParameter("boardCode");
		}
		int boardNO = 0;
		if(request.getParameter("boardNO")!=""){
			boardNO = Integer.parseInt(request.getParameter("boardNO"));
		}
		if(boardNO == 0){
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('존재하지 않는 글입니다.')");
			pw.println("location.href = 'board.jsp'");
			pw.println("</script>");
		}
		int updateReplyNO = 0;
		if(request.getParameter("replyNO")!=null){
			updateReplyNO = Integer.parseInt(request.getParameter("replyNO"));
		}
		board board = new boardDAO().getBoard(boardNO,boardCode);
		// 로그인 유지를 위한 파트
	%>
	
	<div class="container">
		<div class="row">
			<form method="post" action="replyAction.jsp?boardCode=<%=boardCode%>&&boardNO=<%=boardNO%>">
				<table class="table table-striped" border ="1" width = "800" height ="600"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="7" style="background-color: #eeeeee; text-align: center;">
							<p style="font-size:20px"><b>
							<%=board.getBoardTitle().replaceAll("<", "&lt;").replaceAll(" ", "&nbsp;").replaceAll(">", "&gt;")%>
							</b></p>
							</th>
						</tr>
					</thead>

					<tbody>
						<tr>
							<td colspan="2" align="left" width=10% height=2%><b>작성자</b></td>
							<td colspan="3" align="left" width=70%><%=board.getBoardWriter() %></td>
							<td colspan="2" align="center" width=20%><%=board.getBoardDate() %></td>



						</tr>
						<tr>
							<td colspan="2" width = "50" align="left"><b>내용</b></td>
							<td colspan="5" width = "350" align="left"><%=board.getBoardContent() %></td>
						</tr>
						<tr>
							<%
								if (userID == null) {
							%>
							<td colspan="2">로그인 후 사용가능합니다.</td>
							
							<%
								}else{
							%>
								<td colspan="2"><%=userID%></td>
							<%
								}
							%>
							<td colspan="4" height="10" align="left"><input type="text" class="form-control" placeholder="댓글" name="replyContent" maxlength="500"></td>
							<td align="center"><input type="submit" class="btn btn-primary pull-right" value="댓글쓰기"></td>
						</tr>


				</table>
			</form>

		</div>
	</div>
	<div class="container">
		<div class="row">
			<form method="post" action="replyUpdateAction.jsp?boardCode=<%=boardCode%>&&boardNO=<%=boardNO%>&&replyNO=<%=updateReplyNO%>">
				<table class="table table-striped" border ="1" width = "800" style="text-align: center; border: 1px solid #dddddd">
						<%
							replyDAO replyDAO = new replyDAO();
							ArrayList<reply> list = replyDAO.getList(pageNumber, boardNO,boardCode);
							for (int i = 0; i < list.size(); i++) {
								String replyUserID = list.get(i).getUserID();
								int replyNO = list.get(i).getReplyNO();
								if(replyNO==updateReplyNO){
						%>
								<tr>
									<td colspan="2" width=10%><%=replyUserID%></td>
									<td colspan="3" width=70% height="10" align="left"><input type="text" id="updateText" class="form-control" placeholder="댓글" name="replyContent" maxlength="500" value="<%=list.get(i).getReplyContent() %>"></td>
									<td style="border-left: none;" colspan="1" width=10% align="center">
								<%
									if (userID != null && userID.equals(replyUserID)) {
								%> 
									<input type="submit" class="btn btn-primary pull-right" value="확인">
								<%
								
									}
								%>
							</td>
							<td colspan="1" width=10%><%=list.get(i).getReplyDate()%><br>
							</td>
						</tr>
						<%
								}else{
						%>
						<tr>
							<td colspan="2" width=10%><%=replyUserID%></td>
							<td colspan="3" width=70% height="10" align="left"><%=list.get(i).getReplyContent()%></td>
							<td style="border-left: none;" colspan="1" width=10% align="center">
								<%
									if (userID != null && userID.equals(replyUserID)) {
								%> 
								<a href="replyUpdate.jsp?boardCode=<%=boardCode%>&&boardNO=<%=boardNO%>&&replyNO=<%=replyNO%>">수정</a>
								<a onclick="return confirm('정말 삭제하시겠습니까?')"
								href="replyDeleteAction.jsp?boardCode=<%=boardCode%>&&boardNO=<%=boardNO%>&&replyNO=<%=replyNO%>">삭제</a>
								<%
									}
								%>
							</td>
							<td colspan="1" width=10%><%=list.get(i).getReplyDate()%><br>

							</td>

						</tr>
						<%
								}
							}
						%>
					</tbody>

				</table>
			</form>
			<input type="button" class="btn btn-primary pull-right" onclick = "location.href = 'board.jsp'" value="목록">
			<%
				if (userID != null && userID.equals(board.getBoardWriter())) {
			%> 
			<input type="button" class="btn btn-primary pull-right" onclick = "location.href = 'boardDeleteAction.jsp?boardNO=<%=boardNO%>&&boardCode=<%=boardCode%>'" value="삭제">
			<input type="button" class="btn btn-primary pull-right" onclick = "location.href = 'boardUpdate.jsp?boardNO=<%=boardNO%>&&boardCode=<%=boardCode%>'" value="수정"> 
			<%
				}
			%>
		</div>
	</div>
	
	
		<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>