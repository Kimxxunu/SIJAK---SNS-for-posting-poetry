package Comment;


import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Connection;
import java.sql.PreparedStatement;
import Database.DatabaseConnection;

@WebServlet("/Main/Comment/SubmitCommentServlet")
public class SubmitCommentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String boardId = request.getParameter("boardId");
        String content = request.getParameter("content");
        String userId = (String) request.getSession().getAttribute("userID");

        if (userId != null && !content.trim().isEmpty()) {
            try (Connection conn = DatabaseConnection.getConnection()) {
                String sql = "INSERT INTO comment (user_id, poetry_id, content, create_date) VALUES (?, ?, ?, NOW())";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, userId);
                pstmt.setString(2, boardId);
                pstmt.setString(3, content);
                pstmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "댓글 작성 중 오류가 발생했습니다.");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "댓글 작성에 필요한 데이터가 부족합니다.");
        }
    }
}
