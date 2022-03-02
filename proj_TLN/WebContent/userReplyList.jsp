
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.user" %> 
<%@ page import="user.UserDAO"  %> 
<%@ page import="board.board" %> 
<%@ page import="board.boardDAO"%> 
<%@ page import="java.util.ArrayList"%>
<%@ page import="board.reply" %>
<%@ page import="board.replyDAO" %>

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
		String boardWriter = "";
		if(request.getParameter("pageNumber")!=null) 	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		if(request.getParameter("boardWriter")!= null)	boardWriter = request.getParameter("boardWriter");
		replyDAO replyDAO = new replyDAO();
	%>
	
	<div class="well"> <%=boardWriter %>님의 댓글 목록입니다.</div>
		<div class="container" style="height:auto; min-height:750px;">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">게시판</th>
						<th width=400 style="background-color:#eeeeee; text-align:center ;">댓글내용</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">작성일</th>
					</tr>
					
				</thead>
				<tbody>
					<%
						ArrayList<reply> list = replyDAO.getList(pageNumber, boardWriter); // 여기까지 함
						for(int i=0;i<list.size(); i++ ) {

					%>
					<tr>
						<td><%=list.get(i).getBoardCode() %></td>
						<td align="left"><a href="view.jsp?boardNO=<%=list.get(i).getBoardNO()%>&&boardCode=<%=list.get(i).getBoardCode()%>"><%=list.get(i).getReplyContent() %></a>
						</td>
						<td><%=list.get(i).getReplyDate() %></td>
					</tr>	
					<%
						}
						
					%>
				</tbody>
			</table>
			<div align="center">
			<%
				if(pageNumber!=1){
			%>
				<a href="userReplyList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=pageNumber-1 %>" class="btn btn-success btn-arrow-left">이전</a>
			<%
				} 
				int pageCNT = replyDAO.getPageCount(pageNumber,boardWriter);
				for(int i=1; i<=pageCNT ; i++){
			%>
				<a href="userReplyList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=i%>"><%=i%> </a>
			<%
				}
				if(replyDAO.nextPage(pageNumber+1,boardWriter,"myReply")){
			%>
				<a href="userReplyList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=pageNumber+1 %>" class="btn btn-success btn-arrow-left">다음</a>
			<%
				}
			%>

			</div>
			<a href="main.jsp" class="btn btn-primary pull-center">홈으로</a>
			<a href="userBoardList.jsp?boardWriter=<%=boardWriter%>" class="btn btn-primary pull-right">글 목록</a>
		</div>
	</div>
	<br><br><br>
	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>