<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시판</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">

    <h2>게시판</h2>
    <table border="1">
        <tr>
            <th>제목</th>
            <th>작성자</th>
            <th>작성 날짜</th>
        </tr>
        <%
            String queryParam = request.getParameter("query");
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // 데이터베이스 연결
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

                if (queryParam != null && !queryParam.trim().isEmpty()) {
                    // 검색어가 있을 때: 완전 일치와 부분 일치를 처리
                    String query = "SELECT post_id, title, user_id, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at "
                                 + "FROM posts "
                                 + "WHERE title LIKE ? "
                                 + "ORDER BY CASE WHEN title = ? THEN 1 ELSE 2 END, created_at DESC";

                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, "%" + queryParam + "%");  // 부분 일치
                    pstmt.setString(2, queryParam);  // 완전 일치
                } else {
                    // 검색어가 없을 때: 전체 목록 조회
                    String query = "SELECT post_id, title, user_id, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at "
                                 + "FROM posts ORDER BY created_at DESC";
                    pstmt = conn.prepareStatement(query);
                }

                rs = pstmt.executeQuery();

                // 결과가 없는 경우 처리
                if (!rs.isBeforeFirst()) {
        %>
                    <tr>
                        <td colspan="3">검색 결과가 없습니다.</td>
                    </tr>
        <%
                } else {
                    while (rs.next()) {
                        int postId = rs.getInt("post_id");
                        String title = rs.getString("title");
                        String userId = rs.getString("user_id");
                        String createdAt = rs.getString("created_at");
        %>
                        <tr>
                            <td><a href="view_register.jsp?postId=<%= postId %>"><%= title %></a></td>
                            <td><%= userId %></td>
                            <td><%= createdAt %></td>
                        </tr>
        <%
                    }
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
</div>

</body>
</html>
