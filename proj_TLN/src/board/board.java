package board;

import java.sql.Date;

public class board {
	private String boardCode; // board / bank / jedo
	private int boardNO; // 게시판 번호
	private String boardTitle; // 글 제목
	private String boardWriter; // 작성자
	private String provider; // 제공하는 회사, 기관 등등 / 일반 게시판에서는 0으로 통일 
	private String boardContent; // 글 내용
	private Date boardDate; // 작성 날짜
	private int boardViews; // 게시판 조회 수
	private int boardAvailable; // 삭제 시 사용
	private int boardComment;
	private String FileName; // 글 내용
	private String fileRealPath; // 글 내용

	public String getBoardCode() {
		return boardCode;
	}
	public void setBoardCode(String boardCode) {
		this.boardCode = boardCode;
	}
	public int getBoardNO() {
		return boardNO;
	}
	public void setBoardNO(int boardNO) {
		this.boardNO = boardNO;
	}
	public String getBoardTitle() {
		return boardTitle;
	}
	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}
	public String getBoardWriter() {
		return boardWriter;
	}
	public void setBoardWriter(String boardWriter) {
		this.boardWriter = boardWriter;
	}
	public String getProvider() {
		return provider;
	}
	public void setProvider(String provider) {
		this.provider = provider;
	}
	public String getBoardContent() {
		return boardContent;
	}
	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}
	public Date getBoardDate() {
		return boardDate;
	}
	public void setBoardDate(Date boardDate) {
		this.boardDate = boardDate;
	}
	public int getBoardViews() {
		return boardViews;
	}
	public void setBoardViews(int boardViews) {
		this.boardViews = boardViews;
	}
	public int getBoardAvailable() {
		return boardAvailable;
	}
	public void setBoardAvailable(int boardAvailable) {
		this.boardAvailable = boardAvailable;
	}
	public String getFileName() {
		return FileName;
	}
	public void setFileName(String fileName) {
		FileName = fileName;
	}
	public String getFileRealPath() {
		return fileRealPath;
	}
	public void setFileRealPath(String fileRealPath) {
		this.fileRealPath = fileRealPath;
	}
	public int getBoardComment() {
		return boardComment;
	}
	public void setBoardComment(int boardComment) {
		this.boardComment = boardComment;
	}
	
}
