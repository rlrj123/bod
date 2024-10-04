<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Timestamp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>게시물 목록</title>
</head>
<body>
    <h2>게시물 목록</h2>
    <table border="1">
        <tr>
            <th>번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Oracle JDBC 드라이버 로드
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // 데이터베이스 연결
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

                // 게시물 목록 조회 쿼리
                String query = "SELECT p.post_id, p.title, p.user_id, p.created_at FROM posts p ORDER BY p.created_at DESC";
                pstmt = conn.prepareStatement(query);
                rs = pstmt.executeQuery();

                // 결과 출력
                while (rs.next()) {
                    int postId = rs.getInt("post_id");
                    String title = rs.getString("title");
                    String userId = rs.getString("user_id");
                    Timestamp createdAt = rs.getTimestamp("created_at");
        %>
                    <tr>
                        <td><%= postId %></td>
                        <td><a href="view.jsp?postId=<%= postId %>"><%= title %></a></td>
                        <td><%= userId %></td>
                        <td><%= createdAt %></td>
                    </tr>
        <%
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
            }
        %>
    </table>
</body>
</html>
