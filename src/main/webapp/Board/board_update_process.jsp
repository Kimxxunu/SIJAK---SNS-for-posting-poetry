<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    } else {
        response.sendRedirect("../Login/login_page.jsp");
        return;
    }

    int postId = Integer.parseInt(request.getParameter("postId"));
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:mysql://localhost:3306/start_db";
        String user = "root";
        String password = "123456";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String updateQuery = "UPDATE board SET title = ?, content = ? WHERE id = ?";
        pstmt = conn.prepareStatement(updateQuery);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        pstmt.setInt(3, postId);

        int result = pstmt.executeUpdate();
        if (result > 0) {
            response.sendRedirect("../Profile/profile.jsp");
        } else {
            out.println("게시물 수정에 실패했습니다.");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
