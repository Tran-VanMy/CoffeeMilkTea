<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Product" %>
<%@ page import="Modal.bean.Topping" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  Product p = (Product) request.getAttribute("product");
  List<Topping> toppings = (List<Topping>) request.getAttribute("toppings");
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
%>

<% if (p == null) { %>

  <div class="card shadow-sm border-0">
    <div class="card-body">
      <div class="alert alert-danger d-flex align-items-start gap-2 mb-0">
        <i class="bi bi-x-octagon-fill fs-5"></i>
        <div>
          <div class="fw-bold">Không tìm thấy sản phẩm</div>
          Vui lòng quay lại menu để chọn sản phẩm khác.
        </div>
      </div>

      <a class="btn btn-dark mt-3" href="<%=request.getContextPath()%>/home">
        <i class="bi bi-arrow-left me-1"></i> Quay lại menu
      </a>
    </div>
  </div>

<% } else { %>

  <!-- Breadcrumb (UI only) -->
  <nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb product-breadcrumb">
      <li class="breadcrumb-item">
        <a class="text-decoration-none" href="<%=request.getContextPath()%>/home">
          <i class="bi bi-house-door me-1"></i>Trang chủ
        </a>
      </li>
      <li class="breadcrumb-item">
        <a class="text-decoration-none" href="<%=request.getContextPath()%>/home">
          <i class="bi bi-cup-straw me-1"></i>Menu
        </a>
      </li>
      <li class="breadcrumb-item active" aria-current="page"><%=p.getName()%></li>
    </ol>
  </nav>

  <div class="row g-4">
    <!-- LEFT: Image + highlights -->
    <div class="col-lg-5">
      <div class="card shadow-sm border-0 product-card overflow-hidden">
        <div class="product-media">
          <img class="product-img"
               src="<%= (p.getImageUrl()==null || p.getImageUrl().trim().isEmpty())
                        ? "https://via.placeholder.com/800x500?text=MilkTeaShop"
                        : p.getImageUrl() %>"
               alt="product">
          <span class="badge rounded-pill text-bg-dark product-badge">
            <i class="bi bi-stars me-1"></i> Best
          </span>
        </div>

        <div class="card-body">
          <div class="d-flex align-items-start justify-content-between gap-2">
            <div class="min-w-0">
              <h4 class="fw-bold mb-1 text-truncate"><%=p.getName()%></h4>
              <div class="text-muted small">
                <i class="bi bi-shield-check me-1"></i> An toàn
                <span class="mx-1">•</span>
                <i class="bi bi-lightning-charge-fill me-1"></i> Nhanh
                <span class="mx-1">•</span>
                <i class="bi bi-clock me-1"></i> 5–10 phút
              </div>
            </div>
            <button class="btn btn-outline-secondary btn-sm rounded-3"
                    type="button" data-bs-toggle="tooltip" data-bs-title="Yêu thích (UI)">
              <i class="bi bi-heart"></i>
            </button>
          </div>

          <div class="text-muted mt-2 product-desc">
            <%= (p.getDescription()==null ? "" : p.getDescription()) %>
          </div>

          <div class="price-box mt-3">
            <div class="d-flex align-items-center justify-content-between">
              <span class="text-muted small">
                <i class="bi bi-tag me-1"></i> Giá tiền
              </span>
              <span class="fs-4 fw-bold text-danger">
                <%=nf.format(p.getBasePrice())%>đ
              </span>
            </div>
          </div>

          <div class="mt-3 p-3 bg-light border rounded-4 d-flex align-items-start gap-2">
            <i class="bi bi-lightbulb-fill fs-4"></i>
            <div>
              <div class="fw-bold">Mẹo</div>
              <div class="text-muted small">Chọn size/đường/đá + topping rồi bấm “Thêm vào giỏ”.</div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT: Form options -->
    <div class="col-lg-7">
      <div class="card shadow-sm border-0 product-panel">
        <div class="card-body">
          <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
            <div>
              <h5 class="fw-bold mb-0">
                <i class="bi bi-sliders2-vertical me-2 text-primary"></i>Tùy chọn đồ uống
              </h5>
              <div class="text-muted small mt-1">Tuỳ chỉnh theo sở thích của bạn</div>
            </div>
            <span class="badge text-bg-light border">
              <i class="bi bi-check2-circle me-1"></i> Dễ chọn
            </span>
          </div>

          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger d-flex align-items-start gap-2">
              <i class="bi bi-exclamation-triangle-fill fs-5"></i>
              <div><%=request.getAttribute("error")%></div>
            </div>
          <% } %>
          <% if (request.getAttribute("msg") != null) { %>
            <div class="alert alert-success d-flex align-items-start gap-2">
              <i class="bi bi-check-circle-fill fs-5"></i>
              <div><%=request.getAttribute("msg")%></div>
            </div>
          <% } %>

          <!-- LOGIC giữ nguyên: action, hidden inputs, name fields -->
          <form action="<%=request.getContextPath()%>/cart" method="post">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="<%=p.getProductId()%>">

            <div class="row g-3 mt-1">
              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  <i class="bi bi-arrows-angle-expand me-1"></i> Size
                </label>
                <select class="form-select" name="size">
                  <option value="S">S</option>
                  <option value="M" selected>M</option>
                  <option value="L">L</option>
                </select>
              </div>

              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  <i class="bi bi-droplet-half me-1"></i> Sugar (%)
                </label>
                <select class="form-select" name="sugar">
                  <option>0</option><option>30</option><option>50</option>
                  <option selected>70</option><option>100</option>
                </select>
              </div>

              <div class="col-md-4">
                <label class="form-label fw-semibold">
                  <i class="bi bi-snow2 me-1"></i> Ice (%)
                </label>
                <select class="form-select" name="ice">
                  <option>0</option><option>30</option><option>50</option>
                  <option selected>70</option><option>100</option>
                </select>
              </div>
            </div>

            <hr class="my-4">

            <div class="d-flex align-items-center justify-content-between flex-wrap gap-2">
              <label class="form-label fw-semibold mb-0">
                <i class="bi bi-plus-circle-dotted me-1"></i> Topping
              </label>
              <button class="btn btn-sm btn-outline-secondary" type="button" id="clearToppings">
                <i class="bi bi-x-circle me-1"></i> Bỏ chọn
              </button>
            </div>

            <div class="row g-2 mt-2">
              <%
                if (toppings != null) {
                  for (Topping t : toppings) {
              %>
                <div class="col-md-6">
                  <!-- UI cải tiến: chip-style, logic giữ nguyên name/value/id -->
                  <div class="topping-item">
                    <input class="btn-check" type="checkbox"
                           name="toppingId" value="<%=t.getToppingId()%>" id="tp<%=t.getToppingId()%>">
                    <label class="topping-label" for="tp<%=t.getToppingId()%>">
                      <span class="d-flex align-items-center gap-2">
                        <i class="bi bi-check2-circle"></i>
                        <span class="fw-semibold"><%=t.getName()%></span>
                      </span>
                      <span class="text-muted small">+<%=nf.format(t.getPrice())%>đ</span>
                    </label>
                  </div>
                </div>
              <% } } else { %>
                <div class="col-12">
                  <div class="alert alert-info mb-0 d-flex align-items-start gap-2">
                    <i class="bi bi-info-circle-fill fs-5"></i>
                    <div>Hiện chưa có topping cho sản phẩm này.</div>
                  </div>
                </div>
              <% } %>
            </div>

            <div class="mt-4">
              <label class="form-label fw-semibold">
                Số lượng
              </label>

              <!-- UI stepper (vẫn submit input qty như cũ) -->
              <div class="qty-control">
                <button class="btn btn-outline-secondary" type="button" id="qtyMinus" aria-label="Minus">
                  <i class="bi bi-dash-lg"></i>
                </button>

                <input class="form-control text-center" type="number" min="1" name="qty" value="1" style="max-width:140px;" id="qtyInput">

                <button class="btn btn-outline-secondary" type="button" id="qtyPlus" aria-label="Plus">
                  <i class="bi bi-plus-lg"></i>
                </button>
              </div>
            </div>

            <div class="mt-4 d-flex flex-wrap gap-2">
              <button class="btn btn-primary px-4">
                <i class="bi bi-cart-plus me-1"></i> Thêm vào giỏ
              </button>
              <a class="btn btn-outline-dark" href="<%=request.getContextPath()%>/home">
                <i class="bi bi-arrow-left me-1"></i> Quay lại
              </a>

            </div>
          </form>
        </div>
      </div>

      <script>
        // Tooltip (UI only)
        document.addEventListener("DOMContentLoaded", function () {
          var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
          tooltipTriggerList.map(function (el) { return new bootstrap.Tooltip(el); });
        });

        // Stepper qty (UI only - không đổi logic submit)
        (function(){
          const qtyInput = document.getElementById('qtyInput');
          const minus = document.getElementById('qtyMinus');
          const plus = document.getElementById('qtyPlus');

          if(qtyInput && minus && plus){
            minus.addEventListener('click', function(){
              let v = parseInt(qtyInput.value || '1', 10);
              if(isNaN(v) || v <= 1) v = 1;
              else v = v - 1;
              qtyInput.value = v;
            });
            plus.addEventListener('click', function(){
              let v = parseInt(qtyInput.value || '1', 10);
              if(isNaN(v) || v < 1) v = 1;
              qtyInput.value = v + 1;
            });
            qtyInput.addEventListener('input', function(){
              let v = parseInt(qtyInput.value || '1', 10);
              if(isNaN(v) || v < 1) qtyInput.value = 1;
            });
          }
        })();

        // Clear toppings (UI only - không đổi logic submit)
        (function(){
          const btn = document.getElementById('clearToppings');
          if(!btn) return;
          btn.addEventListener('click', function(){
            document.querySelectorAll('input[name="toppingId"]:checked').forEach(cb => cb.checked = false);
          });
        })();
      </script>
    </div>
  </div>

<% } %>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
