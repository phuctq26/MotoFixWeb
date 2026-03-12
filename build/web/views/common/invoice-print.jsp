<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.text.SimpleDateFormat,com.motofix.model.RepairTicket,com.motofix.model.TicketItem" %>
<!doctype html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Hóa đơn</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 24px; color:#111; }
    h1 { font-size: 20px; margin-bottom: 4px; }
    .muted { color:#666; font-size: 12px; }
    table { width:100%; border-collapse: collapse; margin-top: 16px; }
    th, td { border-bottom: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background:#f6f6f6; }
    .total { text-align:right; font-weight:bold; }
    .actions { margin-top: 16px; }
    @media print { .actions { display:none; } }
  </style>
</head>
<body>
<%
  RepairTicket ticket = (RepairTicket) request.getAttribute("ticket");
  List<TicketItem> items = (List<TicketItem>) request.getAttribute("items");
  SimpleDateFormat fmt = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<h1>HÓA ĐƠN SỬA CHỮA</h1>
<div class="muted">MotoFix • 123 Nguyễn Văn Linh, Q7</div>
<div class="muted">Ngày: <%= ticket.getCreatedAt() != null ? fmt.format(ticket.getCreatedAt()) : "" %></div>

<hr />
<div>Khách hàng: <strong><%= ticket.getCustomerName() %></strong></div>
<div>SĐT: <strong><%= ticket.getPhone() %></strong></div>
<div>Biển số: <strong><%= ticket.getPlateNumber() %></strong></div>
<div>Mã phiếu: <strong><%= ticket.getTicketCode() %></strong></div>

<table>
  <thead>
    <tr>
      <th>Hạng mục</th>
      <th>Số lượng</th>
      <th>Đơn giá</th>
      <th>Thành tiền</th>
    </tr>
  </thead>
  <tbody>
  <% if (items != null && !items.isEmpty()) {
       for (TicketItem it : items) { %>
    <tr>
      <td><%= it.getItemName() %></td>
      <td><%= it.getQuantity() %></td>
      <td><%= String.format("%,.0f", it.getUnitPrice()) %>đ</td>
      <td><%= String.format("%,.0f", it.getTotalPrice()) %>đ</td>
    </tr>
  <% } } else { %>
    <tr><td colspan="4" class="muted">Chưa có hạng mục.</td></tr>
  <% } %>
  </tbody>
</table>

<div class="total">Tạm tính: <%= String.format("%,.0f", ticket.getTotalAmount()) %>đ</div>
<div class="total">Giảm giá: <%= String.format("%,.0f", ticket.getDiscount()) %>đ</div>
<div class="total">Tổng thanh toán: <%= String.format("%,.0f", ticket.getFinalAmount()) %>đ</div>

<div class="actions">
  <button onclick="window.print()">In / Lưu PDF</button>
</div>
</body>
</html>
