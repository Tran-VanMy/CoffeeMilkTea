<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="Modal.bean.Voucher" %>

<jsp:include page="/WEB-INF/views/layout/adminHeader.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));
  String msg = (String) request.getAttribute("msg");
  String error = (String) request.getAttribute("error");
  List<Voucher> vouchers = (List<Voucher>) request.getAttribute("vouchers");
%>

<!-- Hero -->
<div class="av-hero mb-3">
  <div class="d-flex flex-wrap align-items-center justify-content-between gap-2">
    <div class="d-flex align-items-center gap-2">
      <span class="av-hero__icon"><i class="bi bi-ticket-perforated-fill"></i></span>
      <div>
        <h4 class="mb-0 fw-bold">Vouchers</h4>
        <div class="text-white-50 small">Tạo / cập nhật voucher, bật tắt và quản lý thời gian áp dụng</div>
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

<!-- UPSERT FORM -->
<div class="card shadow-sm border-0 av-card mb-3">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-plus-circle me-2 text-primary"></i>Thêm / Cập nhật Voucher
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-pencil-square me-1"></i> Upsert
      </span>
    </div>

    <!-- LOGIC giữ nguyên: method=get action=upsert, field names giữ nguyên -->
    <form class="row g-3" action="<%=request.getContextPath()%>/admin/vouchers" method="get">
      <input type="hidden" name="action" value="upsert"/>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-hash me-1"></i> ID
        </label>
        <input class="form-control" name="id" placeholder="(trống nếu thêm)"/>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-upc-scan me-1"></i> Code
        </label>
        <input class="form-control" name="code" required placeholder="VD: SALE10"/>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-sliders me-1"></i> Type
        </label>
        <select class="form-select" name="type" required>
          <option value="PERCENT">PERCENT</option>
          <option value="AMOUNT">AMOUNT</option>
          <option value="FREESHIP">FREESHIP</option>
        </select>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-cash-coin me-1"></i> Value
        </label>
        <input class="form-control" type="number" name="value" value="0" min="0" required/>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-bag me-1"></i> Min subtotal
        </label>
        <input class="form-control" type="number" name="minSubtotal" value="0" min="0" required/>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-shield-plus me-1"></i> Max discount
        </label>
        <input class="form-control" type="number" name="maxDiscount" min="0" placeholder="optional"/>
      </div>

      <div class="col-md-2">
        <label class="form-label fw-semibold">
          <i class="bi bi-box-seam me-1"></i> Quantity
        </label>
        <input class="form-control" type="number" name="quantity" value="0" min="0" required/>
      </div>

      <div class="col-md-3">
        <label class="form-label fw-semibold">
          <i class="bi bi-calendar-event me-1"></i> StartAt
        </label>
        <input class="form-control" type="datetime-local" name="startAt"/>
      </div>

      <div class="col-md-3">
        <label class="form-label fw-semibold">
          <i class="bi bi-calendar-x me-1"></i> EndAt
        </label>
        <input class="form-control" type="datetime-local" name="endAt"/>
      </div>

      <div class="col-md-2 d-flex align-items-end">
        <div class="form-check">
          <input class="form-check-input" type="checkbox" name="active" id="vA" checked>
          <label class="form-check-label fw-semibold" for="vA">
            Active
          </label>
        </div>
      </div>

      <div class="col-md-2 d-flex align-items-end">
        <button class="btn btn-dark w-100">
          <i class="bi bi-save2 me-1"></i> Save
        </button>
      </div>

      <div class="col-12">
        <div class="small text-muted d-flex align-items-start gap-2">
          <i class="bi bi-info-circle mt-1"></i>
          <div>
            * Nếu nhập <b>ID</b> thì cập nhật; để trống thì thêm mới.
          </div>
        </div>
      </div>
    </form>
  </div>
</div>

