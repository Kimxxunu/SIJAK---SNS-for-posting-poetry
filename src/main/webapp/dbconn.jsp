<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "java.sql.*"%>

<% 
	Connection conn = null;
	
	String url = "jdbc:mysql://localhost:3306/start_db";
	String user = "root";
	String password = "123456";
	
	Class.forName("com.mysql.jdbc.Driver");
	conn = DriverManager.getConnection(url, user, password);
 %>

