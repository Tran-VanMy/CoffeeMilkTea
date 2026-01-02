<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Cart" %>
<%@ page import="Modal.bean.CartItem" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  Cart cart = (Cart) session.getAttribute("CART");
  boolean empty = (cart == null || cart.getItems() == null || cart.getItems().isEmpty());
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));

  String voucherError = (String) request.getAttribute("voucherError");
  String voucherMsg = (String) request.getAttribute("voucherMsg");
%>

<!-- Page Header -->
<div class="cart-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="cart-hero__icon"><i class="bi bi-bag-check-fill"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Giỏ hàng</h4>
        <div class="text-black-50 small">Kiểm tra số lượng, voucher và thanh toán</div>
      </div>
    </div>
  </div>
</div>

<% if (empty) { %>

  <!-- Empty state -->
  <div class="card shadow-sm border-0 cart-empty">
    <div class="card-body p-4 p-lg-5 text-center">
      <div class="cart-empty__icon mb-3">
        <i class="bi bi-bag-x"></i>
      </div>
      <h5 class="fw-bold mb-2">Giỏ hàng đang trống</h5>
      <div class="text-muted mb-3">Hãy chọn vài món yêu thích và quay lại đây để thanh toán nhé.</div>
      <a class="btn btn-primary px-4" href="<%=request.getContextPath()%>/home">
        <i class="bi bi-cup-straw me-1"></i> Mua ngay
      </a>
    </div>
  </div>

<% } else { %>

  <div class="row g-3">
    <!-- LEFT: Items table -->
    <div class="col-lg-8">
      <div class="card shadow-sm border-0">
        <div class="card-body">

          <% if (request.getAttribute("msg") != null) { %>
            <div class="alert alert-success d-flex align-items-start gap-2">
              <i class="bi bi-check-circle-fill fs-5"></i>
              <div><%=request.getAttribute("msg")%></div>
            </div>
          <% } %>
          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-start gap-2">
              <i class="bi bi-exclamation-triangle-fill fs-5"></i>
              <div><%=request.getAttribute("error")%></div>
            </div>
          <% } %>

          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <div class="fw-bold">
              <i class="bi bi-list-check me-2 text-primary"></i> Danh sách sản phẩm
            </div>
            <span class="badge text-bg-light border">
              <i class="bi bi-info-circle me-1"></i> Có thể chỉnh số lượng và cập nhật
            </span>
          </div>

          <div class="table-responsive">
            <table class="table align-middle cart-table">
              <thead>
                <tr>
                  <th>Sản phẩm</th>
                  <th class="text-center" style="width:190px;">Số lượng</th>
                  <th class="text-end" style="width:160px;">Giá</th>
                  <th class="text-end" style="width:170px;">Thành tiền</th>
                  <th class="text-end" style="width:90px;"></th>
                </tr>
              </thead>
              <tbody>
                <%
                  long subtotal = 0;
                  for (CartItem it : cart.getItems()) {
                    subtotal += it.getLineTotal();
                %>
                <tr>
                  <td>
                    <div class="d-flex align-items-start gap-3">
                      <div class="cart-item__thumb">
                        <i class="bi bi-cup-hot-fill"></i>
                      </div>
                      <div class="min-w-0">
                        <div class="fw-bold text-truncate"><%=it.getProductName()%></div>

					<div class="text-muted small mt-1 d-flex flex-column gap-1">
  						<div><i class="bi bi-arrows-angle-expand me-1"></i>Size: <b><%=it.getSize()%></b></div>
  						<div><i class="bi bi-droplet-half me-1"></i>Sugar: <b><%=it.getSugar()%>%</b></div>
 						<div><i class="bi bi-snow2 me-1"></i>Ice: <b><%=it.getIce()%>%</b></div>
					</div>


                        <div class="text-muted small mt-1">
                          <i class="bi bi-plus-circle-dotted me-1"></i>
                          Topping:
                          <span class="ms-1">
                            <%= (it.getToppingNames() == null || it.getToppingNames().isEmpty())
                                  ? "Không"
                                  : String.join(", ", it.getToppingNames()) %>
                          </span>
                        </div>
                      </div>
                    </div>
                  </td>

                  <td class="text-center">
                    <!-- LOGIC giữ nguyên: action=update, key, qty -->
                    <form class="d-flex justify-content-center align-items-center gap-2"
                          action="<%=request.getContextPath()%>/cart" method="post">
                      <input type="hidden" name="action" value="update">
                      <input type="hidden" name="key" value="<%=it.getKey()%>">

                      <div class="qty-mini">
                        <input class="form-control form-control-sm text-center"
                               type="number" min="1"
                               name="qty" value="<%=it.getQuantity()%>">
                      </div>

                      <button class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-arrow-repeat me-1"></i> Update
                      </button>
                    </form>
                  </td>

                  <td class="text-end">
                    <div class="text-muted small">Đơn giá</div>
                    <div class="fw-semibold"><%=nf.format(it.getUnitPrice())%>đ</div>
                  </td>

                  <td class="text-end">
                    <div class="text-muted small">Tạm tính</div>
                    <div class="fw-bold text-danger"><%=nf.format(it.getLineTotal())%>đ</div>
                  </td>

                  <td class="text-end">
                    <!-- LOGIC giữ nguyên: action=remove, key, confirm -->
                    <form action="<%=request.getContextPath()%>/cart" method="post"
                          onsubmit="return confirm('Xóa item này khỏi giỏ hàng?');">
                      <input type="hidden" name="action" value="remove">
                      <input type="hidden" name="key" value="<%=it.getKey()%>">
                      <button class="btn btn-sm btn-outline-danger" title="Xóa">
                        <i class="bi bi-trash3 me-1"></i> Xóa
                      </button>
                    </form>
                  </td>
                </tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-2">
            <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/home">
              <i class="bi bi-arrow-left me-1"></i> Tiếp tục mua
            </a>
          </div>

        </div>
      </div>
    </div>

    <!-- RIGHT: Voucher + Summary (sticky) -->
    <div class="col-lg-4">
      <div class="cart-side sticky-lg-top">

        <!-- Voucher -->
        <div class="card shadow-sm border-0 mb-3">
          <div class="card-body">
            <div class="d-flex align-items-center justify-content-between">
              <div class="fw-bold">
                <i class="bi bi-ticket-perforated-fill me-2 text-primary"></i> Voucher
              </div>
              <span class="badge text-bg-light border">
                <i class="bi bi-shield-check me-1"></i> An toàn
              </span>
            </div>

            <div class="text-muted small mt-1">Nhập mã để áp dụng khi checkout</div>

            <% if (voucherError != null) { %>
              <div class="alert alert-danger py-2 mt-2 mb-2 d-flex align-items-start gap-2">
                <i class="bi bi-x-circle-fill"></i>
                <div><%=voucherError%></div>
              </div>
            <% } %>
            <% if (voucherMsg != null) { %>
              <div class="alert alert-success py-2 mt-2 mb-2 d-flex align-items-start gap-2">
                <i class="bi bi-check-circle-fill"></i>
                <div><%=voucherMsg%></div>
              </div>
            <% } %>

            <!-- LOGIC giữ nguyên: action=applyVoucher, code -->
            <form class="d-flex gap-2 mt-2" action="<%=request.getContextPath()%>/cart" method="post">
              <input type="hidden" name="action" value="applyVoucher">
              <div class="input-group">
                <span class="input-group-text bg-white">
                  <i class="bi bi-upc-scan"></i>
                </span>
                <input class="form-control" name="code"
                       placeholder="VD: SALE10"
                       value="<%= (cart.getVoucherCode()==null ? "" : cart.getVoucherCode()) %>">
              </div>
              <button class="btn btn-primary" type="submit">
                <i class="bi bi-check2 me-1"></i> Áp dụng
              </button>
            </form>

            <div class="text-muted small mt-2">
              <i class="bi bi-info-circle me-1"></i> Voucher sẽ được tính khi thanh toán (Checkout).
            </div>

            <% if (cart.getVoucherCode() != null && !cart.getVoucherCode().trim().isEmpty()) { %>
              <div class="mt-2">
                <span class="badge text-bg-warning text-dark">
                  <i class="bi bi-stars me-1"></i> Đang áp dụng: <%=cart.getVoucherCode()%>
                </span>
              </div>
            <% } %>
          </div>
        </div>

        <!-- Summary -->
        <div class="card shadow-sm border-0">
          <div class="card-body">
            <div class="fw-bold mb-2">
              <i class="bi bi-receipt-cutoff me-2 text-primary"></i> Tóm tắt thanh toán
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted">
                <i class="bi bi-bag me-1"></i> Tạm tính
              </div>
              <div class="fw-bold"><%=nf.format(subtotal)%>đ</div>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted">
                <i class="bi bi-truck me-1"></i> Phí ship
              </div>
              <div class="fw-bold"><%=nf.format(cart.getShipping())%>đ</div>
            </div>

            <hr>

            <div class="d-flex justify-content-between align-items-center">
              <div class="fw-bold fs-5">Tạm tổng</div>
              <div class="fw-bold fs-5 text-danger"><%=nf.format(subtotal + cart.getShipping())%>đ</div>
            </div>

            <a class="btn btn-success w-100 mt-3" href="<%=request.getContextPath()%>/checkout">
              <i class="bi bi-credit-card-2-front me-1"></i> Tiến hành thanh toán
            </a>

            <div class="small text-muted mt-2 d-flex align-items-start gap-2">
              <i class="bi bi-lock-fill mt-1"></i>
              <div>Thông tin thanh toán được bảo mật. Vui lòng kiểm tra lại số lượng trước khi checkout.</div>
            </div>
          </div>
        </div>

      </div>
    </div>
  </div>

<% } %>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
