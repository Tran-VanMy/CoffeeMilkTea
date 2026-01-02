<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="Modal.bean.User" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  ArrayList<User> users = (ArrayList<User>) request.getAttribute("users");
  if (users == null) users = new ArrayList<>();

  Object msg = request.getAttribute("msg");
  Object err = request.getAttribute("error");

  SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
  String ctx = request.getContextPath();
%>

<div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
  <div>
    <h4 class="fw-bold mb-0"><i class="bi bi-people me-2 text-primary"></i>Quản lý Users</h4>
    <div class="text-muted small mt-1">Xóa tài khoản (không đổi mật khẩu vì đã mã hóa)</div>
  </div>
  <a class="btn btn-outline-secondary btn-sm" href="<%=ctx%>/admin/dashboard">
    <i class="bi bi-arrow-left me-1"></i>Về Dashboard
  </a>
</div>

<% if (err != null) { %>
  <div class="alert alert-danger d-flex align-items-start gap-2">
    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
    <div><%= String.valueOf(err) %></div>
  </div>
<% } %>

<% if (msg != null) { %>
  <div class="alert alert-success d-flex align-items-start gap-2">
    <i class="bi bi-check-circle-fill fs-5"></i>
    <div><%= String.valueOf(msg) %></div>
  </div>
<% } %>

<div class="card shadow-sm border-0">
  <div class="card-body">
    <div class="table-responsive">
      <table class="table align-middle table-hover">
        <thead class="table-light">
          <tr>
            <th style="width:80px;">ID</th>
            <th>Họ tên</th>
            <th>Username</th>
            <th>Phone</th>
            <th>Email</th>
            <th style="width:110px;">Role</th>
            <th style="width:170px;">Created</th>
            <th style="width:120px;" class="text-end">Action</th>
          </tr>
        </thead>
        <tbody>
        <% if (users.isEmpty()) { %>
          <tr>
            <td colspan="8" class="text-center text-muted py-4">Chưa có user</td>
          </tr>
        <% } else { 
             for (User u : users) {
               boolean isAdmin = (u != null && u.isAdmin());
        %>
          <tr>
            <td class="fw-semibold"><%= u.getUserId() %></td>
            <td><%= u.getFullName() == null ? "" : u.getFullName() %></td>
            <td><%= u.getUsername() == null ? "" : u.getUsername() %></td>
            <td><%= u.getPhone() == null ? "" : u.getPhone() %></td>
            <td><%= u.getEmail() == null ? "" : u.getEmail() %></td>
            <td>
              <% if (isAdmin) { %>
                <span class="badge text-bg-dark"><i class="bi bi-shield-lock-fill me-1"></i>ADMIN</span>
              <% } else { %>
                <span class="badge text-bg-secondary">CUSTOMER</span>
              <% } %>
            </td>
            <td class="text-muted small">
              <%= (u.getCreatedAt() == null) ? "-" : sdf.format(u.getCreatedAt()) %>
            </td>
            <td class="text-end">
              <% if (isAdmin) { %>
                <button class="btn btn-sm btn-outline-secondary" disabled title="Không xóa ADMIN">
                  <i class="bi bi-lock-fill"></i>
                </button>
              <% } else { %>
                <a class="btn btn-sm btn-outline-danger"
                   href="<%=ctx%>/admin/users?action=delete&id=<%=u.getUserId()%>"
                   onclick="return confirm('Bạn chắc chắn muốn xóa user này? Nếu user đã có Orders thì DB có thể chặn xóa.');">
                  <i class="bi bi-trash"></i>
                </a>
              <% } %>
            </td>
          </tr>
        <% } } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
