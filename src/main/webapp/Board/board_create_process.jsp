<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="Board.BoardDAO" %>
<%@ page import="User.UserDAO" %>

<%
	String sessionID = (String) session.getAttribute("userID");
    String userId = sessionID; // 임시로 사용자 ID 설정
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    BoardDAO boardDAO = new BoardDAO();
    boardDAO.createBoard(userId, title, content);

    // 게시물 작성 후 로컬 스토리지의 데이터를 삭제
    session.removeAttribute("gptTitle");
    session.removeAttribute("gptContent");

    // 작성 완료 후 목록 페이지로 리다이렉트
    response.sendRedirect("../Main/main.jsp");
%>