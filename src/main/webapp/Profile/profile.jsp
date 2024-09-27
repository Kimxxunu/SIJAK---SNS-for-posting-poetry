<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.IOException"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.sql.*"%>
<%@ page import="Like.LikeDAO, Like.LikeBean"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>시작</title>
<link rel="stylesheet" href="profile.css" type="text/css" />
<link rel="stylesheet" href="../Header/header.css" type="text/css" />
</head>
<body>
	<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    } else {
        // Redirect to login page if not logged in
        response.sendRedirect("../Login/login_page.jsp");
    }
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String url = "jdbc:mysql://localhost:3306/start_db";
        String user = "root";
        String password = "123456";
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, user, password);
        LikeDAO likeDAO = new LikeDAO(conn); // DAO 객체 생성

        // 총 게시물 개수 가져오기
        String totalPostsQuery = "SELECT COUNT(*) AS total_posts FROM board";
        pstmt = conn.prepareStatement(totalPostsQuery);
        rs = pstmt.executeQuery();
        int totalPosts = 0;
        if (rs.next()) {
            totalPosts = rs.getInt("total_posts");
        }

        // 내가 작성한 게시물 개수 가져오기
        String myPostsCountQuery = "SELECT COUNT(*) AS my_posts FROM board WHERE user_id = ?";
        pstmt = conn.prepareStatement(myPostsCountQuery);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();
        int myPostsCount = 0;
        if (rs.next()) {
            myPostsCount = rs.getInt("my_posts");
        }
        
        
        String myTotalLikesQuery = "SELECT SUM(like_count) AS total_likes " +
                "FROM (SELECT COUNT(*) AS like_count " +
                "      FROM `like` l " +
                "      WHERE l.board_id IN (SELECT id FROM board WHERE user_id = ?) " +
                "      GROUP BY l.board_id) AS my_likes";

		try {
			// 이하 생략
			pstmt = conn.prepareStatement(myTotalLikesQuery);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			int totalLikes = 0;
			if (rs.next()) {
				totalLikes = rs.getInt("total_likes");
			}
			request.setAttribute("totalLikes", totalLikes);
			// 이하 생략
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
			// 이하 생략
		}
        

        // 모든 게시물의 작성자 이름과 정보 가져오기
        String allPostsQuery = "SELECT b.id, b.user_id, b.title, b.content, b.create_date, u.name " +
                       "FROM board b " +
                       "JOIN User u ON b.user_id = u.userid " +
                       "WHERE b.user_id = ? " +
                       "ORDER BY b.create_date DESC";
        pstmt = conn.prepareStatement(allPostsQuery);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();
        List<Map<String, Object>> allPosts = new ArrayList<>();
        while (rs.next()) {
            Map<String, Object> post = new HashMap<>();
            post.put("id", rs.getInt("id"));
            post.put("user_id", rs.getString("user_id"));
            post.put("title", rs.getString("title"));
            post.put("content", rs.getString("content"));
            post.put("create_date", rs.getTimestamp("create_date"));
            post.put("author_name", rs.getString("name")); // 작성자 이름 추가
            allPosts.add(post);
        }

        // 사용자 정보 가져오기
        String userInfoQuery = "SELECT * FROM User WHERE userid = ?";
        pstmt = conn.prepareStatement(userInfoQuery);
        pstmt.setString(1, userID);
        rs = pstmt.executeQuery();
        Map<String, Object> userInfo = new HashMap<>();
        if (rs.next()) {
            userInfo.put("id", rs.getInt("id"));
            userInfo.put("userid", rs.getString("userid"));
            userInfo.put("password", rs.getString("password"));
            userInfo.put("name", rs.getString("name"));
            userInfo.put("phoneNumber", rs.getString("phoneNumber"));
        }

        // 결과를 변수에 담아 사용
        request.setAttribute("totalPosts", totalPosts);
        request.setAttribute("myPostsCount", myPostsCount);
        request.setAttribute("allPosts", allPosts);
        request.setAttribute("userInfo", userInfo);
        
        
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

	<div class="Profile">
		<!-- 프로필 헤더 -->
		<div class="Profile-Header">
			<div class="Profile-Header-Wrap">
				<div class="Profile-Header-Wrap-Content">
					<div class="Profile-Header-Wrap-Content-Image">
						<img src="../Assets/lock.png" alt="좌물쇠 이미지">
					</div>
					<div class="Profile-Header-Wrap-Content-UserID">
						<p><%= userID %></p>
					</div>
				</div>
			</div>
		</div>

		<!-- 프로필 바디 -->
		<div class="Profile-Body">
			<div class="Profile-Body-Wrap">
				<div class="Profile-Body-Wrap-Top">
					<!-- 프로필 이미지 영역 -->
					<div class="Profile-Body-Wrap-Top-ImageArea">
						<div class="Profile-Body-Wrap-Top-ImageArea-Image">
							<img src="../Assets/profile.png" alt="프로필사진">
						</div>
					</div>
					<!-- 프로필 이름 영역 -->
					<div class="Profile-Body-Wrap-Top-NameArea">
						<%
                        Map<String, Object> userInfo = (Map<String, Object>) request.getAttribute("userInfo");
                        if (userInfo != null) {
                            out.print("<p>" + userInfo.get("name") + "</p>");
                        } else {
                            out.print("<p>이름 정보 없음</p>");
                        }
                    %>
					</div>
				</div>

				<div class="Profile-Body-Wrap-Middle">
					<div class="Profile-Body-Wrap-Middle-Imformation">
						<div class="Profile-Body-Wrap-Middle-Imformation-Wrap">
							<!-- 게시물 정보 영역 -->
							<div class="Profile-Body-Wrap-Middle-Imformation-Wrap-Board">
								<div
									class="Profile-Body-Wrap-Middle-Imformation-Wrap-Board-BoardCount">
									<p><%= request.getAttribute("myPostsCount") %></p>
									<!-- 전체 게시물 개수 출력 -->
								</div>
								<div
									class="Profile-Body-Wrap-Middle-Imformation-Wrap-Board-Title">
									<p>게시물</p>
								</div>
							</div>

							<div class="Profile-Body-Wrap-Middle-Imformation-Wrap-Like">
								<div
									class="Profile-Body-Wrap-Middle-Imformation-Wrap-Like-LikeCount">
									<p><%= request.getAttribute("totalLikes") %></p>
								</div>
								<div
									class="Profile-Body-Wrap-Middle-Imformation-Wrap-Like-Title">
									<p>좋아요</p>
								</div>
							</div>
						</div>
					</div>
					<!-- 버튼 영역 -->
					<div class="Profile-Body-Wrap-Middle-ButtonArea">
						<div class="Profile-Body-Wrap-Middle-ButtonArea-Wrap">
							<div class="Profile-Body-Wrap-Middle-ButtonArea-Wrap-ProfileEditButton">
    <p onclick="openModal()">프로필 편집</p>
