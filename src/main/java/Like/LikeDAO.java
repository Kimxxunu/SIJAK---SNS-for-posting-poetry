package Like;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LikeDAO {
    private Connection conn;

    public LikeDAO(Connection conn) {
        this.conn = conn;
    }
    // 좋아요 여부 확인 메서드
    public boolean checkIfLiked(String userId, int boardId) {
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT COUNT(*) AS count FROM `like` WHERE user_id = ? AND board_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, boardId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt("count");
                return count > 0;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 좋아요 추가 메서드
    public boolean addLike(String userId, int boardId) {
        PreparedStatement pstmt = null;
        try {
            String sql = "INSERT INTO `like` (user_id, board_id) VALUES (?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, boardId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                // 좋아요 추가 후 board 테이블의 like_count 증가
                updateLikeCount(boardId, 1);
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 좋아요 삭제 메서드
    public boolean removeLike(String userId, int boardId) {
        PreparedStatement pstmt = null;
        try {
            String sql = "DELETE FROM `like` WHERE user_id = ? AND board_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setInt(2, boardId);
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                // 좋아요 삭제 후 board 테이블의 like_count 감소
                updateLikeCount(boardId, -1);
                return true;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // board 테이블의 like_count 업데이트 메서드
    private void updateLikeCount(int boardId, int delta) {
        PreparedStatement pstmt = null;
        try {
            String sql = "UPDATE board SET like_count = like_count + ? WHERE id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, delta);
            pstmt.setInt(2, boardId);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
