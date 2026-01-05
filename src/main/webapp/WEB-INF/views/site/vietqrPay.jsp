<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>

<jsp:include page="/WEB-INF/views/layout/header.jsp"/>

<%
  NumberFormat nf = NumberFormat.getInstance(new Locale("vi","VN"));

  String qrUrl = (String) request.getAttribute("qrUrl");
  Long total = (Long) request.getAttribute("total");
  if (total == null) total = 0L;

  String addInfo = (String) request.getAttribute("addInfo");
  if (addInfo == null) addInfo = "";

  String ctx = request.getContextPath();

  String receiverName = (String) session.getAttribute("VIETQR_receiverName");
  String receiverPhone = (String) session.getAttribute("VIETQR_receiverPhone");
  String receiverAddress = (String) session.getAttribute("VIETQR_receiverAddress");
  String note = (String) session.getAttribute("VIETQR_note");
  if (note == null) note = "";
%>

<div class="container my-4">
  <div class="card shadow-sm border-0">
    <div class="card-body">
      <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
        <div>
          <h4 class="mb-1 fw-bold">
            <i class="bi bi-qr-code-scan me-2 text-primary"></i>Thanh toán thật (VietQR)
          </h4>
          <div class="text-muted small">
            Quét QR để chuyển khoản đúng số tiền. Sau khi chuyển khoản, bấm “Tôi đã thanh toán – Tạo đơn hàng”.
          </div>
        </div>

        <div class="d-flex gap-2">
          <a class="btn btn-outline-secondary btn-sm" href="<%=ctx%>/checkout">
            <i class="bi bi-arrow-left me-1"></i>Quay lại Checkout
          </a>
          <a class="btn btn-outline-primary btn-sm" href="<%=ctx%>/cart">
            <i class="bi bi-cart3 me-1"></i>Giỏ hàng
          </a>
        </div>
      </div>

      <div class="row g-3 align-items-stretch">
        <div class="col-lg-6">
          <div class="border rounded-3 p-3 h-100 bg-light">
            <div class="fw-semibold mb-2">
              Tổng cần thanh toán:
              <span class="text-danger fs-4 ms-2"><%=nf.format(total)%>đ</span>
            </div>

            <div class="small text-muted mb-2">
              Nội dung chuyển khoản (addInfo):
              <span class="fw-semibold"><%=addInfo%></span>
            </div>

            <div class="text-center">
              <% if (qrUrl != null && !qrUrl.trim().isEmpty()) { %>
                <img src="<%=qrUrl%>" class="img-fluid rounded-3 border bg-white" style="max-width: 420px;" alt="VietQR"/>
              <% } else { %>
                <div class="alert alert-danger mb-0">Không tạo được QR. Vui lòng kiểm tra cấu hình VietQRConfig.</div>
              <% } %>
            </div>

            <div class="small text-muted mt-3">
              <i class="bi bi-info-circle me-1"></i>
              Nếu QR không hiển thị, hãy liên hệ Admin ở SDT <b>0766796358</b>.
            </div>
          </div>
        </div>

        <div class="col-lg-6">
          <div class="border rounded-3 p-3 h-100">
            <div class="fw-bold mb-2">
              <i class="bi bi-clipboard-check me-2 text-success"></i>Bước tiếp theo
            </div>

            <ol class="mb-3">
              <li>Mở app ngân hàng → Quét QR → Chuyển đúng số tiền.</li>
              <li>Sau khi chuyển xong → bấm nút bên dưới để tạo đơn hàng.</li>
            </ol>

            <div class="alert alert-warning d-flex gap-2 align-items-start">
              <i class="bi bi-exclamation-triangle-fill mt-1"></i>
              <div class="small">
                Kiểm tra đầy đủ <b>Thông tin và số tiền</b>. Trước khi <b>thanh toán</b> đặt hàng.
              </div>
            </div>

            <!-- Bấm nút này sẽ POST về /checkout bằng đúng fields hiện tại -> giữ nguyên logic CheckoutController -->
            <form action="<%=ctx%>/checkout" method="post" class="d-grid gap-2">
              <input type="hidden" name="receiverName" value="<%= receiverName == null ? "" : receiverName %>"/>
              <input type="hidden" name="receiverPhone" value="<%= receiverPhone == null ? "" : receiverPhone %>"/>
              <input type="hidden" name="receiverAddress" value="<%= receiverAddress == null ? "" : receiverAddress %>"/>
              <input type="hidden" name="note" value="<%= note %>"/>

              <button class="btn btn-success btn-lg">
                <i class="bi bi-bag-check me-2"></i>Tôi đã thanh toán – Tạo đơn hàng
              </button>

              <a class="btn btn-outline-secondary" href="<%=ctx%>/checkout">
                Tôi muốn sửa thông tin nhận hàng
              </a>
            </form>

          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<jsp:include page="/WEB-INF/views/layout/footer.jsp"/>
