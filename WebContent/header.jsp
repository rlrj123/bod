<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Header</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <nav class="header-nav">
            <div class="logo">
                <a href="index.jsp">MyBoard</a> <!-- Home으로 이동 -->
            </div>

            <div class="right-nav">
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <%
                        // 로그인 상태 확인
                        if (session.getAttribute("user_id") != null) {
                    %>
                        <li><a href="my_posts.jsp">내 글</a></li> <!-- 내 글로 이동 -->
                        <li><a href="logout.jsp">로그아웃</a></li> <!-- 로그아웃 -->
                    <%
                        } else {
                    %>
                        <li><a href="login.jsp">로그인</a></li>
                        <li><a href="sign.jsp">회원가입</a></li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </nav>
        
        <!-- 검색 기능을 MyBoard 아래로 이동하고, 크기 조정 -->
        <div class="search-bar" style="margin-top: 20px; text-align: left;">
            <form action="search.jsp" method="get">
                <input type="text" name="query" placeholder="Search..." required style="width: 250px;"> <!-- 너비 250px로 조정 -->
                <button type="submit">검색</button>
            </form>
        </div>
    </header>
</body>
</html>
