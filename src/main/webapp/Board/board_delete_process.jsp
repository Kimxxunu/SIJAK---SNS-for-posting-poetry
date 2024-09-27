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

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String url = "jdbc:mysql://localhost:3306/start_db";
        String user = "root";
        String password = "123456";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        // 댓글 삭제
        String deleteCommentsQuery = "DELETE FROM comment WHERE poetry_id = ?";
        pstmt = conn.prepareStatement(deleteCommentsQuery);
        pstmt.setInt(1, postId);
        pstmt.executeUpdate();
        pstmt.close();

        // 좋아요 삭제
        String deleteLikesQuery = "DELETE FROM `like` WHERE board_id = ?";
        pstmt = conn.prepareStatement(deleteLikesQuery);
        pstmt.setInt(1, postId);
        pstmt.executeUpdate();
        pstmt.close();

        // 게시물 삭제
        String deletePostQuery = "DELETE FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(deletePostQuery);
        pstmt.setInt(1, postId);
        
        int result = pstmt.executeUpdate();
        if (result > 0) {
            response.sendRedirect("../Profile/profile.jsp");
        } else {
            out.println("게시물 삭제에 실패했습니다.");
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
