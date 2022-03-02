package board;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class boardDAO {

	private DataSource dataFactory;
	private Connection conn;
	private ResultSet rs;
	public static final int listROWNUM = 5; // 게시판에 보이게할 개수
	
	public boardDAO() {
		try {
			Context ctx = new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory = (DataSource) envContext.lookup("jdbc/oracle");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public ArrayList<board> getList(int pageNumber, String boardArgs, String delimeter) { // 게시판 게시글 20개단위로 리스트로 리턴 개인 게시글 확인 시 사용
		String query="";
		if(delimeter.equals("myBoard")) { // delimeter가 myBoard면 userID로 찾아 내 글 보기
			query = "SELECT boardCode, boardNO, boardTitle,boardWriter, provider, boardcontent, boarddate, boardViews, boardComment, boardavailable, filename, filerealPath "
				  + "FROM (SELECT boardCode, boardNO, boardTitle,boardWriter, provider, boardcontent, boarddate, boardViews, boardComment, boardavailable, filename, filerealPath,ROWNUM as RNUM " + 
							"FROM(SELECT boardCode, boardNO, boardTitle,boardWriter, provider, boardcontent, boarddate, boardViews, boardComment, boardavailable, filename, filerealPath " + 
									"FROM board WHERE boardavailable =1 AND boardWriter=? order by boarddate desc )" + 
							") " + 
					"WHERE RNUM<=? AND RNUM>=?";
		}else{
			query = "SELECT * FROM "
					+ "(SELECT * FROM BOARD WHERE boardNO < ? AND boardAvailable = 1 AND boardCode=? ORDER BY boardNO DESC)"
					+ "WHERE ROWNUM <= ?";
		}// 다음 글-1 의 글 부터 20개의 쿼리 선택
		System.out.println("getList()" + pageNumber + " " + boardArgs + " " + delimeter);
		System.out.println(query);
		ArrayList<board> list = new ArrayList<board>();
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			if(delimeter.equals("myBoard")){
				pstmt.setString(1, boardArgs);
				pstmt.setInt(2, (pageNumber)*listROWNUM);
				pstmt.setInt(3, (pageNumber-1)*listROWNUM+1);
			}else {
				System.out.println("getList() 2");
				pstmt.setInt(1, getNext(boardArgs,delimeter) - (pageNumber - 1) * listROWNUM); // 다음 글 - 페이지 수*불러올 개수
				pstmt.setString(2, boardArgs);
				pstmt.setInt(3, listROWNUM); // 불러올 개수
			}
			System.out.println("getList() 종료");
			rs = pstmt.executeQuery();
			while (rs.next()) {
				board board = new board();
				board.setBoardCode(rs.getString(1));
				board.setBoardNO(rs.getInt(2));
				board.setBoardTitle(rs.getString(3));
				board.setBoardWriter(rs.getString(4));
				board.setProvider(rs.getString(5));
				board.setBoardContent(rs.getString(6));
				board.setBoardDate(rs.getDate(7));
				board.setBoardViews(rs.getInt(8));
				board.setBoardComment(rs.getInt(9));
				board.setBoardAvailable(rs.getInt(10));
				board.setFileName(rs.getString(11));
				board.setFileRealPath(rs.getString(12));
				
				list.add(board);
			}
			rs.close();
			pstmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public int getNext(String boardArgs, String delimeter) { // 해당 게시판의 마지막 게시판 번호+1 리턴
		String query="";
		System.out.println("getNext() " + boardArgs + " " +delimeter);
		if(delimeter.equals("myBoard")) query = "SELECT ROW_NUM "
											  + "FROM (SELECT ROW_NUMBER() over(order by boarddate) row_num FROM board WHERE boardWriter=?)"  
											  + "ORDER BY ROW_NUM desc";
		else							query = "SELECT boardNO FROM board WHERE boardcode=? order by boardNO desc";	
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			int result = 1; // 첫 게시물은 1
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardArgs); // ??? 이게 왜 부적합한 열인덱스?!?!
			rs = pstmt.executeQuery();
			if (rs.next()) {
				result = rs.getInt(1) + 1;
			}
			System.out.println("getNext() 종료");
			rs.close();
			pstmt.close();
			conn.close();
			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int getPageCount(int num, String boardArgs,String delimeter) { // 게시판에 나올 게시판 총 페이지 수 계산
		int cnt =0;
		int next = getNext(boardArgs,delimeter);
		if (next % listROWNUM != 1) cnt = next / listROWNUM +1;
		else cnt = next / listROWNUM;
		return cnt;
	}
	
	public boolean nextPage(int pageNumber, String boardArgs,String delimeter) { // 다음 페이지 존재하는 지 체크
		String query = "";
		if(delimeter.equals("myBoard")) query = "SELECT * FROM BOARD WHERE boardNO < ? AND BoardAvailable = 1 AND boardWriter = ?";
		else query="SELECT * FROM BOARD WHERE boardNO < ? AND BoardAvailable = 1 AND boardCode = ?";
		
		System.out.println("nextPage()");
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, getNext(boardArgs,delimeter) - (pageNumber - 1) * listROWNUM);
			pstmt.setString(2, boardArgs);

			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
			rs.close();
			pstmt.close();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	
	public int write(String boardTitle, String userID, String boardContent, String boardCode, String FileName, String realPath) { // 글쓰기 1 일반게시판
		System.out.println("write() + File");
		String query = "INSERT INTO BOARD VALUES (?,?,?,?,'X',?,sysdate,0,0,1,?,?)";
		System.out.println(query);

		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardCode);
			pstmt.setInt(2, getNext(boardCode,""));
			pstmt.setString(3, boardTitle);
			pstmt.setString(4, userID);
			pstmt.setString(5, boardContent);
			pstmt.setString(6, FileName);
			pstmt.setString(7, realPath);
			pstmt.executeUpdate();
			rs.close();
			pstmt.close();
			conn.close();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}

	}

	public int write(String boardTitle, String userID, String boardContent, String boardCode, String provider, String FileName, String realPath) { // 글쓰기2 제도, 은행
		String query = "INSERT INTO BOARD VALUES (?,?,?,?,?,?,sysdate,0,0,1,?,?)";
		System.out.println("write()");
		System.out.println(query);

		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardCode);
			pstmt.setInt(2, getNext(boardCode,""));
			pstmt.setString(3, boardTitle);
			pstmt.setString(4, userID);
			pstmt.setString(5, provider);
			pstmt.setString(6, boardContent);
			pstmt.setString(7, FileName);
			pstmt.setString(8, realPath);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;

	}
	
	public int update(String boardTitle, String boardContent, String boardCode, int boardNO, String FileName) { // 수정 1 일반게시판
		String query = "UPDATE board SET boardTitle = ?, boardContent=?, FileName=? WHERE boardCode=? AND boardNO=?";
		System.out.println(query);
		System.out.println("update()");
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardTitle);
			pstmt.setString(2, boardContent);
			pstmt.setString(3, FileName);
			pstmt.setString(4, boardCode);
			pstmt.setInt(5, boardNO);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}

	}
	
	public int update(String boardTitle, String boardContent, String boardCode, String provider, int boardNO, String FileName) { // 수정 2 제도게시판
		String query = "UPDATE board SET boardTitle = ?, provider=?, boardContent=?, FileName=? WHERE boardCode=? AND boardNO=?";
		System.out.println(query);
		System.out.println("update()");
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardTitle);
			pstmt.setString(2, provider);
			pstmt.setString(3, boardContent);
			pstmt.setString(4, FileName);
			pstmt.setString(5, boardCode);
			pstmt.setInt(6, boardNO);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}

	}
	
	public int delete(String boardCode, int boardNO)  // 글 삭제
	{
		String query = "UPDATE board SET boardAvailable =0 WHERE boardCode=? AND boardNO=?";
		System.out.println("delete()");
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardCode);
			pstmt.setInt(2, boardNO);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	
	public board getBoard(int boardNO, String boardCode) { // 글번호, 게시판코드를 받아 게시판 정보 받아오는 함수
		String query = "SELECT * FROM BOARD WHERE boardNO = ? and boardCode= ?";
		System.out.println("getBoard()");
		System.out.println(query);
		addView(boardNO,boardCode);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, boardNO);
			pstmt.setString(2, boardCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				board board = new board();				
				board.setBoardCode(rs.getString(1));
				board.setBoardNO(rs.getInt(2));
				board.setBoardTitle(rs.getString(3));
				board.setBoardWriter(rs.getString(4));
				board.setProvider(rs.getString(5));
				board.setBoardContent(rs.getString(6));
				board.setBoardDate(rs.getDate(7));
				board.setBoardViews(rs.getInt(8));
				board.setBoardComment(rs.getInt(9));
				board.setBoardAvailable(rs.getInt(10));
				board.setFileName(rs.getString(11));
				board.setFileRealPath(rs.getString(12));
				return board;
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public void addView(int boardNO, String boardCode) { // 조회수 추가 
		String query = "UPDATE board set boardviews = boardviews+1 WHERE boardNO =? AND boardCode = ?";
		System.out.println("addView()");
		System.out.println(query);

		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, boardNO);
			pstmt.setString(2, boardCode);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public String user_infm_yn_chk(String boardWriter) { // 게시글 공개 유무 체크
		String query = "SELECT user_infm_yn FROM user_infm WHERE userID=?";
		System.out.println("user_infm_yn_chk");
		System.out.println(query);
		String chk = "";
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, boardWriter);
			rs = pstmt.executeQuery();
			if(rs.next())				chk=rs.getString(1);
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return chk;
	}
}
