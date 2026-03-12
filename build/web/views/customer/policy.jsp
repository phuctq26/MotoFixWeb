<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Chính sách | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","policy"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Chính sách &amp; điều khoản</h2>
      <p class="text-light">Cam kết minh bạch và bảo vệ quyền lợi khách hàng.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="form-card">
        <h5 class="fw-bold">1. Chính sách bảo hành</h5>
        <p>MotoFix bảo hành phụ tùng và công sửa chữa theo đúng quy định của hãng.</p>
        <h5 class="fw-bold mt-4">2. Chính sách đặt lịch</h5>
        <p>Khách hàng có thể thay đổi hoặc hủy lịch trước 2 giờ so với thời gian hẹn.</p>
        <h5 class="fw-bold mt-4">3. Chính sách thanh toán</h5>
        <p>Chấp nhận thanh toán tiền mặt, chuyển khoản hoặc ví điện tử.</p>
        <h5 class="fw-bold mt-4">4. Bảo mật thông tin</h5>
        <p>Chúng tôi cam kết bảo mật thông tin cá nhân và không chia sẻ cho bên thứ ba.</p>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
