<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Category" %>
<%@ page import="Modal.bean.Product" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Category> categories = (List<Category>) request.getAttribute("categories");
  List<Product> products = (List<Product>) request.getAttribute("products");
%>

<!-- Hero -->
<div class="ap-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="ap-hero__icon"><i class="bi bi-box-seam-fill"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Products</h4>
        <div class="text-white-50 small">Tạo / cập nhật sản phẩm và quản lý hiển thị</div>
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

<!-- CREATE FORM -->
<div class="card shadow-sm border-0 ap-card mb-3">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-plus-circle me-2 text-primary"></i>Thêm sản phẩm
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-lightning-charge me-1"></i> Quick create
      </span>
    </div>

    <!-- ✅ multipart để upload file (giữ nguyên) -->
    <form class="row g-3"
          action="<%=request.getContextPath()%>/admin/products"
          method="post"
          enctype="multipart/form-data">
      <input type="hidden" name="action" value="create"/>

      <div class="col-md-4">
        <label class="form-label fw-semibold">
          <i class="bi bi-tags me-1"></i> Category
        </label>
        <select class="form-select" name="categoryId" required>
          <option value="">-- chọn --</option>
          <% if (categories != null) for (Category c : categories) { %>
            <option value="<%=c.getCategoryId()%>"><%=c.getName()%></option>
          <% } %>
        </select>
      </div>

      <div class="col-md-5">
        <label class="form-label fw-semibold">
          <i class="bi bi-fonts me-1"></i> Name
        </label>
        <input class="form-control" name="name" required placeholder="VD: Trà đào cam sả"/>
      </div>

      <div class="col-md-3">
        <label class="form-label fw-semibold">
          <i class="bi bi-cash-coin me-1"></i> Base price
        </label>
        <input class="form-control" type="number" name="basePrice" value="0" min="0" required/>
      </div>

      <div class="col-md-8">
        <label class="form-label fw-semibold">
          <i class="bi bi-card-text me-1"></i> Description
        </label>
        <textarea class="form-control" name="description" rows="2" placeholder="Mô tả ngắn về sản phẩm..."></textarea>
      </div>

      <div class="col-md-4">
        <label class="form-label fw-semibold">
          <i class="bi bi-image me-1"></i> Image
        </label>

        <!-- chọn mode -->
        <div id="imgModePicker" class="ap-mode d-flex gap-2">
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="chooseImgMode('url')">
            <i class="bi bi-link-45deg me-1"></i> Nhập URL
          </button>
          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="chooseImgMode('upload')">
            <i class="bi bi-upload me-1"></i> Chọn tệp
          </button>
        </div>

        <input type="hidden" name="imageMode" id="imageMode" value="url"/>

        <!-- mode URL -->
        <div id="imgUrlBox" class="mt-2" style="display:none;">
          <div class="input-group">
            <span class="input-group-text bg-white"><i class="bi bi-link-45deg"></i></span>
            <input class="form-control" name="imageUrl" placeholder="https://... hoặc /images/..." />
          </div>
          <button type="button" class="btn btn-link p-0 mt-1" onclick="backImgMode()">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
          </button>
        </div>

        <!-- mode Upload -->
        <div id="imgUploadBox" class="mt-2" style="display:none;">
          <div class="input-group">
            <span class="input-group-text bg-white"><i class="bi bi-file-earmark-image"></i></span>
            <input class="form-control" type="file" name="imageFile" accept="image/*"/>
          </div>
          <div class="small text-muted mt-1">
            <i class="bi bi-info-circle me-1"></i> File sẽ lưu vào thư mục <b>uploads/</b> trong server ảo.
          </div>
          <button type="button" class="btn btn-link p-0 mt-1" onclick="backImgMode()">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
          </button>
        </div>
      </div>

      <div class="col-12 d-flex align-items-center justify-content-between flex-wrap gap-2">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" name="active" id="a1" checked>
          <label class="form-check-label fw-semibold" for="a1">
            Active
          </label>
        </div>

        <button class="btn btn-dark">
          <i class="bi bi-plus-lg me-1"></i> Create
        </button>
      </div>
    </form>
  </div>
</div>

