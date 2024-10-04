<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%
    // POST 요청인지 확인
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String userId = (String) session.getAttribute("user_id"); // 현재 로그인된 사용자 ID
        String commentContent = request.getParameter("commentContent");
        String postIdStr = request.getParameter("postId");

        // 필수 값 확인
        if (userId == null || userId.isEmpty()) {
            out.println("<script>alert('로그인이 필요합니다.'); window.location.href = 'login.jsp';</script>");
            return;
        }
        if (commentContent == null || commentContent.isEmpty() || postIdStr == null || postIdStr.isEmpty()) {
            out.println("<script>alert('댓글 내용이 비어 있습니다.'); history.back();</script>");
            return;
        }

        int postId = Integer.parseInt(postIdStr);

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 데이터베이스 연결
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

            // 댓글 저장 쿼리
            // 댓글 저장 쿼리 (COMMENT_ID에 시퀀스 값을 삽입)
			String query = "INSERT INTO comments (comment_id, post_id, user_id, content, created_at) VALUES (comment_seq.NEXTVAL, ?, ?, ?, SYSDATE)";
			pstmt = conn.prepareStatement(query);
			pstmt.setInt(1, postId);
			pstmt.setString(2, userId);
			pstmt.setString(3, commentContent);


            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("view_register.jsp?postId=" + postId); // 댓글 작성 성공 시 게시물 상세 페이지로 이동
            } else {
                out.println("<script>alert('댓글 작성 실패'); history.back();</script>");
            }

        } catch (Exception e) {
            e.printStackTrace(); // 서버 로그에 스택 트레이스 출력
            out.println("<pre>"); // 예외 메시지를 HTML에 출력
            e.printStackTrace(new java.io.PrintWriter(out));
            out.println("</pre>");
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignore) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignore) {}
        }
    }
%>
