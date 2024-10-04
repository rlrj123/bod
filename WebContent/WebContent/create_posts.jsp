<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>게시물 작성</title>
</head>
<body>
<%
if (session.getAttribute("user_id") == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>
    <h2>게시물 작성</h2>
    <form action="save_posts.jsp" method="post" accept-charset="UTF-8">
        <label>제목:</label><input type="text" name="title" required><br>
        <label>내용:</label><textarea name="content" required></textarea><br>
        <input type="submit" value="등록">
    </form>
</body>
</html>
