<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>회원가입</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="auth-container">
        <h2>Sign Up</h2>
        <p class="subtext">Fill in your details to create an account</p>
        <form action="sign_register.jsp" method="post" accept-charset="UTF-8">
            <div class="form-group">
                <input type="text" id="user_id" name="user_id" maxlength="8" placeholder="Choose a username" required>
            </div>
            <div class="form-group">
                <input type="password" id="password" name="password" maxlength="12" placeholder="Create a password" required 
                       pattern="[A-Za-z0-9]+" title="비밀번호는 영어와 숫자만 입력 가능합니다.">
            </div>
            <input type="submit" class="btn btn-primary" value="Sign Up">
        </form>
        <p class="footer-text">Already have an account? <a href="login.jsp">Log in now</a></p>
    </div>
</body>
</html>
