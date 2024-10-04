<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%@ page import="java.io.File, java.io.IOException, java.util.List" %>
<%@ page import="org.apache.commons.fileupload.FileItem, org.apache.commons.fileupload.disk.DiskFileItemFactory, org.apache.commons.fileupload.servlet.ServletFileUpload" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>게시물 저장</title>
</head>
<body>
<%
    // POST 요청일 경우만 처리
    if (request.getMethod().equalsIgnoreCase("POST")) {
        // 파일이 저장될 경로 지정 (서버의 실제 경로)
        String uploadPath = application.getRealPath("/") + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // uploads 폴더가 없을 경우 생성
        }

        String title = null;
        String content = null;
        String userId = (String) session.getAttribute("user_id");
        String fileName = null;

        Connection conn = null;
        PreparedStatement pstmt = null;

        // 파일 처리 객체 준비
        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        try {
            // Oracle JDBC 드라이버 로드
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // DB 연결
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            // 폼 데이터를 처리 (파일 및 일반 데이터)
            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                if (item.isFormField()) {
                    // 일반 폼 필드 처리
                    if (item.getFieldName().equals("title")) {
                        title = item.getString("UTF-8");
                    } else if (item.getFieldName().equals("content")) {
                        content = item.getString("UTF-8");
                    }
                } else {
                    // 파일 처리
                    if (!item.getName().isEmpty()) {
                        fileName = new File(item.getName()).getName();
                        String filePath = uploadPath + File.separator + fileName;
                        File storeFile = new File(filePath);
                        item.write(storeFile); // 파일 저장
                        out.println("파일 저장 경로: " + filePath + "<br>"); // 로그 출력
                    }
                }
            }

            // 로그 출력 (타이틀, 콘텐츠, 파일명)
            out.println("타이틀: " + title + "<br>");
            out.println("내용: " + content + "<br>");
            out.println("파일명: " + fileName + "<br>");

            // 파일 업로드 또는 게시물 등록 시 오류 확인
            if (title == null || content == null || title.isEmpty() || content.isEmpty()) {
                out.println("<script>alert('제목과 내용을 입력하세요.'); history.back();</script>");
            } else {
                // 게시물 저장 쿼리 실행
                String query = "INSERT INTO posts (title, content, user_id, image) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, title);
                pstmt.setString(2, content);
                pstmt.setString(3, userId);
                pstmt.setString(4, fileName != null ? "uploads/" + fileName : null);

                int result = pstmt.executeUpdate();

                if (result > 0) {
                    response.setContentType("text/html; charset=UTF-8");
                    out.println("<script>alert('게시물 등록 성공!'); window.location.href = 'index.jsp';</script>");
                } else {
                    out.println("<script>alert('게시물 등록 실패: 데이터베이스에 저장되지 않았습니다.'); history.back();</script>");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<script>alert('게시물 등록 실패: " + e.getMessage() + "'); history.back();</script>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>
</body>
</html>
