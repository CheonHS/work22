package com.lcomputerstudy.testmvc.service;

import java.util.ArrayList;
import com.lcomputerstudy.testmvc.dao.BoardDAO;
import com.lcomputerstudy.testmvc.vo.Board;
import com.lcomputerstudy.testmvc.vo.Pagination;


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

	public ArrayList<Board> getBoardList(Pagination pagination) {
		return dao.getBoardList(pagination);
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
		return dao.getUserCount();
	}

}
