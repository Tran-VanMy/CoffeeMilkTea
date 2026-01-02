<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));

  Long revToday = (Long) request.getAttribute("revToday");
  Long revMonth = (Long) request.getAttribute("revMonth");

  ArrayList<String[]> rev7 = (ArrayList<String[]>) request.getAttribute("rev7");
  if (rev7 == null) rev7 = new ArrayList<>();

  LinkedHashMap<String, Integer> statusMap = (LinkedHashMap<String, Integer>) request.getAttribute("statusMap");
  if (statusMap == null) statusMap = new LinkedHashMap<>();

  ArrayList<String[]> topProducts = (ArrayList<String[]>) request.getAttribute("topProducts");
  if (topProducts == null) topProducts = new ArrayList<>();

  // Build JS arrays
  StringBuilder labels7 = new StringBuilder("[");
  StringBuilder data7 = new StringBuilder("[");
  for (int i=0;i<rev7.size();i++){
      String[] row = rev7.get(i);
      String d = row[0];
      String v = row[1];
      labels7.append("\"").append(d).append("\"");
      data7.append(v);
      if(i<rev7.size()-1){ labels7.append(","); data7.append(","); }
  }
  labels7.append("]");
  data7.append("]");

  StringBuilder stLabels = new StringBuilder("[");
  StringBuilder stData = new StringBuilder("[");
  int idx = 0;
  for (Map.Entry<String,Integer> en : statusMap.entrySet()){
      stLabels.append("\"").append(en.getKey()).append("\"");
      stData.append(en.getValue());
      if(idx < statusMap.size()-1){ stLabels.append(","); stData.append(","); }
      idx++;
  }
  stLabels.append("]");
  stData.append("]");

  StringBuilder tpLabels = new StringBuilder("[");
  StringBuilder tpData = new StringBuilder("[");
  for (int i=0;i<topProducts.size();i++){
      String[] row = topProducts.get(i); // [product_name, qty]
      String name = row[0] == null ? "" : row[0].replace("\"","'");
      String qty = row[1] == null ? "0" : row[1];
      tpLabels.append("\"").append(name).append("\"");
      tpData.append(qty);
      if(i<topProducts.size()-1){ tpLabels.append(","); tpData.append(","); }
  }
  tpLabels.append("]");
  tpData.append("]");
%>

<div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
  <div>
    <h4 class="fw-bold mb-0"><i class="bi bi-graph-up-arrow me-2 text-primary"></i>Thống kê</h4>
    <div class="text-muted small mt-1">Biểu đồ doanh thu & đơn hàng (Chart.js)</div>
  </div>
  <a class="btn btn-outline-secondary btn-sm" href="<%=request.getContextPath()%>/admin/dashboard">
    <i class="bi bi-arrow-left me-1"></i>Về Dashboard
  </a>
</div>

<div class="row g-3">
  <div class="col-md-6 col-xl-3">
    <div class="card shadow-sm border-0">
      <div class="card-body">
        <div class="text-muted small">Doanh thu hôm nay</div>
        <div class="fs-4 fw-bold text-success"><%= nf.format(revToday == null ? 0 : revToday) %>đ</div>
      </div>
    </div>
  </div>

  <div class="col-md-6 col-xl-3">
    <div class="card shadow-sm border-0">
      <div class="card-body">
        <div class="text-muted small">Doanh thu tháng này</div>
        <div class="fs-4 fw-bold text-primary"><%= nf.format(revMonth == null ? 0 : revMonth) %>đ</div>
      </div>
    </div>
  </div>

  <div class="col-xl-6">
    <div class="card shadow-sm border-0">
      <div class="card-body">
        <div class="fw-bold mb-1">Doanh thu 7 ngày gần nhất</div>
        <div class="text-muted small mb-2">Line chart</div>
        <canvas id="rev7Chart" height="110"></canvas>
      </div>
    </div>
  </div>

  <div class="col-lg-5">
    <div class="card shadow-sm border-0">
      <div class="card-body">
        <div class="fw-bold mb-1">Phân bố trạng thái đơn</div>
        <div class="text-muted small mb-2">Doughnut chart</div>
        <canvas id="statusChart" height="170"></canvas>

        <div class="mt-3 small text-muted">
          <div><b>Gợi ý:</b> Di chuyển chuột vào vùng màu để xem chi tiết.</div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-7">
    <div class="card shadow-sm border-0">
      <div class="card-body">
        <div class="fw-bold mb-1">Top sản phẩm bán chạy</div>
        <div class="text-muted small mb-2">Bar chart theo tổng số lượng</div>
        <canvas id="topProductsChart" height="170"></canvas>
      </div>
    </div>
  </div>
</div>

<!-- Chart.js CDN -->
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

<script>
  // Data từ server (JSP)
  const labels7 = <%= labels7.toString() %>;
  const data7   = <%= data7.toString() %>;

  const stLabels = <%= stLabels.toString() %>;
  const stData   = <%= stData.toString() %>;

  const tpLabels = <%= tpLabels.toString() %>;
  const tpData   = <%= tpData.toString() %>;

  // ---- Line: revenue last 7 days
  const rev7Ctx = document.getElementById('rev7Chart');
  if (rev7Ctx) {
    new Chart(rev7Ctx, {
      type: 'line',
      data: {
        labels: labels7,
        datasets: [{
          label: 'Doanh thu (đ)',
          data: data7,
          borderColor: 'rgba(13,110,253,1)',
          backgroundColor: 'rgba(13,110,253,0.15)',
          fill: true,
          tension: 0.35,
          pointRadius: 3
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: true }
        },
        scales: {
          y: {
            ticks: {
              callback: function(v){ return v.toLocaleString('vi-VN'); }
            }
          }
        }
      }
    });
  }

  // ---- Doughnut: status distribution
  const stCtx = document.getElementById('statusChart');
  if (stCtx) {
    const colors = [
      'rgba(255,193,7,0.85)',  // warning
      'rgba(13,110,253,0.85)', // primary
      'rgba(25,135,84,0.85)',  // success
      'rgba(108,117,125,0.85)',// secondary
      'rgba(220,53,69,0.85)'   // danger
    ];
    new Chart(stCtx, {
      type: 'doughnut',
      data: {
        labels: stLabels,
        datasets: [{
          data: stData,
          backgroundColor: colors,
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { position: 'bottom' }
        }
      }
    });
  }

  // ---- Bar: top products
  const tpCtx = document.getElementById('topProductsChart');
  if (tpCtx) {
    new Chart(tpCtx, {
      type: 'bar',
      data: {
        labels: tpLabels,
        datasets: [{
          label: 'Số lượng',
          data: tpData,
          backgroundColor: 'rgba(25,135,84,0.75)',
          borderColor: 'rgba(25,135,84,1)',
          borderWidth: 1
        }]
      },
      options: {
        responsive: true,
        plugins: {
          legend: { display: true }
        },
        scales: {
          y: { beginAtZero: true }
        }
      }
    });
  }
</script>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
