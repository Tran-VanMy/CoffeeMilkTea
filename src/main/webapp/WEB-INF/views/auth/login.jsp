<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/auth-ui.css">

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<!-- FULL PAGE WRAP: center + background -->
<div class="auth-wrap min-vh-100 d-flex align-items-center justify-content-center py-5">
  <div class="container">
    <div class="row justify-content-center w-100">
      <div class="col-md-7 col-lg-5">

        <!-- Hero -->
        <div class="login-hero mb-3">
          <div class="d-flex align-items-center gap-2">
            <span class="login-hero__icon"><i class="bi bi-person-lock"></i></span>
            <div>
              <h4 class="mb-0 fw-bold text-white">Đăng nhập</h4>
              <div class="text-white-50 small">Chào mừng bạn quay lại MilkTeaShop</div>
            </div>
          </div>
        </div>

        <div class="card shadow-sm border-0 login-card">
          <div class="card-body p-4">

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

            <form action="<%=request.getContextPath()%>/login" method="post">

              <div class="mb-3">
                <label class="form-label fw-semibold">Username</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-person"></i></span>
                  <input class="form-control" name="username" placeholder="Nhập username" required>
                </div>
              </div>

              <div class="mb-3">
                <label class="form-label fw-semibold">Password</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-lock"></i></span>
                  <input class="form-control" type="password" name="pass" placeholder="Nhập mật khẩu" required>
                  <button class="btn btn-outline-secondary" type="button" id="btnTogglePass" title="Hiện/ẩn mật khẩu">
                    <i class="bi bi-eye"></i>
                  </button>
                </div>
              </div>

              <%
                Integer attempts = (Integer) session.getAttribute("loginAttempts");
                if (attempts == null) attempts = 0;
                Boolean showCaptcha = (Boolean) request.getAttribute("showCaptcha");
                if (attempts >= 3 || (showCaptcha != null && showCaptcha)) {
              %>
              <div class="mb-3">
                <label class="form-label fw-semibold">CAPTCHA</label>

                <div class="d-flex align-items-center gap-3 flex-wrap">
                  <div class="login-captcha" title="Click để đổi mã">
                    <img src="<%=request.getContextPath()%>/captcha"
                         onclick="this.src='<%=request.getContextPath()%>/captcha?'+Math.random()"
                         style="cursor:pointer" alt="captcha"/>
                  </div>

                  <div class="flex-grow-1" style="min-width:220px;">
                    <div class="input-group">
                      <span class="input-group-text"><i class="bi bi-shield-check"></i></span>
                      <input class="form-control" name="captcha" placeholder="Nhập CAPTCHA" required>
                    </div>
                    <div class="text-muted small mt-1">
                      <i class="bi bi-arrow-repeat me-1"></i> Click vào ảnh để lấy mã mới
                    </div>
                  </div>
                </div>
              </div>
              <% } %>

              <button class="btn btn-primary w-100 fw-semibold py-2">
                <i class="bi bi-box-arrow-in-right me-2"></i>Login
              </button>

              <div class="text-center mt-3">
                <span class="text-muted">Chưa có tài khoản?</span>
                <a class="fw-semibold" href="<%=request.getContextPath()%>/register">Đăng ký</a>
              </div>
            </form>
          </div>
        </div>

        <div class="small text-muted mt-3 text-center">
          <i class="bi bi-shield-lock me-1"></i> Thông tin của bạn được bảo mật.
        </div>

      </div>
    </div>
  </div>
</div>

<script>
  // UI only: hiện/ẩn mật khẩu (không ảnh hưởng logic)
  (function () {
    var btn = document.getElementById('btnTogglePass');
    if (!btn) return;
    btn.addEventListener('click', function () {
      var pass = document.querySelector('input[name="pass"]');
      if (!pass) return;
      var isPw = pass.type === 'password';
      pass.type = isPw ? 'text' : 'password';
      btn.innerHTML = isPw ? '<i class="bi bi-eye-slash"></i>' : '<i class="bi bi-eye"></i>';
    });
  })();
</script>
