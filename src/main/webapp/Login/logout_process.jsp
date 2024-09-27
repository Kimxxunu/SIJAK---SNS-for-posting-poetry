<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인아웃 프로세스</title>
</head>
<body>
	<%
		session.invalidate();
	%>
	<script>
		location.href = "../Main/main.jsp";
	</script>
</body>
</html>

