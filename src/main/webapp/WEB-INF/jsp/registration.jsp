<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<%
String errorMessage = (String) request.getAttribute("errorMessage");
String mobileNo = (String) request.getAttribute("mobileNo");
String email = (String) request.getAttribute("email");
String restaurantName = (String) request.getAttribute("restaurantName");
if (mobileNo == null) {
    mobileNo = "";
}
if (email == null) {
    email = "";
}
if (restaurantName == null) {
    restaurantName = "";
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="ISO-8859-1">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Restaurant Signup</title>
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
      max-width: 460px;
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
    <h1 class="auth-title">Restaurant Signup</h1>
    <br>
    <% if (errorMessage != null && !errorMessage.trim().isEmpty()) { %>
      <div class="alert alert-danger py-2" role="alert"><%= HtmlUtils.htmlEscape(errorMessage) %></div>
    <% } %>

    <form action="/signup" method="post" autocomplete="off">
      <div class="mb-3">
        <label for="mobileNo" class="form-label">Mobile Number</label>
        <input type="text"
               class="form-control"
               id="mobileNo"
               name="mobileNo"
               value="<%= HtmlUtils.htmlEscape(mobileNo) %>"
               maxlength="15"
               inputmode="numeric"
               pattern="[0-9]{10,15}"
               placeholder="Enter mobile number"
               required>
      </div>

      <div class="mb-3">
        <label for="email" class="form-label">Email</label>
        <input type="email"
               class="form-control"
               id="email"
               name="email"
               value="<%= HtmlUtils.htmlEscape(email) %>"
               placeholder="Enter email"
               required>
      </div>

      <div class="mb-3">
        <label for="restaurantName" class="form-label">Restaurant Name</label>
        <input type="text"
               class="form-control"
               id="restaurantName"
               name="restaurantName"
               value="<%= HtmlUtils.htmlEscape(restaurantName) %>"
               placeholder="Enter restaurant name"
               required>
      </div>

      <div class="mb-3">
        <label for="password" class="form-label">Password</label>
        <input type="password"
               class="form-control"
               id="password"
               name="password"
               placeholder="Enter password"
               required>
      </div>

      <button type="submit" class="btn btn-primary w-100">Signup</button>
    </form>

    <p class="text-center mt-3 mb-0">
      Already registered? <a href="/login">Login</a>
    </p>
  </div>
</body>
</html>
