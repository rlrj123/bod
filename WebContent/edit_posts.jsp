<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 수정</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <%
        int postId = Integer.parseInt(request.getParameter("postId"));
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String title = "";
        String content = "";
        String image = "";

        try {
            // 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            // 게시물 정보 가져오기
            String query = "SELECT title, content, image FROM posts WHERE post_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                title = rs.getString("title");
                content = rs.getString("content");
                image = rs.getString("image");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>

    <h3>게시물 수정</h3>
    <form action="update_posts.jsp" method="post" enctype="multipart/form-data">
        <input type="hidden" name="postId" value="<%= postId %>">
        <label for="title">제목:</label>
        <input type="text" id="title" name="title" value="<%= title %>" required><br>
        <label for="content">내용:</label>
        <textarea id="content" name="content" required><%= content %></textarea><br>
        <label for="image">현재 이미지:</label>
        <%
            if (image != null && !image.isEmpty()) {
        %>
            <img src="<%= image %>" alt="게시물 이미지" style="max-width: 100%; height: auto;" />
            <p>이미지를 변경하려면 파일을 선택하세요:</p>
        <%
            }
        %>
        <input type="file" id="image" name="image" accept="image/*"><br>
        <button type="submit" class="btn">수정</button>
    </form>
</div>

</body>
</html>
