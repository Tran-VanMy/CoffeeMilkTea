<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  Long revToday = (Long) request.getAttribute("revToday");
  Long revMonth = (Long) request.getAttribute("revMonth");
  List<String[]> topProducts = (List<String[]>) request.getAttribute("topProducts");
  if (revToday == null) revToday = 0L;
  if (revMonth == null) revMonth = 0L;
%>

<!-- Hero -->
<div class="ad-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="ad-hero__icon"><i class="bi bi-speedometer2"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Dashboard</h4>
        <div class="text-white-50 small">Tổng quan doanh thu & sản phẩm bán chạy</div>
      </div>
    </div>

    <span class="badge text-bg-light border">
      <i class="bi bi-clock-history me-1"></i> Cập nhật theo hệ thống
    </span>
  </div>
</div>

<!-- KPI -->
<div class="row g-3">
  <div class="col-md-6">
    <div class="card shadow-sm border-0 ad-kpi">
      <div class="card-body">
        <div class="d-flex align-items-start justify-content-between gap-2">
          <div>
            <div class="text-muted small">
              <i class="bi bi-calendar-day me-1"></i> Doanh thu hôm nay
            </div>
            <div class="fs-3 fw-bold text-danger mt-1"><%=nf.format(revToday)%>đ</div>
            <div class="text-muted small mt-1">
              <i class="bi bi-info-circle me-1"></i> Tổng doanh thu trong ngày
            </div>
          </div>
          <div class="ad-kpi__icon ad-kpi__icon--today">
            <i class="bi bi-cash-coin"></i>
          </div>
        </div>
      </div>
      <div class="ad-kpi__bar"></div>
    </div>
  </div>

  <div class="col-md-6">
    <div class="card shadow-sm border-0 ad-kpi">
      <div class="card-body">
        <div class="d-flex align-items-start justify-content-between gap-2">
          <div>
            <div class="text-muted small">
              <i class="bi bi-calendar3 me-1"></i> Doanh thu tháng này
            </div>
            <div class="fs-3 fw-bold text-danger mt-1"><%=nf.format(revMonth)%>đ</div>
            <div class="text-muted small mt-1">
              <i class="bi bi-graph-up-arrow me-1"></i> Tổng doanh thu trong tháng
            </div>
          </div>
          <div class="ad-kpi__icon ad-kpi__icon--month">
            <i class="bi bi-bar-chart-line-fill"></i>
          </div>
        </div>
      </div>
      <div class="ad-kpi__bar"></div>
    </div>
  </div>
</div>

<!-- Top products -->
<div class="card shadow-sm border-0 mt-3 ad-card">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-fire me-2 text-primary"></i> Top sản phẩm
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-award me-1"></i> Best sellers
      </span>
    </div>

    <div class="table-responsive">
      <table class="table align-middle ad-table mb-0">
        <thead>
          <tr>
            <th style="width:80px;">#</th>
            <th>Sản phẩm</th>
            <th class="text-end" style="width:160px;">Số lượng</th>
          </tr>
        </thead>
        <tbody>
          <% if (topProducts == null || topProducts.isEmpty()) { %>
            <tr>
              <td colspan="3" class="text-center text-muted py-4">
                <div class="ad-empty">
                  <div class="ad-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                  <div class="fw-bold">Chưa có dữ liệu</div>
                  <div class="text-muted small">Khi có đơn hàng, hệ thống sẽ thống kê tại đây.</div>
                </div>
              </td>
            </tr>
          <% } else {
               for (int i=0;i<topProducts.size();i++) {
                 String[] row = topProducts.get(i);
          %>
            <tr>
              <td>
                <span class="ad-rank">
                  <%=i+1%>
                </span>
              </td>
              <td class="fw-bold"><%=row[0]%></td>
              <td class="text-end">
                <span class="badge text-bg-light border ad-qty">
                  <i class="bi bi-box-seam me-1"></i><%=row[1]%>
                </span>
              </td>
            </tr>
          <%   }
             } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
