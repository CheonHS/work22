package com.lcomputerstudy.testmvc.controller;

import java.io.IOException;
import java.util.ArrayList;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lcomputerstudy.testmvc.service.BoardService;
import com.lcomputerstudy.testmvc.service.UserService;
import com.lcomputerstudy.testmvc.vo.Board;
import com.lcomputerstudy.testmvc.vo.Comment;
import com.lcomputerstudy.testmvc.vo.Pagination;
import com.lcomputerstudy.testmvc.vo.Search;
import com.lcomputerstudy.testmvc.vo.User;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("*.do")
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html; charset=utf-8");

		String requestURI = request.getRequestURI();	//	/lcomputerstudy/*.do
		String contextPath = request.getContextPath();	//	/lcomputerstudy
		String command = requestURI.substring(contextPath.length());
		String view = null;
		
		int count = 0;
		int page = 1;
		
		String idx = null;
		String pw = null;
		
		HttpSession session = null;
		
		command = checkSession(request, response, command);
		
		response.setContentType("text/html; charset=utf-8");
		request.setCharacterEncoding("utf-8");
		
		switch (command) {
			case "/user-list.do":
				String reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				UserService userService = UserService.getInstance();
				count = userService.getUsersCount();
				
				Pagination pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();
				
				ArrayList<User> list = userService.getUsers(pagination);
			
				view = "user/list";
				request.setAttribute("list", list);
				request.setAttribute("pagination", pagination);
				break;
			case "/user-insert.do":
				view = "user/insert";
				break;
			case "/user-insert-process.do":
				User user = new User();
				user.setU_id(request.getParameter("id"));
				user.setU_pw(request.getParameter("password"));
				user.setU_name(request.getParameter("name"));
				user.setU_tel(request.getParameter("tel1") + "-" + request.getParameter("tel2") + "-" + request.getParameter("tel3"));
				user.setU_age(request.getParameter("age"));
				
				userService = UserService.getInstance();
				userService.insertUser(user);
				view = "user/insert-result";
				break;
			case "/user-detail.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				userService = UserService.getInstance();
				user = userService.detailUser(user);
				view = "user/detail";
				request.setAttribute("user", user);
				break;
			case "/user-edit.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				userService = UserService.getInstance();
				user = userService.detailUser(user);
				view = "user/edit";
				request.setAttribute("user", user);
				break;
				
			case "/user-edit-process.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				user.setU_id(request.getParameter("edit_id"));
				user.setU_pw(request.getParameter("edit_password"));
				user.setU_name(request.getParameter("edit_name"));
				user.setU_tel(request.getParameter("edit_tel1") + "-" + request.getParameter("edit_tel2")+ "-" + request.getParameter("edit_tel3"));
				user.setU_age(request.getParameter("edit_age"));
				userService = UserService.getInstance();
				userService.editUser(user);
				view = "user/edit-result";
				break;
			case "/user-delete.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				userService = UserService.getInstance();
				userService.deleteUser(user);
				view = "user/delete-result";
				break;
			case "/user-level.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				user.setU_level(Integer.parseInt(request.getParameter("u_level")));
				userService = UserService.getInstance();
				userService.setUserLevel(user);
				
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				userService = UserService.getInstance();
				count = userService.getUsersCount();
				
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();
				
				list = userService.getUsers(pagination);
				
				view = "user/aj-user-list";
				request.setAttribute("list", list);
				request.setAttribute("pagination", pagination);
				break;
			/* login */
			case "/user-login.do":
				view = "user/login";
				break;
			case "/user-login-process.do":
				idx = request.getParameter("login_id");
				pw = request.getParameter("login_password");
				
				userService = UserService.getInstance();
				user = userService.loginUser(idx,pw);
							
				if(user != null) {
					session = request.getSession();
					session.setAttribute("user", user);

					view = "user/login-result";
				} else {
					view = "user/login-fail";
				}			
				break;
			case "/logout.do" :
				session = request.getSession();
				session.invalidate();
				view = "user/login";
				break;
			case "/access-denied.do":
				view = "user/access-denied";
				break;
			case "/login-view.do":
				session = request.getSession();
				user = (User) session.getAttribute("user");
				session.setAttribute("user", user);
				view = "user/login-result";
				break;
				
			/* board */	
			case "/board-list.do":
				Search search = new Search();
				if(request.getParameter("searchType")!=null&&request.getParameter("searchType")!="") {
					search.setSearchType(Integer.parseInt(request.getParameter("searchType")));
				}else {
					search.setSearchType(1);
				}
				search.setKeyword(request.getParameter("keyword"));
				
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				BoardService boardService = BoardService.getInstance();
				count = boardService.getBoardsCount(search);
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();
				pagination.setSearch(search);
				
				ArrayList<Board> boardlist=null;
				boardlist = boardService.getBoardList(pagination);
				
				for(Board i : boardlist) {
					user = i.getUser();
					userService = UserService.getInstance();
					user = userService.detailUser(user);
					i.setUser(user);
				}

				view = "board/list";
				request.setAttribute("search", search);
				request.setAttribute("boardlist", boardlist);
				request.setAttribute("pagination", pagination);
				break;
				
			case "/board-write.do":
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				view = "board/write";
				request.setAttribute("user", user);
				break;
			case "/board-write-process.do":
				MultipartRequest multi = fileUpload(request);
				user = new User();
//				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				user.setU_idx(Integer.parseInt(multi.getParameter("u_idx")));
				
				Board board = new Board();
				board.setUser(user);
//				board.setB_title(request.getParameter("title"));
//				board.setB_content(request.getParameter("content"));
				board.setB_title(multi.getParameter("title"));
				board.setB_content(multi.getParameter("content"));
				if(multi.getFilesystemName("filename")!=null) {
					board.setB_filename(multi.getFilesystemName("filename"));
				}else {
					board.setB_filename("");
				}
				
				boardService = BoardService.getInstance();
				boardService.writeBoard(board);
				
				view = "board/write-result";
				break;
			case "/board-detail.do":
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				boardService = BoardService.getInstance();
				board = boardService.detailBoard(board);
				userService = UserService.getInstance();
				board.setUser(userService.detailUser(board.getUser()));
				
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				count = boardService.getCommentCount(); 
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();
				ArrayList<Comment> commentlist = boardService.getCommentList(board, pagination);
				
				view = "board/detail";
				request.setAttribute("board", board);
				request.setAttribute("commentlist", commentlist);
				
				break;
			case "/board-edit.do":
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				boardService = BoardService.getInstance();
				board = boardService.detailBoard(board);
				session = request.getSession();
				user = (User) session.getAttribute("user");
				view = "board/edit";
				request.setAttribute("board", board);
				if(board.getUser().getU_idx()!=user.getU_idx()) {
					view = "board/board-access-denied";
				}
				break;
			case "/board-edit-process.do":
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				board.setB_title(request.getParameter("title"));
				board.setB_content(request.getParameter("content"));
				boardService = BoardService.getInstance();
				boardService.editBoard(board);	
				board = boardService.detailBoard(board);
				view = "board/detail";
				request.setAttribute("board", board);
				break;
			case "/board-delete.do":
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				boardService = BoardService.getInstance();
				
				session = request.getSession();
				User loginUser = (User) session.getAttribute("user");
				User boardUser = boardService.detailBoard(board).getUser();
				if(loginUser.getU_idx()!=boardUser.getU_idx()) {
					view = "board/board-access-denied";
					break;
				}
				
				boardService.deleteBoard(board);
				view = "board/delete-result";							
				break;	
				
			case "/board-reply.do":
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				boardService = BoardService.getInstance();
				board = boardService.detailBoard(board);
				request.setAttribute("board", board);
				view = "board/reply";
				break;
			case "/board-reply-process.do":
				board = new Board();
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				board.setUser(user);
				board.setB_title(request.getParameter("title"));
				board.setB_content(request.getParameter("content"));
				board.setB_group(Integer.parseInt(request.getParameter("b_group")));
				board.setB_order(Integer.parseInt(request.getParameter("b_order")));
				board.setB_depth(Integer.parseInt(request.getParameter("b_depth")));
				
				boardService = BoardService.getInstance();
				board = boardService.replyBoard(board);
				view = "board/detail";
				request.setAttribute("board", board);
				break;
				
			/* comment */
			case "/comment-insert.do":
				Comment comment = new Comment();
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				comment.setUser(user);
				
				boardService = BoardService.getInstance();
				boardService.commentInsert(comment);
				
				view = "board/comment-result";
				request.setAttribute("comment", comment);
				break;
			case "/comment-reply.do":	
				comment = new Comment();
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));
				comment.setUser(user);
				comment.setC_group(Integer.parseInt(request.getParameter("c_group")));
				comment.setC_order(Integer.parseInt(request.getParameter("c_order")));
				comment.setC_depth(Integer.parseInt(request.getParameter("c_depth")));
				
				boardService = BoardService.getInstance();
				boardService.commentReply(comment);
				
				view = "board/comment-result";
				request.setAttribute("comment", comment);
				break;
			case "/comment-edit.do":
				session = request.getSession();
				loginUser = (User) session.getAttribute("user");
				
				comment = new Comment();
				comment.setC_idx(Integer.parseInt(request.getParameter("c_idx")));
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));

				boardService = BoardService.getInstance();
				boardService.commentEdit(comment);
				
				view = "board/comment-result";
				request.setAttribute("comment", comment);
				break;
			case "/comment-delete.do":
				comment = new Comment();
				comment.setC_idx(Integer.parseInt(request.getParameter("c_idx")));
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				
				boardService = BoardService.getInstance();
				boardService.commentDelete(comment);
				
				view = "board/comment-result";
				request.setAttribute("comment", comment);
				break;
				
			/* ajax-comment */
			case "/aj-insert-comment.do":
				comment = new Comment();
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				comment.setUser(user);
				
				boardService = BoardService.getInstance();
				boardService.commentInsert(comment);
				
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				board = boardService.detailBoard(board);
				userService = UserService.getInstance();
				board.setUser(userService.detailUser(board.getUser()));
				
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				count = boardService.getCommentCount(); 
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();

				commentlist = boardService.getCommentList(board, pagination);
				
				view = "board/aj-comment-list";
				request.setAttribute("board", board);
				request.setAttribute("commentlist", commentlist);
				break;
			case "/aj-reply-comment.do":
				comment = new Comment();
				user = new User();
				user.setU_idx(Integer.parseInt(request.getParameter("u_idx")));
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));
				comment.setUser(user);
				comment.setC_group(Integer.parseInt(request.getParameter("c_group")));
				comment.setC_order(Integer.parseInt(request.getParameter("c_order")));
				comment.setC_depth(Integer.parseInt(request.getParameter("c_depth")));
				
				boardService = BoardService.getInstance();
				boardService.commentReply(comment);
						
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				board = boardService.detailBoard(board);
				userService = UserService.getInstance();
				board.setUser(userService.detailUser(board.getUser()));
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				count = boardService.getCommentCount(); 
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();

				commentlist = boardService.getCommentList(board, pagination);
				
				view = "board/aj-comment-list";
				request.setAttribute("board", board);
				request.setAttribute("commentlist", commentlist);
				break;
			case "/aj-edit-comment.do":
				comment = new Comment();
				comment.setC_idx(Integer.parseInt(request.getParameter("c_idx")));
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				comment.setC_content(request.getParameter("c_content"));

				boardService = BoardService.getInstance();
				boardService.commentEdit(comment);
				
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				board = boardService.detailBoard(board);
				userService = UserService.getInstance();
				board.setUser(userService.detailUser(board.getUser()));
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				count = boardService.getCommentCount(); 
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();

				commentlist = boardService.getCommentList(board, pagination);
				
				view = "board/aj-comment-list";
				request.setAttribute("board", board);
				request.setAttribute("commentlist", commentlist);
				break;
			case "/aj-del-comment.do":
				comment = new Comment();
				comment.setC_idx(Integer.parseInt(request.getParameter("c_idx")));
				comment.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				
				boardService = BoardService.getInstance();
				boardService.commentDelete(comment);
				
				board = new Board();
				board.setB_idx(Integer.parseInt(request.getParameter("b_idx")));
				board = boardService.detailBoard(board);
				userService = UserService.getInstance();
				board.setUser(userService.detailUser(board.getUser()));
				reqPage = request.getParameter("page");
				if (reqPage != null) { 
					page = Integer.parseInt(reqPage);
				}
				count = boardService.getCommentCount(); 
				pagination = new Pagination();
				pagination.setPage(page);
				pagination.setCount(count);
				pagination.init();

				commentlist = boardService.getCommentList(board, pagination);
				
				view = "board/aj-comment-list";
				request.setAttribute("board", board);
				request.setAttribute("commentlist", commentlist);
				break;
		}
		
		RequestDispatcher rd = request.getRequestDispatcher(view+".jsp");
		rd.forward(request, response);
	}
	String checkSession(HttpServletRequest request, HttpServletResponse response, String command) {
		HttpSession session = request.getSession();
		
		String[] authList = {
				"/user-list.do"
				,"/user-insert.do"
				,"/user-insert-process.do"
				,"/user-detail.do"
				,"/user-edit.do"
				,"/user-edit-process.do"
				,"/logout.do"
				,"/login-view.do"
				
				,"/board-write.do"
				,"/board-write-process.do"
				,"/board-edit.do"
				,"/board-edit-process.do"
				,"/board-delete.do"
				,"/board-reply.do"
				,"/board-reply-process.do"
				
				,"/comment-insert.do"
				,"/aj-insert-comment.do"
			};
		
		for (String item : authList) {
			if (item.equals(command)) {
				if (session.getAttribute("user") == null) {
					command = "/access-denied.do";
				}
			}
		}
		return command;
	}
	MultipartRequest fileUpload(HttpServletRequest request) {
		String path = request.getServletContext().getRealPath("/fileupload");
//		System.out.println(path);
		
		int size = 1024 * 1024 * 80;
		MultipartRequest multi = null;
		try {
			multi = new MultipartRequest(
					request, path, size, "UTF-8",
					new DefaultFileRenamePolicy()
				);
		}catch (Exception e) {
			e.printStackTrace();
		}

		return multi;
	}
	
}
