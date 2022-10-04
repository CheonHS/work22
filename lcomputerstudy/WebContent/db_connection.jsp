<%@ page import="java.sql.*" %>

<%
	Connection conn = null;

	String url = "jdbc:mariadb://localhost:3306/work22";
	String user ="root";
	String dbPassword="1234";
	
	Class.forName("org.mariadb.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, dbPassword);

%>

