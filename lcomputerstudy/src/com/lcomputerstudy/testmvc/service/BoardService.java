package com.lcomputerstudy.testmvc.service;

import java.util.ArrayList;
import com.lcomputerstudy.testmvc.dao.BoardDAO;
import com.lcomputerstudy.testmvc.vo.Board;
import com.lcomputerstudy.testmvc.vo.Comment;
import com.lcomputerstudy.testmvc.vo.Pagination;
import com.lcomputerstudy.testmvc.vo.Search;


public class BoardService {
	private static BoardService service = null;
	private static BoardDAO dao = null;
    
	private BoardService() {
		
	}

	public static BoardService getInstance() {
		if(service == null) {
			service = new BoardService();
			dao = BoardDAO.getInstance();
		}
		return service;
	}

	public ArrayList<Board> getBoardList(Pagination pagination, Search search) {
		return dao.getBoardList(pagination, search);
	}
	
	public void writeBoard(Board board) {
		dao.writeBoard(board);
	}

	public Board detailBoard(Board board) {
		return dao.detailBoard(board);
		
	}

	public void deleteBoard(Board board) {
		dao.deleteBoard(board);
		
	}

	public void editBoard(Board board) {
		dao.editBoard(board);
		
	}

	public int getBoardsCount() {
		return dao.getBoardCount();
	}

	public Board replyBoard(Board board) {
		return dao.replyBoard(board);
		
	}

	public void commentInsert(Comment comment) {
		dao.commentInsert(comment);
		
	}

	public ArrayList<Comment> getCommentList(Board board, Pagination pagination) {
		return dao.getCommentList(board, pagination);
	}

	public int getCommentCount() {
		return dao.getCommentCount();
	}

	public void commentReply(Comment comment) {
		dao.commentReply(comment);
		
	}

	public void commentEdit(Comment comment) {
		dao.commentEdit(comment);
		
	}

	public void commentDelete(Comment comment) {
		dao.commentDelete(comment);
		
	}

}
