<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>로그아웃</title>
</head>
<body>
<%
    // 세션 무효화 (로그아웃)
    session.invalidate();
    // 로그아웃 후 메인 페이지로 이동
    response.sendRedirect("index.jsp");
%>
</body>
</html>
