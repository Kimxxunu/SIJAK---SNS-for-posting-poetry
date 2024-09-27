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
    String title = null;
    String content = null;

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String url = "jdbc:mysql://localhost:3306/start_db";
        String user = "root";
        String password = "123456";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);

        String postQuery = "SELECT title, content FROM board WHERE id = ?";
        pstmt = conn.prepareStatement(postQuery);
        pstmt.setInt(1, postId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            content = rs.getString("content");
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

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>시작</title>
<link rel="stylesheet" href="board_create.css" type="text/css" />
<link rel="stylesheet" href="../Header/header.css" type="text/css" />
</head>

<body>




    <div class="Board_Create_Page">
        <div class="Board_Create_Page-Header">
            <p>새 게시물</p>
        </div>
        <div class="Board_Create_Page-Body">
            <form class="Board_Create_Page-Body-Form" action="board_update_process.jsp" method="post">
            	<input type="hidden" name="postId" value="<%= postId %>">
            	
            	<input type="text" class="Board_Create_Page-Body-Form-Title" name="title" value="<%= title %>" required>
                
                <textarea placeholder="내용" class="Board_Create_Page-Body-Form-content" name="content" required><%= content %></textarea>
                
                
                <div class="Board_Create_Page-Body-Form-CallGPT">
                    <a href="./board_GPT.jsp"> GPT 3.5와 같이 쓰기 🤖</a>
                </div>
                <div class="ButtonWrap">
	                <input type="submit" value="수정완료" class="Board_Create_Page-Body-Form-Submit2">
                
    	            <a href="./board_delete_process.jsp?postId=<%= postId %>" class="Board_Create_Page-Body-Form-Submit3">삭제하기</a>
    	            
    	          
                </div>
            </form>
        </div>
        
    </div>
    <script>
        // 페이지 로드 시 로컬 스토리지에서 제목과 내용을 불러옴
        document.addEventListener('DOMContentLoaded', () => {
            const title = localStorage.getItem('gptTitle');
            const content = localStorage.getItem('gptContent');
            if (title) {
                document.querySelector('.Board_Create_Page-Body-Form-Title').value = title;
            }
            if (content) {
                document.querySelector('.Board_Create_Page-Body-Form-content').value = content;
            }
        });
    </script>
    <%-- Include header --%>
        <jsp:include page="../Header/header.jsp"></jsp:include>
</body>

</html>
