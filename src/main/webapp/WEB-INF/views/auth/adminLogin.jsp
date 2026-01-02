<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin Login</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5" style="max-width:520px;">
  <div class="card shadow-sm">
    <div class="card-header bg-dark text-white text-center">
      <b>🔐 ADMIN LOGIN</b>
    </div>
    <div class="card-body">

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%=request.getAttribute("error")%></div>
      <% } %>

      <form action="<%=request.getContextPath()%>/admin/login" method="post">
        <div class="mb-3">
          <label class="form-label">Username</label>
          <input class="form-control" name="username" required>
        </div>
        <div class="mb-3">
          <label class="form-label">Password</label>
          <input class="form-control" type="password" name="pass" required>
        </div>
        <button class="btn btn-dark w-100">Login</button>
      </form>

      <div class="text-center mt-3">
        <a href="<%=request.getContextPath()%>/home">← Quay lại trang bán hàng</a>
      </div>
    </div>
  </div>
</div>

</body>
</html>