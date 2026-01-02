<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Order" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  String filter = (String) request.getAttribute("filter");
  List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<%
  String[] st = new String[]{"CHO_XAC_NHAN","DANG_PHA","DANG_GIAO","HOAN_TAT","HUY"};
%>

<!-- Hero -->
<div class="ao-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="ao-hero__icon"><i class="bi bi-receipt-cutoff"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Orders</h4>
        <div class="text-white-50 small">Quản lý đơn hàng, lọc theo trạng thái và cập nhật trạng thái</div>
      </div>
    </div>

    <span class="badge text-bg-light border">
      <i class="bi bi-shield-check me-1"></i> Admin panel
    </span>
  </div>
</div>

<% if (msg != null) { %>
  <div class="alert alert-success d-flex align-items-start gap-2">
    <i class="bi bi-check-circle-fill fs-5"></i>
    <div><%=msg%></div>
  </div>
<% } %>
<% if (error != null) { %>
  <div class="alert alert-danger d-flex align-items-start gap-2">
    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
    <div><%=error%></div>
  </div>
<% } %>

<!-- Filter -->
<div class="card shadow-sm border-0 ao-card mb-3">
  <div class="card-body">
    <div class="d-flex flex-wrap gap-2 align-items-center justify-content-between">
      <div class="d-flex align-items-center gap-2">
        <span class="fw-bold">
          <i class="bi bi-funnel-fill me-2 text-primary"></i>Filter status
        </span>

        <a class="btn btn-sm ao-pill <%= (filter==null || filter.trim().isEmpty()) ? "active" : "" %>"
           href="<%=request.getContextPath()%>/admin/orders">
          <i class="bi bi-grid me-1"></i> ALL
        </a>

        <%
          for (String s : st) {
        %>
          <a class="btn btn-sm ao-pill <%= (s.equals(filter)) ? "active" : "" %>"
             href="<%=request.getContextPath()%>/admin/orders?filter=<%=s%>">
            <i class="bi bi-circle-fill me-1 ao-dot ao-dot-<%=s%>"></i><%=s%>
          </a>
        <% } %>
      </div>

      <span class="badge text-bg-light border">
        <i class="bi bi-info-circle me-1"></i> Click để lọc nhanh
      </span>
    </div>
  </div>
</div>

<!-- List -->
<div class="card shadow-sm border-0 ao-card">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <div class="fw-bold">
        <i class="bi bi-list-check me-2 text-primary"></i>Danh sách đơn hàng
      </div>
      <span class="badge text-bg-light border">
        <i class="bi bi-arrow-repeat me-1"></i> Update status
      </span>
    </div>

    <div class="table-responsive">
      <table class="table align-middle ao-table mb-0">
        <thead>
          <tr>
            <th style="width:110px;">Mã</th>
            <th style="width:90px;">UserID</th>
            <th style="min-width:220px;">Người nhận</th>
            <th style="width:170px;">Trạng thái</th>
            <th class="text-end" style="width:150px;">Tổng</th>
            <th style="width:170px;">Ngày</th>
            <th class="text-end" style="width:360px;"></th>
          </tr>
        </thead>

        <tbody>
          <% if (orders == null || orders.isEmpty()) { %>
            <tr>
              <td colspan="7" class="text-center text-muted py-4">
                <div class="ao-empty">
                  <div class="ao-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                  <div class="fw-bold">Chưa có đơn</div>
                  <div class="text-muted small">Khi có đơn hàng, danh sách sẽ hiển thị tại đây.</div>
                </div>
              </td>
            </tr>
          <% } else {
               for (Order o : orders) { %>

            <tr>
              <td class="fw-bold">#<%=o.getOrderId()%></td>

              <td>
                <span class="badge text-bg-light border">
                  <i class="bi bi-person-badge me-1"></i><%=o.getUserId()%>
                </span>
              </td>

              <td>
                <div class="d-flex align-items-start gap-3">
                  <div class="ao-avatar"><i class="bi bi-person-fill"></i></div>
                  <div class="min-w-0">
                    <div class="fw-bold text-truncate"><%=o.getReceiverName()%></div>
                    <div class="text-muted small">
                      <i class="bi bi-telephone me-1"></i><%=o.getReceiverPhone()%>
                    </div>
                  </div>
                </div>
              </td>

              <td>
                <span class="badge ao-status ao-status-<%=o.getStatus()%>">
                  <i class="bi bi-hourglass-split me-1"></i><%=o.getStatus()%>
                </span>
              </td>

              <td class="text-end">
                <div class="text-muted small">Tổng</div>
                <div class="fw-bold text-danger"><%=nf.format(o.getTotal())%>đ</div>
              </td>

              <td class="text-muted small">
                <i class="bi bi-calendar3 me-1"></i><%=o.getCreatedAt()%>
              </td>

              <td class="text-end">
                <div class="ao-actions">
                  <a class="btn btn-outline-primary btn-sm"
                     href="<%=request.getContextPath()%>/admin/orders?action=detail&id=<%=o.getOrderId()%>">
                    <i class="bi bi-eye me-1"></i> Detail
                  </a>

                  <!-- LOGIC giữ nguyên: action=status, method=get, hidden id, select status, button Update -->
                  <form class="ao-actions__form" action="<%=request.getContextPath()%>/admin/orders" method="get">
                    <input type="hidden" name="action" value="status"/>
                    <input type="hidden" name="id" value="<%=o.getOrderId()%>"/>
                    <select class="form-select form-select-sm" name="status">
                      <% for (String s : st) { %>
                        <option value="<%=s%>" <%= s.equals(o.getStatus()) ? "selected":"" %>><%=s%></option>
                      <% } %>
                    </select>
                    <button class="btn btn-sm btn-dark">
                      <i class="bi bi-arrow-repeat me-1"></i> Update
                    </button>
                  </form>
                </div>
              </td>
            </tr>

          <%   }
             } %>
        </tbody>
      </table>
    </div>

    <div class="small text-muted mt-2 d-flex align-items-start gap-2">
      <i class="bi bi-info-circle mt-1"></i>
      <div>Chọn trạng thái mới và bấm <b>Update</b> để cập nhật.</div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
