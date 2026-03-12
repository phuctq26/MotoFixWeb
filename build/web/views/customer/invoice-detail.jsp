<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket,com.motofix.model.TicketItem" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Chi tiết hóa đơn | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","invoices"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Chi tiết hóa đơn</h2>
      <p class="text-light">Thông tin chi tiết các hạng mục đã sửa chữa.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>

      <%
        RepairTicket ticket = (RepairTicket) request.getAttribute("ticket");
        List<TicketItem> items = (List<TicketItem>) request.getAttribute("items");
        SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
      %>

      <% if (ticket == null) { %>
        <div class="table-card">Không tìm thấy hóa đơn.</div>
      <% } else { %>
        <div class="table-card p-4">
          <div class="d-flex justify-content-between align-items-center">
            <div>
              <h5 class="fw-bold mb-1"><%= ticket.getTicketCode() %></h5>
              <small class="text-muted">Ngày: <%= ticket.getCreatedAt() != null ? fmt.format(ticket.getCreatedAt()) : "" %></small>
            </div>
            <span class="status-pill success">Đã thanh toán</span>
          </div>
          <div class="mt-3 text-muted">
            Biển số: <strong><%= ticket.getPlateNumber() %></strong>
          </div>

          <div class="table-responsive mt-3">
            <table class="table align-middle">
              <thead>
                <tr>
                  <th>Hạng mục</th>
                  <th>Số lượng</th>
                  <th>Đơn giá</th>
                  <th class="text-end">Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <% if (items != null && !items.isEmpty()) {
                    for (TicketItem it : items) { %>
                  <tr>
                    <td><%= it.getItemName() %></td>
                    <td><%= it.getQuantity() %></td>
                    <td><%= String.format("%,.0f", it.getUnitPrice()) %>đ</td>
                    <td class="text-end fw-semibold"><%= String.format("%,.0f", it.getTotalPrice()) %>đ</td>
                  </tr>
                <% } } else { %>
                  <tr><td colspan="4" class="text-center text-muted">Chưa có hạng mục.</td></tr>
                <% } %>
              </tbody>
            </table>
          </div>

          <div class="d-flex justify-content-between mt-3">
            <span>Tạm tính</span>
            <strong><%= String.format("%,.0f", ticket.getTotalAmount()) %>đ</strong>
          </div>
          <div class="d-flex justify-content-between mt-2">
            <span>Giảm giá</span>
            <strong><%= String.format("%,.0f", ticket.getDiscount()) %>đ</strong>
          </div>
          <hr />
          <div class="d-flex justify-content-between">
            <span>Tổng thanh toán</span>
            <strong><%= String.format("%,.0f", ticket.getFinalAmount()) %>đ</strong>
          </div>

          <div class="mt-4">
            <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/invoices">Quay lại hóa đơn</a>
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/invoice-print?ticketId=<%= ticket.getTicketId() %>">Xuất hóa đơn (PDF)</a>
          </div>
        </div>
      <% } %>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
