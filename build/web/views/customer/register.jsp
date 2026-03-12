<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Đăng ký | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","register"); %>
  <%@ include file="_header.jspf" %>

  <section class="py-5">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-lg-6">
          <div class="auth-card text-center">
            <h3 class="fw-bold">Đăng ký tài khoản</h3>
            <p class="text-muted">Trở thành thành viên của MotoFix ngay hôm nay</p>

            <% if (request.getAttribute("error") != null) { %>
              <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>

            <form class="text-start mt-4" method="post" action="${pageContext.request.contextPath}/register">
              <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <input class="form-control" name="fullName" placeholder="Nguyễn Văn A" required value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>" />
              </div>
              <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input class="form-control" name="phone" placeholder="0901234567" required pattern="0\d{9}" title="Số điện thoại phải gồm 10 chữ số và bắt đầu bằng số 0"
                       value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>" />
                <% if ("phone".equals(request.getAttribute("errorField"))) { %>
                  <div class="text-danger small mt-1"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
              </div>
              <div class="mb-3">
                <label class="form-label">Mật khẩu</label>
                <input type="password" class="form-control" name="password" required 
                       pattern=".{6,}"
                       title="Tối thiểu 6 ký tự" />
                <% if ("password".equals(request.getAttribute("errorField"))) { %>
                  <div class="text-danger small mt-1"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
              </div>
              <div class="mb-3">
                <label class="form-label">Xác nhận mật khẩu</label>
                <input type="password" class="form-control" name="confirm" required />
                <% if ("confirm".equals(request.getAttribute("errorField"))) { %>
                  <div class="text-danger small mt-1"><%= request.getAttribute("errorMessage") %></div>
                <% } %>
              </div>
              <button class="btn btn-primary w-100">Đăng ký</button>
              <div class="text-center mt-3">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
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