<!-- LIST -->
<div class="card shadow-sm border-0 ap-card">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-list-check me-2 text-primary"></i>Danh sách sản phẩm
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-pencil-square me-1"></i> Inline edit
      </span>
    </div>

    <div class="table-responsive">
      <table class="table align-middle ap-table mb-0">
        <thead>
          <tr>
            <th style="width:90px;">ID</th>
            <th style="min-width:360px;">Name</th>
            <th style="min-width:190px;">Category</th>
            <th style="width:160px;">Price</th>
            <th style="width:160px;">Active</th>
            <th class="text-end" style="width:260px;"></th>
          </tr>
        </thead>

        <tbody>
          <% if (products == null || products.isEmpty()) { %>
            <tr>
              <td colspan="6" class="text-center text-muted py-4">
                <div class="ap-empty">
                  <div class="ap-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                  <div class="fw-bold">Chưa có sản phẩm</div>
                  <div class="text-muted small">Hãy tạo sản phẩm ở khung phía trên.</div>
                </div>
              </td>
            </tr>
          <% } else {
               for (Product p : products) { %>

            <tr>
              <form class="ap-rowform" action="<%=request.getContextPath()%>/admin/products" method="post">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="<%=p.getProductId()%>"/>

                <td class="fw-bold">#<%=p.getProductId()%></td>

                <td>
                  <div class="d-flex align-items-start gap-3">
                   

                    <div class="min-w-0 flex-grow-1">
                      <input class="form-control" name="name" value="<%=p.getName()%>" required/>

                      <div class="mt-2">
                        <label class="form-label small text-muted mb-1">
                          <i class="bi bi-card-text me-1"></i>Description
                        </label>
                        <textarea class="form-control" name="description" rows="2"><%= (p.getDescription()==null?"":p.getDescription()) %></textarea>
                      </div>

                      <div class="mt-2">
                        <label class="form-label small text-muted mb-1">
                          <i class="bi bi-link-45deg me-1"></i>Image URL / uploads
                        </label>
                        <input class="form-control" name="imageUrl"
                               value="<%= (p.getImageUrl()==null?"":p.getImageUrl()) %>"
                               placeholder="Image URL hoặc uploads/..." />
                      </div>
                    </div>
                  </div>
                </td>

                <td>
                  <select class="form-select" name="categoryId" required>
                    <% if (categories != null) for (Category c : categories) { %>
                      <option value="<%=c.getCategoryId()%>" <%= (c.getCategoryId()==p.getCategoryId() ? "selected" : "") %>><%=c.getName()%></option>
                    <% } %>
                  </select>
                </td>

                <td class="text-end">
                  <input class="form-control text-end" type="number" name="basePrice" min="0"
                         value="<%=p.getBasePrice()%>" required/>
                </td>

                <td>
                  <div class="d-flex align-items-center gap-2">
                    <div class="form-check mb-0">
                      <input class="form-check-input" type="checkbox" name="active" <%=p.isActive() ? "checked":""%>>
                      <label class="form-check-label">Active</label>
                    </div>

                    <% if (p.isActive()) { %>
                      <span class="badge text-bg-success-subtle border text-success">
                        <i class="bi bi-check2-circle me-1"></i>On
                      </span>
                    <% } else { %>
                      <span class="badge text-bg-danger-subtle border text-danger">
                        <i class="bi bi-x-circle me-1"></i>Off
                      </span>
                    <% } %>
                  </div>
                </td>

                <td class="text-end">
                  <div class="ap-actions">
                    <button class="btn btn-outline-primary btn-sm">
                      <i class="bi bi-save2 me-1"></i> Save
                    </button>

                    <a class="btn btn-outline-danger btn-sm"
                       href="<%=request.getContextPath()%>/admin/products?action=delete&id=<%=p.getProductId()%>"
                       onclick="return confirm('Xóa sản phẩm này?')">
                      <i class="bi bi-trash3 me-1"></i> Delete
                    </a>
                  </div>
                </td>
              </form>
            </tr>

          <%   }
             } %>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
  function chooseImgMode(mode) {
    document.getElementById('imageMode').value = mode;

    // ẩn picker
    document.getElementById('imgModePicker').style.display = 'none';

    if (mode === 'url') {
      document.getElementById('imgUrlBox').style.display = 'block';
      document.getElementById('imgUploadBox').style.display = 'none';
    } else {
      document.getElementById('imgUploadBox').style.display = 'block';
      document.getElementById('imgUrlBox').style.display = 'none';
    }
  }

  function backImgMode() {
    document.getElementById('imageMode').value = 'url';
    document.getElementById('imgModePicker').style.display = 'flex';
    document.getElementById('imgUrlBox').style.display = 'none';
    document.getElementById('imgUploadBox').style.display = 'none';
  }

  // mặc định: chưa chọn mode -> hiện picker
  backImgMode();
</script>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
