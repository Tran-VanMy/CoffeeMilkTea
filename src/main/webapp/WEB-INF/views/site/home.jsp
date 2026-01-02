<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="Modal.bean.Category" %>
<%@ page import="Modal.bean.Product" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  List<Product> products = (List<Product>) request.getAttribute("products");
  Integer activeCategoryId = (Integer) request.getAttribute("activeCategoryId");
  String q = (String) request.getAttribute("q");
  String sort = (String) request.getAttribute("sort");

  Set<Integer> favoriteIds = (Set<Integer>) request.getAttribute("favoriteIds");
  if (favoriteIds == null) favoriteIds = new HashSet<>();

  boolean hasQuery = (q != null && !q.trim().isEmpty());
  String ctx = request.getContextPath();

  if (sort == null || sort.trim().isEmpty()) sort = "";

  // build base url cho sort
  String baseUrl;
  if (hasQuery) {
      baseUrl = ctx + "/home?q=" + URLEncoder.encode(q.trim(), "UTF-8");
  } else if (activeCategoryId != null) {
      baseUrl = ctx + "/product?cid=" + activeCategoryId;
  } else {
      baseUrl = ctx + "/home";
  }
  String sortParamJoin = baseUrl.contains("?") ? "&" : "?";
%>

<section class="menu-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div>
      <div class="d-flex align-items-center gap-2">
        <span class="menu-hero__icon">
          <i class="bi bi-cup-hot-fill"></i>
        </span>
        <div>
          <% if (hasQuery) { %>
            <h4 class="mb-0">Kết quả tìm kiếm</h4>
            <div class="text-white-50 small mt-1">Từ khóa: "<%= q %>"</div>
          <% } else { %>
            <h4 class="mb-0">Menu đồ uống</h4>
            <div class="text-white-50 small mt-1">Chọn món yêu thích, tùy chỉnh size/đường/đá/topping</div>
          <% } %>
        </div>
      </div>
    </div>

    <div class="d-flex align-items-center gap-2">
      <a class="btn btn-outline-light btn-sm fw-semibold" href="<%=ctx%>/home">
        <i class="bi bi-arrow-clockwise me-1"></i> Làm mới
      </a>
    </div>
  </div>
</section>

