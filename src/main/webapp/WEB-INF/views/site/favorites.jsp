<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Product" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  List<Product> favorites = (List<Product>) request.getAttribute("favorites");
  String ctx = request.getContextPath();
  String msg = (String) request.getAttribute("msg");
%>

<div class="card shadow-sm">
  <div class="card-header bg-white d-flex align-items-center justify-content-between">
    <div class="fw-bold">
      <i class="bi bi-heart-fill text-danger me-2"></i> Yêu thích của bạn
    </div>
    <a class="btn btn-sm btn-outline-secondary" href="<%=ctx%>/home">
      <i class="bi bi-arrow-left me-1"></i> Quay lại menu
    </a>
  </div>

  <div class="card-body">
    <% if (msg != null && !msg.trim().isEmpty()) { %>
      <div class="alert alert-info"><%=msg%></div>
    <% } %>

    <% if (favorites == null || favorites.isEmpty()) { %>
      <div class="alert alert-warning mb-0">
        Bạn chưa thêm sản phẩm nào vào yêu thích.
      </div>
    <% } else { %>
      <div class="row g-3">
        <% for (Product p : favorites) {
            String img = (p.getImageUrl()==null || p.getImageUrl().trim().isEmpty())
                    ? "https://images.unsplash.com/photo-1521302080391-cb041f3f58ff?q=80&w=1200&auto=format&fit=crop"
                    : p.getImageUrl();
        %>
          <div class="col-12 col-md-6 col-xl-4">
            <div class="card h-100 shadow-sm">
              <img src="<%=img%>" class="card-img-top" style="height:180px;object-fit:cover" alt="img"/>
              <div class="card-body">
                <div class="fw-bold"><%=p.getName()%></div>
                <div class="text-muted small mt-1">
                  <i class="bi bi-tag me-1"></i><%=p.getCategoryName()%>
                </div>

                <div class="mt-2">
                  <span class="fw-bold text-danger"><%=nf.format(p.getBasePrice())%>đ</span>
                  <span class="text-muted small">(Size S)</span>
                </div>

                <div class="d-flex gap-2 mt-3">
                  <a class="btn btn-primary w-100" href="<%=ctx%>/product?id=<%=p.getProductId()%>">
                    <i class="bi bi-cart-plus me-1"></i> Chọn mua
                  </a>

                  <a class="btn btn-outline-danger"
                     href="<%=ctx%>/favorites?action=remove&productId=<%=p.getProductId()%>">
                    <i class="bi bi-trash"></i>
                  </a>
                </div>
              </div>
            </div>
          </div>
        <% } %>
      </div>
    <% } %>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
