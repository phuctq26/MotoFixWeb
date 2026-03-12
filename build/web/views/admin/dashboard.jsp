<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Dashboard | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","dashboard"); %>
    <% request.setAttribute("pageTitle","Dashboard Tổng Quan"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <div class="row g-3">
        <div class="col-md-3">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-currency-dollar"></i></div>
              <div>
                <div class="text-muted">Doanh thu hôm nay</div>
                <div class="fw-bold">4.500.000đ</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-tools"></i></div>
              <div>
                <div class="text-muted">Xe đang sửa</div>
                <div class="fw-bold">8</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-calendar-event"></i></div>
              <div>
                <div class="text-muted">Đặt lịch chờ duyệt</div>
                <div class="fw-bold">3</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-people"></i></div>
              <div>
                <div class="text-muted">Khách hàng mới</div>
                <div class="fw-bold">2</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="row g-4 mt-1">
        <div class="col-lg-7">
          <div class="card p-4">
            <h6 class="fw-bold mb-3">Biểu đồ doanh thu tuần</h6>
            <div class="chart-placeholder"></div>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="card p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h6 class="fw-bold mb-0">Hoạt động gần đây</h6>
              <a class="small text-decoration-none" href="#">Xem tất cả</a>
            </div>
            <div class="d-flex gap-3 mb-3">
              <span class="badge-soft warning">Yêu cầu mới</span>
              <div>
                <div class="fw-semibold">Nguyễn Văn A</div>
                <small class="text-muted">10 phút trước • Bảo dưỡng toàn bộ</small>
              </div>
            </div>
            <div class="d-flex gap-3 mb-3">
              <span class="badge-soft success">Hoàn thành</span>
              <div>
                <div class="fw-semibold">59-X2 987.65</div>
                <small class="text-muted">30 phút trước • KTV Trần B</small>
              </div>
            </div>
            <div class="d-flex gap-3">
              <span class="badge-soft danger">Cảnh báo kho</span>
              <div>
                <div class="fw-semibold">Bugi NGK sắp hết</div>
                <small class="text-muted">1 giờ trước • Còn lại: 2</small>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
