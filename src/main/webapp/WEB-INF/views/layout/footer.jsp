<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

</div> <%-- container --%>

<footer class="cs-footer mt-5">
  <div class="container py-4">

    <div class="row g-4">
      <!-- Brand -->
      <div class="col-md-5">
        <div class="d-flex align-items-center gap-2 mb-2">
          <span class="cs-footer__logo"><i class="bi bi-cup-straw"></i></span>
          <div class="fw-bold fs-5 mb-0">MilkTeaShop</div>
        </div>

        <div class="text-white-50 small">
          Thức uống thơm ngon mỗi ngày — đặt nhanh, tuỳ chỉnh size/đường/đá/topping dễ dàng.
        </div>

        <div class="d-flex flex-wrap gap-2 mt-3">
          <span class="badge text-bg-light border cs-footer__badge">
            <i class="bi bi-lightning-charge-fill me-1"></i> Đặt nhanh
          </span>
          <span class="badge text-bg-light border cs-footer__badge">
            <i class="bi bi-shield-check me-1"></i> An toàn & tiện lợi
          </span>
        </div>
      </div>

      <!-- Quick links -->
      <div class="col-md-4">
        <div class="fw-bold mb-2">
          <i class="bi bi-link-45deg me-2"></i>Liên kết nhanh
        </div>

        <div class="d-flex flex-column gap-2 small">
          <a class="cs-footer__link" href="<%=request.getContextPath()%>/home">
            <i class="bi bi-cup-hot me-2"></i>Menu đồ uống
          </a>
          <a class="cs-footer__link" href="<%=request.getContextPath()%>/cart">
            <i class="bi bi-cart3 me-2"></i>Giỏ hàng
          </a>
          <a class="cs-footer__link" href="<%=request.getContextPath()%>/orders">
            <i class="bi bi-receipt-cutoff me-2"></i>Đơn hàng
          </a>
          <a class="cs-footer__link" href="<%=request.getContextPath()%>/admin/login">
            <i class="bi bi-shield-lock me-2"></i>Admin
          </a>
        </div>
      </div>

      <!-- Contact -->
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
            <i class="bi bi-clock"></i>
            <span>Giờ mở cửa: <b class="text-white">08:00 - 22:00</b></span>
          </div>

          <div class="d-flex align-items-center gap-2">
            <i class="bi bi-geo-alt"></i>
            <span>Khu vực: <b class="text-white">Giao nội thành</b></span>
          </div>
        </div>
      </div>
    </div>

    <hr class="cs-footer__hr my-3"/>

    <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 small">
      <div class="text-white-50">
        © <b class="text-white"><%=java.time.Year.now()%></b> MilkTeaShop. All rights reserved.
      </div>

      <div class="text-white-50 d-flex align-items-center gap-2">
        <i class="bi bi-heart-fill"></i>
        <span>Cảm ơn bạn đã ủng hộ!</span>
      </div>
    </div>

  </div>
</footer>

</body>
</html>
