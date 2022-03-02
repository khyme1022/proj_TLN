
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>

<%@ page import="board.boardDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%
	request.setCharacterEncoding("UTF-8");
%>


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

		/////////////////////// 파일 관련
		String realPath ="";
		String fileName ="";
		String fileUploadFolder = "/fileUploadFolder";
		String encType = "utf-8";

		int maxSize = 1024 * 1024 * 10;
		realPath = request.getSession().getServletContext().getRealPath(fileUploadFolder);

		MultipartRequest multi = null;
		multi = new MultipartRequest(request, realPath, maxSize, encType, new DefaultFileRenamePolicy());
		fileName = multi.getFilesystemName("fileName");
		String boardTitle = multi.getParameter("boardTitle");
		String boardContent = multi.getParameter("boardContent");
		String boardCode = multi.getParameter("boardCode");
		String provider = multi.getParameter("provider");
		String[] split = realPath.split("wtpwebapps");
		realPath=split[1];
		System.out.println(realPath); // 파일경로
		System.out.println(fileName); // 파일이름
		////////////////////////

		if (boardTitle == null || boardContent == null || boardCode == null) {
			PrintWriter pw = response.getWriter();
			pw.println("<script>");
			pw.println("alert('모두 입력해주세요!')");
			pw.println("history.back()");
			pw.println("</script>");

		} else {
			boardContent = boardContent.replace("\r\n","<br>");
			boardDAO boardDAO = new boardDAO();
			int result = -1;
			if (provider.equals("X")) {
				result = boardDAO.write(boardTitle, userID, boardContent, boardCode,fileName,realPath);
				System.out.println("write1");
			} else {
				result = boardDAO.write(boardTitle, userID, boardContent, boardCode, provider, fileName,realPath);
				System.out.println("write2");
			}

			if (result == -1) {
				PrintWriter pw = response.getWriter();
				pw.println("<script>");
				pw.println("alert('글쓰기에 실패했습니다. 모두 입력해주세요')");
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