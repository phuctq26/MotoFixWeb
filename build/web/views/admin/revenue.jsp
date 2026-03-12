<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Hóa đơn & doanh thu | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","revenue"); %>
    <% request.setAttribute("pageTitle","Lịch sử hóa đơn & doanh thu"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>

      <div class="row g-3 mb-3">
        <div class="col-md-4">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-cash"></i></div>
              <div>
                <div class="text-muted">Tổng doanh thu (tháng này)</div>
                <div class="fw-bold"><%= String.format("%,.0f", request.getAttribute("revenueMonth") != null ? (Double) request.getAttribute("revenueMonth") : 0) %>đ</div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-receipt"></i></div>
              <div>
                <div class="text-muted">Số lượng hóa đơn</div>
                <div class="fw-bold"><%= request.getAttribute("invoiceCount") != null ? request.getAttribute("invoiceCount") : 0 %></div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="card stat-card">
            <div class="d-flex align-items-center gap-3">
              <div class="stat-icon"><i class="bi bi-calendar"></i></div>
              <div>
                <div class="text-muted">Hôm nay</div>
                <div class="fw-bold"><%= String.format("%,.0f", request.getAttribute("revenueToday") != null ? (Double) request.getAttribute("revenueToday") : 0) %>đ</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="card p-4">
        <div class="text-muted">Báo cáo doanh thu đang được tổng hợp từ các hóa đơn đã thanh toán.</div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
