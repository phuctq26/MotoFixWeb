<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Quên mật khẩu | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <%@ include file="_header.jspf" %>

  <section class="py-5">
    <div class="container">
      <div class="auth-card" style="max-width:520px; margin:0 auto;">
        <h4 class="fw-bold">Quên mật khẩu?</h4>
        <p class="text-muted">Nhập số điện thoại để nhận hướng dẫn đặt lại mật khẩu.</p>
        <form class="mt-3">
          <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input class="form-control" placeholder="0901234567" />
          </div>
          <button class="btn btn-primary w-100">Gửi yêu cầu</button>
          <div class="text-center mt-3">
            <a href="${pageContext.request.contextPath}/login">Quay lại đăng nhập</a>
          </div>
        </form>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
