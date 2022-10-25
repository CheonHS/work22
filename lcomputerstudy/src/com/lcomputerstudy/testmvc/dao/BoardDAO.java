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
import com.lcomputerstudy.testmvc.vo.Comment;
import com.lcomputerstudy.testmvc.vo.Pagination;
import com.lcomputerstudy.testmvc.vo.Search;
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
		Search search = pagination.getSearch();
		int searchType = search.getSearchType();
		String keyword = "%" + search.getKeyword() + "%";
		try {
			conn = DBConnection.getConnection();
//			String sql = "SELECT 		@ROWNUM := @ROWNUM - 1 AS ROWNUM, ta.* \n"
//					   + "FROM 			board ta \n"
//					   + "INNER JOIN 	(SELECT @rownum := (SELECT	COUNT(*)-?+1 FROM board ta ORDER BY b_group desc, b_order asc)) tb \n"
//					   + "ORDER BY b_group desc, b_order asc \n"
//					   + "LIMIT 		?, ? \n";
//	       	pstmt.setInt(1, pageNum);
//	       	pstmt.setInt(2, pageNum);
//	       	pstmt.setInt(3, pagination.getPerPage());
			
			String sql = "SELECT ROW_NUMBER() OVER(ORDER BY b_group asc, b_order desc) AS ROWNUM, \n"
					   + "		ta.*				\n"
					   + "FROM board ta 			\n";
			switch (searchType) {
			
			case 2:
				sql += "WHERE b_title LIKE ? 		\n"
					+  "ORDER BY ROWNUM desc		\n"
					+  "LIMIT ?,?					\n";
		       	pstmt = conn.prepareStatement(sql);
		       	pstmt.setString(1, keyword);
		       	pstmt.setInt(2, pageNum);
		       	pstmt.setInt(3, pagination.getPerPage());
				break;
			case 3:			
				sql	+= "WHERE b_content LIKE ?		\n"
				    +  "ORDER BY ROWNUM desc		\n"
				    +  "LIMIT ?,?					\n";
		       	pstmt = conn.prepareStatement(sql);
		       	pstmt.setString(1, keyword);
		       	pstmt.setInt(2, pageNum);
		       	pstmt.setInt(3, pagination.getPerPage());
				break;
			case 4:			
				sql	+= "WHERE b_title LIKE ?		\n"
					+  "OR    b_content LIKE ? 		\n"	
					+  "ORDER BY ROWNUM desc		\n"
					+  "LIMIT ?,?					\n";	
		       	pstmt = conn.prepareStatement(sql);
		       	pstmt.setString(1, keyword);
		       	pstmt.setString(2, keyword);
		       	pstmt.setInt(3, pageNum);
		       	pstmt.setInt(4, pagination.getPerPage());
				break;
			case 5:			
				sql += "INNER JOIN user tb	 		\n"
					+  "ON ta.u_idx = tb.u_idx		\n"
					+  "WHERE tb.u_name LIKE ?		\n"
					+  "ORDER BY ROWNUM desc		\n"
				    +  "LIMIT ?,?					\n";
		       	pstmt = conn.prepareStatement(sql);
		       	pstmt.setString(1, keyword);
		       	pstmt.setInt(2, pageNum);
		       	pstmt.setInt(3, pagination.getPerPage());
				break;
			default:
				sql += "ORDER BY ROWNUM desc		\n"
				    +  "LIMIT ?,?					\n";
		       	pstmt = conn.prepareStatement(sql);
		       	pstmt.setInt(1, pageNum);
		       	pstmt.setInt(2, pagination.getPerPage());
				break;
			}
				
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
	        	board.setB_group(rs.getInt("b_group"));
	        	board.setB_order(rs.getInt("b_order"));
	        	board.setB_depth(rs.getInt("b_depth"));
       	       	list.add(board);
	        }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if(rs!=null) rs.close();
				if(pstmt!=null) pstmt.close();
				if(conn!=null) conn.close();
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
			String sql = "insert into board (b_title, b_content, b_date, u_idx, b_group, b_order, b_depth) values (?,?,now(),?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			User user = board.getUser();
			pstmt.setInt(3, user.getU_idx());
			pstmt.setInt(4, 0);
			pstmt.setInt(5, 1);
			pstmt.setInt(6, 0);
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) {
					pstmt.close();
					
					pstmt = conn.prepareStatement("update board set b_group = last_insert_id() where b_idx = last_insert_id()");
					pstmt.executeUpdate();
					pstmt.close();
				}	
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
	        	row.setB_group(rs.getInt("b_group"));
	        	row.setB_order(rs.getInt("b_order"));
	        	row.setB_depth(rs.getInt("b_depth"));
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
			String sql = "update board set b_title = ?, b_content = ? where b_idx = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			pstmt.setInt(3, board.getB_idx());
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

	public int getBoardCount(Search search) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		int type = search.getSearchType();
		String keyword = search.getKeyword();
		
		try {
			conn = DBConnection.getConnection();
			String sql = "select count(*) count from board ta	\n";
			if(type==2) {
				sql += "WHERE b_title = ?	\n";
			}else if(type==3) {
				sql += "WHERE b_content = ?	\n";
			}else if(type==4) {
				sql += "WHERE b_title = ? OR b_content = ?	\n";
			}else if(type==5) {
				sql += "INNER JOIN user tb	 		\n"
					+  "ON ta.u_idx = tb.u_idx		\n"
					+  "WHERE tb.u_name LIKE ?		\n";
			}
	       	pstmt = conn.prepareStatement(sql);
	       	if(type!=1)
	       		pstmt.setString(1, keyword);
	       	if(type==4)
	       		pstmt.setString(2, keyword);
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

	public Board replyBoard(Board board) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		Board reply = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "update board set b_order = b_order+1 where b_group = ? and b_order > ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, board.getB_group());
			pstmt.setInt(2, board.getB_order());
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
		
		try {
			conn = DBConnection.getConnection();
			String sql = "insert into board (b_title, b_content, b_date, u_idx, b_group, b_order, b_depth) values (?, ?, now(), ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, board.getB_title());
			pstmt.setString(2, board.getB_content());
			User user = board.getUser();
			pstmt.setInt(3, user.getU_idx());
			pstmt.setInt(4, board.getB_group());
			pstmt.setInt(5, board.getB_order()+1);
			pstmt.setInt(6, board.getB_depth()+1);
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
				
		try {
			conn = DBConnection.getConnection();
			String sql = "select * from board where b_group=? and b_order=1";
	       	pstmt = conn.prepareStatement(sql);
	       	pstmt.setInt(1, board.getB_group());
	        rs = pstmt.executeQuery();

	        while(rs.next()){     
	        	reply = new Board();
	        	reply.setB_idx(rs.getInt("b_idx"));
	        	reply.setB_title(rs.getString("b_title"));
	        	reply.setB_content(rs.getString("b_content"));
	        	reply.setB_views(rs.getInt("b_views"));
	        	Date date = new Date();
	        	date.setTime(rs.getTimestamp("b_date").getTime());
	        	reply.setB_date(date);
	        	User user = new User();
	        	user.setU_idx(rs.getInt("u_idx"));
	        	reply.setUser(user);
	        	reply.setB_group(rs.getInt("b_group"));
	        	reply.setB_order(rs.getInt("b_order"));
	        	reply.setB_depth(rs.getInt("b_depth"));
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
		return reply;
		
	}

	public void commentInsert(Comment comment) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql= "insert into comment	\n"
					+	"(c_content, c_date, b_idx, u_idx, c_group, c_order, c_depth)	\n"
					+	"values	\n"
					+	"(?, now(), ?, ?, ?, ?, ?)	\n";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getC_content());
			pstmt.setInt(2, comment.getB_idx());
			pstmt.setInt(3, comment.getUser().getU_idx());
			pstmt.setInt(4, 0);
			pstmt.setInt(5, 1);
			pstmt.setInt(6, 0);
			pstmt.executeUpdate();
		}catch (Exception ex) {
			ex.printStackTrace();
		}finally {
			try {
				if(pstmt!= null) {
					pstmt.close();
					
					pstmt = conn.prepareStatement("update comment set c_group = last_insert_id() where c_idx = last_insert_id()");
					pstmt.executeUpdate();
					pstmt.close();
				}	
				if(conn!= null) conn.close();
			}catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

	public ArrayList<Comment> getCommentList(Board board, Pagination pagination) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Comment> list = null;
		int pageNum = pagination.getPageNum();
		try {
			conn = DBConnection.getConnection();
			String sql = "SELECT ROW_NUMBER() OVER(ORDER BY c_group asc, c_order desc) AS ROWNUM, \n"
					   + "		ta.*				\n"
					   + "FROM comment ta 			\n"
					   + "WHERE b_idx = ?			\n"
					   + "ORDER BY ROWNUM desc		\n"
					   + "LIMIT ?,?					\n";
	       	pstmt = conn.prepareStatement(sql);
	       	pstmt.setInt(1, board.getB_idx());
	       	pstmt.setInt(2, pageNum);
	       	pstmt.setInt(3, pagination.getPerPage());
	        rs = pstmt.executeQuery();
	        list = new ArrayList<Comment>();

	        while(rs.next()){
	        	
       	       	Comment c = new Comment();
       	       	Date date = new Date();
	        	date.setTime(rs.getTimestamp("c_date").getTime());
	        	User user = new User();
	        	UserService userService = UserService.getInstance();
	        	user.setU_idx(rs.getInt("u_idx"));
        		user = userService.detailUser(user);  
        		
       	       	c.setRownum(rs.getInt("ROWNUM"));
       	       	c.setC_idx(rs.getInt("c_idx"));
       	       	c.setC_content(rs.getString("c_content"));
       	       	c.setC_date(date);
       	       	c.setB_idx(rs.getInt("b_idx"));
        		c.setUser(user);
        		c.setC_group(rs.getInt("c_group"));
        		c.setC_order(rs.getInt("c_order"));
        		c.setC_depth(rs.getInt("c_depth"));
        		list.add(c);
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

	public int getCommentCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "select count(*) count from comment";
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

	public void commentReply(Comment comment) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql = "update comment set c_order = c_order+1 where c_group = ? and c_order > ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment.getC_group());
			pstmt.setInt(2, comment.getC_order());
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
		
		try {
			conn = DBConnection.getConnection();
			String sql= "insert into comment	\n"
					+	"(c_content, c_date, b_idx, u_idx, c_group, c_order, c_depth)	\n"
					+	"values	\n"
					+	"(?, now(), ?, ?, ?, ?, ?)	\n";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getC_content());
			pstmt.setInt(2, comment.getB_idx());
			pstmt.setInt(3, comment.getUser().getU_idx());
			pstmt.setInt(4, comment.getC_group());
			pstmt.setInt(5, comment.getC_order()+1);
			pstmt.setInt(6, comment.getC_depth()+1);
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

	public void commentEdit(Comment comment) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql ="update comment set	\n"
					+	"c_content = ? where c_idx = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, comment.getC_content());
			pstmt.setInt(2, comment.getC_idx());
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

	public void commentDelete(Comment comment) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		try {
			conn = DBConnection.getConnection();
			String sql ="delete from comment	\n"
					+	"where c_idx = ? ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment.getC_idx());
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

}
