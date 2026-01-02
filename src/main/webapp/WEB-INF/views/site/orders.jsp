<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Order" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  List<Order> orders = (List<Order>) request.getAttribute("orders");
  String msg = (String) request.getAttribute("msg");
%>

<!-- Hero -->
<div class="orders-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="orders-hero__icon"><i class="bi bi-receipt-cutoff"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Đơn hàng của bạn</h4>
        <div class="text-white-50 small">Theo dõi trạng thái và xem chi tiết đơn hàng</div>
      </div>
    </div>

    <div class="d-flex align-items-center gap-2">
      <a class="btn btn-light btn-sm fw-semibold" href="<%=request.getContextPath()%>/home">
        <i class="bi bi-arrow-left me-1"></i> Quay lại menu
      </a>
    </div>
  </div>
</div>

<% if (msg != null) { %>
  <div class="alert alert-info d-flex align-items-start gap-2">
    <i class="bi bi-info-circle-fill fs-5"></i>
    <div><%=msg%></div>
  </div>
<% } %>

<div class="card shadow-sm border-0 orders-card">
  <div class="card-body">

    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <div class="fw-bold">
        <i class="bi bi-list-check me-2 text-primary"></i> Danh sách đơn hàng
      </div>
      <span class="badge text-bg-light border">
        <i class="bi bi-clock-history me-1"></i> Cập nhật theo hệ thống
      </span>
    </div>

    <div class="table-responsive">
      <table class="table align-middle orders-table">
        <thead>
          <tr>
            <th style="width:110px;">Mã</th>
            <th>Người nhận</th>
            <th style="width:170px;">Trạng thái</th>
            <th class="text-end" style="width:150px;">Tổng</th>
            <th style="width:170px;">Ngày</th>
            <th class="text-end" style="width:160px;"></th>
          </tr>
        </thead>

        <tbody>
          <% if (orders == null || orders.isEmpty()) { %>
            <tr>
              <td colspan="6">
                <div class="orders-empty text-center py-4">
                  <div class="orders-empty__icon mb-2"><i class="bi bi-receipt"></i></div>
                  <div class="fw-bold">Chưa có đơn hàng</div>
                  <div class="text-muted small mb-3">Hãy chọn món yêu thích và đặt hàng ngay.</div>
                  <a class="btn btn-primary btn-sm px-4" href="<%=request.getContextPath()%>/home">
                    <i class="bi bi-cup-straw me-1"></i> Mua ngay
                  </a>
                </div>
              </td>
            </tr>
          <% } else {
               for (Order o : orders) { %>

            <tr>
              <td class="fw-bold">#<%=o.getOrderId()%></td>

              <td>
                <div class="d-flex align-items-start gap-3">
                  <div class="orders-avatar">
                    <i class="bi bi-person-fill"></i>
                  </div>
                  <div class="min-w-0">
                    <div class="fw-bold text-truncate"><%=o.getReceiverName()%></div>
                    <div class="text-muted small">
                      <i class="bi bi-telephone me-1"></i><%=o.getReceiverPhone()%>
                    </div>
                  </div>
                </div>
              </td>

              <td>
                <!-- Không đổi logic: vẫn hiển thị o.getStatus() -->
                <!-- UI: badge màu theo status bằng CSS class -->
                <span class="badge status-badge status-<%=o.getStatus()%>">
                  <i class="bi bi-hourglass-split me-1"></i><%=o.getStatus()%>
                </span>
              </td>

              <td class="text-end">
                <div class="text-muted small">Tổng tiền</div>
                <div class="fw-bold text-danger"><%=nf.format(o.getTotal())%>đ</div>
              </td>

              <td class="text-muted">
                <i class="bi bi-calendar3 me-1"></i><%=o.getCreatedAt()%>
              </td>

              <td class="text-end">
                <a class="btn btn-outline-primary btn-sm m-1"
                   href="<%=request.getContextPath()%>/orders?action=detail&id=<%=o.getOrderId()%>">
                  <i class="bi bi-eye me-1"></i> Chi tiết
                </a>

                <% if ("CHO_XAC_NHAN".equals(o.getStatus())) { %>
                  <a class="btn btn-outline-danger btn-sm m-1"
                     href="<%=request.getContextPath()%>/orders?action=cancel&id=<%=o.getOrderId()%>"
                     onclick="return confirm('Hủy đơn #<%=o.getOrderId()%>?')">
                    <i class="bi bi-x-circle me-1"></i> Hủy đơn
                  </a>
                <% } %>
              </td>
            </tr>

          <%   }
             } %>
        </tbody>
      </table>
    </div>

    <div class="small text-muted mt-2 d-flex align-items-start gap-2">
      <i class="bi bi-shield-check mt-1"></i>
      <div>
        Bạn chỉ có thể <b>Hủy</b> khi đơn đang ở trạng thái <b>CHO_XAC_NHAN</b>.
      </div>
    </div>

  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
