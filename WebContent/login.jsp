<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>로그인</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <h2>Log In</h2>
        <p class="subtext">Enter your details to log in to your account</p>
        <form action="login_register.jsp" method="post" accept-charset="UTF-8">
            <div class="form-group">
                <input type="text" id="user_id" name="user_id" maxlength="8" placeholder="Enter your username" required>
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" maxlength="12" placeholder="Enter your password" required>
            </div>
            <input type="submit" class="btn btn-primary" value="Log In">
        </form>
        <p class="footer-text">Don't have an account? <a href="sign.jsp">Sign up now</a></p>
    </div>
</body>
</html>