<!-- LIST -->
<div class="card shadow-sm border-0 av-card">
  <div class="card-body">
    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-2">
      <h5 class="fw-bold mb-0">
        <i class="bi bi-list-check me-2 text-primary"></i>Danh sách voucher
      </h5>
      <span class="badge text-bg-light border">
        <i class="bi bi-arrow-repeat me-1"></i> Toggle active
      </span>
    </div>

    <div class="table-responsive">
      <table class="table align-middle av-table mb-0">
        <thead>
          <tr>
            <th style="width:90px;">ID</th>
            <th style="min-width:140px;">Code</th>
            <th style="width:140px;">Type</th>
            <th class="text-end" style="width:120px;">Value</th>
            <th class="text-end" style="width:130px;">Min</th>
            <th class="text-end" style="width:130px;">Max</th>
            <th class="text-end" style="width:90px;">Qty</th>
            <th style="width:140px;">Active</th>
            <th style="min-width:170px;">Start</th>
            <th style="min-width:170px;">End</th>
            <th class="text-end" style="width:120px;"></th>
          </tr>
        </thead>

        <tbody>
          <% if (vouchers == null || vouchers.isEmpty()) { %>
            <tr>
              <td colspan="11" class="text-center text-muted py-4">
                <div class="av-empty">
                  <div class="av-empty__icon mb-2"><i class="bi bi-inbox"></i></div>
                  <div class="fw-bold">Chưa có voucher</div>
                  <div class="text-muted small">Hãy tạo voucher ở form phía trên.</div>
                </div>
              </td>
            </tr>
          <% } else {
               for (Voucher v : vouchers) { %>
            <tr>
              <td class="fw-bold">#<%=v.getVoucherId()%></td>

              <td>
                <span class="av-code"><i class="bi bi-upc-scan me-1"></i><%=v.getCode()%></span>
              </td>

              <td>
                <span class="badge av-type av-type-<%=v.getType()%>">
                  <i class="bi bi-tag-fill me-1"></i><%=v.getType()%>
                </span>
              </td>

              <td class="text-end fw-semibold"><%=nf.format(v.getValue())%></td>
              <td class="text-end"><%=nf.format(v.getMinSubtotal())%></td>
              <td class="text-end"><%= (v.getMaxDiscount()==null ? "-" : nf.format(v.getMaxDiscount())) %></td>
              <td class="text-end"><span class="badge text-bg-light border"><i class="bi bi-box-seam me-1"></i><%=v.getQuantity()%></span></td>

              <!-- ✅ Active selection (auto submit) - GIỮ NGUYÊN LOGIC -->
              <td>
                <form action="<%=request.getContextPath()%>/admin/vouchers" method="post" class="d-inline">
                  <input type="hidden" name="action" value="setActive"/>
                  <input type="hidden" name="id" value="<%=v.getVoucherId()%>"/>
                  <select class="form-select form-select-sm" name="activeVal" onchange="this.form.submit()">
                    <option value="1" <%= v.isActive() ? "selected" : "" %>>1</option>
                    <option value="0" <%= !v.isActive() ? "selected" : "" %>>0</option>
                  </select>
                </form>

                <% if (v.isActive()) { %>
                  <div class="small text-success mt-1">
                    <i class="bi bi-check2-circle me-1"></i> On
                  </div>
                <% } else { %>
                  <div class="small text-danger mt-1">
                    <i class="bi bi-x-circle me-1"></i> Off
                  </div>
                <% } %>
              </td>

              <td class="text-muted small"><i class="bi bi-calendar-event me-1"></i><%=v.getStartAt()%></td>
              <td class="text-muted small"><i class="bi bi-calendar-x me-1"></i><%=v.getEndAt()%></td>

              <!-- ✅ Delete = HARD DELETE (GIỮ NGUYÊN LOGIC) -->
              <td class="text-end">
                <a class="btn btn-outline-danger btn-sm"
                   href="<%=request.getContextPath()%>/admin/vouchers?action=delete&id=<%=v.getVoucherId()%>"
                   onclick="return confirm('Xóa voucher này khỏi CSDL?')">
                  <i class="bi bi-trash3 me-1"></i> Delete
                </a>
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
