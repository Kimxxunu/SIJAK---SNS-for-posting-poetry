<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시작</title>
    <link rel="stylesheet" href="login.css" type="text/css" />
</head>

<body>
    <div class="Login">
        <form class="Login-Wrap" name="login" method="post" action="login_process.jsp">
            <div class="Login-Wrap-Logo">
                <img src="../Assets/start-logo.png">
            </div>

            <div class="Login-Wrap-LoginBox">

                <div class="Login-Wrap-LoginBox-LoginBoxWrap">
                    <div class="Login-Wrap-LoginBox-LoginBoxWrap-UserID">
                        <p>이메일</p>
                        <input type="email" name="userid">
                    </div>
                </div>

                <div class="Login-Wrap-LoginBox-LoginBoxWrap">
                    <div class="Login-Wrap-LoginBox-LoginBoxWrap-password">
                        <p>비밀번호</p>
                        <input type="password" name="password">
                    </div>
                </div>
            </div>
            <div class="Login-Wrap-Submit">
                <input type="submit" value="로그인">
            </div>

            <div class="Login-Wrap-IsJoin">
                <p>계정이 없으신가요? <a href="../SignUp/sign_up.jsp"> 가입하기</a></p>
            </div>

        </form>

    </div>
</body>

</html>