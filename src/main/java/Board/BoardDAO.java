package Board;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BoardDAO {
    private String url = "jdbc:mysql://localhost:3306/start_db";
    private String user = "root";
    private String password = "123456";

    public BoardDAO() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public void createBoard(String userId, String title, String content) {
        String sql = "INSERT INTO board (user_id, title, content) VALUES (?, ?, ?)";
        try (
            Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, userId);
            pstmt.setString(2, title);
            pstmt.setString(3, content);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 사용자가 작성한 총 게시물 수를 가져오는 메서드
    public int getBoardCount(String userId) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM board WHERE user_id = ?";
        try (
            Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    // 사용자가 작성한 게시물들이 받은 총 좋아요 수를 가져오는 메서드
    public int getTotalLikeCount(String userId) {
        int totalLikes = 0;
        String sql = "SELECT SUM(like_count) FROM board WHERE user_id = ?";
        try (
            Connection conn = DriverManager.getConnection(url, user, password);
            PreparedStatement pstmt = conn.prepareStatement(sql);
        ) {
            pstmt.setString(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                totalLikes = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalLikes;
    }
}
