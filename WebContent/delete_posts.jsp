<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 삭제</title>
</head>
<body>
<%
    String postId = request.getParameter("postId");
    String userId = (String) session.getAttribute("user_id");

    if (postId != null && userId != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            String query = "DELETE FROM posts WHERE post_id = ? AND user_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(postId));
            pstmt.setString(2, userId);

            int rows = pstmt.executeUpdate();

            if (rows > 0) {
                out.println("<script>alert('게시물이 성공적으로 삭제되었습니다.'); location.href='my_posts.jsp';</script>");
            } else {
                out.println("<script>alert('게시물을 삭제하는데 실패했습니다.'); history.back();</script>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<script>alert('게시물 삭제 중 오류가 발생했습니다.'); history.back();</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    } else {
        out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
    }
%>
</body>
</html>
