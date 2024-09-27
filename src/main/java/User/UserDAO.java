package User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public UserDAO() {
        try {
            String url = "jdbc:mysql://localhost:3306/start_db";
        	String user = "root";
        	String password = "123456";
        	Class.forName("com.mysql.cj.jdbc.Driver");
        	conn = DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int login(String userID, String userPassword) {
        String SQL = "SELECT password FROM User WHERE userid = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                if (rs.getString(1).equals(userPassword)) {
                    return 1; // 로그인 성공
                } else {
                    return 0; // 비밀번호 불일치
                }
            }
            System.out.println(userID);
            return -1; // 아이디 불일치
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -2; // DB 오류
    }
    
    public int join(UserEntity user) {
        String SQL = "INSERT INTO User (userid, password, name, phoneNumber) VALUES (?, ?, ?, ?)";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, user.getUserid());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getPhoneNumber());
            System.out.println("PreparedStatement executed: " + pstmt.toString());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 오류가 발생하면 -1 리턴
    }
    
    public UserEntity getUserByID(String userID) {
        String SQL = "SELECT * FROM User WHERE userid = ?";
        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, userID);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                UserEntity user = new UserEntity();
                user.setId(rs.getInt("id"));
                user.setUserid(rs.getString("userid"));
                user.setPassword(rs.getString("password"));
                user.setName(rs.getString("name"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // If no user found or error occurs
    }
    
    public int updateProfile(UserEntity user) {
        String SQL = "UPDATE User SET name = ?, phoneNumber = ?";

        // 비밀번호를 변경하는 경우 추가
        if (user.getPassword() != null && !user.getPassword().isEmpty()) {
            SQL += ", password = ?";
        }

        SQL += " WHERE userid = ?";

        try {
            pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, user.getName());
            pstmt.setString(2, user.getPhoneNumber());

            // 비밀번호를 변경하는 경우 파라미터 추가
            if (user.getPassword() != null && !user.getPassword().isEmpty()) {
                pstmt.setString(3, user.getPassword());
                pstmt.setString(4, user.getUserid());
            } else {
                pstmt.setString(3, user.getUserid());
            }

            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 해제 코드
            // pstmt, conn 등의 자원을 닫는 코드 작성 필요
        }

        return -1; // 업데이트 실패 시 리턴
    }

    
    
    
    
}
