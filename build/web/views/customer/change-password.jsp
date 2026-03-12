<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Đổi mật khẩu | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container">
      <h2>Đổi mật khẩu</h2>
      <p class="text-light">Bảo mật tài khoản bằng mật khẩu mạnh hơn.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-3">
          <% request.setAttribute("activeAccount","change-password"); %>
          <%@ include file="_account_sidebar.jspf" %>
        </div>

        <div class="col-lg-9">
          <div class="form-card">
            <h5 class="fw-bold mb-3">Đổi mật khẩu</h5>
            
            <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success"><%= session.getAttribute("message") %></div>
                <% session.removeAttribute("message"); %>
            <% } %>
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= session.getAttribute("error") %></div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <form action="${pageContext.request.contextPath}/customer/change-password" method="post">
              <div class="mb-3">
                <label class="form-label">Mật khẩu hiện tại</label>
                <input type="password" class="form-control" name="currentPassword" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu mới</label>
                <input type="password" class="form-control" name="newPassword" required />
              </div>
              <div class="mb-3">
                <label class="form-label">Xác nhận mật khẩu mới</label>
                <input type="password" class="form-control" name="confirmPassword" required />
              </div>
              <div class="d-flex justify-content-end">
                  <button type="submit" class="btn btn-primary">Cập nhật mật khẩu</button>
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
