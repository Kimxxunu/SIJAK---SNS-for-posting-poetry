<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시작</title>
    <link rel="stylesheet" href="sign_up.css" type="text/css" />
</head>

<body>
    <div class="SignUpPage">
        <div class="SignUpPage-Wrap">
            <div class="SignUpPage-Wrap-SignUp">
                <div class="SignUpPage-Wrap-SignUp-Logo">
                    <img src="../Assets/start-logo.png">
                </div>
                <div class="SignUpPage-Wrap-SignUp-ment">
                    <p>시작과 함께 창의성 넘치는</p>
                    <p>시인이 되어봐요</p>
                </div>
                <form class="SignUpPage-Wrap-SignUp-SignUpArea" action="sign_up_process.jsp" method="post">
                    <div class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpBox">
                        <div class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpBox-SignUpInputBox">
                            <input type="email" name="userid" placeholder="아이디">
                        </div>
                        <div class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpBox-SignUpInputBox">
                            <input type="password" id="password" name="password" placeholder="비밀번호">
                        </div>
                        <div class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpBox-SignUpInputBox">
                            <input type="text" id="name" name="name" placeholder="이름">
                        </div>
                        <div class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpBox-SignUpInputBox">
                            <input type="tel" name="phoneNumber" placeholder="연락처">
                        </div>
                    </div>
                    <input type="submit" value="회원가입" class="SignUpPage-Wrap-SignUp-SignUpArea-SignUpSubmit">
                </form>
            </div>
            <div class="SignUpPage-Wrap-Login">
                <p>계정이 있으신가요? <a href="../Login/login_page.jsp"> 로그인</a></p>
            </div>
        </div>
    </div>
</body>

</html>