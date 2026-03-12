<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Yêu cầu tư vấn | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","consultations"); %>
    <% request.setAttribute("pageTitle","Danh sách cần tư vấn"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <h5 class="fw-bold mb-0">Quản lý yêu cầu tư vấn</h5>
          <div class="btn-group">
            <button class="btn btn-outline-secondary btn-sm">Tất cả</button>
            <button class="btn btn-outline-secondary btn-sm">Chờ xử lý</button>
            <button class="btn btn-outline-secondary btn-sm">Đã liên hệ</button>
          </div>
        </div>
        <div class="table-responsive">
          <table class="table align-middle">
            <thead>
              <tr>
                <th>Khách hàng</th>
                <th>Nội dung</th>
                <th>Thời gian gửi</th>
                <th>Trạng thái</th>
                <th class="text-end">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>
                  <div class="fw-semibold">Trần Văn Tùng</div>
                  <small class="text-muted">0909111222</small>
                </td>
                <td>Xe Exciter 150 kêu lạ, cần tư vấn thay nhớt và kiểm tra nồi.</td>
                <td>25/11/2023 14:30</td>
                <td><span class="badge-soft warning">Chờ xử lý</span></td>
                <td class="text-end">
                  <button class="btn btn-sm btn-primary">Gọi lại</button>
                  <button class="btn btn-sm btn-outline-danger"><i class="bi bi-trash"></i></button>
                </td>
              </tr>
              <tr>
                <td>
                  <div class="fw-semibold">Lê Thị Mai</div>
                  <small class="text-muted">0909887766</small>
                </td>
                <td>Tư vấn gói bảo dưỡng toàn bộ cho xe Vision 2019.</td>
                <td>25/11/2023 10:15</td>
                <td><span class="badge-soft success">Đã tư vấn</span></td>
                <td class="text-end">
                  <button class="btn btn-sm btn-outline-secondary">Xem</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
