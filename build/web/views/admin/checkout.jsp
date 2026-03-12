<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket,com.motofix.model.TicketItem" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Thanh toán | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","repairs"); %>
    <% request.setAttribute("pageTitle","Thanh toán & hóa đơn"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>
      <% if ("1".equals(request.getParameter("paid"))) { %>
        <div class="alert alert-success">Đã xác nhận thanh toán.</div>
      <% } %>

      <div class="row g-4">
        <div class="col-lg-5">
          <div class="card p-4">
            <h6 class="fw-bold mb-3">Phiếu chờ thanh toán</h6>
            <div class="table-responsive">
              <table class="table align-middle">
                <thead>
                  <tr>
                    <th>Mã phiếu</th>
                    <th>Khách hàng</th>
                    <th class="text-end">Tạm tính</th>
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
                    <td>
                      <a href="${pageContext.request.contextPath}/admin/checkout?ticketId=<%= t.getTicketId() %>"><%= t.getTicketCode() %></a>
                      <div class="small text-muted"><%= t.getCreatedAt() != null ? fmt.format(t.getCreatedAt()) : "" %></div>
                    </td>
                    <td>
                      <div class="fw-semibold"><%= t.getCustomerName() %></div>
                      <small class="text-muted"><%= t.getPlateNumber() %></small>
                    </td>
                    <td class="text-end fw-bold"><%= String.format("%,.0f", t.getFinalAmount()) %>đ</td>
                  </tr>
                  <% }
                    } else { %>
                  <tr>
                    <td colspan="3" class="text-center text-muted">Không có phiếu chờ thanh toán.</td>
                  </tr>
                  <% } %>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="col-lg-7">
          <div class="card p-4">
            <%
              RepairTicket ticket = (RepairTicket) request.getAttribute("ticket");
              List<TicketItem> items = (List<TicketItem>) request.getAttribute("items");
              String qrUrl = (String) request.getAttribute("qrUrl");
            %>
            <% if (ticket == null) { %>
              <div class="text-muted">Chọn một phiếu để xem chi tiết thanh toán.</div>
            <% } else { %>
              <h5 class="fw-bold mb-3">Chi tiết hóa đơn - <%= ticket.getTicketCode() %></h5>
              <div class="mb-2 text-muted">Khách: <strong><%= ticket.getCustomerName() %></strong> • <%= ticket.getPhone() %></div>
              <div class="mb-3 text-muted">Biển số: <strong><%= ticket.getPlateNumber() %></strong></div>

              <div class="table-responsive">
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
                      <tr><td colspan="4" class="text-muted text-center">Chưa có hạng mục.</td></tr>
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

              <% if (qrUrl != null && !qrUrl.isEmpty()) { %>
                <div class="mt-4">
                  <div class="fw-semibold mb-2">Quét mã QR để thanh toán</div>
                  <img src="<%= qrUrl %>" alt="VietQR" style="max-width:260px;" />
                </div>
              <% } %>

              <form method="post" action="${pageContext.request.contextPath}/admin/checkout" class="mt-3">
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>" />
                <label class="form-label">Phương thức thanh toán</label>
                <select class="form-select" name="paymentMethod">
                  <option value="CASH">Tiền mặt</option>
                  <option value="TRANSFER">Chuyển khoản</option>
                </select>
                <button class="btn btn-success w-100 mt-3">Xác nhận đã thanh toán</button>
              </form>
              <a class="btn btn-outline-secondary w-100 mt-2" href="${pageContext.request.contextPath}/admin/invoice-print?ticketId=<%= ticket.getTicketId() %>">Xuất hóa đơn (PDF)</a>
            <% } %>
          </div>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
