<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="Modal.bean.Category" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<!-- Hero -->
<div class="ac-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="ac-hero__icon"><i class="bi bi-tags-fill"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Categories</h4>
        <div class="text-white-50 small">Tạo / chỉnh sửa danh mục hiển thị cho khách hàng</div>
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

<div class="row g-3">
  <!-- LEFT: Create -->
  <div class="col-lg-4">
    <div class="card shadow-sm border-0 ac-card">
      <div class="card-body">
        <div class="d-flex align-items-center justify-content-between mb-2">
          <h5 class="fw-bold mb-0">
            <i class="bi bi-plus-circle me-2 text-primary"></i>Thêm danh mục
          </h5>
          <span class="badge text-bg-light border">
            <i class="bi bi-lightning-charge me-1"></i> Quick create
          </span>
        </div>

        <!-- LOGIC giữ nguyên: method=get, action=create -->
        <form action="<%=request.getContextPath()%>/admin/categories" method="get">
          <input type="hidden" name="action" value="create"/>

          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-fonts me-1"></i> Name
            </label>
            <input class="form-control" name="name" required placeholder="VD: Trà sữa"/>
          </div>

          <div class="mb-3">
            <label class="form-label fw-semibold">
              <i class="bi bi-link-45deg me-1"></i> Slug
            </label>
            <input class="form-control" name="slug" required placeholder="VD: tra-sua"/>
            <div class="form-text">
              Slug nên viết thường, không dấu, dùng dấu “-”.
            </div>
          </div>

          <button class="btn btn-dark w-100">
            <i class="bi bi-plus-lg me-1"></i> Create
          </button>
        </form>
      </div>
    </div>

    <div class="alert alert-info mt-3 mb-0 d-flex align-items-start gap-2">
      <i class="bi bi-info-circle-fill fs-5"></i>
      <div>
        <div class="fw-bold">Gợi ý</div>
        Category chỉ hiển thị ở trang customer khi <b>Active = 1</b>.
      </div>
    </div>
  </div>

  <!-- RIGHT: List -->
  <div class="col-lg-8">
    <div class="card shadow-sm border-0 ac-card">
      <div class="card-body">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
          <h5 class="fw-bold mb-0">
            <i class="bi bi-list-check me-2 text-primary"></i>Danh sách
          </h5>
          <span class="badge text-bg-light border">
            <i class="bi bi-pencil-square me-1"></i> Inline edit
          </span>
        </div>

        <div class="table-responsive">
          <table class="table align-middle ac-table mb-0">
            <thead>
              <tr>
                <th style="width:70px;">ID</th>
                <th style="min-width:220px;">Name</th>
                <th style="min-width:220px;">Slug</th>
                <th style="width:140px;">Active</th>
                <th class="text-end" style="width:220px;"></th>
              </tr>
            </thead>

            <tbody>
            <% if (categories == null || categories.isEmpty()) { %>
              <tr>
                <td colspan="5" class="text-center text-muted py-4">
                  <div class="ac-empty">
                    <div class="ac-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                    <div class="fw-bold">Chưa có danh mục</div>
                    <div class="text-muted small">Hãy tạo danh mục ở khung bên trái.</div>
                  </div>
                </td>
              </tr>
            <% } else {
                 for (Category c : categories) { %>
              <tr>
                <td class="fw-bold">#<%=c.getCategoryId()%></td>

                <!-- LOGIC giữ nguyên: form update, method=get, hidden action/id -->
                <td>
                  <form class="ac-rowform"
                        action="<%=request.getContextPath()%>/admin/categories" method="get">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="id" value="<%=c.getCategoryId()%>"/>

                    <input class="form-control" name="name" value="<%=c.getName()%>" required/>
                </td>

                <td>
                    <input class="form-control" name="slug" value="<%=c.getSlug()%>" required/>
                </td>

                <td>
                    <div class="d-flex align-items-center gap-2">
                      <select class="form-select" name="active">
                        <option value="1" <%= c.isActive() ? "selected" : "" %>>1</option>
                        <option value="0" <%= !c.isActive() ? "selected" : "" %>>0</option>
                      </select>

                      <!-- UI badge preview -->
                      <% if (c.isActive()) { %>
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
                    <div class="ac-actions">
                      <button class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-save2 me-1"></i> Save
                      </button>

                      <a class="btn btn-outline-danger btn-sm"
                         href="<%=request.getContextPath()%>/admin/categories?action=delete&id=<%=c.getCategoryId()%>"
                         onclick="return confirm('XÓA HẲN danh mục này khỏi CSDL?');">
                        <i class="bi bi-trash3 me-1"></i> Delete
                      </a>
                    </div>
                  </form>
                </td>
              </tr>
            <%   }
               } %>
            </tbody>
          </table>
        </div>

     

      </div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
