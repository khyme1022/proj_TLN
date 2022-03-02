package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class replyDAO {
	private DataSource dataFactory;
	private Connection conn;
	private ResultSet rs;
	public static final int listROWNUM = 20; // 게시판에 보이게할 개수
	
	public replyDAO() {
		try {
			Context ctx= new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory =(DataSource) envContext.lookup("jdbc/oracle");
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int getNext(int boardNO, String boardCode) { // 다음 댓글 순서 
		System.out.println("---getNext()---"+ boardNO + " " + boardCode);
		String query = "SELECT replyNO FROM reply WHERE boardNO = ? AND boardCode = ? order by replyNO desc";
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			int result=1; // 첫 게시물은 1
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, boardNO);
			pstmt.setString(2, boardCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1) +1;
			}
			rs.close();
			pstmt.close();
			conn.close();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int getNext(String replyWriter) { // 다음 댓글 순서 
		System.out.println("---getNext()my---");
		String query = "SELECT ROW_NUM " + 
				"FROM (SELECT ROW_NUMBER() over(order by replydate) as ROW_NUM FROM reply WHERE userID=?) " + 
				"ORDER BY ROW_NUM desc";
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			int result=1; // 첫 게시물은 1
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, replyWriter);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1) +1;
			}
			rs.close();
			pstmt.close();
			conn.close();
			return result;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public ArrayList<reply> getList(int pageNumber, int boardNO, String boardCode){ // 댓글 listRowNum개단위로 리스트로 리턴
		System.out.println("---getList()---");
		String query = "SELECT * FROM "
				+ "(SELECT * FROM reply WHERE replyNO < ? AND replyAvailable = 1 AND boardNO = ? AND boardCode = ? ORDER BY replyNO DESC)"
				+ "WHERE ROWNUM < ?";
		System.out.println(query);

		ArrayList<reply> list = new ArrayList<reply>();
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, getNext(boardNO,boardCode) - (pageNumber - 1)*listROWNUM);
			pstmt.setInt(2, boardNO);
			pstmt.setString(3, boardCode);
			pstmt.setInt(4, listROWNUM);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				reply reply = new reply();
				reply.setUserID(rs.getString(1));
				reply.setReplyNO(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setReplyDate(rs.getDate(4));
				reply.setReplyAvailable(rs.getInt(5));
				reply.setBoardNO(rs.getInt(6));
				reply.setBoardCode(rs.getString(7));
				list.add(reply);
				
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	} // 여기까지
	
	public ArrayList<reply> getList(int pageNumber, String replyWriter){ // 댓글 listRowNum개단위로 리스트로 리턴
		System.out.println("---getList()my---");
		String query = "SELECT userID,replyNO,replyContent,replyDATE,replyAvailable, boardNO, boardCode " + 
						"FROM (SELECT userID,replyNO,replyContent,replyDATE,replyAvailable, boardNO, boardCode, ROWNUM as RNUM " + 
							   "FROM(SELECT userID,replyNO,replyContent,replyDATE,replyAvailable, boardNO, boardCode " + 
							   		"FROM reply WHERE replyavailable =1 AND userID=? order by replydate desc ) " + 
							   ") " + 
					    "WHERE RNUM<=? AND RNUM>=?";
		System.out.println(query);

		ArrayList<reply> list = new ArrayList<reply>();
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, replyWriter);
			pstmt.setInt(2, (pageNumber)*listROWNUM);
			pstmt.setInt(3, (pageNumber-1)*listROWNUM+1);
			rs = pstmt.executeQuery();
			while(rs.next()) {
				reply reply = new reply();
				reply.setUserID(rs.getString(1));
				reply.setReplyNO(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setReplyDate(rs.getDate(4));
				reply.setReplyAvailable(rs.getInt(5));
				reply.setBoardNO(rs.getInt(6));
				reply.setBoardCode(rs.getString(7));
				list.add(reply);
				
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	} // 여기까지
	public int write(String userID, String replyContent, int boardNO,String boardCode) { // 댓글 쓰기 기능
		System.out.println("---write()---");
		String query = "INSERT INTO reply VALUES (?,?,?,sysdate,?,?,?,?)";
		System.out.println(query);
		
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			pstmt.setInt(2, getNext(boardNO,boardCode));
			pstmt.setString(3, replyContent);
			pstmt.setInt(4, 1);
			pstmt.setInt(5, boardNO);
			pstmt.setString(6, boardCode);
			pstmt.setInt(7, 0);
			pstmt.executeUpdate();
			rs.close();
			pstmt.close();
			conn.close();
			replyCount(boardNO,boardCode,0);
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public void replyCount(int boardNO,String boardCode,int count) { // board의 boardComment 속성 가감
		System.out.println("---replyCount()---");
		String query0 = "UPDATE board set boardComment = boardComment+1 WHERE boardNO =? AND boardCode = ?"; // 0은 증가
		String query1 = "UPDATE board set boardComment = boardComment-1 WHERE boardNO =? AND boardCode = ?"; // 1는 감소
		String query ="";
		System.out.println(query);
		if(count==0) query = query0; 
		else query = query1;
		
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1,boardNO);
			pstmt.setString(2,boardCode);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public reply getReply(int boardNO, int replyNO, String boardCode) { // 댓글 불러오기 수정 시 사용
		System.out.println("---getReply()---");
		String query = "SELECT * FROM reply WHERE boardNO = ? AND replyNO = ? AND boardCode=?";
		System.out.println(query);

		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, boardNO);
			pstmt.setInt(2, replyNO);
			pstmt.setString(3,boardCode);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				reply reply = new reply();				
				
				return reply;
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int replyNO, int boardNO, String boardCode, String replyContent) {
		System.out.println("---reply update---");
		String query = "UPDATE reply SET replyContent=? WHERE replyNO=? and boardNO=? and boardCode=?";
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, replyNO);
			pstmt.setInt(3, boardNO);
			pstmt.setString(4, boardCode);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
		
	}
	public int delete(int boardNO, String boardCode, int replyNO) 
	{
		System.out.println("---delete()---");
		String query = "UPDATE reply SET replyAvailable =0 WHERE boardNO =? and replyNO = ? and boardCode=?";
		System.out.println(query);
		replyCount(boardNO,boardCode,1);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, boardNO);
			pstmt.setInt(2, replyNO);
			pstmt.setString(3, boardCode);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int getPageCount(int num, String replyWriter) { 
		System.out.println("---getpageCount()---");
		int cnt =0;
		int next = getNext(replyWriter);
		if (next % listROWNUM != 1) cnt = next / listROWNUM +1;
		else cnt = next / listROWNUM;
		return cnt;
	}
	
	public int getPageCount(int num, String boardCode, int boardNO) { 
		System.out.println("---getpageCount()---");
		int cnt =0;
		int next = getNext(boardNO,boardCode);
		if (next % listROWNUM != 1) cnt = next / listROWNUM +1;
		else cnt = next / listROWNUM;
		return cnt;
	}
	
	
	public boolean nextPage(int pageNumber, String replyArgs, String delimeter) { // 다음 페이지 존재하는 지 체크
		System.out.println("---nextPage()---");
		String query = "";
		if(delimeter.equals("myReply")) query = "SELECT * FROM REPLY WHERE replyNO < ? AND replyAvailable = 1 AND boardCode = ?";
		else query="SELECT * FROM REPLY WHERE boardNO < ? AND replyAvailable = 1 AND userID = ?";
		
		System.out.println("nextPage()");
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, getNext(replyArgs) - (pageNumber - 1) * listROWNUM);
			pstmt.setString(2, replyArgs);

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
}
