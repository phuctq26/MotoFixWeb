<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Đặt lịch thành công | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <%@ include file="_header.jspf" %>

  <section class="py-5">
    <div class="container">
      <div class="auth-card text-center" style="max-width:640px; margin:0 auto;">
        <div class="display-6 text-success"><i class="bi bi-check-circle"></i></div>
        <h3 class="fw-bold mt-3">Đặt lịch thành công</h3>
        <p class="text-muted">Yêu cầu của bạn đã được ghi nhận. Chúng tôi sẽ liên hệ xác nhận trong thời gian sớm nhất.</p>
        <div class="table-card mt-4 text-start">
          <div class="d-flex justify-content-between">
            <span>Mã đặt lịch</span>
            <strong>BK-2026-001</strong>
          </div>
          <div class="d-flex justify-content-between mt-2">
            <span>Thời gian</span>
            <strong>29/01/2026 09:30</strong>
          </div>
          <div class="d-flex justify-content-between mt-2">
            <span>Xe</span>
            <strong>Honda AirBlade • 59-C1 123.45</strong>
          </div>
        </div>
        <div class="d-flex gap-2 justify-content-center mt-4">
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/booking-detail">Xem chi tiết</a>
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/home">Về trang chủ</a>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
