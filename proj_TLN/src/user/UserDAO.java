package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import board.board;

public class UserDAO {
	
	private DataSource dataFactory;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		try {
			Context ctx= new InitialContext();
			Context envContext = (Context) ctx.lookup("java:/comp/env");
			dataFactory =(DataSource) envContext.lookup("jdbc/oracle");
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String userID, String userPW) {
		String query = "SELECT userPW FROM USER_INFM WHERE userID = ? AND userAvailable=1";
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPW)){
					pstmt.close();
					conn.close();
					return 1;	
				}
				else {
					pstmt.close();
					conn.close();
					return 0;
				}
					

			}
			pstmt.close();
			conn.close();
			return -1;
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		return -2;
	}
	
	public int join(user user) {
		String query = "INSERT INTO USER_INFM VALUES (?,?,?,?,?,?,?,?,?)";
		try {
			conn = dataFactory.getConnection();
			pstmt = conn.prepareStatement(query);
			
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPW());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserPhone());
			pstmt.setString(5, user.getUserEmail());
			pstmt.setString(6, user.getUserGender());
			pstmt.setInt(7, 1);
			pstmt.setString(8, user.getUser_Intro());
			pstmt.setString(9, user.getUser_INFM_YN());
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public int delete(String userID) {
		String query = "DELETE FROM USER_INFM WHERE userID = ?";
		
		try {
			conn = dataFactory.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;	

		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		return -1;
	}
	
	public user getUser(String userID) {
		String query = "SELECT * FROM USER_INFM WHERE userID = ?";
		System.out.println(query);

		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user user = new user();
				user.setUserID(rs.getString(1));
				user.setUserPW(rs.getString(2));
				user.setUserName(rs.getString(3));
				user.setUserPhone(rs.getString(4));
				user.setUserEmail(rs.getString(5));
				user.setUserGender(rs.getString(6));
				user.setUserAvailable(rs.getInt(7));
				user.setUser_Intro(rs.getString(8));
				user.setUser_INFM_YN(rs.getString(9));
				return user;
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public String getUser_Intro(String userID) {
		String query = "SELECT user_intro FROM USER_INFM WHERE userID = ?";
		System.out.println(query);
		String user_intro="";
		try {
			conn = dataFactory.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(query);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				user_intro = rs.getString(1);
				return user_intro;
			}
			rs.close();
			pstmt.close();
			conn.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
	public int update(user user) {
		String query = "UPDATE USER_INFM SET userPW=?, userName=?, userPhone=?,userEmail=?, userGender=?, user_intro=?, user_infm_yn=? WHERE userID=?";
		System.out.println(query);
		try {
			conn = dataFactory.getConnection();
			pstmt = conn.prepareStatement(query);
			pstmt.setString(1, user.getUserPW());
			pstmt.setString(2, user.getUserName());
			pstmt.setString(3, user.getUserPhone());
			pstmt.setString(4, user.getUserEmail());
			pstmt.setString(5, user.getUserGender());
			pstmt.setString(6, user.getUser_Intro());
			pstmt.setString(7, user.getUser_INFM_YN());
			pstmt.setString(8, user.getUserID());
			pstmt.executeUpdate();
			pstmt.close();
			conn.close();
			return 0;

		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	

}
