<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Modal.bean.User"%>
<%@ page import="Modal.bean.Cart"%>
<%@ page import="Modal.bo.FavoriteBO"%>

<%
    User u = (User) session.getAttribute("USER");
    Cart cart = (Cart) session.getAttribute("CART");
    int cartCount = (cart == null || cart.getItems() == null) ? 0 : cart.getItems().size();

    int favCount = 0;
    if (u != null) {
        try {
            FavoriteBO fbo = new FavoriteBO();
            favCount = fbo.countByUser(u.getUserId());
        } catch (Exception ignored) {}
    }

    String ctx = request.getContextPath();
    String uri = request.getRequestURI();
%>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Coffee & Milk Tea</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Bootstrap Icons -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

  <link rel="stylesheet" href="<%=ctx%>/assets/css/menu-pro.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/header-pro.css">

  <link rel="stylesheet" href="<%=ctx%>/assets/css/product-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/orders-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/order-detail-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/checkout-ui.css">
  <link rel="stylesheet" href="<%=ctx%>/assets/css/customer-footer-ui.css">
</head>

<body class="bg-light">

  <div class="topbar d-none d-lg-block">
    <div class="container d-flex align-items-center justify-content-between">
      <div class="topbar__left">
        <i class="bi bi-geo-alt"></i>
        <span class="ms-1">MilkTeaShop • Giao nhanh 5–10 phút</span>
      </div>
      <div class="topbar__right d-flex align-items-center gap-3">
        <span><i class="bi bi-shield-check"></i> An toàn</span>
        <span><i class="bi bi-cup-hot"></i> Fresh mỗi ngày</span>
        <span><i class="bi bi-headset"></i> Hỗ trợ 24/7</span>
      </div>
    </div>
  </div>

  <nav class="navbar navbar-expand-lg navbar-dark sticky-top nav-pro">
    <div class="container">

      <a class="navbar-brand d-flex align-items-center gap-2 fw-bold" href="<%=ctx%>/home">
        <span class="brand-badge"><i class="bi bi-cup-hot-fill"></i></span>
        <span>MilkTeaShop</span>
      </a>

      <div class="d-flex align-items-center gap-2 d-lg-none">
        <% if (u != null) { %>
          <a class="btn btn-sm btn-outline-light position-relative" href="<%=ctx%>/favorites" aria-label="Favorites">
            <i class="bi bi-heart"></i>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark">
              <%=favCount%>
            </span>
          </a>
        <% } %>

        <a class="btn btn-sm btn-outline-light position-relative" href="<%=ctx%>/cart" aria-label="Cart">
          <i class="bi bi-bag"></i>
          <% if (cartCount > 0) { %>
            <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark">
              <%=cartCount%>
            </span>
          <% } %>
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#nav">
          <span class="navbar-toggler-icon"></span>
        </button>
      </div>

      <div class="collapse navbar-collapse" id="nav">

        <form class="ms-lg-3 my-3 my-lg-0 nav-search" action="<%=ctx%>/home" method="get" role="search">
          <div class="input-group input-group-sm">
            <span class="input-group-text bg-transparent text-white-50 border-0">
              <i class="bi bi-search"></i>
            </span>
            <input class="form-control bg-transparent text-white border-0 shadow-none"
                   type="text" name="q" placeholder="Tìm đồ uống, topping, ...">
            <button class="btn btn-warning fw-semibold" type="submit">
              Tìm
            </button>
          </div>
        </form>

        <ul class="navbar-nav ms-auto align-items-lg-center gap-lg-1">

          <li class="nav-item">
            <a class="nav-link <%= (uri != null && uri.contains("/home")) ? "active" : "" %>" href="<%=ctx%>/home">
              <i class="bi bi-house-door me-1"></i> Trang chủ
            </a>
          </li>

          <% if (u != null) { %>
          <li class="nav-item">
            <a class="nav-link <%= (uri != null && uri.contains("/orders")) ? "active" : "" %>" href="<%=ctx%>/orders">
              <i class="bi bi-receipt me-1"></i> Đơn hàng
            </a>
          </li>

          <!-- ✅ Favorites -->
          <li class="nav-item">
            <a class="nav-link <%= (uri != null && uri.contains("/favorites")) ? "active" : "" %>" href="<%=ctx%>/favorites">
              <i class="bi bi-heart me-1"></i> Yêu thích
              <span class="badge rounded-pill bg-warning text-dark ms-1"><%=favCount%></span>
            </a>
          </li>
          <% } %>

          <li class="nav-item d-none d-lg-block">
            <a class="btn btn-sm btn-outline-light ms-lg-2 position-relative" href="<%=ctx%>/cart">
              <i class="bi bi-bag me-1"></i> Giỏ hàng
              <% if (cartCount > 0) { %>
                <span class="badge rounded-pill bg-warning text-dark ms-1"><%=cartCount%></span>
              <% } else { %>
                <span class="badge rounded-pill bg-light text-dark ms-1">0</span>
              <% } %>
            </a>
          </li>

          <% if (u == null) { %>
            <li class="nav-item ms-lg-2">
              <a class="nav-link <%= (uri != null && uri.contains("/login")) ? "active" : "" %>" href="<%=ctx%>/login">
                <i class="bi bi-box-arrow-in-right me-1"></i> Đăng nhập
              </a>
            </li>
            <li class="nav-item">
              <a class="btn btn-sm btn-warning fw-semibold ms-lg-1" href="<%=ctx%>/register">
                <i class="bi bi-person-plus me-1"></i> Đăng ký
              </a>
            </li>
          <% } else { %>
            <li class="nav-item dropdown ms-lg-2">
              <a class="nav-link dropdown-toggle d-flex align-items-center gap-2" href="#" role="button" data-bs-toggle="dropdown">
                <span class="user-avatar"><i class="bi bi-person-fill"></i></span>
                <span class="d-none d-lg-inline">
                  <span class="text-white-50 small d-block lh-1">Xin chào</span>
                  <span class="fw-semibold"><%=u.getFullName()%></span>
                </span>
              </a>
              <ul class="dropdown-menu dropdown-menu-end shadow-sm">
                <li>
                  <h6 class="dropdown-header">
                    <i class="bi bi-person-badge me-2"></i>Tài khoản
                  </h6>
                </li>
                <li>
                  <a class="dropdown-item" href="<%=ctx%>/orders">
                    <i class="bi bi-receipt me-2"></i>Đơn hàng của tôi
                  </a>
                </li>
                <li><hr class="dropdown-divider"></li>
                <li>
                  <a class="dropdown-item text-danger" href="<%=ctx%>/logout">
                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                  </a>
                </li>
              </ul>
            </li>
          <% } %>

          <li class="nav-item ms-lg-2">
            <a class="nav-link admin-link <%= (uri != null && uri.contains("/admin")) ? "active" : "" %>"
               href="<%=ctx%>/admin/login">
              <i class="bi bi-shield-lock-fill me-1"></i> Admin
            </a>
          </li>

        </ul>
      </div>
    </div>
  </nav>

  <div class="container my-4">
