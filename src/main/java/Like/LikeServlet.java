package Like;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/Main/LikeServlet")
public class LikeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private LikeDAO likeDAO;
    private Connection conn;

    public void init() {
        // JDBC 연결 설정
        String url = "jdbc:mysql://localhost:3306/start_db?useSSL=false&serverTimezone=UTC";
        String user = "root";
        String password = "123456";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, user, password);
            likeDAO = new LikeDAO(conn);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false); // 세션이 없으면 새로 생성하지 않음
        if (session == null || session.getAttribute("userID") == null) {
            out.println("로그인이 필요합니다.");
            return;
        }

        String action = request.getParameter("action");
        String userId = (String) session.getAttribute("userID");
        int boardId = Integer.parseInt(request.getParameter("boardId"));

        boolean success = false;

        if ("like".equals(action)) {
            success = likeDAO.addLike(userId, boardId);
        } else if ("unlike".equals(action)) {
            success = likeDAO.removeLike(userId, boardId);
        }

        if (success) {
            try {
                String likeCountQuery = "SELECT like_count FROM board WHERE id = ?";
                PreparedStatement pstmt = conn.prepareStatement(likeCountQuery);
                pstmt.setInt(1, boardId);
                ResultSet rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    int likeCount = rs.getInt("like_count");
                    out.println(likeCount); // 좋아요 수 반환
                } else {
                    out.println("좋아요 수 조회 중 오류 발생");
                }

                rs.close();
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("좋아요 수 조회 중 오류 발생");
            }
        } else {
            out.println("좋아요 처리 중 오류 발생");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    public void destroy() {
        // 리소스 정리
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
