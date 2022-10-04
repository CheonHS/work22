package com.lcomputerstudy.testmvc.service;

import java.util.ArrayList;
import com.lcomputerstudy.testmvc.dao.UserDAO;
import com.lcomputerstudy.testmvc.vo.Pagination;
import com.lcomputerstudy.testmvc.vo.User;

public class UserService {
	
	private static UserService service = null;
	private static UserDAO dao = null;
    
	private UserService() {
		
	}

	public static UserService getInstance() {
		if(service == null) {
			service = new UserService();
			dao = UserDAO.getInstance();
		}
		return service;
	}

	public ArrayList<User> getUsers(Pagination pagination) {
		return dao.getUsers(pagination);
	}
	public void insertUser(User user) {
		dao.insertUser(user);
	}
	public User detailUser(User user) {
		return dao.detailUser(user);	
	}
	public void editUser(User user) {
		dao.editUser(user);		
	}
	public void deleteUser(User user) {
		dao.deleteUser(user);		
		
	}

	public int getUsersCount() {
		return dao.getUserCount();
	}

	public User loginUser(String idx, String pw) {
		return dao.loginUser(idx,pw);
	}
}