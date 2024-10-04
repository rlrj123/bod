<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException, java.sql.Timestamp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>�Խù� ���</title>
</head>
<body>
    <h2>�Խù� ���</h2>
    <table border="1">
        <tr>
            <th>��ȣ</th>
            <th>����</th>
            <th>�ۼ���</th>
            <th>�ۼ���</th>
        </tr>
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Oracle JDBC ����̹� �ε�
                Class.forName("oracle.jdbc.driver.OracleDriver");

                // �����ͺ��̽� ����
                conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "system", "1234");

                // �Խù� ��� ��ȸ ����
                String query = "SELECT p.post_id, p.title, p.user_id, p.created_at FROM posts p ORDER BY p.created_at DESC";
                pstmt = conn.prepareStatement(query);
                rs = pstmt.executeQuery();

                // ��� ���
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
