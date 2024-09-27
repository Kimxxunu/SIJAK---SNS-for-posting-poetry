<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="header.css" type="text/css" />
<title>시작</title>
<script>
function loginRequired() {
    alert("로그인이 필요한 서비스입니다!");
    window.location.href = "../Login/login_page.jsp"; // 로그인 페이지로 이동
}
</script>
</head>
<body>
	<%
	
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
	
		if(userID == null){ 
	%>
	<nav class="Footer">
		<div class = "Footer-Wrap">
			<div class="Footer-Wrap-Home">
				<a  href = "../Main/main.jsp">
					<div class = "menu-icon"><img src="../Assets/home.png" alt="홈버튼"></div>
				</a>
			</div>
			<div class="Footer-Wrap-Hot">
				<a href="#" onclick="loginRequired();">
					<div class = "menu-icon"><img src="../Assets/Hot.svg" alt="인기게시물버튼"></div>
				</a>
			</div>
			<div class = "Footer-Wrap-BoardWrite" >
				<a href="#" onclick="loginRequired();">
					<div class = "menu-icon"><img src="../Assets/board-write.png" alt="글쓰기버튼"></div>
				</a>
			</div>
			<div class = "Footer-Wrap-BoardWrite-MyLike" >
				<a href="#" onclick="loginRequired();">
					<div class = "menu-icon"><img src="../Assets/myLove.png" alt="내좋아요게시물버튼"></div>
				</a>
			</div>
			<div class = "Footer-Wrap-BoardWrite-Login" >
				<a href = "../Login/login_page.jsp">
					<div class = "menu-icon"><img src="../Assets/login-key.png" alt="로그인버튼" id="login-key"></div>
				</a>
			</div>
		</div>
	</nav>
	
	
	<%
		}else{
	
	%>
	<nav class="Footer">
		<div class = "Footer-Wrap">
			<div class="Footer-Wrap-Home">
				<a  href = "../Main/main.jsp">
					<div class = "menu-icon"><img src="../Assets/home.png" alt="홈버튼"></div>
				</a>
			</div>
			<div class="Footer-Wrap-Hot">
				<a href = "../Hot/Hot.jsp">
					<div class = "menu-icon"><img src="../Assets/Hot.svg" alt="인기게시물버튼"></div>
				</a>
			</div>
			<div class = "Footer-Wrap-BoardWrite" >
                <a href = "../Board/board_create.jsp" onclick="localStorage.removeItem('gptTitle'); localStorage.removeItem('gptContent');">
                    <div class = "menu-icon"><img src="../Assets/board-write.png" alt="글쓰기버튼"></div>
                </a>
            </div>
			<div class = "Footer-Wrap-BoardWrite-MyLike" >
				<a href = "../MyLike/MyLike.jsp">
					<div class = "menu-icon"><img src="../Assets/myLove.png" alt="내좋아요게시물버튼"></div>
				</a>
			</div>
			<div class = "Footer-Wrap-BoardWrite-Proflie" >
				<a href = "../Profile/profile.jsp">
					<div class = "menu-icon"><img src="../Assets/profile.png" alt="프로필버튼"></div>
				</a>
			</div>
		</div>
	</nav>

	<%
		}
	%>
	
</body>
</html>