</div>
							<a href = "../Login/login_page.jsp" class="Profile-Body-Wrap-Middle-ButtonArea-Wrap-LogoutButton">
								<p>로그아웃</p>
							</a>
						</div>
					</div>
				</div>
				<div class="Profile-Body-Wrap-Bottom">
                    <div class="Profile-Body-Wrap-Bottom-BrushImage">
                        <img src="../Assets/brush.png" alt="브러시 아이콘 이미지">
                    </div>
                </div>
            </div>
        </div>

				<!-- 게시물 목록 영역 -->
				<div class="Profile-MyBoard">
					<div class="Profile-MyBoard-BoardList">
						<%
                        List<Map<String, Object>> allPosts = (List<Map<String, Object>>) request.getAttribute("allPosts");
                        if (allPosts != null) {
                            for (Map<String, Object> post : allPosts) {
                    %>
						<a href="../Board/board_update.jsp?postId=<%= post.get("id") %>">
						<div class="Profile-MyBoard-BoardList-BoardItem">
							<div class="Profile-MyBoard-BoardList-BoardItem-Title">
								<p><%= post.get("title") %></p>
							</div>
							<div class="Profile-MyBoard-BoardList-BoardItem-Content">
								<p><%= post.get("content") %></p>
							</div>
						</div>
						</a>
						<%
                            }
                        }
                    %>
					</div>
				</div>

			</div>
		</div>

		<!-- 하단 헤더 -->
		<jsp:include page="../Header/header.jsp"></jsp:include>
	</div>
	
	<div id="editModal" class="modal">
	
    <div class="modal-content">
		
        <span class="close">&times;</span>
		<div class="modal-content-title">
			<p>프로필 편집</p>
		</div>
        <form action="update_profile.jsp" method="post" class="modal-content-form">
			<div class="modal-content-form-input">
				<div class="modal-content-form-input-Box">
					<p>이름</p>
					<input type="text" id="name" name="name" value="<%= userInfo.get("name") %>">
				</div>
				<div class="modal-content-form-input-Box">
					<p>연락처</p>
					<input type="text" id="phoneNumber" name="phoneNumber" value="<%= userInfo.get("phoneNumber") %>">
				</div>
				<div class="modal-content-form-input-Box">
					<p>새비밀번호</p>
					<input type="password" id="newPassword" name="newPassword">
				</div>
				<div class="modal-content-form-input-Box">
					<p>비밀번호 재입력</p>
					<input type="password" id="confirmPassword" name="confirmPassword">
				</div>
			</div>
			
           <div class="modal-content-form-submit" >
			   <input type="submit" value="수정 완료">
		   </div>
        </form>
    </div>
</div>
<script>
//모달 열기
function openModal() {
    var modal = document.getElementById('editModal');
    modal.style.display = 'block';
    modal.classList.add('slide-up'); // 슬라이드 업 애니메이션 추가
    document.body.style.overflow = 'hidden'; // 스크롤 방지
}

// 모달 닫기
function closeModal() {
    var modal = document.getElementById('editModal');
    modal.classList.remove('slide-up'); // 슬라이드 다운 애니메이션 추가
    modal.classList.add('slide-down');
    setTimeout(function() {
        modal.style.display = 'none';
        modal.classList.remove('slide-down');
        document.body.style.overflow = ''; // 스크롤 복구
    }, 500); // 애니메이션 시간과 동일하게 설정 (0.5초)
}

// 모달 닫기 버튼 이벤트 처리
var closeBtn = document.getElementsByClassName('close')[0];
if (closeBtn) {
    closeBtn.onclick = function() {
        closeModal();
    }
}

// 모달 영역 외부 클릭 시 닫기
window.onclick = function(event) {
    var modal = document.getElementById('editModal');
    if (event.target == modal) {
        closeModal();
    }
}

// 수정 완료 버튼 클릭 시, 비밀번호 확인
document.getElementById('editModal').getElementsByTagName('form')[0].onsubmit = function() {
    var newPassword = document.getElementById('newPassword').value;
    var confirmPassword = document.getElementById('confirmPassword').value;

    if (newPassword !== confirmPassword) {
        alert('새 비밀번호와 비밀번호 재입력이 일치하지 않습니다.');
        return false; // 폼 전송 취소
    }
}
</script>
</body>
</html>
