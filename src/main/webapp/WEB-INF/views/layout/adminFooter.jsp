<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

</div> <%-- container --%>

<footer class="admin-footer mt-5">
  <div class="container py-4">

    <div class="row g-3 align-items-start">
      <div class="col-md-5">
        <div class="d-flex align-items-center gap-2 mb-2">
          <span class="admin-footer__logo"><i class="bi bi-shield-lock-fill"></i></span>
          <div class="fw-bold">MilkTeaShop Admin</div>
        </div>

        <div class="text-white-50 small">
          Khu vực quản trị hệ thống: sản phẩm, danh mục, topping, voucher và đơn hàng.
        </div>

        <div class="d-flex flex-wrap gap-2 mt-3">
          <span class="badge text-bg-light border admin-footer__badge">
            <i class="bi bi-shield-check me-1"></i> Secure
          </span>
          <span class="badge text-bg-light border admin-footer__badge">
            <i class="bi bi-clock-history me-1"></i> System update
          </span>
        </div>
      </div>

      <div class="col-md-4">
        <div class="fw-bold mb-2">
          <i class="bi bi-link-45deg me-2"></i>Truy cập nhanh
        </div>

        <div class="d-flex flex-column gap-2 small">
          <a class="admin-footer__link" href="<%=request.getContextPath()%>/admin/dashboard">
            <i class="bi bi-speedometer2 me-2"></i>Dashboard
          </a>
          <a class="admin-footer__link" href="<%=request.getContextPath()%>/admin/products">
            <i class="bi bi-cup-hot me-2"></i>Products
          </a>
          <a class="admin-footer__link" href="<%=request.getContextPath()%>/admin/orders">
            <i class="bi bi-receipt-cutoff me-2"></i>Orders
          </a>
          <a class="admin-footer__link" href="<%=request.getContextPath()%>/home">
            <i class="bi bi-box-arrow-up-right me-2"></i>Mở trang khách
          </a>
        </div>
      </div>

      <div class="col-md-3">
        <div class="fw-bold mb-2">
          <i class="bi bi-headset me-2"></i>Hỗ trợ
        </div>

        <div class="text-white-50 small">
          <div class="d-flex align-items-center gap-2 mb-2">
            <i class="bi bi-telephone"></i>
            <span>Hotline: <b class="text-white">0123 456 789</b></span>
          </div>

          <div class="d-flex align-items-center gap-2 mb-2">
            <i class="bi bi-envelope"></i>
            <span>Email: <b class="text-white">support@milkteashop.local</b></span>
          </div>

          <div class="d-flex align-items-center gap-2">
            <i class="bi bi-geo-alt"></i>
            <span>Khu vực: <b class="text-white">Admin Panel</b></span>
          </div>
        </div>
      </div>
    </div>

    <hr class="admin-footer__hr my-3"/>

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 small">
      <div class="text-white-50">
        © <b class="text-white"><%=java.time.Year.now()%></b> MilkTeaShop. All rights reserved.
      </div>

      <div class="text-white-50 d-flex align-items-center gap-2">
        <i class="bi bi-info-circle"></i>
        <span>Phiên bản giao diện: <b class="text-white">UI Pro</b></span>
      </div>
    </div>

  </div>
</footer>

</body>
</html>

