<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Chi tiết đặt lịch | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Chi tiết đặt lịch</h2>
      <p class="text-light">Theo dõi trạng thái xử lý yêu cầu của bạn.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="form-card">
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h5 class="fw-bold mb-1">BK-2026-001</h5>
            <small class="text-muted">Ngày tạo: 29/01/2026</small>
          </div>
          <span class="status-pill info">Đang chờ xác nhận</span>
        </div>
        <hr />
        <div class="row g-3">
          <div class="col-md-6">
            <div class="text-muted">Khách hàng</div>
            <div class="fw-semibold">Nguyễn Văn A</div>
            <div class="text-muted">0901234567</div>
          </div>
          <div class="col-md-6">
            <div class="text-muted">Xe</div>
            <div class="fw-semibold">Honda AirBlade</div>
            <div class="text-muted">59-C1 123.45</div>
          </div>
          <div class="col-md-6">
            <div class="text-muted">Thời gian hẹn</div>
            <div class="fw-semibold">29/01/2026 09:30</div>
          </div>
          <div class="col-md-6">
            <div class="text-muted">Dịch vụ</div>
            <div class="fw-semibold">Bảo dưỡng định kỳ</div>
          </div>
        </div>
        <div class="mt-3">
          <div class="text-muted">Ghi chú</div>
          <div>Xe bị rung khi chạy tốc độ cao.</div>
        </div>
        <div class="d-flex gap-2 mt-4">
          <button class="btn btn-outline-danger">Hủy lịch</button>
          <a class="btn btn-primary" href="${pageContext.request.contextPath}/booking">Đặt lịch mới</a>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
