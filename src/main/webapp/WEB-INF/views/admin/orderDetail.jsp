<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Order" %>
<%@ page import="Modal.bean.OrderItem" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  Order o = (Order) request.getAttribute("order");
%>

<% if (o == null) { %>

  <div class="alert alert-danger d-flex align-items-start gap-2">
    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
    <div>Không tìm thấy đơn.</div>
  </div>
  <a class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/admin/orders">
    <i class="bi bi-arrow-left me-1"></i> Quay lại
  </a>

<% } else { %>

  <!-- Hero -->
  <div class="aod-hero mb-3">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
      <div class="d-flex align-items-center gap-2">
        <span class="aod-hero__icon"><i class="bi bi-receipt"></i></span>
        <div>
          <h4 class="mb-0 fw-bold">Order #<%=o.getOrderId()%></h4>
          <div class="text-white-50 small">Chi tiết đơn hàng (Admin)</div>
        </div>
      </div>

      <div class="d-flex align-items-center gap-2">

        <a class="btn btn-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/admin/orders">
          <i class="bi bi-arrow-left me-1"></i> Orders
        </a>
      </div>
    </div>
  </div>

  <div class="row g-3">
    <!-- LEFT -->
    <div class="col-lg-5">
      <div class="card shadow-sm border-0 aod-card">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between mb-2">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-person-lines-fill me-2 text-primary"></i>Thông tin đơn
            </h5>
            <span class="badge text-bg-light border">
              <i class="bi bi-person-badge me-1"></i>UserID: <%=o.getUserId()%>
            </span>
          </div>

          <div class="aod-kv">
            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-person me-2"></i>Receiver</div>
              <div class="aod-kv__v fw-semibold"><%=o.getReceiverName()%></div>
            </div>

            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-telephone me-2"></i>Phone</div>
              <div class="aod-kv__v"><%=o.getReceiverPhone()%></div>
            </div>

            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-geo-alt me-2"></i>Address</div>
              <div class="aod-kv__v"><%=o.getReceiverAddress()%></div>
            </div>

            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-flag me-2"></i>Status</div>
              <div class="aod-kv__v">
                <span class="badge aod-status aod-status-<%=o.getStatus()%>">
                  <i class="bi bi-hourglass-split me-1"></i><%=o.getStatus()%>
                </span>
              </div>
            </div>

            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-chat-left-text me-2"></i>Note</div>
              <div class="aod-kv__v"><%= (o.getNote()==null?"":o.getNote()) %></div>
            </div>

            <div class="aod-kv__row">
              <div class="aod-kv__k"><i class="bi bi-calendar3 me-2"></i>Created</div>
              <div class="aod-kv__v text-muted"><%=o.getCreatedAt()%></div>
            </div>
          </div>
        </div>
      </div>

      <div class="card shadow-sm border-0 aod-card mt-3">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between mb-2">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-cash-stack me-2 text-primary"></i>Tổng kết thanh toán
            </h5>
          </div>

          <div class="aod-sum">
            <div class="d-flex justify-content-between">
              <div class="text-muted">
                <i class="bi bi-receipt-cutoff me-1"></i> Subtotal
              </div>
              <div class="fw-bold"><%=nf.format(o.getSubtotal())%>đ</div>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted">
                <i class="bi bi-truck me-1"></i> Shipping
              </div>
              <div class="fw-bold"><%=nf.format(o.getShipping())%>đ</div>
            </div>

            <div class="d-flex justify-content-between mt-2">
              <div class="text-muted">
                <i class="bi bi-ticket-perforated me-1"></i> Discount
              </div>
              <div class="fw-bold text-success">-<%=nf.format(o.getDiscount())%>đ</div>
            </div>

            <hr/>

            <div class="d-flex justify-content-between fs-5">
              <div class="fw-bold">Total</div>
              <div class="fw-bold text-danger"><%=nf.format(o.getTotal())%>đ</div>
            </div>

            <% if (o.getVoucherCode() != null && !o.getVoucherCode().trim().isEmpty()) { %>
              <div class="text-muted small mt-2">
                <i class="bi bi-ticket-perforated-fill me-1"></i> Voucher:
                <b><%=o.getVoucherCode()%></b>
              </div>
            <% } %>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT -->
    <div class="col-lg-7">
      <div class="card shadow-sm border-0 aod-card">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <h5 class="fw-bold mb-0">
              <i class="bi bi-basket3 me-2 text-primary"></i>Items
            </h5>
            <span class="badge text-bg-light border">
              <i class="bi bi-list-check me-1"></i> Danh sách sản phẩm
            </span>
          </div>

          <div class="table-responsive">
            <table class="table align-middle aod-table mb-0">
              <thead>
                <tr>
                  <th style="width:60px;">#</th>
                  <th>Tên</th>
                  <th style="min-width:240px;">Tuỳ chọn</th>
                  <th class="text-end" style="width:130px;">Đơn giá</th>
                  <th class="text-end" style="width:70px;">SL</th>
                  <th class="text-end" style="width:140px;">Thành tiền</th>
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

                    <td class="fw-bold">
                      <div class="d-flex align-items-center gap-2">
                        <span class="aod-itemdot"><i class="bi bi-cup-hot"></i></span>
                        <span><%=it.getProductName()%></span>
                      </div>
                    </td>

                    <td class="small text-muted">
                      <div class="d-flex flex-wrap gap-2">
                        <span class="badge text-bg-light border">
                          <i class="bi bi-arrows-angle-expand me-1"></i> Size <b><%=it.getSize()%></b>
                        </span>
                        <span class="badge text-bg-light border">
                          <i class="bi bi-droplet-half me-1"></i> Đường <b><%=it.getSugar()%>%</b>
                        </span>
                        <span class="badge text-bg-light border">
                          <i class="bi bi-snow2 me-1"></i> Đá <b><%=it.getIce()%>%</b>
                        </span>
                      </div>

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

                    <td class="text-end fw-bold"><%=nf.format(it.getUnitPrice())%>đ</td>
                    <td class="text-end"><span class="badge text-bg-light border"><%=it.getQuantity()%></span></td>
                    <td class="text-end fw-bold text-danger"><%=nf.format(it.getLineTotal())%>đ</td>
                  </tr>
                <%
                    }
                  }
                %>
              </tbody>
            </table>
          </div>

          
        </div>
      </div>
    </div>
  </div>

<% } %>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
