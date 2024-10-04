<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 검색 결과</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <h2>검색 결과</h2>
    <table border="1">
        <tr>
            <th>제목</th>
            <th>작성자</th>
            <th>작성 날짜</th>
        </tr>
        <%
            String query = request.getParameter("query"); // 검색어 가져오기
            if (query != null && !query.trim().isEmpty()) {
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    // Oracle JDBC 드라이버 로드
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

                    // 완전 일치 검색어 우선, 그 다음 부분 일치 검색어
                    String sql = "SELECT post_id, title, user_id, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at " +
                                 "FROM posts WHERE title = ? " +
                                 "UNION ALL " +
                                 "SELECT post_id, title, user_id, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at " +
                                 "FROM posts WHERE title LIKE ? AND title != ? " +
                                 "ORDER BY 2";  // 'title'은 SELECT 목록에서 두 번째 항목

                    pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, query); // 완전 일치하는 제목
                    pstmt.setString(2, "%" + query + "%"); // 부분 일치하는 제목
                    pstmt.setString(3, query); // 중복 방지를 위해 완전 일치 제외

                    rs = pstmt.executeQuery();

                    // 결과 출력
                    if (!rs.isBeforeFirst()) {
                        out.println("<tr><td colspan='3'>검색 결과가 없습니다.</td></tr>");
                    } else {
                        while (rs.next()) {
                            int postId = rs.getInt("post_id");
                            String title = rs.getString("title");
                            String userId = rs.getString("user_id");
                            String createdAt = rs.getString("created_at");

                            out.println("<tr>");
                            out.println("<td><a href='view_register.jsp?postId=" + postId + "'>" + title + "</a></td>");
                            out.println("<td>" + userId + "</td>");
                            out.println("<td>" + createdAt + "</td>");
                            out.println("</tr>");
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace(); // 오류 로그 출력
                    out.println("<tr><td colspan='3'>오류가 발생했습니다: " + e.getMessage() + "</td></tr>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignore) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
                }
            } else {
                out.println("<tr><td colspan='3'>검색어를 입력해 주세요.</td></tr>");
            }
        %>
    </table>
</div>

</body>
</html>
