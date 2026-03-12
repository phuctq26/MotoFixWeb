<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Đăng nhập | MotoFix</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;600;700;800&display=swap" rel="stylesheet">
  <style>
    :root { --brand:#1e78ff; --ink:#1d232b; --soft:#f5f6f8; --nav:#1f2429; --shadow:0 18px 40px rgba(20,27,37,.12); --radius:18px; }
    body { font-family:"Manrope",sans-serif; background:var(--soft); color:var(--ink); }
    .site-navbar { background:linear-gradient(180deg,#262c33 0%,#1f2429 100%); box-shadow:0 6px 18px rgba(8,12,18,.2); }
    .brand { display:inline-flex; align-items:center; gap:.6rem; font-weight:800; letter-spacing:.4px; color:#fff; text-decoration:none; }
    .brand-icon { width:28px; height:28px; background:rgba(30,120,255,.15); border-radius:10px; display:grid; place-items:center; color:var(--brand); }
    .auth-wrap { padding:70px 0 90px; }
    .image-panel { border-radius:var(--radius); min-height:360px; background:url("https://images.unsplash.com/photo-1503376780353-7e6692767b70?q=80&w=1200&auto=format&fit=crop") center/cover; box-shadow:var(--shadow); position:relative; overflow:hidden; }
    .image-panel::after { content:""; position:absolute; inset:0; background:linear-gradient(120deg, rgba(30,120,255,.2), rgba(17,24,39,.35)); }
    .auth-panel { background:#fff; border-radius:var(--radius); box-shadow:var(--shadow); }
    .form-control { border-radius:12px; padding:.7rem 1rem; }
    .btn-primary { background:var(--brand); border-color:var(--brand); font-weight:700; border-radius:12px; box-shadow:0 10px 20px rgba(30,120,255,.25); }
    .site-footer { background:var(--nav); color:#cfd6dd; padding:40px 0 20px; margin-top:60px; }
    .site-footer h6 { color:#fff; font-weight:700; }
  </style>
</head>
<body>
  <nav class="navbar navbar-expand-lg navbar-dark site-navbar">
    <div class="container">
      <a class="brand" href="${pageContext.request.contextPath}/home">
        <span class="brand-icon"><i class="bi bi-lightning-charge-fill"></i></span>
        MotoFix
      </a>
    </div>
  </nav>

  <main class="auth-wrap">
    <div class="container">
      <div class="row g-4 align-items-center">
        <div class="col-lg-7">
          <div class="image-panel" role="img" aria-label="MotoFix service"></div>
        </div>
        <div class="col-lg-5">
          <div class="auth-panel p-4 p-md-5">
            <h2 class="fw-bold mb-2">Đăng nhập</h2>
            <p class="text-muted">Chào mừng bạn quay trở lại MotoFix</p>
            <% if (request.getAttribute("error") != null) { %>
              <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <form class="mt-4" method="post" action="${pageContext.request.contextPath}/login">
              <div class="mb-3">
                <label class="form-label">Tên đăng nhập</label>
                <input type="text" name="username" class="form-control" placeholder="admin_motofix" required>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required>
              </div>
              <div class="d-flex align-items-center justify-content-between mb-3">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="remember">
                  <label class="form-check-label" for="remember">Ghi nhớ</label>
                </div>
                <a href="${pageContext.request.contextPath}/forgot-password" class="text-decoration-none">Quên mật khẩu?</a>
              </div>
              <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
              <div class="text-center mt-3">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </main>

  <footer class="site-footer">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-4">
          <h6>MotoFix</h6>
          <p class="mb-2">Dịch vụ sửa chữa xe máy chuyên nghiệp, uy tín hàng đầu.</p>
        </div>
        <div class="col-lg-4">
          <h6>Liên kết nhanh</h6>
          <p class="mb-1">Về chúng tôi</p>
          <p class="mb-1">Dịch vụ</p>
          <p class="mb-1">Bảng giá</p>
        </div>
        <div class="col-lg-4">
          <h6>Liên hệ</h6>
          <p class="mb-1"><i class="bi bi-geo-alt"></i> 123 Nguyễn Văn Linh, Q7</p>
          <p class="mb-1"><i class="bi bi-telephone"></i> 090 123 4567</p>
        </div>
      </div>
    </div>
  </footer>
</body>
</html>
