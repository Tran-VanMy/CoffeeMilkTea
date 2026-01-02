<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Topping" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Topping> toppings = (List<Topping>) request.getAttribute("toppings");
%>

<!-- Hero -->
<div class="at-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="at-hero__icon"><i class="bi bi-plus-circle-dotted"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Toppings</h4>
        <div class="text-white-50 small">Quản lý topping (giá, trạng thái hiển thị)</div>
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

<!-- CREATE -->
<div class="card shadow-sm border-0 at-card mb-3">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-plus-circle me-2 text-primary"></i>Thêm topping
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-lightning-charge me-1"></i> Quick create
      </span>
    </div>

    <!-- LOGIC giữ nguyên: method=get, action=create -->
    <form class="row g-3" action="<%=request.getContextPath()%>/admin/toppings" method="get">
      <input type="hidden" name="action" value="create"/>

      <div class="col-md-6">
        <label class="form-label fw-semibold">
          <i class="bi bi-fonts me-1"></i> Name
        </label>
        <input class="form-control" name="name" required placeholder="VD: Kem cheese"/>
      </div>

      <div class="col-md-3">
        <label class="form-label fw-semibold">
          <i class="bi bi-cash-coin me-1"></i> Price
        </label>
        <input class="form-control" type="number" name="price" min="0" value="0" required/>
        <div class="form-text">
          Giá sẽ cộng thêm vào đơn hàng.
        </div>
      </div>

      <div class="col-md-3 d-flex align-items-end justify-content-between gap-2">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" name="active" id="tpA" checked>
          <label class="form-check-label fw-semibold" for="tpA">
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
<div class="card shadow-sm border-0 at-card">
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
      <table class="table align-middle at-table mb-0">
        <thead>
          <tr>
            <th style="width:90px;">ID</th>
            <th style="min-width:260px;">Name</th>
            <th style="width:190px;">Price</th>
            <th style="width:170px;">Active</th>
            <th class="text-end" style="width:220px;"></th>
          </tr>
        </thead>
        <tbody>
          <% if (toppings == null || toppings.isEmpty()) { %>
            <tr>
              <td colspan="5" class="text-center text-muted py-4">
                <div class="at-empty">
                  <div class="at-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                  <div class="fw-bold">Chưa có topping</div>
                  <div class="text-muted small">Hãy tạo topping ở khung phía trên.</div>
                </div>
              </td>
            </tr>
          <% } else {
               for (Topping t : toppings) { %>
            <tr>
              <!-- LOGIC giữ nguyên: form update method=get -->
              <form class="at-rowform" action="<%=request.getContextPath()%>/admin/toppings" method="get">
                <input type="hidden" name="action" value="update"/>
                <input type="hidden" name="id" value="<%=t.getToppingId()%>"/>

                <td class="fw-bold">#<%=t.getToppingId()%></td>

                <td>
                  <input class="form-control" name="name" value="<%=t.getName()%>" required/>
                </td>

                <td>
                  <input class="form-control text-end" type="number" name="price" min="0" value="<%=t.getPrice()%>" required/>
                </td>

                <td>
                  <div class="d-flex align-items-center gap-2">
                    <input class="form-check-input" type="checkbox" name="active" <%=t.isActive()?"checked":""%> />

                    <% if (t.isActive()) { %>
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
                  <div class="at-actions">
                    <button class="btn btn-outline-primary btn-sm">
                      <i class="bi bi-save2 me-1"></i> Save
                    </button>

                    <a class="btn btn-outline-danger btn-sm"
                       href="<%=request.getContextPath()%>/admin/toppings?action=delete&id=<%=t.getToppingId()%>"
                       onclick="return confirm('Xóa topping này?')">
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

    <div class="text-muted small mt-2 d-flex align-items-start gap-2">
      <i class="bi bi-info-circle mt-1"></i>
      <div>* Topping chỉ hiển thị cho khách khi <b>Active</b> được bật.</div>
    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/adminFooter.jsp"/>
