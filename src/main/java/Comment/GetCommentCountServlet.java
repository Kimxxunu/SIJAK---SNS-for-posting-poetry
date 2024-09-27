package Comment;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/Comment/GetCommentCountServlet")
public class GetCommentCountServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int boardId = Integer.parseInt(request.getParameter("boardId"));
        
        // 이 부분에서 데이터베이스에서 댓글 수를 가져오는 로직을 구현
        int commentCount = getCommentCountFromDatabase(boardId);
        
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(String.valueOf(commentCount));
    }
    
    // 데이터베이스에서 댓글 수를 가져오는 메서드 예시
    private int getCommentCountFromDatabase(int boardId) {
        int commentCount = 0;
        // 여기에 데이터베이스 쿼리를 통해 댓글 수를 가져오는 로직을 구현
        // 예를 들어, Comment 테이블에서 해당 게시물(boardId)의 댓글 수를 카운트하여 반환
        
        return commentCount;
    }
}
