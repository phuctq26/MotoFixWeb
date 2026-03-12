<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Cứu hộ khẩn cấp | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","emergency"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container text-center">
      <h2>Cứu hộ khẩn cấp</h2>
      <p class="text-light">Hỗ trợ nhanh khi xe gặp sự cố giữa đường.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="row g-4">
        <div class="col-lg-6">
          <div class="form-card">
            <h5 class="fw-bold">Gọi ngay hotline</h5>
            <p class="text-muted">Đội cứu hộ 24/7 sẵn sàng hỗ trợ trong vòng 15-30 phút.</p>
            <a class="btn btn-danger" href="tel:0901234567"><i class="bi bi-telephone"></i> 090 123 4567</a>
            <div class="mt-4">
              <p><i class="bi bi-geo-alt"></i> Phạm vi hỗ trợ: TP. Hồ Chí Minh</p>
              <p><i class="bi bi-truck"></i> Miễn phí trong bán kính 5km</p>
            </div>
          </div>
        </div>
        <div class="col-lg-6">
          <div class="form-card">
            <h5 class="fw-bold">Gửi yêu cầu cứu hộ</h5>
            <form class="mt-3">
              <div class="mb-3">
                <label class="form-label">Họ và tên</label>
                <input class="form-control" placeholder="Nguyễn Văn A" />
              </div>
              <div class="mb-3">
                <label class="form-label">Số điện thoại</label>
                <input class="form-control" placeholder="090 xxx xxxx" />
              </div>
              <div class="mb-3">
                <label class="form-label">Vị trí hiện tại</label>
                <input class="form-control" placeholder="Nhập địa chỉ hoặc điểm mốc" />
              </div>
              <div class="mb-3">
                <label class="form-label">Mô tả sự cố</label>
                <textarea class="form-control" rows="3" placeholder="Xe bị thủng lốp, chết máy..." ></textarea>
              </div>
              <button class="btn btn-primary">Gửi yêu cầu</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
