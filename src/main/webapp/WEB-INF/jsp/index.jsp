<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%
String errorMessage = (String) request.getAttribute("errorMessage");
String successMessage = (String) request.getAttribute("successMessage");
String mobileNo = (String) request.getAttribute("mobileNo");
if (mobileNo == null) {
    mobileNo = "";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Restaurant Login</title>
  <link rel="stylesheet" href="/css/bootstrap5.min.css">
  <style>
    :root {
      --purple-50: #f6f2ff;
      --purple-200: #d9cbff;
      --purple-500: #7b4dff;
      --purple-600: #673de6;
      --purple-700: #5b35ce;
      --text-700: #2f2b3d;
      --text-500: #6e6487;
    }

    body {
      margin: 0;
      min-height: 100vh;
      position: relative;
      background-color: #1f1537;
      background-image: url("/images/auth-theme.jpeg");
      background-size: cover;
      background-position: center;
      background-repeat: no-repeat;
      font-family: Arial, sans-serif;
      display: flex;
      align-items: center;
      justify-content: flex-end;
      padding: 20px 5vw;
    }

    body::before {
      content: "";
      position: fixed;
      inset: 0;
      background: rgba(35, 22, 64, 0.58);
      z-index: 0;
    }

    .auth-wrap {
      width: 100%;
      max-width: 430px;
      background: #ffffff;
      border: 1px solid var(--purple-200);
      border-radius: 10px;
      padding: 20px;
      box-shadow: 0 10px 24px rgba(103, 61, 230, 0.14);
      position: relative;
      z-index: 1;
      backdrop-filter: blur(1px);
    }

    .auth-title {
      margin: 0 0 4px;
      font-size: 22px;
      font-weight: 700;
      color: var(--purple-700);
    }

    .auth-subtitle {
      margin: 0 0 16px;
      color: var(--text-500);
      font-size: 14px;
    }

    .form-label {
      color: var(--text-700);
      font-weight: 600;
    }

    .form-control {
      border-color: #d4cde8;
    }

    .form-control:focus {
      border-color: var(--purple-500);
      box-shadow: 0 0 0 0.2rem rgba(123, 77, 255, 0.2);
    }

    .btn.btn-primary {
      background-color: var(--purple-600);
      border-color: var(--purple-600);
      font-weight: 600;
    }

    .btn.btn-primary:hover,
    .btn.btn-primary:focus {
      background-color: var(--purple-700);
      border-color: var(--purple-700);
    }

    a {
      color: var(--purple-600);
      text-decoration: none;
      font-weight: 600;
    }

    a:hover {
      color: var(--purple-700);
      text-decoration: underline;
    }

    @media (max-width: 768px) {
      body {
        justify-content: center;
        padding: 14px;
      }
    }
  </style>
</head>
<body>
  <div class="auth-wrap">
    <h1 class="auth-title">Restaurant Login</h1>
    <br>

    <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
      <div class="alert alert-danger py-2" role="alert"><%= HtmlUtils.htmlEscape(errorMessage) %></div>
    <% } %>
    <% if (successMessage != null && !successMessage.trim().isEmpty()) { %>
      <div class="alert alert-success py-2" role="alert"><%= HtmlUtils.htmlEscape(successMessage) %></div>
    <% } %>

    <form action="/login" method="post" autocomplete="off">
      <div class="mb-3">
        <label for="mobileNo" class="form-label">Mobile Number</label>
        <input type="text"
               class="form-control"
               id="mobileNo"
               name="mobileNo"
               <%--value="<%= HtmlUtils.htmlEscape(mobileNo) %>"--%>
               maxlength="15"
               inputmode="numeric"
               pattern="[0-9]{10,15}"
               placeholder="Enter mobile number"
               value="9666705710"
               required>
      </div>
      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password"
               class="form-control"
               id="password"
               name="password"
               placeholder="Enter password"
               value="Amma@143"
               required>
      </div>
      <div class="d-flex justify-content-end mb-3">
        <a href="/forgot-password">Forgot password?</a>
      </div>
      <button type="submit" class="btn btn-primary w-100">Login</button>
    </form>

    <p class="text-center mt-3 mb-0">
      New restaurant? <a href="/signup">Create account</a>
    </p>
  </div>
</body>
</html>
