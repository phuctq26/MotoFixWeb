<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Đặt lịch | MotoFix</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <% request.setAttribute("activeMenu","booking"); %>
  <%@ include file="_header.jspf" %>

  <section class="page-hero">
    <div class="container text-center">
      <h2>Đặt lịch sửa chữa online</h2>
      <p class="text-light">Tiết kiệm thời gian chờ đợi. Dịch vụ chuyên nghiệp, phụ tùng chính hãng.</p>
    </div>
  </section>

  <section class="py-5">
    <div class="container">
      <div class="form-card">
        <h4 class="text-center fw-bold text-primary mb-4">Thông tin đặt lịch</h4>

        <% if (request.getAttribute("success") != null) { %>
          <div class="alert alert-success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
          <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/booking">
          <div class="row g-3">
            <div class="col-md-6">
              <label class="form-label">Họ và tên</label>
              <input class="form-control" name="fullName" value="${sessionScope.user.fullName}" placeholder="Nguyễn Văn A" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Số điện thoại</label>
              <input class="form-control" name="phone" value="${sessionScope.user.phone}" placeholder="0901234567" required />
            </div>
          </div>

          <% 
             java.util.List<com.motofix.model.Vehicle> vehicles = (java.util.List<com.motofix.model.Vehicle>) request.getAttribute("vehicles");
             boolean hasVehicles = (vehicles != null && !vehicles.isEmpty());
          %>

          <div class="row g-3 mt-1">
             <div class="col-12">
                 <label class="form-label fw-bold">Thông tin xe</label>
                 <% if (hasVehicles) { %>
                     <div class="mb-2">
                         <div class="form-check form-check-inline">
                             <input class="form-check-input" type="radio" name="vehicleOption" id="optExisting" value="existing" checked onchange="toggleVehicleForm()">
                             <label class="form-check-label" for="optExisting">Chọn xe đã có</label>
                         </div>
                         <div class="form-check form-check-inline">
                             <input class="form-check-input" type="radio" name="vehicleOption" id="optNew" value="new" onchange="toggleVehicleForm()">
                             <label class="form-check-label" for="optNew">Thêm xe mới</label>
                         </div>
                     </div>
                     
                     <div id="existingVehicleSelect">
                         <select class="form-select" name="vehicleId">
                             <% for (com.motofix.model.Vehicle v : vehicles) { %>
                                 <option value="<%= v.getVehicleId() %>"><%= v.getPlateNumber() %> - <%= v.getBrand() %> <%= v.getModel() %></option>
                             <% } %>
                         </select>
                     </div>
                 <% } else { %>
                     <input type="hidden" name="vehicleOption" value="new">
                 <% } %>
             </div>
          </div>

          <div id="newVehicleForm" class="row g-3 mt-1" style="<%= hasVehicles ? "display:none;" : "" %>">
            <div class="col-md-4">
              <label class="form-label">Biển số xe</label>
              <input class="form-control" name="plateNumber" placeholder="59-C1 123.45" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Hãng xe</label>
              <input class="form-control" name="brand" placeholder="Honda" />
            </div>
            <div class="col-md-4">
              <label class="form-label">Dòng xe</label>
              <input class="form-control" name="model" placeholder="AirBlade 2020" />
            </div>
          </div>

          <script>
              function toggleVehicleForm() {
                  var isNew = document.getElementById('optNew').checked;
                  document.getElementById('newVehicleForm').style.display = isNew ? 'flex' : 'none';
                  document.getElementById('existingVehicleSelect').style.display = isNew ? 'none' : 'block';
              }
          </script>

          <div class="row g-3 mt-1">
            <div class="col-md-6">
              <label class="form-label">Ngày hẹn</label>
              <input type="date" name="bookingDate" class="form-control" required />
            </div>
            <div class="col-md-6">
              <label class="form-label">Giờ hẹn</label>
              <input type="time" name="bookingTime" class="form-control" required />
            </div>
          </div>

          <div class="mt-3">
            <label class="form-label">Dịch vụ yêu cầu</label>
            <select class="form-select" name="service">
              <option>Bảo dưỡng định kỳ</option>
              <option>Thay nhớt</option>
              <option>Kiểm tra phanh</option>
            </select>
          </div>

          <div class="mt-3">
            <label class="form-label">Mô tả tình trạng xe (nếu có)</label>
            <textarea class="form-control" rows="4" name="note" placeholder="Ví dụ: Xe bị rung khi chạy tốc độ cao..."></textarea>
          </div>
          <button class="btn btn-primary w-100 mt-4">Xác nhận đặt lịch</button>
        </form>
      </div>
    </div>
  </section>

  <%@ include file="_footer.jspf" %>
</body>
</html>
