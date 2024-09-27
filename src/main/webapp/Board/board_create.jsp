<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>시작</title>
    <link rel="stylesheet" href="board_create.css" type="text/css" />
    <link rel="stylesheet" href="../Header/header.css" type="text/css" />
</head>
<body>
    <div class="Board_Create_Page">
        <div class="Board_Create_Page-Header">
            <p>새 게시물</p>
        </div>
        <div class="Board_Create_Page-Body">
            <form class="Board_Create_Page-Body-Form" action="board_create_process.jsp" method="post">
                <input type="text" placeholder="제목" class="Board_Create_Page-Body-Form-Title" name="title">
                <textarea placeholder="내용" class="Board_Create_Page-Body-Form-content" name="content"></textarea>
                <div class="Board_Create_Page-Body-Form-CallGPT">
                    <a href="./board_GPT.jsp"> GPT 3.5와 같이 쓰기 🤖</a>
                </div>
                <input type="submit" value="작성완료" class="Board_Create_Page-Body-Form-Submit">
            </form>
        </div>
        
    </div>
    <script>
        // 페이지 로드 시 로컬 스토리지에서 제목과 내용을 불러옴
        document.addEventListener('DOMContentLoaded', () => {
            const title = localStorage.getItem('gptTitle');
            const content = localStorage.getItem('gptContent');
            if (title) {
                document.querySelector('.Board_Create_Page-Body-Form-Title').value = title;
            }
            if (content) {
                document.querySelector('.Board_Create_Page-Body-Form-content').value = content;
            }
        });
    </script>
    <%-- Include header --%>
        <jsp:include page="../Header/header.jsp"></jsp:include>
</body>
</html>
