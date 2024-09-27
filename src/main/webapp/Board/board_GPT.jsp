<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시작</title>
    <link rel="stylesheet" href="board_GPT.css" type="text/css" />
    <link rel="stylesheet" href="../Header/header.css" type="text/css" />
</head>
<body>
    <div class="Board_GPT_Page">
        <div class="Board_GPT_Page-Header">
            <p>GPT 3.5</p>
        </div>
        <div class="Board_GPT_Page-Body">
            <form class="Board_GPT_Page-Body-Form">
                <div class="Board_GPT_Page-Body-Form-content" id="chat-messages"></div>
                <div class="Board_GPT_Page-Body-Form-InputMessage">
                    <input type="text" placeholder="메시지를 입력하세요...">
                    <button type="button" class="Board_GPT_Page-Body-Form-Submit">전송</button>
                </div>
            </form>
        </div>
        
        <%-- Include header --%>
        <jsp:include page="../Header/header.jsp"></jsp:include>
    </div>
    <script src="board_GPT.js"></script>
</body>
</html>
