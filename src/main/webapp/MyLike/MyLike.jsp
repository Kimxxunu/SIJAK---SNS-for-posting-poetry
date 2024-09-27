<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.*" %>
<%@ page import="Like.LikeDAO, Like.LikeBean" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시작</title>
<link rel="stylesheet" href="../Main/main.css" type="text/css" />
<link rel="stylesheet" href="../Header/header.css" type="text/css" />
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
    <div class="main">

        <%-- Check if user is logged in --%>
        <%
            String userID = null;
            if (session.getAttribute("userID") != null) {
                userID = (String) session.getAttribute("userID");
            } else {
                // Redirect to login page if not logged in
                response.sendRedirect("../Login/login_page.jsp");
            }
        %>

        <div class="Header-title">
            <div class="Header-title-Image">
                <img src="../Assets/start-logo.png">
            </div>
        </div>

        <%-- Retrieve and display liked board posts --%>
        <div class="board-list">
            
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    String url = "jdbc:mysql://localhost:3306/start_db";
                    String user = "root";
                    String password = "123456";
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection(url, user, password);
                    LikeDAO likeDAO = new LikeDAO(conn); // DAO 객체 생성
                    
                    String sql = "SELECT b.id, b.user_id, b.title, b.content, b.like_count, b.create_date, " +
                            "COUNT(c.id) AS comment_count " +
                            "FROM board b " +
                            "LEFT JOIN comment c ON b.id = c.poetry_id " +
                            "JOIN `like` l ON b.id = l.board_id " +
                            "WHERE l.user_id = ? " +
                            "GROUP BY b.id";

                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, userID);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int boardId = rs.getInt("id");
                        String boardUserID = rs.getString("user_id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        int likeCount = rs.getInt("like_count");
                        Timestamp createDate = rs.getTimestamp("create_date");
                        int commentCount = rs.getInt("comment_count"); // 댓글 수 가져오기

                        // Calculate time ago
                        Date now = new Date();
                        long diffInMillis = now.getTime() - createDate.getTime();
                        long diffInMinutes = diffInMillis / (60 * 1000);
                        String timeAgo = "";

                        if (diffInMinutes < 1) {
                            timeAgo = "방금 전";
                        } else if (diffInMinutes < 60) {
                            timeAgo = diffInMinutes + "분 전";
                        } else {
                            long diffInHours = diffInMinutes / 60;
                            if (diffInHours < 24) {
                                timeAgo = diffInHours + "시간 전";
                            } else {
                                SimpleDateFormat dateFormat = new SimpleDateFormat("@MM-dd");
                                timeAgo = dateFormat.format(createDate);
                            }
                        }
            %>
                        <div class="Board-Item">
                            <div class="Board-Item-Header">
                                <div class="Board-Item-Header-Wrap">
                                    <div class="Board-Item-Header-Wrap-Writer">
                                        <p><%= boardUserID %></p>
                                    </div>
                                    <div class="Board-Item-Header-Wrap-WriteTime">
                                        <p><%= timeAgo %></p>
                                    </div>
                                </div>
                            </div>
                            <div class="Board-Item-Body">
                                <div class="Board-Item-Body-Title">
                                    <p><%= title %></p>
                                </div>
                                <div class="Board-Item-Body-Content">
                                    <p><%= content %></p>
                                </div>
                                <div class="Board-Item-Body-LikeArea">
                                    <div class="Board-Item-Body-LikeArea-Like">
                                        <p>좋아요 <span id="like-count-<%= boardId %>"><%= likeCount %></span>개</p>
                                        <p>댓글 <span id="comment-count-<%= boardId %>"><%= commentCount %></span>개</p>
                                    </div>
                                </div>
                            </div>
                            <div class="Board-Item-Footer">
                                <div class="Board-Item-Footer-LikeButton">
                                    <button class="like-button liked" disabled>
                                        <img src="../Assets/board-love-on.png" alt="Liked">
                                        <p>좋아요</p>
                                    </button>
                                </div>
                                <div class="Board-Item-Footer-Comment">
                                    <button class="Comment" onclick="showCommentsModal(<%= boardId %>)">
                                        <img src="../Assets/comment.png">
                                        <p>댓글 달기</p>
                                    </button>
                                </div>
                            </div>
                        </div>
            <% 
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
        </div>
        <%-- Include header --%>
        <jsp:include page="../Header/header.jsp"></jsp:include>
        
    </div>

    <%-- Comment Modal --%>
    <div id="commentModal" class="comment-modal">
        <div class="comment-modal-content">
            <span class="close">&times;</span>
            <div id="commentsList"></div>
            <div class="input">
            <textarea id="newCommentContent" placeholder="댓글을 입력하세요"></textarea>
            <button id="submitCommentButton">댓글 작성</button>
            </div>
        </div>
    </div>

    <script>
    // 좋아요 버튼 클릭 처리 함수
    function likeButtonClick(boardId, userId) {
        // This function is disabled in MyLike.jsp since all posts are already liked
    }

    // 댓글 모달 표시 함수
    function showCommentsModal(boardId) {
        var modal = document.getElementById("commentModal");
        var modalContent = document.querySelector(".comment-modal-content");

        // 모달을 열기
        modal.style.display = "block";
        document.body.style.overflow = "hidden"; // 스크롤 방지

        // 댓글 목록 불러오기
        loadComments(boardId);

        // 댓글 작성 버튼 클릭 이벤트
        var submitButton = document.getElementById("submitCommentButton");
        submitButton.onclick = function() {
            submitComment(boardId);
        }
    }

 // 댓글 목록 불러오기 함수
    function loadComments(boardId) {
        var commentsList = document.getElementById("commentsList");
        commentsList.innerHTML = "댓글 불러오는 중...";

        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'Comment/GetCommentsServlet?boardId=' + boardId, true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                var comments = JSON.parse(xhr.responseText);
                commentsList.innerHTML = "";

                comments.forEach(function(comment) {
                    var createDate = new Date(comment.create_date);
                    var timeAgo = calculateCommentTimeAgo(createDate);

                    var commentDiv = document.createElement("div");
                    commentDiv.className = "commentBox";
                    commentDiv.innerHTML =
                        '<div class="chatting-icon"><img src="../Assets/chatting.png" alt="채팅아이콘"></div>' +
                        '<div class="commentBox-wrap-content">' +
                            '<div class="commentBox-Writer">' +
                                '<p>' + comment.user_id + '</p>' +
                            '</div>' +
                            '<div class="commentBox-content">' +
                                '<p>' + comment.content + '</p>' +
                            '</div>' +
                        '</div>' +
                        '<div class="commentBox-time">' +
                            '<p>' + timeAgo + '</p>' +
                        '</div>';
                    commentsList.appendChild(commentDiv);
                });
            } else {
                commentsList.innerHTML = "";
            }
        };

        xhr.onerror = function() {
            commentsList.innerHTML = "댓글을 불러오지 못했습니다.";
        };

        // 댓글 목록 요청 보내기
        xhr.send();
    }