<div class="row g-3">
  <div class="col-lg-3">
    <div class="card card-soft shadow-sm sticky-lg-top sidebar-card">
      <div class="card-header bg-white d-flex align-items-center justify-content-between">
        <div class="fw-bold">
          <i class="bi bi-grid-3x3-gap me-2 text-primary"></i> Danh mục
        </div>
        <span class="badge text-bg-light border">
          <i class="bi bi-funnel me-1"></i> Filter
        </span>
      </div>

      <div class="card-body pt-3">
        <form class="mb-3" action="<%=ctx%>/home" method="get">
          <input type="hidden" name="sort" value="<%=sort%>"/>
          <div class="input-group">
            <span class="input-group-text bg-white">
              <i class="bi bi-search"></i>
            </span>
            <input type="text" class="form-control" name="q" value="<%= (q==null) ? "" : q %>"
                   placeholder="Tìm đồ uống..." />
            <button class="btn btn-dark" type="submit">
              Tìm
            </button>
          </div>
          <div class="form-text">Gợi ý: “trà sữa”, “cà phê”, “matcha”...</div>
        </form>

        <div class="list-group list-group-flush category-list">
          <a class="list-group-item list-group-item-action d-flex align-items-center justify-content-between
                    <%= (activeCategoryId==null && !hasQuery) ? "active" : "" %>"
             href="<%=ctx%>/home<%= (sort!=null && !sort.isEmpty()) ? ("?sort=" + sort) : "" %>">
            <span class="d-flex align-items-center gap-2">
              <i class="bi bi-app-indicator"></i> Tất cả
            </span>
            <i class="bi bi-chevron-right small opacity-75"></i>
          </a>

          <% if (categories != null) {
               for (Category c : categories) { %>
            <a class="list-group-item list-group-item-action d-flex align-items-center justify-content-between
                      <%= (activeCategoryId!=null && activeCategoryId==c.getCategoryId()) ? "active" : "" %>"
               href="<%=ctx%>/product?cid=<%=c.getCategoryId()%><%= (sort!=null && !sort.isEmpty()) ? ("&sort=" + sort) : "" %>">
              <span class="d-flex align-items-center gap-2">
                <i class="bi bi-tag-fill"></i> <%=c.getName()%>
              </span>
              <i class="bi bi-chevron-right small opacity-75"></i>
            </a>
          <%   }
             } %>
        </div>

        <div class="alert alert-info mt-3 mb-0 d-flex gap-2 align-items-start">
          <i class="bi bi-lightbulb-fill fs-5"></i>
          <div>
            <div class="fw-bold">Tip</div>
            Bấm vào sản phẩm để chọn <b>size</b>, <b>đường</b>, <b>đá</b>, <b>topping</b>.
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="col-lg-9">
    <div class="d-flex flex-wrap align-items-center justify-content-between gap-2 mb-2">
      <div class="d-flex align-items-center gap-2">
        <span class="badge text-bg-light border">
          <i class="bi bi-list-ul me-1"></i>
          <%= (products == null) ? 0 : products.size() %> sản phẩm
        </span>

        <% if (activeCategoryId != null) { %>
          <span class="badge text-bg-primary">
            <i class="bi bi-bookmark-star-fill me-1"></i> Đang lọc theo danh mục
          </span>
        <% } %>

        <% if (hasQuery) { %>
          <a class="badge text-bg-warning text-decoration-none" href="<%=ctx%>/home">
            <i class="bi bi-x-circle me-1"></i> Xóa tìm kiếm
          </a>
        <% } %>
      </div>

      <div class="d-flex align-items-center gap-2">
        <div class="dropdown">
          <button class="btn btn-outline-secondary btn-sm dropdown-toggle" data-bs-toggle="dropdown" type="button">
            <i class="bi bi-sort-down me-1"></i> Sắp xếp
          </button>
          <ul class="dropdown-menu dropdown-menu-end w-200">
            <li>
              <a class="dropdown-item <%= "popular".equalsIgnoreCase(sort) ? "active" : "" %>"
                 href="<%=baseUrl%><%=sortParamJoin%>sort=popular">
                <i class="bi bi-stars me-2"></i>Phổ biến
              </a>
            </li>
            <li>
              <a class="dropdown-item <%= "priceAsc".equalsIgnoreCase(sort) ? "active" : "" %>"
                 href="<%=baseUrl%><%=sortParamJoin%>sort=priceAsc">
                <i class="bi bi-cash-stack me-2"></i>Giá tăng dần
              </a>
            </li>
            <li>
              <a class="dropdown-item <%= "priceDesc".equalsIgnoreCase(sort) ? "active" : "" %>"
                 href="<%=baseUrl%><%=sortParamJoin%>sort=priceDesc">
                <i class="bi bi-cash me-2"></i>Giá giảm dần
              </a>
            </li>
            <li>
              <a class="dropdown-item <%= "newest".equalsIgnoreCase(sort) ? "active" : "" %>"
                 href="<%=baseUrl%><%=sortParamJoin%>sort=newest">
                <i class="bi bi-clock-history me-2"></i>Mới nhất
              </a>
            </li>
          </ul>
        </div>

        <a class="btn btn-outline-dark btn-sm" href="<%=ctx%>/cart">
          <i class="bi bi-bag me-1"></i> Xem giỏ
        </a>
      </div>
    </div>

    <% if (products == null || products.isEmpty()) { %>
      <div class="card shadow-sm">
        <div class="card-body">
          <div class="alert alert-warning mb-0 d-flex align-items-start gap-2">
            <i class="bi bi-exclamation-triangle-fill fs-5"></i>
            <div>
              <div class="fw-bold">Không có sản phẩm</div>
              Hãy thử đổi danh mục hoặc từ khóa khác.
            </div>
          </div>
        </div>
      </div>
    <% } else { %>

      <div class="row g-3">
        <% for (Product p : products) {
             String img = (p.getImageUrl()==null || p.getImageUrl().trim().isEmpty())
                          ? "https://images.unsplash.com/photo-1521302080391-cb041f3f58ff?q=80&w=1200&auto=format&fit=crop"
                          : p.getImageUrl();

             boolean isFav = favoriteIds.contains(p.getProductId());

             // ✅ FIX CHÍNH: redirect luôn về endpoint controller (/home hoặc /product), không bao giờ về /WEB-INF
             String redirectTarget = baseUrl;
             if (sort != null && !sort.trim().isEmpty()) {
                 redirectTarget = redirectTarget + (redirectTarget.contains("?") ? "&" : "?") + "sort=" + URLEncoder.encode(sort, "UTF-8");
             }

             String favUrl = ctx + "/favorites?action=toggle&productId=" + p.getProductId()
                     + "&redirect=" + URLEncoder.encode(redirectTarget, "UTF-8");
        %>
          <div class="col-12 col-md-6 col-xl-4">
            <div class="card product-card h-100 shadow-sm">
              <div class="product-card__media">
                <img class="product-card__img" src="<%= img %>" alt="img"/>
                <span class="product-card__badge badge rounded-pill text-bg-dark">
                  <i class="bi bi-bookmark-heart-fill me-1"></i> Best
                </span>
              </div>

              <div class="card-body">
                <div class="d-flex align-items-start justify-content-between gap-2">
                  <div class="min-w-0">
                    <div class="product-card__title"><%= p.getName() %></div>
                    <div class="text-muted small d-flex align-items-center gap-2 mt-1">
                      <span class="badge text-bg-light border">
                        <i class="bi bi-tag me-1"></i><%= p.getCategoryName() %>
                      </span>
                      <span class="small">
                        <i class="bi bi-geo-alt me-1"></i> Fresh
                      </span>
                    </div>
                  </div>

                  <a class="btn btn-outline-secondary btn-sm product-card__fav"
                     href="<%=favUrl%>"
                     data-bs-toggle="tooltip"
                     data-bs-title="<%= isFav ? "Bỏ yêu thích" : "Thêm yêu thích" %>">
                    <i class="bi <%= isFav ? "bi-heart-fill text-danger" : "bi-heart" %>"></i>
                  </a>
                </div>

                <div class="text-muted small mt-2 product-card__desc">
                  <%= (p.getDescription()==null) ? "" : p.getDescription() %>
                </div>

                <div class="d-flex align-items-center justify-content-between mt-3">
                  <div>
                    <div class="small text-muted">
                      <i class="bi bi-cup-straw me-1"></i> Giá từ
                    </div>
                    <div class="product-card__price">
                      <span class="fw-bold text-danger"><%= nf.format(p.getBasePrice()) %>đ</span>
                      <span class="text-muted small ms-1">(Size S)</span>
                    </div>
                  </div>

                  <span class="badge text-bg-success-subtle border text-success">
                    <i class="bi bi-lightning-charge-fill me-1"></i> Nhanh
                  </span>
                </div>

                <a class="btn btn-primary w-100 mt-3"
                   href="<%=ctx%>/product?id=<%=p.getProductId()%>">
                  <i class="bi bi-cart-plus me-1"></i> Chọn mua
                </a>

                <div class="d-flex justify-content-between text-muted small mt-2">
                  <span><i class="bi bi-shield-check me-1"></i> An toàn</span>
                  <span><i class="bi bi-clock me-1"></i> 5-10 phút</span>
                </div>
              </div>
            </div>
          </div>
        <% } %>
      </div>

      <script>
        document.addEventListener("DOMContentLoaded", function () {
          var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
          tooltipTriggerList.map(function (el) { return new bootstrap.Tooltip(el); });
        });
      </script>

    <% } %>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
