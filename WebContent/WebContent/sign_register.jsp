<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>회원가입 처리</title>
</head>
<body>
<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = request.getParameter("user_id");
        String password = request.getParameter("password");

        try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO users (user_id, password) VALUES (?, ?)")) {
             
            pstmt.setString(1, userId);
            pstmt.setString(2, password);
            pstmt.executeUpdate();

            out.println("<script>alert('회원가입 성공'); location.href='login.jsp';</script>");
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('회원가입 실패');</script>");
        }
    }
%>
</body>
</html>
