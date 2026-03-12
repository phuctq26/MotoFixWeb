<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Xe & tiến độ | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","vehicles"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Xe &amp; tiến độ sửa chữa</h2>
      <p class="text-light">Theo dõi trực tiếp tình trạng sửa chữa của xe bạn tại cửa hàng.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3">
          <% request.setAttribute("activeAccount","vehicles"); %>
          <%@ include file="_account_sidebar.jspf" %>
        </div>
        <div class="col-lg-9">
          <div class="table-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h5 class="fw-bold mb-0">Tiến độ sửa chữa</h5>
              <span class="text-muted small">Cập nhật bởi cửa hàng</span>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                <thead>
                  <tr>
                    <th>Ngày</th>
                    <th>Mã phiếu</th>
                    <th>Biển số</th>
                    <th>Trạng thái</th>
                    <th class="text-end">Thao tác</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    List<RepairTicket> tickets = (List<RepairTicket>) request.getAttribute("tickets");
                    SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
                    if (tickets != null && !tickets.isEmpty()) {
                      for (RepairTicket t : tickets) {
                        String status = t.getStatus();
                        String pill = "status-pill info";
                        String label = status;
                        if ("OPEN".equalsIgnoreCase(status)) { label = "Đã tiếp nhận"; pill = "status-pill info"; }
                        if ("IN_PROGRESS".equalsIgnoreCase(status)) { label = "Đang sửa"; pill = "status-pill warning"; }
                        if ("TESTING".equalsIgnoreCase(status)) { label = "Kiểm tra"; pill = "status-pill info"; }
                        if ("COMPLETED".equalsIgnoreCase(status)) { label = "Hoàn thành"; pill = "status-pill success"; }
                  %>
                  <tr>
                    <td><%= t.getCreatedAt() != null ? fmt.format(t.getCreatedAt()) : "" %></td>
                    <td><%= t.getTicketCode() %></td>
                    <td><%= t.getPlateNumber() %></td>
                    <td><span class="<%= pill %>"><%= label %></span></td>
                    <td class="text-end"><span class="text-muted small">Theo dõi tại cửa hàng</span></td>
                  </tr>
                  <% } } else { %>
                  <tr>
                    <td colspan="5" class="text-center text-muted">Chưa có phiếu sửa nào.</td>
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
