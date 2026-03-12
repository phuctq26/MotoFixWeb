<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.motofix.model.Booking,java.text.SimpleDateFormat" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Yêu cầu đặt lịch | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","bookings"); %>
    <% request.setAttribute("pageTitle","Danh sách yêu cầu đặt lịch"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div class="input-group" style="max-width:360px;">
            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
            <input class="form-control" placeholder="Tìm theo tên hoặc SĐT..." />
          </div>
          <button class="btn btn-outline-secondary"><i class="bi bi-funnel"></i> Lọc</button>
        </div>

        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Khách hàng</th>
                <th>Xe</th>
                <th>Giờ hẹn</th>
                <th>Ghi chú</th>
                <th>Trạng thái</th>
                <th class="text-end">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <%
                List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy HH:mm");
                if (bookings != null && !bookings.isEmpty()) {
                  for (Booking b : bookings) {
                    String status = b.getStatus();
                    String badgeClass = "badge-soft info";
                    String statusText = status;
                    if ("PENDING".equalsIgnoreCase(status)) { badgeClass = "badge-soft warning"; statusText = "Chờ duyệt"; }
                    else if ("CONFIRMED".equalsIgnoreCase(status)) { badgeClass = "badge-soft info"; statusText = "Đã duyệt"; }
                    else if ("CANCELLED".equalsIgnoreCase(status)) { badgeClass = "badge-soft danger"; statusText = "Từ chối"; }
              %>
              <tr>
                <td>
                  <div class="fw-semibold"><%= b.getCustomerName() %></div>
                  <small class="text-muted"><%= b.getPhone() %></small>
                </td>
                <td><%= (b.getPlateNumber() == null ? "(Chưa có)" : b.getPlateNumber()) %></td>
                <td><%= b.getBookingDate() != null ? fmt.format(b.getBookingDate()) : "" %></td>
                <td><%= b.getNote() == null ? "" : b.getNote() %></td>
                <td><span class="<%= badgeClass %>"><%= statusText %></span></td>
                <td class="text-end">
                  <% if ("PENDING".equalsIgnoreCase(status)) { %>
                    <form method="post" action="${pageContext.request.contextPath}/admin/bookings" class="d-inline">
                      <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                      <input type="hidden" name="action" value="approve" />
                      <button class="btn btn-sm btn-primary">Duyệt</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/admin/bookings" class="d-inline">
                      <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>" />
                      <input type="hidden" name="action" value="reject" />
                      <button class="btn btn-sm btn-outline-danger">Từ chối</button>
                    </form>
                  <% } else { %>
                    <button class="btn btn-sm btn-outline-secondary" disabled>Đã xử lý</button>
                  <% } %>
                </td>
              </tr>
              <%
                  }
                } else {
              %>
              <tr>
                <td colspan="6" class="text-center text-muted">Chưa có yêu cầu đặt lịch.</td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
