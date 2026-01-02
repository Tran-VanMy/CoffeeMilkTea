<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Cart" %>
<%@ page import="Modal.bean.CartItem" %>
<%@ page import="Modal.bean.Voucher" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  Cart cart = (Cart) request.getAttribute("cart");
  Voucher voucher = (Voucher) request.getAttribute("voucher");
  String voucherError = (String) request.getAttribute("voucherError");
  Long discount = (Long) request.getAttribute("discount");
  if (discount == null) discount = 0L;

  String error = (String) request.getAttribute("error");
%>

<!-- Hero -->
<div class="ck-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="ck-hero__icon"><i class="bi bi-credit-card-2-front-fill"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Checkout</h4>
        <div class="text-white-50 small">Nhập thông tin nhận hàng và xác nhận đặt hàng</div>
      </div>
    </div>

    <div class="d-flex align-items-center gap-2">
      <a class="btn btn-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/cart">
        <i class="bi bi-arrow-left me-1"></i> Quay lại giỏ
      </a>
      <a class="btn btn-outline-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/home">
        <i class="bi bi-cup-straw me-1"></i> Menu
      </a>
    </div>
  </div>
</div>

<% if (error != null) { %>
  <div class="alert alert-danger d-flex align-items-start gap-2">
    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
    <div><%=error%></div>
  </div>
<% } %>

<div class="row g-3">
  <!-- LEFT: Shipping info -->
  <div class="col-lg-7">
    <div class="card shadow-sm border-0 ck-card">
      <div class="card-body">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
          <h5 class="fw-bold mb-0">
            <i class="bi bi-truck me-2 text-primary"></i>Thông tin nhận hàng
          </h5>
          <span class="badge text-bg-light border">
            <i class="bi bi-shield-check me-1"></i> Bảo mật
          </span>
        </div>

        <!-- LOGIC giữ nguyên: action checkout POST, fields name như cũ -->
        <form action="<%=request.getContextPath()%>/checkout" method="post">
          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-person-fill me-1"></i> Họ tên người nhận *
            </label>
            <input class="form-control" name="receiverName" required/>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-telephone-fill me-1"></i> Số điện thoại *
            </label>
            <input class="form-control" name="receiverPhone" required/>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-geo-alt-fill me-1"></i> Địa chỉ *
            </label>
            <input class="form-control" name="receiverAddress" required/>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-chat-left-text-fill me-1"></i> Ghi chú
            </label>
            <textarea class="form-control" name="note" rows="2" placeholder="VD: Giao giờ hành chính, gọi trước khi đến..."></textarea>
          </div>

          <button class="btn btn-primary w-100">
            <i class="bi bi-bag-check me-1"></i> Xác nhận đặt hàng
          </button>

          <div class="small text-muted mt-3 d-flex align-items-start gap-2">
            <i class="bi bi-lock-fill mt-1"></i>
            <div>Thông tin của bạn chỉ được dùng để xử lý đơn hàng.</div>
          </div>
        </form>
      </div>
    </div>
  </div>

  <!-- RIGHT: Order summary -->
  <div class="col-lg-5">
    <div class="ck-sticky">
      <div class="card shadow-sm border-0 ck-card">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-receipt-cutoff me-2 text-primary"></i>Đơn hàng
            </h5>
            <span class="badge text-bg-light border">
              <i class="bi bi-list-check me-1"></i> Tóm tắt
            </span>
          </div>

          <ul class="list-group mb-3 ck-list">
            <% for (CartItem it : cart.getItems()) { %>
              <li class="list-group-item d-flex justify-content-between align-items-start gap-3">
                <div class="d-flex align-items-start gap-3">
                  <div class="ck-item__thumb"><i class="bi bi-cup-hot-fill"></i></div>

                  <div class="min-w-0">
                    <div class="fw-bold text-truncate"><%=it.getProductName()%></div>

                    <div class="text-muted small mt-1 d-flex flex-column gap-1">
                      <div><i class="bi bi-arrows-angle-expand me-1"></i>Size: <b><%=it.getSize()%></b></div>
                      <div><i class="bi bi-droplet-half me-1"></i>Đường: <b><%=it.getSugar()%>%</b></div>
                      <div><i class="bi bi-snow2 me-1"></i>Đá: <b><%=it.getIce()%>%</b></div>

                      <!-- ✅ THÊM HIỂN THỊ TOPPING (UI) -->
                      <div>
                        <i class="bi bi-plus-circle-dotted me-1"></i>Topping:
                        <span class="ms-1">
                          <%= (it.getToppingNames() == null || it.getToppingNames().isEmpty())
                                ? "Không"
                                : String.join(", ", it.getToppingNames()) %>
                        </span>
                      </div>

                      <div>Số lượng: <b><%=it.getQuantity()%></b></div>
                    </div>
                  </div>
                </div>

                <div class="fw-bold text-end ck-item__price">
                  <div class="text-muted small">Tạm tính</div>
                  <div><%=nf.format(it.getLineTotal())%>đ</div>
                </div>
              </li>
            <% } %>
          </ul>

          <div class="ck-summary">
            <div class="d-flex justify-content-between">
              <div class="text-muted"><i class="bi bi-bag me-1"></i>Tạm tính</div>
              <div class="fw-bold"><%=nf.format(cart.getSubtotal())%>đ</div>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted"><i class="bi bi-truck me-1"></i>Ship</div>
              <div class="fw-bold"><%=nf.format(cart.getShipping())%>đ</div>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted"><i class="bi bi-ticket-perforated me-1"></i>Voucher</div>
              <div class="fw-bold text-success">-<%=nf.format(discount)%>đ</div>
            </div>

            <% if (cart.getVoucherCode() != null && !cart.getVoucherCode().trim().isEmpty()) { %>
              <% if (voucherError != null) { %>
                <div class="alert alert-danger mt-3 mb-0 py-2 d-flex align-items-start gap-2">
                  <i class="bi bi-x-circle-fill"></i>
                  <div>Voucher "<b><%=cart.getVoucherCode()%></b>": <%=voucherError%></div>
                </div>
              <% } else { %>
                <div class="alert alert-success mt-3 mb-0 py-2 d-flex align-items-start gap-2">
                  <i class="bi bi-check-circle-fill"></i>
                  <div>Đang áp dụng voucher: <b><%=cart.getVoucherCode()%></b></div>
                </div>
              <% } %>
            <% } %>

            <hr/>

            <%
              long total = cart.getSubtotal() + cart.getShipping() - discount;
              if (total < 0) total = 0;
            %>

            <div class="d-flex justify-content-between fs-5">
              <div class="fw-bold">Tổng</div>
              <div class="fw-bold text-danger"><%=nf.format(total)%>đ</div>
            </div>

            <div class="small text-muted mt-2 d-flex align-items-start gap-2">
              <i class="bi bi-info-circle mt-1"></i>
              <div>Vui lòng kiểm tra lại thông tin nhận hàng trước khi xác nhận.</div>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
