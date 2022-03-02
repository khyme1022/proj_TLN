
<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.user" %> 
<%@ page import="user.UserDAO"  %> 
<%@ page import="board.board" %> 
<%@ page import="board.boardDAO"%> 
<%@ page import="java.util.ArrayList"%>

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
		int userID_NULL_CHK=1;	
		if(userID==null){
			userID_NULL_CHK=0;
		}
		int pageNumber = 1;
		String boardWriter = "";
		if(request.getParameter("pageNumber")!=null) 	pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		if(request.getParameter("boardWriter")!= null)	boardWriter = request.getParameter("boardWriter");
		boardDAO boardDAO = new boardDAO();
		if(userID_NULL_CHK==0){
			if(boardDAO.user_infm_yn_chk(boardWriter).equals("N")){
	%>
		<script>
			alert("공개를 허용하지 않은 회원입니다");
			history.back();
		</script>
	<%		}
		}
	%>
	
	<div class="well"> <%=boardWriter %>님의 게시글 목록입니다.</div>
		<div class="container" style="height:auto; min-height:750px;">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th width=150 style="background-color:#eeeeee; text-align:center ;">게시판이름</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">번호</th>
						<th width=350 style="background-color:#eeeeee; text-align:center ;">제목</th>					
						<th width=100 style="background-color:#eeeeee; text-align:center ;">작성자</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">작성일</th>
					</tr>
					
				</thead>
				<tbody>
					<%
						ArrayList<board> list = boardDAO.getList(pageNumber, boardWriter,"myBoard");
						for(int i=0;i<list.size(); i++ ) {

					%>
					<tr>
						<td><%=list.get(i).getBoardCode() %> </td>
						<td><%=list.get(i).getBoardNO() %></td>
						<td align="left"><a href="view.jsp?boardNO=<%=list.get(i).getBoardNO()%>&&boardCode=<%=list.get(i).getBoardCode()%>"><%= list.get(i).getBoardTitle().replaceAll("<","&lt;").replaceAll(" ","&nbsp;").replaceAll(">","&gt;") %></a>
						<font color="red">[<%=list.get(i).getBoardComment() %>] </font>
						</td>
						<td><%=list.get(i).getBoardWriter() %></td>
						<td><%=list.get(i).getBoardDate() %></td>
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
				<a href="userBoardList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=pageNumber-1 %>" class="btn btn-success btn-arrow-left">이전</a>
			<%
				} 
				int pageCNT = boardDAO.getPageCount(pageNumber,boardWriter,"myBoard");
				for(int i=1; i<=pageCNT ; i++){
			%>
				<a href="userBoardList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=i%>"><%=i%> </a>
			<%
				}
				if(boardDAO.nextPage(pageNumber+1,boardWriter,"myBoard")){
			%>
				<a href="userBoardList.jsp?boardWriter=<%=boardWriter%>&&pageNumber=<%=pageNumber+1 %>" class="btn btn-success btn-arrow-left">다음</a>
			<%
				}
			%>

			</div>
			<a href="main.jsp" class="btn btn-primary pull-center">홈으로</a>
			<a href="userReplyList.jsp?boardWriter=<%=boardWriter %>" class="btn btn-primary pull-right">댓글 목록</a>
		</div>
	</div>
	<br><br><br>
	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>