
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
		final int listRowNUM = 5; // 게시판에 보이게할 개수
		int thispageNumber = 0;
		int pageNumber = 1;
		if(request.getParameter("pageNumber")!=null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		thispageNumber = (pageNumber-1)/5;
		System.out.println(thispageNumber);
		String boardCode = "게시판";
		boardDAO boardDAO = new boardDAO();
		// 로그인 유지를 위한 파트
	%>


		<div class="container" style="height:auto; min-height:750px;">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">번호</th>
						<th width=400 style="background-color:#eeeeee; text-align:center ;">제목</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">조회수</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">작성자</th>
						<th width=100 style="background-color:#eeeeee; text-align:center ;">작성일</th>
					</tr>
					
				</thead>
				<tbody>
					<%
						ArrayList<board> list = boardDAO.getList(pageNumber,boardCode,"");
						for(int i=0;i<list.size(); i++ ) {

					%>
					<tr>
						<td><%=list.get(i).getBoardNO() %></td>
						<td align="left"><a href="view.jsp?boardNO=<%=list.get(i).getBoardNO()%>&&boardCode=<%=list.get(i).getBoardCode()%>"><%= list.get(i).getBoardTitle().replaceAll("<","&lt;").replaceAll(" ","&nbsp;").replaceAll(">","&gt;") %></a>
						<font color="red">[<%=list.get(i).getBoardComment() %>] </font>
						
						</td>
						<td><%=list.get(i).getBoardViews() %></td>
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
				if(pageNumber>listRowNUM){
			%>
				<a href="board.jsp?pageNumber=<%=(thispageNumber-1)*listRowNUM+1 %>" class="btn btn-success btn-arrow-left">이전</a>
			<%
				} 
				int pageCNT = boardDAO.getPageCount(pageNumber,boardCode,"");
				int thisPageCNT = pageNumber;
				for(int i=1; i<=5 ; i++){
					if(thispageNumber*listRowNUM+i>pageCNT) break;
			%>
				<a href="board.jsp?pageNumber=<%=(thispageNumber*listRowNUM)+i%>"><%=(thispageNumber*listRowNUM)+i%> </a>
			<%
				}
				if(boardDAO.nextPage(pageNumber+1,boardCode,"")){
			%>
				<a href="board.jsp?pageNumber=<%=(thispageNumber+1)*listRowNUM+1 %>" class="btn btn-success btn-arrow-left">다음</a>
			<%
				}
			%>

			</div>
			<a href="write.jsp?boardCode=<%=boardCode %>" class="btn btn-primary pull-right">글쓰기</a>
			
		</div>
	</div>
	<br><br><br>
	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>