<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="User.UserDAO, User.UserEntity"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="Like.LikeDAO, Like.LikeBean"%>

<%
// 현재 로그인된 사용자의 아이디 확인
String userID = null;
if (session.getAttribute("userID") != null) {
    userID = (String) session.getAttribute("userID");
} else {
    // 로그인 되어 있지 않으면 로그인 페이지로 이동
    response.sendRedirect("../Login/login_page.jsp");
}

//사용자가 입력한 정보 가져오기
String name = request.getParameter("name");
String phoneNumber = request.getParameter("phoneNumber");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

//데이터베이스 연결 및 사용자 정보 업데이트
Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
 String url = "jdbc:mysql://localhost:3306/start_db";
 String dbUser = "root";
 String dbPassword = "123456";
 Class.forName("com.mysql.cj.jdbc.Driver");
 conn = DriverManager.getConnection(url, dbUser, dbPassword);

 // UserDAO 객체 생성
 UserDAO userDao = new UserDAO();

 // 기존 사용자 정보 가져오기
 UserEntity user = userDao.getUserByID(userID);

 // 새로운 정보 설정
 user.setName(name);
 user.setPhoneNumber(phoneNumber);

 // 새 비밀번호가 입력된 경우에만 비밀번호 업데이트
 if (!newPassword.isEmpty() && !confirmPassword.isEmpty() && newPassword.equals(confirmPassword)) {
     user.setPassword(newPassword);
 }

 // 프로필 정보 업데이트
 int result = userDao.updateProfile(user);

 if (result == 1) {
     // 업데이트 성공
     response.sendRedirect("profile.jsp"); // 프로필 페이지로 리다이렉트
 } else {
     // 업데이트 실패
     out.println("<script>alert('프로필 업데이트에 실패했습니다.');</script>");
 }

} catch (Exception e) {
 e.printStackTrace();
} finally {
 try {
     if (rs != null) rs.close();
     if (pstmt != null) pstmt.close();
     if (conn != null) conn.close();
 } catch (SQLException e) {
     e.printStackTrace();
 }
}
%>
