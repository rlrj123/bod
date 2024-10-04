<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 보기</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <%
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null || postIdStr.isEmpty()) {
            out.println("<p>유효하지 않은 요청입니다. postId가 없습니다.</p>");
            return;
        }

        int postId = Integer.parseInt(postIdStr);
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            // 게시물 상세 정보 조회 쿼리
            String query = "SELECT title, content, image, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at FROM posts WHERE post_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();

            // 게시물 정보 출력
            if (rs.next()) {
                String title = rs.getString("title");
                String content = rs.getString("content");
                String image = rs.getString("image");
                String createdAt = rs.getString("created_at");
    %>
                <h2><%= title %></h2>
                <p><strong>작성일:</strong> <%= createdAt %></p>
                <p><%= content %></p>
                <%
                    // 이미지가 존재할 경우 출력
                    if (image != null && !image.isEmpty()) {
                %>
                    <!-- 이미지 경로가 uploads 폴더 내에 저장된 경우 출력 -->
                    <img src="<%= request.getContextPath() %>/uploads/<%= image %>" alt="게시물 이미지" style="max-width: 100%; height: auto;" />
                <%
                    } else {
                        out.println("<p>이미지가 없습니다.</p>");
                    }
                %>
    <%
            } else {
                out.println("<p>해당 게시물이 존재하지 않습니다.</p>");
            }

            rs.close();
            pstmt.close();

            // 댓글 조회
            String commentQuery = "SELECT user_id, content, TO_CHAR(created_at, 'YYYY-MM-DD HH24:MI') AS created_at FROM comments WHERE post_id = ? ORDER BY created_at";
            pstmt = conn.prepareStatement(commentQuery);
            pstmt.setInt(1, postId);
            rs = pstmt.executeQuery();
    %>

    <!-- 댓글 섹션 -->
    <div class="comments-section">
        <h3>댓글</h3>
        <%
            while (rs.next()) {
                String userId = rs.getString("user_id");
                String commentContent = rs.getString("content");
                String commentCreatedAt = rs.getString("created_at");
        %>
                <div class="comment">
                    <p><strong><%= userId %>:</strong> <%= commentContent %> <em>(<%= commentCreatedAt %>)</em></p>
                </div>
        <%
            }
        %>
    </div>

    <!-- 댓글 작성 폼 -->
    <div class="comment-form">
        <h3>댓글 작성</h3>
        <%
            // 로그인 확인 후 댓글 작성 폼 표시
            String currentUser = (String) session.getAttribute("user_id");
            if (currentUser != null) {
        %>
            <form action="save_comment.jsp" method="post">
                <input type="hidden" name="postId" value="<%= postId %>">
                <textarea name="commentContent" rows="3" placeholder="댓글을 입력하세요" required></textarea><br>
                <button type="submit" class="btn">댓글 작성</button>
            </form>
        <%
            } else {
        %>
            <p>댓글을 작성하려면 <a href="login.jsp">로그인</a>이 필요합니다.</p>
        <%
            }
        %>
    </div>

    <%
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // 자원 정리
            if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    %>
</div>

</body>
</html>
