<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>로그인</title>
</head>
<body>
    <h2>로그인</h2>
    <form action="login_register.jsp" method="post" accept-charset="UTF-8">
        <label>아이디:</label><input type="text" name="user_id" maxlength="8" required><br>
        <label>비밀번호:</label><input type="password" name="password" maxlength="12" required><br>
        <input type="submit" value="로그인">
    </form>
</body>
</html>
