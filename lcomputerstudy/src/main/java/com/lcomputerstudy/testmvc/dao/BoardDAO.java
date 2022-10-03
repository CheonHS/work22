package com.lcomputerstudy.testmvc.dao;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import com.lcomputerstudy.testmvc.database.DBConnection;
import com.lcomputerstudy.testmvc.service.UserService;
import com.lcomputerstudy.testmvc.vo.Board;
import com.lcomputerstudy.testmvc.vo.Pagination;
import com.lcomputerstudy.testmvc.vo.User;

public class BoardDAO {
	private static BoardDAO dao = null;
    
	private BoardDAO() {
		
	}

	public static BoardDAO getInstance() {
		if(dao == null) {
			dao = new BoardDAO();
		}
		return dao;
	}
	
	public ArrayList<Board> getBoardList(Pagination pagination) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Board> list = null;
		int pageNum = pagination.getPageNum();
		try {
			conn = DBConnection.getConnection();
//			String sql = "select * from board";
			String sql = "SELECT 		@ROWNUM := @ROWNUM - 1 AS ROWNUM, ta.* "
					   + "FROM board ta "
					   + "INNER JOIN (SELECT @rownum := (SELECT	COUNT(*)-?+1 FROM board ta)) tb "
					   + "LIMIT ?, 3";
	       	pstmt = conn.prepareStatement(sql);
	       	pstmt.setInt(1, pageNum);
	       	pstmt.setInt(2, pageNum);
	        rs = pstmt.executeQuery();
	        list = new ArrayList<Board>();

	        while(rs.next()){
	        	Board board = new Board();
	        	board.setRownum(rs.getInt("ROWNUM"));
	        	board.setB_idx(rs.getInt("b_idx"));
	        	board.setB_title(rs.getString("b_title"));
	        	board.setB_content(rs.getString("b_content"));
	        	board.setB_views(rs.getInt("b_views"));
	        	Date date = new Date();
	        	date.setTime(rs.getTimestamp("b_date").getTime());
	        	board.setB_date(date);
	        	User user = new User();
	        	UserService userService = UserService.getInstance();
	        	user.setU_idx(rs.getInt("u_idx"));
	        	user = userService.detailUser(user);  	
	        	board.setUser(user);
       	       	list.add(board);
	        }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		return list;
		
	}

	public void writeBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "insert into board (b_title, b_content, b_date, u_idx) values (?,?,now(),?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			User user = board.getUser();
			pstmt.setInt(3, user.getU_idx());
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) pstmt.close();
				if(conn!= null) conn.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public Board detailBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Board row = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "select * from board where b_idx=?";
	       	pstmt = conn.prepareStatement(sql);
	       	pstmt.setInt(1, board.getB_idx());
	        rs = pstmt.executeQuery();

	        while(rs.next()){     
	        	row = new Board();
	        	row.setB_idx(rs.getInt("b_idx"));
	        	row.setB_title(rs.getString("b_title"));
	        	row.setB_content(rs.getString("b_content"));
	        	row.setB_views(rs.getInt("b_views"));
	        	Date date = new Date();
	        	date.setTime(rs.getTimestamp("b_date").getTime());
	        	row.setB_date(date);
	        	User user = new User();
	        	user.setU_idx(rs.getInt("u_idx"));
	        	row.setUser(user);
	        }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
		try {
			conn = DBConnection.getConnection();
			String sql = "update board set b_views = ? where b_idx = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, row.getB_views()+1);
			pstmt.setInt(2, row.getB_idx());
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) pstmt.close();
				if(conn!= null) conn.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return row;
	}
	
	public void editBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "update board set b_title = ?, b_content = ?, b_date = now(), b_writer = ? where b_idx = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			pstmt.setInt(4, board.getB_idx());
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) pstmt.close();
				if(conn!= null) conn.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}
	public void deleteBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "delete from board where b_idx=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board.getB_idx());
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) pstmt.close();
				if(conn!= null) conn.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
		
	}

	public int getUserCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "select count(*) count from board";
	       	pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while(rs.next()){     
	        	count = rs.getInt("count");
	        }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				rs.close();
				pstmt.close();
				conn.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		return count;
	}


}
