<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem, org.apache.commons.fileupload.disk.DiskFileItemFactory, org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 수정</title>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
    <h2>게시물 수정</h2>
    
    <%
        String postIdStr = request.getParameter("postId");

        if (postIdStr == null || postIdStr.isEmpty()) {
            out.println("<script>alert('유효하지 않은 게시물입니다.'); history.back();</script>");
            return;
        }

        int postId = Integer.parseInt(postIdStr);
        String title = null;
        String content = null;
        String image = null;

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

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

    <!-- 게시물 수정 폼 -->
    <form action="update_posts.jsp?postId=<%= postId %>" method="post" enctype="multipart/form-data">
        <label for="title">제목:</label>
        <input type="text" id="title" name="title" value="<%= title %>" required><br>

        <label for="content">내용:</label>
        <textarea id="content" name="content" required><%= content %></textarea><br>

        <label for="image">이미지 변경:</label>
        <input type="file" id="image" name="image" accept="image/*"><br>

        <% if (image != null && !image.isEmpty()) { %>
            <p>현재 이미지: <img src="uploads/<%= image %>" alt="게시물 이미지" style="max-width: 200px;"></p>
            <input type="hidden" name="currentImage" value="<%= image %>">
        <% } else { %>
            <p>이미지가 없습니다.</p>
        <% } %>

        <button type="submit" class="btn">수정</button>
    </form>
</div>

<%
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String uploadPath = application.getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        String newTitle = null;
        String newContent = null;
        String fileName = null;
        String currentImage = null;

        Connection connPost = null;
        PreparedStatement pstmtPost = null;

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    if (item.getFieldName().equals("title")) {
                        newTitle = item.getString("UTF-8");
                    } else if (item.getFieldName().equals("content")) {
                        newContent = item.getString("UTF-8");
                    } else if (item.getFieldName().equals("currentImage")) {
                        currentImage = item.getString("UTF-8");
                    }
                } else {
                    if (!item.getName().isEmpty()) {
                        fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile); // 파일 저장
                    }
                }
            }

            if (fileName == null) {
                fileName = currentImage; // 이미지가 변경되지 않은 경우 기존 이미지 사용
            }

            // Oracle JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");
            connPost = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            // 게시물 업데이트 쿼리
            String updateQuery = "UPDATE posts SET title = ?, content = ?, image = ? WHERE post_id = ?";
            pstmtPost = connPost.prepareStatement(updateQuery);
            pstmtPost.setString(1, newTitle);
            pstmtPost.setString(2, newContent);
            pstmtPost.setString(3, fileName);
            pstmtPost.setInt(4, postId);

            int result = pstmtPost.executeUpdate();

            if (result > 0) {
                response.sendRedirect("my_posts.jsp"); // 수정 성공 후 내 게시물 페이지로 이동
            } else {
                out.println("<script>alert('게시물 수정 실패'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('게시물 수정 실패: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            if (pstmtPost != null) try { pstmtPost.close(); } catch (SQLException ignore) {}
            if (connPost != null) try { connPost.close(); } catch (SQLException ignore) {}
        }
    }
%>

</body>
</html>
