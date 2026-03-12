<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Hồ sơ cá nhân | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","profile"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Hồ sơ cá nhân</h2>
      <p class="text-light">Quản lý thông tin cá nhân, xe của tôi và lịch sử dịch vụ.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3">
          <% request.setAttribute("activeAccount","profile"); %>
          <%@ include file="_account_sidebar.jspf" %>
        </div>

        <div class="col-lg-9">
            <div class="form-card">
            <h5 class="fw-bold mb-3">Thông tin cá nhân</h5>
            <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success"><%= session.getAttribute("message") %></div>
                <% session.removeAttribute("message"); %>
            <% } %>
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= session.getAttribute("error") %></div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <form action="${pageContext.request.contextPath}/customer/update-profile" method="post">
              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label">Họ và tên</label>
                  <input class="form-control" name="fullName" value="${sessionScope.user.fullName}" required />
                </div>
                <div class="col-md-6">
                  <label class="form-label">Số điện thoại</label>
                  <input class="form-control" name="phone" value="${sessionScope.user.phone}" required />
                </div>
              </div>
              <div class="mt-3">
                <label class="form-label">Địa chỉ</label>
                <input class="form-control" name="address" value="${sessionScope.user.address}" placeholder="Địa chỉ (nếu có)" />
              </div>

              <div class="d-flex justify-content-end mt-4">
                <button class="btn btn-primary" type="submit">Lưu thay đổi</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
