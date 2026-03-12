<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.motofix.model.User,com.motofix.model.Vehicle" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Tiếp nhận xe | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <% request.setAttribute("activeMenu","reception"); %>
    <% request.setAttribute("pageTitle","Tiếp nhận & tạo phiếu sửa"); %>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
      <% } %>
      <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("message") %></div>
      <% } %>

      <div class="row g-4">
        <div class="col-lg-8">
          <div class="card p-4">
            <h5 class="fw-bold mb-4">Tiếp nhận xe</h5>
            
            <!-- Step 1: Search -->
            <form method="post" action="${pageContext.request.contextPath}/admin/reception" class="mb-4">
              <input type="hidden" name="action" value="search" />
              <div class="input-group">
                <input class="form-control form-control-lg" name="phone" 
                       value="${searchedPhone}" 
                       placeholder="Nhập số điện thoại khách hàng..." required />
                <button class="btn btn-primary px-4"><i class="bi bi-search"></i> Tìm kiếm</button>
              </div>
            </form>

            <%
              User customer = (User) request.getAttribute("customer");
              List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
              boolean notFound = request.getAttribute("notFound") != null;
              String searchedPhone = (String) request.getAttribute("searchedPhone");
            %>

            <% if (customer != null || notFound) { %>
            <form method="post" action="${pageContext.request.contextPath}/admin/reception">
                <input type="hidden" name="action" value="createTicketCombined" />
                
                <!-- Step 2: Customer Info -->
                <div class="mb-4 p-3 bg-light rounded border">
                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-person-badge"></i> Thông tin khách hàng</h6>
                    <% if (customer != null) { %>
                        <!-- Existing Customer -->
                        <input type="hidden" name="customerType" value="existing" />
                        <input type="hidden" name="customerId" value="<%= customer.getUserId() %>" />
                        <div class="row">
                            <div class="col-md-6">
                                <label class="small text-muted">Họ tên</label>
                                <div class="fw-semibold"><%= customer.getFullName() %></div>
                            </div>
                            <div class="col-md-6">
                                <label class="small text-muted">Số điện thoại</label>
                                <div class="fw-semibold"><%= customer.getPhone() %></div>
                            </div>
                        </div>
                    <% } else { %>
                        <!-- New Customer -->
                        <input type="hidden" name="customerType" value="new" />
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                <input class="form-control" name="fullName" required />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                                <input class="form-control" name="phone" value="<%= searchedPhone %>" readonly />
                            </div>
                        </div>
                    <% } %>
                </div>

                <!-- Step 3: Vehicle Info -->
                <div class="mb-4 p-3 bg-light rounded border">
                    <h6 class="fw-bold text-primary mb-3"><i class="bi bi-bicycle"></i> Thông tin xe</h6>
                    
                    <% if (vehicles != null && !vehicles.isEmpty()) { %>
                        <!-- Existing Vehicles List -->
                        <div class="mb-3">
                            <label class="form-label d-block mb-2">Chọn xe đã có:</label>
                            <% for (Vehicle v : vehicles) { %>
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="vehicleOption" 
                                       id="v_<%= v.getVehicleId() %>" value="existing" 
                                       onclick="document.getElementById('vehicleIdInput').value='<%= v.getVehicleId() %>'; document.getElementById('newVehicleForm').style.display='none';" required>
                                <label class="form-check-label" for="v_<%= v.getVehicleId() %>">
                                    <strong><%= v.getPlateNumber() %></strong> - <%= v.getBrand() %> <%= v.getModel() %>
                                </label>
                            </div>
                            <% } %>
                            
                            <!-- Option to add new vehicle -->
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="vehicleOption" 
                                       id="v_new" value="new" 
                                       onclick="document.getElementById('newVehicleForm').style.display='block';" required>
                                <label class="form-check-label" for="v_new">
                                    <em>+ Thêm xe mới</em>
                                </label>
                            </div>
                            <input type="hidden" name="vehicleId" id="vehicleIdInput">
                        </div>
                    <% } else { %>
                        <!-- Force new vehicle for new customer or empty list -->
                        <input type="hidden" name="vehicleOption" value="new" />
                    <% } %>

                    <!-- New Vehicle Form -->
                    <div id="newVehicleForm" style="<%= (vehicles == null || vehicles.isEmpty()) ? "display:block" : "display:none" %>">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Biển số <span class="text-danger">*</span></label>
                                <input class="form-control" name="plateNumber" placeholder="VD: 59P1-12345" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Hãng xe</label>
                                <input class="form-control" name="brand" placeholder="Honda, Yamaha..." />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Dòng xe</label>
                                <input class="form-control" name="model" placeholder="Vision, AirBlade..." />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Step 4: Diagnosis -->
                <div class="mb-4">
                    <label class="form-label fw-bold">Mô tả hư hỏng / Yêu cầu <span class="text-danger">*</span></label>
                    <textarea class="form-control" name="diagnosis" rows="3" required placeholder="Khách báo tình trạng xe..."></textarea>
                </div>

                <div class="d-grid">
                    <button class="btn btn-primary btn-lg">Tạo phiếu tiếp nhận</button>
                </div>
            </form>
            <% } %>
          </div>
        </div>

        <div class="col-lg-4">
          <div class="card p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
              <h6 class="fw-bold mb-0">Tiếp nhận hôm nay</h6>
              <small class="text-muted">29/01/2026</small>
            </div>
            <div class="schedule-item">
              <div class="fw-semibold text-primary">59-C1 123.45</div>
              <small class="text-muted">Honda AirBlade</small>
              <div class="d-flex justify-content-between mt-2">
                <small class="text-muted">08:30</small>
                <span class="badge-soft warning">Đang sửa</span>
              </div>
            </div>
            <div class="schedule-item">
              <div class="fw-semibold text-primary">59-X2 999.99</div>
              <small class="text-muted">Vision 2021</small>
              <div class="d-flex justify-content-between mt-2">
                <small class="text-muted">09:15</small>
                <span class="badge-soft info">Chờ sửa</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>
</body>
</html>
