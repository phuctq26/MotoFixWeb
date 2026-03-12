<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket,com.motofix.model.TicketItem,com.motofix.model.Service,com.motofix.model.Part" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Quản lý sửa chữa | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","repairs"); %>
    <% request.setAttribute("pageTitle","Quản lý sửa chữa"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>

      <div class="row g-4">
        <div class="col-lg-5">
          <div class="card p-4">
            <h6 class="fw-bold mb-3">Phiếu đang xử lý</h6>
            <div class="table-responsive">
              <table class="table align-middle">
                <thead>
                  <tr>
                    <th>Mã phiếu</th>
                    <th>Khách hàng</th>
                    <th class="text-end">Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    List<RepairTicket> tickets = (List<RepairTicket>) request.getAttribute("tickets");
                    SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy");
                    if (tickets != null && !tickets.isEmpty()) {
                      for (RepairTicket t : tickets) {
                        String status = t.getStatus();
                  %>
                  <tr>
                    <td>
                      <a href="${pageContext.request.contextPath}/admin/repairs?ticketId=<%= t.getTicketId() %>"><%= t.getTicketCode() %></a>
                      <div class="small text-muted"><%= t.getCreatedAt() != null ? fmt.format(t.getCreatedAt()) : "" %></div>
                    </td>
                    <td>
                      <div class="fw-semibold"><%= t.getCustomerName() %></div>
                      <small class="text-muted"><%= t.getPlateNumber() %></small>
                    </td>
                    <td class="text-end"><span class="badge-soft info"><%= status %></span></td>
                  </tr>
                  <% }
                    } else { %>
                  <tr>
                    <td colspan="3" class="text-center text-muted">Không có phiếu đang xử lý.</td>
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
            %>
            <% if (ticket == null) { %>
              <div class="text-muted">Chọn một phiếu để cập nhật sửa chữa.</div>
            <% } else { %>
              <h5 class="fw-bold mb-3">Chi tiết phiếu - <%= ticket.getTicketCode() %></h5>
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

              <form method="post" action="${pageContext.request.contextPath}/admin/repairs" class="row g-3 mt-3">
                <input type="hidden" name="action" value="addItem" />
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>" />
                <div class="col-md-4">
                  <label class="form-label">Chọn từ Catalog</label>
                  <select class="form-select" name="catalogId">
                    <option value="">-- Chọn --</option>
                    <%
                      List<Service> servicesList = (List<Service>) request.getAttribute("services");
                      List<Part> partsList = (List<Part>) request.getAttribute("parts");
                      if (servicesList != null) {
                        for (Service s : servicesList) {
                    %>
                      <option value="SERVICE_<%= s.getServiceId() %>">[DV] <%= s.getServiceName() %> - <%= String.format("%,.0f", s.getPrice()) %>đ</option>
                    <% } }
                      if (partsList != null) {
                        for (Part p : partsList) {
                    %>
                      <option value="PART_<%= p.getPartId() %>">[PT] <%= p.getPartName() %> - <%= String.format("%,.0f", p.getSellingPrice()) %>đ</option>
                    <% } } %>
                  </select>
                  <input type="hidden" name="mode" value="catalog" />
                </div>
                <div class="col-md-2">
                  <label class="form-label">SL</label>
                  <input class="form-control" name="quantity" value="1" />
                </div>
                <div class="col-md-6 d-flex align-items-end">
                  <button class="btn btn-primary w-100">Thêm từ Catalog</button>
                </div>
              </form>

              <div class="text-muted small mt-3">Hoặc nhập tay hạng mục (khi chưa có trong Catalog)</div>
              <form method="post" action="${pageContext.request.contextPath}/admin/repairs" class="row g-3 mt-2">
                <input type="hidden" name="action" value="addItem" />
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>" />
                <input type="hidden" name="mode" value="manual" />
                <div class="col-md-5">
                  <label class="form-label">Tên hạng mục</label>
                  <input class="form-control" name="itemName" required />
                </div>
                <div class="col-md-2">
                  <label class="form-label">SL</label>
                  <input class="form-control" name="quantity" value="1" />
                </div>
                <div class="col-md-3">
                  <label class="form-label">Đơn giá</label>
                  <input class="form-control" name="unitPrice" value="0" />
                </div>
                <div class="col-md-2">
                  <label class="form-label">Loại</label>
                  <select class="form-select" name="type">
                    <option value="PART">Phụ tùng</option>
                    <option value="SERVICE">Dịch vụ</option>
                  </select>
                </div>
                <div class="col-12">
                  <button class="btn btn-outline-primary">Thêm thủ công</button>
                </div>
              </form>

              <form method="post" action="${pageContext.request.contextPath}/admin/repairs" class="mt-4">
                <input type="hidden" name="action" value="updateStatus" />
                <input type="hidden" name="ticketId" value="<%= ticket.getTicketId() %>" />
                <label class="form-label">Cập nhật trạng thái</label>
                <select class="form-select" name="status">
                  <option value="OPEN" <%= "OPEN".equalsIgnoreCase(ticket.getStatus()) ? "selected" : "" %>>OPEN</option>
                  <option value="IN_PROGRESS" <%= "IN_PROGRESS".equalsIgnoreCase(ticket.getStatus()) ? "selected" : "" %>>IN_PROGRESS</option>
                  <option value="TESTING" <%= "TESTING".equalsIgnoreCase(ticket.getStatus()) ? "selected" : "" %>>TESTING</option>
                  <option value="COMPLETED" <%= "COMPLETED".equalsIgnoreCase(ticket.getStatus()) ? "selected" : "" %>>COMPLETED</option>
                </select>
                <button class="btn btn-success mt-3">Cập nhật trạng thái</button>
              </form>

              <div class="d-flex justify-content-between mt-4">
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
            <% } %>
          </div>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