// 댓글 작성 함수
function submitComment(boardId) {
var newCommentContent = document.getElementById("newCommentContent").value.trim();

if (newCommentContent === "") {
    alert("댓글 내용을 입력해주세요.");
    return;
}

var xhr = new XMLHttpRequest();
xhr.open("POST", "Comment/AddCommentServlet", true);
xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
xhr.onload = function() {
    if (xhr.status === 200) {
        var response = JSON.parse(xhr.responseText);
        if (response.success) {
            loadComments(boardId); // 댓글 목록 다시 불러오기
            document.getElementById("newCommentContent").value = ""; // 입력창 초기화
        } else {
            alert("댓글 작성에 실패했습니다.");
        }
    } else {
        alert("댓글 작성 중 오류가 발생했습니다.");
    }
};
xhr.onerror = function() {
    alert("댓글 작성 중 오류가 발생했습니다.");
};

var params = "boardId=" + encodeURIComponent(boardId) + "&content=" + encodeURIComponent(newCommentContent);
xhr.send(params);
}

// 댓글 작성 시간 계산 함수
function calculateCommentTimeAgo(createDate) {
var now = new Date();
var diffInMillis = now.getTime() - createDate.getTime();
var diffInSeconds = Math.floor(diffInMillis / 1000);

if (diffInSeconds < 60) {
    return diffInSeconds + "초 전";
} else if (diffInSeconds < 3600) {
    return Math.floor(diffInSeconds / 60) + "분 전";
} else if (diffInSeconds < 86400) {
    return Math.floor(diffInSeconds / 3600) + "시간 전";
} else {
    var dateFormat = new Intl.DateTimeFormat('ko-KR', {
        year: 'numeric', month: '2-digit', day: '2-digit',
        hour: '2-digit', minute: '2-digit'
    });
    return dateFormat.format(createDate);
}
}

// 댓글 모달 닫기 이벤트
var modal = document.getElementById("commentModal");
var span = document.getElementsByClassName("close")[0];
span.onclick = function() {
modal.style.display = "none";
document.body.style.overflow = ""; // 스크롤 해제
};
window.onclick = function(event) {
if (event.target === modal) {
    modal.style.display = "none";
    document.body.style.overflow = ""; // 스크롤 해제
}
};
</script>

</body>
</html>

