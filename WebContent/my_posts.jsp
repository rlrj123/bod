<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>내 게시물</title>
    <link rel="stylesheet" href="css/style.css">
    <script>
        function deletePost(postId) {
            if (confirm("정말로 이 게시물을 삭제하시겠습니까?")) {
                window.location.href = 'delete_posts.jsp?postId=' + postId;
            }
        }

        // 게시물 작성 폼을 보여주는 함수
        function showPostForm() {
            document.getElementById("postForm").style.display = "flex"; // 모달창을 화면에 표시
        }

        // 게시물 작성 폼을 숨기는 함수
        function hidePostForm() {
            document.getElementById("postForm").style.display = "none"; // 모달창을 숨김
        }
    </script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <h2>내가 작성한 게시물</h2>

    <!-- 게시물 작성 버튼 (크기 줄이고 왼쪽 정렬) -->
    <div class="post-button" style="text-align: left; margin-bottom: 20px;">
        <button class="btn small-btn" onclick="showPostForm()">게시물 작성</button>
    </div>

    <!-- 게시물 목록 -->
    <div class="posts-list">
        <table>
            <tr>
                <th>제목</th>
                <th>작성 날짜</th>
                <th>수정</th>
                <th>삭제</th>
            </tr>
            <%
                String userId = (String) session.getAttribute("user_id");
                if (userId != null) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        Class.forName("oracle.jdbc.driver.OracleDriver");
                        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

                        // 게시물 조회 쿼리
                        String query = "SELECT post_id, title, TO_CHAR(created_at, 'YYYY-MM-DD') AS created_at FROM posts WHERE user_id = ? ORDER BY created_at DESC";
                        pstmt = conn.prepareStatement(query);
                        pstmt.setString(1, userId);
                        rs = pstmt.executeQuery();

                        // 결과 출력
                        while (rs.next()) {
                            int postId = rs.getInt("post_id");
                            String title = rs.getString("title");
                            String createdAt = rs.getString("created_at");
            %>
                            <tr>
                                <td><a href="view_register.jsp?postId=<%= postId %>"><%= title %></a></td>
                                <td><%= createdAt %></td>
                                <td><a href="update_posts.jsp?postId=<%= postId %>" class="btn">수정</a></td>
                                <td><a href="javascript:void(0);" class="btn" onclick="deletePost(<%= postId %>)">삭제</a></td>
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
                } else {
                    out.println("<p>로그인된 상태가 아닙니다.</p>");
                }
            %>
        </table>
    </div>

    <!-- 게시물 작성 화면 (모달) -->
    <div id="postForm" class="post-form-overlay" style="display:none;">
        <div class="post-form">
            <button class="close-btn" onclick="hidePostForm()">X</button>
            <h3>게시물 작성</h3>
            <form action="save_posts.jsp" method="post" enctype="multipart/form-data">
                <label for="title">제목:</label>
                <input type="text" id="title" name="title" required><br>
                <label for="content">내용:</label>
                <textarea id="content" name="content" rows="5" required></textarea><br>
                <label for="image">이미지 첨부:</label>
                <input type="file" id="image" name="image" accept="image/*"><br>
                <button type="submit" class="btn">등록</button>
            </form>
        </div>
    </div>

</div>

</body>
</html>
