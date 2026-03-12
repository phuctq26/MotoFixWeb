<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.motofix.model.RepairTicket" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Lịch sử sửa chữa | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","history"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Lịch sử sửa chữa</h2>
      <p class="text-light">Xem lại các lần sửa chữa trước đây của bạn.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3">
          <% request.setAttribute("activeAccount","history"); %>
          <%@ include file="_account_sidebar.jspf" %>
        </div>
        <div class="col-lg-9">
          <div class="table-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div class="input-group" style="max-width:360px;">
                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                <input class="form-control" placeholder="Tìm theo biển số, dịch vụ..." />
              </div>
              <span class="text-muted small">Tổng: 3 phiếu</span>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                <thead>
                  <tr>
                    <th>Ngày</th>
                    <th>Biển số</th>
                    <th>Mã phiếu</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Tổng tiền</th>
                  </tr>
                </thead>
                <tbody>
                <tbody>
                  <%
                    List<RepairTicket> tickets = (List<RepairTicket>) request.getAttribute("tickets");
                    java.text.SimpleDateFormat fmt = new java.text.SimpleDateFormat("dd/MM/yyyy");
                    if (tickets != null && !tickets.isEmpty()) {
                      for (RepairTicket t : tickets) {
                  %>
                  <tr>
                    <td><%= t.getCreatedAt() != null ? fmt.format(t.getCreatedAt()) : "" %></td>
                    <td><%= t.getPlateNumber() %></td>
                    <td><%= t.getTicketCode() %></td>
                    <td><span class="badge bg-info text-dark"><%= t.getStatus() %></span></td>
                    <td class="text-end fw-bold"><%= String.format("%,.0f", t.getFinalAmount()) %>đ</td>
                  </tr>
                  <% }
                    } else { %>
                  <tr>
                    <td colspan="5" class="text-center text-muted">Chưa có lịch sử sửa chữa.</td>
                  </tr>
                  <% } %>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
