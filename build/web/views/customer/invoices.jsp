<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Hóa đơn | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","invoices"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Hóa đơn điện tử</h2>
      <p class="text-light">Tra cứu hóa đơn đã thanh toán.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3">
          <% request.setAttribute("activeAccount","invoices"); %>
          <%@ include file="_account_sidebar.jspf" %>
        </div>
        <div class="col-lg-9">
          <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
          <% } %>
          <div class="table-card">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <div class="input-group" style="max-width:360px;">
                <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                <input class="form-control" placeholder="Tìm mã hóa đơn..." />
              </div>
            </div>
            <div class="table-responsive">
              <table class="table align-middle">
                <thead>
                  <tr>
                    <th>Mã phiếu</th>
                    <th>Ngày</th>
                    <th>Biển số</th>
                    <th class="text-end">Tổng tiền</th>
                    <th class="text-end">Chi tiết</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    List<RepairTicket> tickets = (List<RepairTicket>) request.getAttribute("tickets");
                    SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
                    if (tickets != null && !tickets.isEmpty()) {
                      for (RepairTicket t : tickets) {
                  %>
                  <tr>
                    <td><%= t.getTicketCode() %></td>
                    <td><%= t.getCreatedAt() != null ? fmt.format(t.getCreatedAt()) : "" %></td>
                    <td><%= t.getPlateNumber() %></td>
                    <td class="text-end fw-bold"><%= String.format("%,.0f", t.getFinalAmount()) %>đ</td>
                    <td class="text-end"><a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/invoice-detail?ticketId=<%= t.getTicketId() %>">Xem</a></td>
                  </tr>
                  <% }
                    } else { %>
                  <tr>
                    <td colspan="5" class="text-center text-muted">Chưa có hóa đơn nào.</td>
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
