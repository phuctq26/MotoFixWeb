<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Dịch vụ | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <c:set scope="request" var="activeMenu" value="services"/>
    <c:set scope="request" var="pageTitle"  value="Danh sách dịch vụ"/>
    <%@ include file="_sidebar.jspf" %>
    <main class="content">
      <%@ include file="_topbar.jspf" %>

      <%-- Success --%>
      <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show">
          <i class="bi bi-check-circle me-2"></i>${sessionScope.message}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
      </c:if>
      <%-- Error --%>
      <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show">
          <i class="bi bi-exclamation-triangle me-2"></i>${sessionScope.error}
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
      </c:if>

      <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
          <div class="input-group" style="max-width:360px;">
            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
            <input class="form-control" id="searchInput" placeholder="Tìm dịch vụ..." oninput="filterCards()" />
          </div>
          <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addServiceModal">
            <i class="bi bi-plus-lg"></i> Thêm dịch vụ
          </button>
        </div>

        <!-- ===== ADD MODAL ===== -->
        <div class="modal fade" id="addServiceModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <form method="post" action="${pageContext.request.contextPath}/admin/services">
                <div class="modal-header">
                  <h5 class="modal-title"><i class="bi bi-wrench-adjustable me-2 text-primary"></i>Thêm dịch vụ mới</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <div class="row g-3">
                    <div class="col-12">
                      <label class="form-label fw-semibold">Tên dịch vụ <span class="text-danger">*</span></label>
                      <input class="form-control" name="name" placeholder="VD: Thay nhớt, Vá xe..." required>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-semibold">Mô tả</label>
                      <textarea class="form-control" name="description" rows="2"
                                placeholder="Mô tả ngắn về dịch vụ..."></textarea>
                    </div>
                    <div class="col-md-8">
                      <label class="form-label fw-semibold">Giá niêm yết (VNĐ) <span class="text-danger">*</span></label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-tag text-primary"></i></span>
                        <input class="form-control" name="price" type="number" min="0" placeholder="150000" required>
                      </div>
                    </div>
                    <div class="col-md-4 d-flex flex-column justify-content-end">
                      <label class="form-label fw-semibold">Trạng thái</label>
                      <div class="form-check form-switch mb-2">
                        <input class="form-check-input" type="checkbox" name="isActive" value="1"
                               id="addIsActive" checked>
                        <label class="form-check-label" for="addIsActive">Đang hoạt động</label>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                  <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>Thêm mới</button>
                </div>
              </form>
            </div>
          </div>
        </div>

        <!-- ===== SERVICE CARDS ===== -->
        <div class="row g-3" id="serviceCards">
          <c:choose>
            <c:when test="${not empty services}">
              <c:forEach var="s" items="${services}">
                <div class="col-md-4 service-card-col">
                  <div class="card h-100 shadow-sm border-0 position-relative service-card-item">

                    <!-- Status badge -->
                    <c:choose>
                      <c:when test="${s.active}">
                        <span class="position-absolute top-0 end-0 m-2 badge bg-success-subtle text-success border border-success-subtle">
                          <i class="bi bi-circle-fill me-1" style="font-size:.45rem"></i>Hoạt động
                        </span>
                      </c:when>
                      <c:otherwise>
                        <span class="position-absolute top-0 end-0 m-2 badge bg-secondary-subtle text-secondary border border-secondary-subtle">
                          Ngừng HĐ
                        </span>
                      </c:otherwise>
                    </c:choose>

                    <div class="card-body pt-4">
                      <div class="service-icon mb-2">
                        <i class="bi bi-wrench-adjustable text-primary" style="font-size:1.6rem"></i>
                      </div>
                      <h6 class="fw-bold mb-1"><c:out value="${s.serviceName}"/></h6>
                      <p class="text-muted small mb-2" style="min-height:38px;">
                        <c:out value="${empty s.description ? 'Dịch vụ sửa chữa & bảo dưỡng' : s.description}"/>
                      </p>
                      <div class="fw-bold text-primary fs-5 mb-3">
                        <fmt:formatNumber value="${s.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                      </div>
                      <div class="d-flex gap-2">
                        <button class="btn btn-sm btn-outline-primary flex-fill" data-bs-toggle="modal"
                                data-bs-target="#editModal${s.serviceId}">
                          <i class="bi bi-pencil me-1"></i>Sửa
                        </button>
                        <c:choose>
                          <c:when test="${s.active}">
                            <button class="btn btn-sm btn-outline-warning" data-bs-toggle="modal"
                                    data-bs-target="#deleteModal${s.serviceId}" title="Ngừng hoạt động">
                              <i class="bi bi-slash-circle"></i>
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button class="btn btn-sm btn-outline-secondary" disabled
                                    title="Dịch vụ đã dùng trong phiếu sửa. Kích hoạt lại bằng Sửa.">
                              <i class="bi bi-lock-fill"></i>
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- EDIT MODAL -->
                <div class="modal fade" id="editModal${s.serviceId}" tabindex="-1">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <form method="post" action="${pageContext.request.contextPath}/admin/services">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id"     value="${s.serviceId}">
                        <div class="modal-header">
                          <h5 class="modal-title"><i class="bi bi-pencil me-2 text-primary"></i>Sửa dịch vụ</h5>
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                          <div class="row g-3">
                            <div class="col-12">
                              <label class="form-label fw-semibold">Tên dịch vụ <span class="text-danger">*</span></label>
                              <input class="form-control" name="name" value="${fn:escapeXml(s.serviceName)}" required>
                            </div>
                            <div class="col-12">
                              <label class="form-label fw-semibold">Mô tả</label>
                              <textarea class="form-control" name="description" rows="2"><c:out value="${s.description}"/></textarea>
                            </div>
                            <div class="col-md-8">
                              <label class="form-label fw-semibold">Giá niêm yết (VNĐ) <span class="text-danger">*</span></label>
                              <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-tag text-primary"></i></span>
                                <input class="form-control" name="price" type="number" min="0"
                                       value="${s.price}" required>
                              </div>
                            </div>
                            <div class="col-md-4 d-flex flex-column justify-content-end">
                              <label class="form-label fw-semibold">Trạng thái</label>
                              <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" name="isActive" value="1"
                                       id="isActive${s.serviceId}" ${s.active ? 'checked' : ''}>
                                <label class="form-check-label" for="isActive${s.serviceId}">Đang hoạt động</label>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="modal-footer">
                          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                          <button type="submit" class="btn btn-primary"><i class="bi bi-check-lg me-1"></i>Lưu thay đổi</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>

                <!-- DEACTIVATE MODAL -->
                <div class="modal fade" id="deleteModal${s.serviceId}" tabindex="-1">
                  <div class="modal-dialog modal-sm">
                    <div class="modal-content">
                      <form method="post" action="${pageContext.request.contextPath}/admin/services">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="id"     value="${s.serviceId}">
                        <div class="modal-header border-0 pb-0">
                          <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body text-center pt-0">
                          <div class="text-warning fs-1"><i class="bi bi-slash-circle-fill"></i></div>
                          <h6 class="mb-1 mt-2">Ngừng hoạt động dịch vụ?</h6>
                          <p class="text-muted small mb-0">
                            Dịch vụ <strong><c:out value="${s.serviceName}"/></strong> sẽ chuyển sang
                            <strong>Ngừng hoạt động</strong>.<br>
                            Bạn có thể kích hoạt lại bằng cách <em>Sửa → Bật toggle</em>.
                          </p>
                        </div>
                        <div class="modal-footer border-0 justify-content-center gap-2">
                          <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Hủy</button>
                          <button type="submit" class="btn btn-warning btn-sm px-4 text-white">
                            <i class="bi bi-slash-circle me-1"></i>Ngừng hoạt động
                          </button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <div class="col-12 text-center text-muted py-5">
                <i class="bi bi-wrench fs-1 d-block mb-2 opacity-25"></i>
                Chưa có dịch vụ nào trong hệ thống.
              </div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="text-muted small mt-4">
          Tổng: <strong>${fn:length(services)}</strong> dịch vụ
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>

  <script>
    function filterCards() {
      const q = document.getElementById('searchInput').value.toLowerCase();
      document.querySelectorAll('.service-card-col').forEach(col => {
        col.style.display = col.textContent.toLowerCase().includes(q) ? '' : 'none';
      });
    }
  </script>
</body>
</html>
