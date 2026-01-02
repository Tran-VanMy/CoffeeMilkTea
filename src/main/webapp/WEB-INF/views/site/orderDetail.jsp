<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Order" %>
<%@ page import="Modal.bean.OrderItem" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  Order o = (Order) request.getAttribute("order");
%>

<% if (o == null) { %>

  <div class="card shadow-sm border-0">
    <div class="card-body">
      <div class="alert alert-danger d-flex align-items-start gap-2 mb-0">
        <i class="bi bi-x-octagon-fill fs-5"></i>
        <div>
          <div class="fw-bold">Không tìm thấy đơn hàng</div>
          Vui lòng quay lại danh sách đơn hàng.
        </div>
      </div>
      <a class="btn btn-dark mt-3" href="<%=request.getContextPath()%>/orders">
        <i class="bi bi-arrow-left me-1"></i> Quay lại
      </a>
    </div>
  </div>

<% } else { %>

  <!-- Hero -->
  <div class="od-hero mb-3">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
      <div class="d-flex align-items-center gap-2">
        <span class="od-hero__icon"><i class="bi bi-receipt"></i></span>
        <div>
          <h4 class="mb-0 fw-bold">Chi tiết đơn #<%=o.getOrderId()%></h4>
          <div class="text-white-50 small">
            <i class="bi bi-calendar3 me-1"></i>Tạo lúc: <%=o.getCreatedAt()%>
          </div>
        </div>
      </div>

      <div class="d-flex align-items-center gap-2">
        <a class="btn btn-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/orders">
          <i class="bi bi-list-ul me-1"></i> Danh sách đơn
        </a>
        <a class="btn btn-outline-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/home">
          <i class="bi bi-cup-straw me-1"></i> Menu
        </a>
      </div>
    </div>
  </div>

  <!-- Breadcrumb -->
  <nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb od-breadcrumb">
      <li class="breadcrumb-item">
        <a class="text-decoration-none" href="<%=request.getContextPath()%>/home">
          <i class="bi bi-house-door me-1"></i>Trang chủ
        </a>
      </li>
      <li class="breadcrumb-item">
        <a class="text-decoration-none" href="<%=request.getContextPath()%>/orders">
          <i class="bi bi-receipt-cutoff me-1"></i>Đơn hàng
        </a>
      </li>
      <li class="breadcrumb-item active" aria-current="page">#<%=o.getOrderId()%></li>
    </ol>
  </nav>

  <div class="row g-3">
    <!-- LEFT -->
    <div class="col-lg-5">
      <!-- Receiver info -->
      <div class="card shadow-sm border-0 od-card">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <div class="fw-bold">
              <i class="bi bi-truck me-2 text-primary"></i>Thông tin giao hàng
            </div>

            <!-- Badge status (không đổi logic: vẫn hiển thị o.getStatus()) -->
            <span class="badge od-status status-<%=o.getStatus()%>">
              <i class="bi bi-hourglass-split me-1"></i><%=o.getStatus()%>
            </span>
          </div>

          <div class="od-info">
            <div class="od-info__row">
              <div class="od-info__label"><i class="bi bi-person-fill me-2"></i>Người nhận</div>
              <div class="od-info__value fw-semibold"><%=o.getReceiverName()%></div>
            </div>

            <div class="od-info__row">
              <div class="od-info__label"><i class="bi bi-telephone me-2"></i>SĐT</div>
              <div class="od-info__value"><%=o.getReceiverPhone()%></div>
            </div>

            <div class="od-info__row">
              <div class="od-info__label"><i class="bi bi-geo-alt me-2"></i>Địa chỉ</div>
              <div class="od-info__value"><%=o.getReceiverAddress()%></div>
            </div>

            <div class="od-info__row">
              <div class="od-info__label"><i class="bi bi-chat-left-text me-2"></i>Ghi chú</div>
              <div class="od-info__value"><%= (o.getNote()==null ? "" : o.getNote()) %></div>
            </div>
          </div>

          <div class="small text-muted mt-3 d-flex align-items-start gap-2">
            <i class="bi bi-shield-check mt-1"></i>
            <div>Thông tin đơn hàng được bảo mật và cập nhật theo hệ thống.</div>
          </div>
        </div>
      </div>

      <!-- Payment summary -->
      <div class="card shadow-sm border-0 od-card mt-3 od-sticky">
        <div class="card-body">
          <div class="fw-bold mb-2">
            <i class="bi bi-receipt-cutoff me-2 text-primary"></i>Tóm tắt thanh toán
          </div>

          <div class="d-flex justify-content-between mt-2">
            <div class="text-muted"><i class="bi bi-bag me-1"></i>Tạm tính</div>
            <div class="fw-bold"><%=nf.format(o.getSubtotal())%>đ</div>
          </div>

          <div class="d-flex justify-content-between mt-2">
            <div class="text-muted"><i class="bi bi-truck me-1"></i>Ship</div>
            <div class="fw-bold"><%=nf.format(o.getShipping())%>đ</div>
          </div>

          <div class="d-flex justify-content-between mt-2">
            <div class="text-muted"><i class="bi bi-tags me-1"></i>Giảm giá</div>
            <div class="fw-bold text-success">-<%=nf.format(o.getDiscount())%>đ</div>
          </div>

          <hr>

          <div class="d-flex justify-content-between align-items-center">
            <div class="fw-bold fs-5">Tổng</div>
            <div class="fw-bold fs-5 text-danger"><%=nf.format(o.getTotal())%>đ</div>
          </div>

          <% if (o.getVoucherCode() != null) { %>
            <div class="mt-2">
              <span class="badge text-bg-warning text-dark">
                <i class="bi bi-ticket-perforated me-1"></i> Voucher: <%=o.getVoucherCode()%>
              </span>
            </div>
          <% } %>

          <div class="d-grid gap-2 mt-3">
            <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/orders">
              <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
            </a>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT -->
    <div class="col-lg-7">
      <div class="card shadow-sm border-0 od-card">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-bag-check me-2 text-primary"></i>Sản phẩm
            </h5>
            <span class="badge text-bg-light border">
              <i class="bi bi-list-check me-1"></i> Chi tiết item
            </span>
          </div>

          <div class="table-responsive">
            <table class="table align-middle od-table">
              <thead>
                <tr>
                  <th style="width:60px;">#</th>
                  <th>Tên</th>
                  <th style="width:260px;">Tuỳ chọn</th>
                  <th class="text-end" style="width:140px;">Đơn giá</th>
                  <th class="text-end" style="width:90px;">SL</th>
                  <th class="text-end" style="width:150px;">Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <%
                  List<OrderItem> items = o.getItems();
                  if (items == null || items.isEmpty()) {
                %>
                  <tr>
                    <td colspan="6" class="text-center text-muted py-4">
                      <i class="bi bi-inbox me-1"></i> Không có item.
                    </td>
                  </tr>
                <%
                  } else {
                    for (int i=0;i<items.size();i++) {
                      OrderItem it = items.get(i);
                %>
                  <tr>
                    <td class="text-muted"><%=i+1%></td>

                    <td>
                      <div class="d-flex align-items-start gap-3">
                        <div class="od-item__thumb"><i class="bi bi-cup-hot-fill"></i></div>
                        <div class="min-w-0">
                          <div class="fw-bold text-truncate"><%=it.getProductName()%></div>
                          <div class="text-muted small mt-1 d-flex flex-column gap-1">
                            <div><i class="bi bi-arrows-angle-expand me-1"></i>Size: <b><%=it.getSize()%></b></div>
                            <div><i class="bi bi-droplet-half me-1"></i>Đường: <b><%=it.getSugar()%>%</b></div>
                            <div><i class="bi bi-snow2 me-1"></i>Đá: <b><%=it.getIce()%>%</b></div>
                          </div>
                        </div>
                      </div>
                    </td>

<td class="small text-muted">
  <div class="od-opt">
    <div class="od-opt__line">
      <i class="bi bi-plus-circle-dotted me-1"></i>
      Topping:
    </div>

    <%
      String tp = (it.getToppingJson()==null) ? "" : it.getToppingJson().trim();
      if (tp.isEmpty()) {
    %>
      <div class="ms-4">Không</div>
    <%
      } else {
        // Có thể nhiều topping, phân tách bởi dấu phẩy
        String[] tpArr = tp.split("\\s*,\\s*");
        for (String one : tpArr) {
          if (one == null) continue;
          one = one.trim();
          if (one.isEmpty()) continue;

          // Format thường gặp: id:name:price  (vd: 5:Pudding trứng:6000)
          String[] parts = one.split("\\s*:\\s*");
          String tName = one;   // fallback nếu không đúng format
          String tPrice = "";   // fallback

          if (parts.length >= 3) {
            tName = parts[1];
            tPrice = parts[2];
          } else if (parts.length == 2) {
            // Nếu thiếu id hoặc thiếu price
            tName = parts[0];
            tPrice = parts[1];
          }

          // Làm sạch price nếu có ký tự lạ
          String priceDigits = (tPrice == null) ? "" : tPrice.replaceAll("[^0-9]", "");
    %>
      <div class="ms-4 d-flex align-items-start gap-2">
        <i class="bi bi-dot mt-1"></i>
        <span class="fw-semibold"><%= tName %></span>
        <% if (priceDigits != null && !priceDigits.isEmpty()) { %>
          <span class="text-muted">: +<%= nf.format(Long.parseLong(priceDigits)) %>đ</span>
        <% } %>
      </div>
    <%
        }
      }
    %>
  </div>
</td>



                    <td class="text-end">
                      <div class="text-muted small">Đơn giá</div>
                      <div class="fw-bold"><%=nf.format(it.getUnitPrice())%>đ</div>
                    </td>

                    <td class="text-end">
                      <span class="badge text-bg-light border"><%=it.getQuantity()%></span>
                    </td>

                    <td class="text-end">
                      <div class="text-muted small">Tạm tính</div>
                      <div class="fw-bold text-danger"><%=nf.format(it.getLineTotal())%>đ</div>
                    </td>
                  </tr>
                <%
                    }
                  }
                %>
              </tbody>
            </table>
          </div>

          <div class="small text-muted mt-2 d-flex align-items-start gap-2">
            <i class="bi bi-info-circle mt-1"></i>
            <div>Tuỳ chọn (size/đường/đá/topping) được lưu theo từng item.</div>
          </div>
        </div>
      </div>
    </div>
  </div>

<% } %>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
