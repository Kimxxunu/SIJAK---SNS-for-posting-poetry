package Like;

import java.sql.Timestamp;

public class LikeBean {
    private int id;
    private String userId;
    private int boardId;
    private Timestamp createDate;

    // 생성자, 게터, 세터
    public LikeBean() {
    }

    public LikeBean(String userId, int boardId) {
        this.userId = userId;
        this.boardId = boardId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getBoardId() {
        return boardId;
    }

    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public Timestamp getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Timestamp createDate) {
        this.createDate = createDate;
    }
}
