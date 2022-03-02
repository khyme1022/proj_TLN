package user;



public class user{
	private String userID;
	private String userPW;
	private String userName;
	private String userPhone;
	private String userEmail;
	private String userGender;
	private int userAvailable;
	private String user_Intro;
	private String user_INFM_YN;


	public String getUser_Intro() {
		return user_Intro;
	}
	public void setUser_Intro(String user_Intro) {
		this.user_Intro = user_Intro;
	}
	public String getUser_INFM_YN() {
		return user_INFM_YN;
	}
	public void setUser_INFM_YN(String user_INFM_YN) {
		this.user_INFM_YN = user_INFM_YN;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getUserPW() {
		return userPW;
	}
	public void setUserPW(String userPW) {
		this.userPW = userPW;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhone() {
		return userPhone;
	}
	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}
	public String getUserEmail() {
		return userEmail;
	}
	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}
	public String getUserGender() {
		return userGender;
	}
	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}
	public int getUserAvailable() {
		return userAvailable;
	}
	public void setUserAvailable(int userAvailable) {
		this.userAvailable = userAvailable;
	}
}
