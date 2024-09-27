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
            }
        %>

        <div class="Header-title">
            <div class="Header-title-Image">
                <img src="../Assets/start-logo.png">
            </div>
        </div>

        <%-- Retrieve and display board posts --%>
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
                            "FROM board b LEFT JOIN comment c ON b.id = c.poetry_id " +
                            "GROUP BY b.id " +
                            "ORDER BY b.like_count ASC";

                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        int boardId = rs.getInt("id");
                        String boardUserID = rs.getString("user_id");
                        String title = rs.getString("title");
                        String content = rs.getString("content");
                        int likeCount = rs.getInt("like_count");
                        Timestamp createDate = rs.getTimestamp("create_date");
                        int commentCount = rs.getInt("comment_count"); // 댓글 수 가져오기
                     // JSP에 commentCount 전달
                        request.setAttribute("commentCount", commentCount);

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

                        // 좋아요 여부 확인
                        boolean isLiked = false; // 초기 좋아요 상태
                        if (userID != null) {
                            isLiked = likeDAO.checkIfLiked(userID, boardId);
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
                                        <p>댓글 <span id="comment-count-<%= boardId %>"><%= request.getAttribute("commentCount") %></span>개</p>
                                    </div>
                                </div>
                            </div>
                            <div class="Board-Item-Footer">
                                <div class="Board-Item-Footer-LikeButton">
                                    <button class="like-button <%= isLiked ? "liked" : "" %>" onclick="likeButtonClick(<%= boardId %>, '<%= userID %>')">
                                        <img src="<%= isLiked ? "../Assets/board-love-on.png" : "../Assets/board-love-off.png" %>" alt="Like">
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
        var likeCountElement = document.getElementById('like-count-' + boardId);
        var likeButton = document.querySelector('.like-button[onclick*="likeButtonClick(' + boardId + '"]');
        var isLiked = likeButton.classList.contains('liked');
        var confirmMsg = isLiked ? "좋아요를 취소하시겠습니까?" : "좋아요를 하시겠습니까?";

        if (confirm(confirmMsg)) {
            var action = isLiked ? 'unlike' : 'like';
            var url = 'LikeServlet?action=' + action + '&userId=' + userId + '&boardId=' + boardId;

            // AJAX 요청 보내기
            var xhr = new XMLHttpRequest();
            xhr.open('GET', url, true);
            xhr.onload = function() {
                if (xhr.status === 200) {
                    var response = xhr.responseText.trim(); // 공백 제거

                    // 반환된 데이터가 숫자인지 확인
                    if (!isNaN(parseInt(response))) {
                        var newLikeCount = parseInt(response);

                        // 좋아요 수 업데이트
                        likeCountElement.textContent = newLikeCount;

                        // 좋아요 버튼 이미지 변경
                        var imgElement = likeButton.querySelector('img');
                        if (isLiked) {
                            imgElement.src = '../Assets/board-love-off.png'; // 좋아요 취소 시 이미지
                        } else {
                            imgElement.src = '../Assets/board-love-on.png'; // 좋아요 시 이미지
                        }

                        // 좋아요 버튼 스타일 변경
                        likeButton.classList.toggle('liked');
                    } else {
                        console.error('서버에서 올바르지 않은 데이터를 반환했습니다.');
                    }
                } else {
                    alert('오류 발생: ' + xhr.status);
                }
            };
            xhr.send();
        }
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

    // 댓글 모달 닫기 함수
    function closeCommentModal(modal, modalContent) {
        modalContent.style.animation = "slide-down 0.4s ease-out";
        setTimeout(function() {
            modal.style.display = "none";
            document.body.style.overflow = "auto"; // 스크롤 허용
            modalContent.style.animation = ""; // 애니메이션 초기화
        }, 400); // 애니메이션 지속 시간과 동일하게 설정
    }

    // 이벤트 핸들러 한 번만 등록
    window.onload = function() {
        var modal = document.getElementById("commentModal");
        var modalContent = document.querySelector(".comment-modal-content");
        var span = document.getElementsByClassName("close")[0];

        // 모달 닫기 이벤트
        window.onclick = function(event) {
            if (event.target == modal) {
                closeCommentModal(modal, modalContent);
            }
        }

        // 모달 내부 클릭 이벤트 전파 방지
        modalContent.onclick = function(event) {
            event.stopPropagation(); // 이벤트 전파 중지
        }

        // 닫기 버튼 클릭 이벤트
        span.onclick = function() {
            closeCommentModal(modal, modalContent);
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
                commentsList.innerHTML = "댓글을 불러오는 중 오류가 발생했습니다.";
            }
        };
        xhr.send();
    }

    // 댓글 작성 함수
    function submitComment(boardId) {
        var newCommentContent = document.getElementById("newCommentContent").value;
        if (newCommentContent.trim() === "") {
            alert("댓글 내용을 입력하세요.");
            return;
        }

        if (confirm("댓글을 작성하시겠습니까?")) {
            var xhr = new XMLHttpRequest();
            xhr.open('POST', 'Comment/SubmitCommentServlet', true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.onload = function() {
                if (xhr.status === 200) {
                    loadComments(boardId); // 댓글 목록 갱신
                    document.getElementById("newCommentContent").value = ""; // 입력 필드 초기화
                    updateCommentCount(boardId); // 댓글 수 업데이트
                } else {
                    alert("댓글 작성 중 오류가 발생했습니다.");
                }
            };
            xhr.send("boardId=" + boardId + "&content=" + encodeURIComponent(newCommentContent));
        }
    }

    // 댓글 수 업데이트 함수
    function updateCommentCount(boardId) {
        var commentCountElement = document.getElementById('comment-count-' + boardId);

        // AJAX 요청 보내기
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'Comment/GetCommentCountServlet?boardId=' + boardId, true);
        xhr.onload = function() {
            if (xhr.status === 200) {
                var response = xhr.responseText.trim(); // 공백 제거

                // 반환된 데이터가 숫자인지 확인
                if (!isNaN(parseInt(response))) {
                    var newCommentCount = parseInt(response);

                    // 댓글 수 업데이트
                    commentCountElement.textContent = newCommentCount;
                } else {
                    console.error('서버에서 올바르지 않은 데이터를 반환했습니다.');
                }
            } else {
                alert('오류 발생: ' + xhr.status);
            }
        };
        xhr.send();
    }

    // 댓글 작성 시간을 계산하여 형식에 맞게 반환하는 함수
    function calculateCommentTimeAgo(createDate) {
        var now = new Date();
        var diffInMillis = now - createDate;
        var diffInMinutes = diffInMillis / (60 * 1000);
        var timeAgo = "";

        if (diffInMinutes < 1) {
            timeAgo = "방금 전";
        } else if (diffInMinutes < 60) {
            timeAgo = Math.floor(diffInMinutes) + "분 전";
        } else {
            var diffInHours = diffInMinutes / 60;
            if (diffInHours < 24) {
                timeAgo = Math.floor(diffInHours) + "시간 전";
            } else {
                var dateFormat = new Intl.DateTimeFormat('ko-KR', { month: 'numeric', day: 'numeric' });
                timeAgo = dateFormat.format(createDate);
            }
        }

        return timeAgo;
    }
</script>
</body>
</html>
