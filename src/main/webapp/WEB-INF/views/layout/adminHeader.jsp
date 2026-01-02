<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modal.bean.User" %>
<%
  User a = (User) session.getAttribute("ADMIN");
  if (a == null || !a.isAdmin()) {
    response.sendRedirect(request.getContextPath() + "/admin/login");
    return;
  }

  // UI only: xác định menu đang active dựa theo URI hiện tại (không đổi logic nghiệp vụ)
  String uri = request.getRequestURI();
  String ctx = request.getContextPath();
  String path = (uri == null) ? "" : uri;

  boolean actDashboard  = path.contains("/admin/dashboard");
  boolean actCategories = path.contains("/admin/categories");
  boolean actProducts   = path.contains("/admin/products");
  boolean actToppings   = path.contains("/admin/toppings");
  boolean actVouchers   = path.contains("/admin/vouchers");
  boolean actOrders     = path.contains("/admin/orders");
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Admin - MilkTeaShop</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

  <!-- Admin UI CSS -->
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-shell-ui.css">

  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-dashboard-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-categories-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-products-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-toppings-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-vouchers-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-orders-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/admin-order-detail-ui.css">
  <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/admin-footer-ui.css">
  
</head>

<body class="bg-light">

<!-- Admin Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark admin-nav shadow-sm">
  <div class="container">
    <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="<%=ctx%>/admin/dashboard">
      <span class="admin-brand__logo"><i class="bi bi-shield-lock-fill"></i></span>
      <span>MilkTeaShop <span class="text-white-50 fw-semibold">Admin</span></span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="adminNav">

      <ul class="navbar-nav me-auto gap-lg-1 mt-3 mt-lg-0">
        <li class="nav-item">
          <a class="nav-link admin-link <%= actDashboard ? "active" : "" %>" href="<%=ctx%>/admin/dashboard">
            <i class="bi bi-speedometer2 me-2"></i>Dashboard
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link admin-link <%= actCategories ? "active" : "" %>" href="<%=ctx%>/admin/categories">
            <i class="bi bi-tags me-2"></i>Categories
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link admin-link <%= actProducts ? "active" : "" %>" href="<%=ctx%>/admin/products">
            <i class="bi bi-cup-hot me-2"></i>Products
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link admin-link <%= actToppings ? "active" : "" %>" href="<%=ctx%>/admin/toppings">
            <i class="bi bi-plus-circle-dotted me-2"></i>Toppings
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link admin-link <%= actVouchers ? "active" : "" %>" href="<%=ctx%>/admin/vouchers">
            <i class="bi bi-ticket-perforated me-2"></i>Vouchers
          </a>
        </li>

        <li class="nav-item">
          <a class="nav-link admin-link <%= actOrders ? "active" : "" %>" href="<%=ctx%>/admin/orders">
            <i class="bi bi-receipt-cutoff me-2"></i>Orders
          </a>
        </li>
      </ul>

      <div class="d-flex align-items-center gap-2 ms-lg-2 pb-3 pb-lg-0">
        <div class="dropdown">
          <button class="btn btn-light btn-sm dropdown-toggle admin-userbtn" type="button" data-bs-toggle="dropdown">
            <i class="bi bi-person-circle me-1"></i>
            <span class="fw-semibold"><%=a.getFullName()%></span>
          </button>

          <ul class="dropdown-menu dropdown-menu-end shadow-sm">
            <li class="dropdown-header text-muted small">
              <i class="bi bi-shield-check me-1"></i> Quản trị viên
            </li>
            <li><hr class="dropdown-divider"></li>
            <li>
              <a class="dropdown-item" href="<%=ctx%>/admin/dashboard">
                <i class="bi bi-house-door me-2"></i>Về Dashboard
              </a>
            </li>
            <li>
              <a class="dropdown-item" href="<%=ctx%>/home">
                <i class="bi bi-box-arrow-up-right me-2"></i>Mở trang khách
              </a>
            </li>
          </ul>
        </div>

        <a class="btn btn-outline-light btn-sm admin-logout" href="<%=ctx%>/admin/logout">
          <i class="bi bi-box-arrow-right me-1"></i>Logout
        </a>
      </div>

    </div>
  </div>
</nav>

<!-- Page container: giữ nguyên để các page include adminHeader không bị vỡ layout -->
<div class="container my-3">
