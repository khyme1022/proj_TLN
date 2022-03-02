<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="board.board" %> 
<%@ page import="board.boardDAO"%>

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
			boardDAO boardDAO = new boardDAO();
			int boardNext = boardDAO.getNext("게시판","");
			int bankNext = boardDAO.getNext("은행","");
			int jedoNext = boardDAO.getNext("제도","");
			int idx = 5;
			System.out.println(boardNext+" "+bankNext+" "+ jedoNext);
		%>
		<div class="container" style="height:auto;" >
		<div class="row">
			<table class="table">
				<thead>
					<tr>
						<th width=200 style="background-color:#c2f595; ">일반 게시판</th>
						<th width=200 style="background-color:#c2f595; ">은행 혜택 모음</th>
						<th width=200 style="background-color:#c2f595; ">국가 제도 모음</th>
					</tr>

				</thead>
				<tbody>
				<%
					ArrayList<board> list = boardDAO.getList(1,"게시판","");
					ArrayList<board> banklist = boardDAO.getList(1,"은행","");
					ArrayList<board> jedolist = boardDAO.getList(1,"제도","");

					for(int i=0;i<idx; i++ ) {
				%>
					<tr>
					<%if((boardNext-i)>=1) {%>		<td><a href="view.jsp?boardNO=<%=list.get(i).getBoardNO()%>&&boardCode=<%=list.get(i).getBoardCode()%>"><%=list.get(i).getBoardTitle()%><font color="red">[<%=list.get(i).getBoardComment() %>] </font></a></td>
					<%}else{ %> <td></td>
					<%}if((bankNext-1)-i>=1){ %>	<td><a href="view.jsp?boardNO=<%=banklist.get(i).getBoardNO()%>&&boardCode=<%=banklist.get(i).getBoardCode()%>"><%=banklist.get(i).getBoardTitle()%><font color="red">[<%=banklist.get(i).getBoardComment() %>] </font></a></td>
					<%}else{ %> <td></td>
					<%}if((jedoNext-1)-i>=1) {%>	<td><a href="view.jsp?boardNO=<%=jedolist.get(i).getBoardNO()%>&&boardCode=<%=jedolist.get(i).getBoardCode()%>"><%=jedolist.get(i).getBoardTitle()%><font color="red">[<%=jedolist.get(i).getBoardComment() %>] </font></a></td>
					<%}else{ %> <td></td><%} }%>
					</tr>	


				</tbody>
			</table>
		</div>
	</div>
	<%-- Carousel --%>

	<div class="container" style="height:auto; min-height:550px;" >
		<div id="myCarousel" class="carousel slide" data-ride="carousel" style="height:auto; max-height:500;">
			<ol class="carousel-indicators">
				<li data-target="#myCarousel" data-slide-to="0" class="active"></li>
				<li data-target="#myCarousel" data-slide-to="1"></li>
				<li data-target="#myCarousel" data-slide-to="2"></li>
			</ol>
			<div class="carousel-inner">
				<div class="item active">
					<a href="bank.jsp"><img src="image/그림1.jpg" height=500 class="img-responsive center-block "/></a>
				</div>
				<div class="item">
					<a href="jedo.jsp"><img src="image/그림2.jpg" height=500 class="img-responsive center-block" /></a>
				</div>			
				<div class="item">
					<a href="view.jsp?boardNO=3&&boardCode=제도"><img src="image/그림3.jpg" height=500 class="img-responsive center-block" /></a>
				</div>			
			</div>				
			<a class="left carousel-control" href="#myCarousel" data-slide="prev">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</a>
			<a class="right carousel-control" href="#myCarousel" data-slide="next">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</a>		

		</div>
	</div>


	<%@ include file="/footer.jsp" %>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>