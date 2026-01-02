<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/auth-ui.css">

<!-- Bootstrap -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<div class="auth-wrap min-vh-100 d-flex align-items-center justify-content-center py-5">
  <div class="container">
    <div class="row justify-content-center w-100">
      <div class="col-md-7 col-lg-6">

        <!-- Hero -->
        <div class="register-hero mb-3">
          <div class="d-flex align-items-center gap-2">
            <span class="register-hero__icon"><i class="bi bi-person-plus"></i></span>
            <div>
              <h4 class="mb-0 fw-bold text-white">Đăng ký</h4>
              <div class="text-white-50 small">Tạo tài khoản để đặt đồ uống nhanh hơn</div>
            </div>
          </div>
        </div>

        <div class="card shadow-sm border-0 register-card">
          <div class="card-body p-4">

            <% if (request.getAttribute("error") != null) { %>
              <div class="alert alert-danger d-flex align-items-start gap-2">
                <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                <div><%=request.getAttribute("error")%></div>
              </div>
            <% } %>

            <form action="<%=request.getContextPath()%>/register" method="post">

              <div class="mb-3">
                <label class="form-label fw-semibold">Họ tên *</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                  <input class="form-control" name="fullName" placeholder="Nhập họ tên" required>
                </div>
              </div>

              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label fw-semibold">SĐT</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                    <input class="form-control" name="phone" placeholder="VD: 090xxxxxxx">
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="form-label fw-semibold">Email</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input class="form-control" type="email" name="email" placeholder="you@email.com">
                  </div>
                </div>
              </div>

              <div class="mt-3 mb-3">
                <label class="form-label fw-semibold">Username *</label>
                <div class="input-group">
                  <span class="input-group-text"><i class="bi bi-at"></i></span>
                  <input class="form-control" name="username" placeholder="Tạo username" required>
                </div>
              </div>

              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label fw-semibold">Password *</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input class="form-control" type="password" name="pass" placeholder="Nhập mật khẩu" required>
                    <button class="btn btn-outline-secondary" type="button" id="btnTogglePass" title="Hiện/ẩn mật khẩu">
                      <i class="bi bi-eye"></i>
                    </button>
                  </div>
                </div>

                <div class="col-md-6">
                  <label class="form-label fw-semibold">Nhập lại Password *</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-shield-lock"></i></span>
                    <input class="form-control" type="password" name="repass" placeholder="Nhập lại mật khẩu" required>
                    <button class="btn btn-outline-secondary" type="button" id="btnToggleRepass" title="Hiện/ẩn mật khẩu">
                      <i class="bi bi-eye"></i>
                    </button>
                  </div>
                </div>
              </div>

              <button class="btn btn-success w-100 fw-semibold py-2 mt-4">
                <i class="bi bi-person-check me-2"></i>Register
              </button>

              <div class="text-center mt-3">
                <span class="text-muted">Đã có tài khoản?</span>
                <a class="fw-semibold" href="<%=request.getContextPath()%>/login">Đăng nhập</a>
              </div>
            </form>
          </div>
        </div>

        <div class="small text-muted mt-3 text-center">
          <i class="bi bi-shield-check me-1"></i> Tài khoản của bạn được bảo vệ theo chính sách bảo mật.
        </div>

      </div>
    </div>
  </div>
</div>

<script>
  // UI only: hiện/ẩn mật khẩu (không ảnh hưởng logic)
  (function () {
    var btn1 = document.getElementById('btnTogglePass');
    var btn2 = document.getElementById('btnToggleRepass');

    function toggle(btn, selector){
      if(!btn) return;
      btn.addEventListener('click', function(){
        var input = document.querySelector(selector);
        if(!input) return;
        var isPw = input.type === 'password';
        input.type = isPw ? 'text' : 'password';
        btn.innerHTML = isPw ? '<i class="bi bi-eye-slash"></i>' : '<i class="bi bi-eye"></i>';
      });
    }

    toggle(btn1, 'input[name="pass"]');
    toggle(btn2, 'input[name="repass"]');
  })();
</script>

