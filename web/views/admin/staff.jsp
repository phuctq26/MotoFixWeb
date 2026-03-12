<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Nhân sự | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <c:set scope="request" var="activeMenu" value="staff"/>
    <c:set scope="request" var="pageTitle"  value="Quản lý nhân sự"/>
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

      <%-- Form error --%>
      <c:set var="formError"  value="${sessionScope.formError}"/>
      <c:set var="fPhone"     value="${sessionScope.formPhone}"/>
      <c:set var="fFullName"  value="${sessionScope.formFullName}"/>
      <c:set var="fPosition"  value="${sessionScope.formPosition}"/>
      <c:set var="fSalary"    value="${sessionScope.formSalary}"/>
      <c:set var="fHireDate"  value="${sessionScope.formHireDate}"/>
      <c:set var="openModal"  value="${not empty formError}"/>
      <c:remove var="formError"   scope="session"/>
      <c:remove var="formPhone"   scope="session"/>
      <c:remove var="formFullName"  scope="session"/>
      <c:remove var="formPosition"  scope="session"/>
      <c:remove var="formSalary"    scope="session"/>
      <c:remove var="formHireDate"  scope="session"/>

      <div class="card p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div class="input-group" style="max-width:360px;">
            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
            <input class="form-control" id="searchInput" placeholder="Tìm theo tên hoặc chức vụ..." oninput="filterTable()" />
          </div>
          <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addStaffModal">
            <i class="bi bi-plus-lg"></i> Thêm nhân viên
          </button>
        </div>

        <!-- ===== ADD MODAL ===== -->
        <div class="modal fade" id="addStaffModal" tabindex="-1">
          <div class="modal-dialog">
            <div class="modal-content">
              <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                <div class="modal-header">
                  <h5 class="modal-title"><i class="bi bi-person-badge me-2 text-primary"></i>Thêm nhân viên mới</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <c:if test="${openModal and not empty formError}">
                    <div class="alert alert-danger py-2 d-flex align-items-center gap-2 mb-3">
                      <i class="bi bi-exclamation-triangle-fill flex-shrink-0"></i>
                      <span>${formError}</span>
                    </div>
                  </c:if>
                  <div class="row g-3">
                    <div class="col-12">
                      <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                      <input class="form-control" name="fullName" value="${fn:escapeXml(fFullName)}"
                             placeholder="VD: Trần Văn B" required>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-semibold">Số điện thoại</label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-phone"></i></span>
                        <input class="form-control ${openModal and not empty fPhone ? 'is-invalid' : ''}"
                               name="phone" value="${fn:escapeXml(fPhone)}" placeholder="0911000001">
                        <c:if test="${openModal and not empty fPhone}">
                          <div class="invalid-feedback">SĐT này đã tồn tại.</div>
                        </c:if>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-semibold">Chức vụ <span class="text-danger">*</span></label>
                      <select class="form-select" name="position" required>
                        <option value="" disabled ${empty fPosition ? 'selected' : ''}>-- Chọn chức vụ --</option>
                        <option value="Kỹ thuật trưởng" ${'Kỹ thuật trưởng' == fPosition ? 'selected' : ''}>Kỹ thuật trưởng</option>
                        <option value="Thợ chính"       ${'Thợ chính'       == fPosition ? 'selected' : ''}>Thợ chính</option>
                        <option value="Thợ phụ"         ${'Thợ phụ'         == fPosition ? 'selected' : ''}>Thợ phụ</option>
                        <option value="Thu ngân"        ${'Thu ngân'        == fPosition ? 'selected' : ''}>Thu ngân</option>
                        <option value="Tiếp tân"        ${'Tiếp tân'        == fPosition ? 'selected' : ''}>Tiếp tân</option>
                      </select>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-semibold">Lương (VNĐ)</label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-currency-dollar"></i></span>
                        <input class="form-control" name="salary" type="number" min="0"
                               value="${fn:escapeXml(fSalary)}" placeholder="8000000">
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label class="form-label fw-semibold">Ngày vào làm</label>
                      <input class="form-control" name="hireDate" type="date" value="${fn:escapeXml(fHireDate)}">
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-semibold">Trạng thái</label>
                      <select class="form-select" name="status">
                        <option value="ACTIVE"   selected>Đang làm việc</option>
                        <option value="INACTIVE">Đã nghỉ việc</option>
                      </select>
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

        <!-- ===== TABLE ===== -->
        <div class="table-responsive">
          <table class="table align-middle" id="staffTable">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Nhân viên</th>
                <th>Chức vụ</th>
                <th>Số điện thoại</th>
                <th class="text-end">Lương</th>
                <th class="text-center">Ngày vào làm</th>
                <th class="text-center">Trạng thái</th>
                <th class="text-end">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty staffs}">
                  <c:forEach var="s" items="${staffs}" varStatus="st">
                    <%-- Determine badge color for position --%>
                    <c:set var="pColor" value="primary"/>
                    <c:if test="${s.position == 'Kỹ thuật trưởng'}"><c:set var="pColor" value="danger"/></c:if>
                    <c:if test="${s.position == 'Thợ chính'}"><c:set var="pColor" value="warning"/></c:if>
                    <c:if test="${s.position == 'Thợ phụ'}"><c:set var="pColor" value="info"/></c:if>
                    <c:if test="${s.position == 'Thu ngân'}"><c:set var="pColor" value="success"/></c:if>

                    <tr>
                      <td class="text-muted small">${st.count}</td>
                      <td>
                        <div class="d-flex align-items-center gap-2">
                          <div class="avatar-circle bg-primary text-white">
                            ${fn:substring(s.fullName, 0, 1)}
                          </div>
                          <div>
                            <div class="fw-semibold">${fn:escapeXml(s.fullName)}</div>
                            <small class="text-muted">ID: #${s.employeeId}</small>
                          </div>
                        </div>
                      </td>
                      <td>
                        <span class="badge bg-${pColor}-subtle text-${pColor} border border-${pColor}-subtle">
                          <c:out value="${empty s.position ? '—' : s.position}"/>
                        </span>
                      </td>
                      <td><i class="bi bi-phone text-muted me-1"></i>
                        <c:out value="${empty s.phone ? '—' : s.phone}"/>
                      </td>
                      <td class="text-end fw-semibold">
                        <c:choose>
                          <c:when test="${s.salary > 0}">
                            <fmt:formatNumber value="${s.salary}" type="number" groupingUsed="true"/>đ
                          </c:when>
                          <c:otherwise><span class="text-muted">—</span></c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-center text-muted small">
                        <c:out value="${empty s.hireDate ? '—' : s.hireDate}"/>
                      </td>
                      <td class="text-center">
                        <c:choose>
                          <c:when test="${s.active}">
                            <span class="badge bg-success-subtle text-success border border-success-subtle">
                              <i class="bi bi-circle-fill me-1" style="font-size:.5rem"></i>Đang làm
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Đã nghỉ</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary" title="Sửa"
                                data-bs-toggle="modal" data-bs-target="#editModal${s.employeeId}">
                          <i class="bi bi-pencil"></i>
                        </button>
                        <c:choose>
                          <c:when test="${s.active}">
                            <button class="btn btn-sm btn-outline-warning" title="Đánh dấu nghỉ việc"
                                    data-bs-toggle="modal" data-bs-target="#deleteModal${s.employeeId}">
                              <i class="bi bi-slash-circle"></i>
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button class="btn btn-sm btn-outline-secondary" disabled
                                    title="Nhân viên đã nghỉ. Có thể kích hoạt lại bằng Sửa.">
                              <i class="bi bi-lock-fill"></i>
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </td>
                    </tr>

                    <!-- EDIT MODAL -->
                    <div class="modal fade" id="editModal${s.employeeId}" tabindex="-1">
                      <div class="modal-dialog">
                        <div class="modal-content">
                          <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id"     value="${s.employeeId}">
                            <div class="modal-header">
                              <h5 class="modal-title"><i class="bi bi-pencil me-2 text-primary"></i>Sửa nhân viên</h5>
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                              <div class="row g-3">
                                <div class="col-12">
                                  <label class="form-label fw-semibold">Họ và tên <span class="text-danger">*</span></label>
                                  <input class="form-control" name="fullName" value="${fn:escapeXml(s.fullName)}" required>
                                </div>
                                <div class="col-md-6">
                                  <label class="form-label fw-semibold">Số điện thoại</label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-phone"></i></span>
                                    <input class="form-control" name="phone" value="${fn:escapeXml(s.phone)}">
                                  </div>
                                </div>
                                <div class="col-md-6">
                                  <label class="form-label fw-semibold">Chức vụ <span class="text-danger">*</span></label>
                                  <select class="form-select" name="position" required>
                                    <option value="Kỹ thuật trưởng" ${'Kỹ thuật trưởng' == s.position ? 'selected' : ''}>Kỹ thuật trưởng</option>
                                    <option value="Thợ chính"       ${'Thợ chính'       == s.position ? 'selected' : ''}>Thợ chính</option>
                                    <option value="Thợ phụ"         ${'Thợ phụ'         == s.position ? 'selected' : ''}>Thợ phụ</option>
                                    <option value="Thu ngân"        ${'Thu ngân'        == s.position ? 'selected' : ''}>Thu ngân</option>
                                    <option value="Tiếp tân"        ${'Tiếp tân'        == s.position ? 'selected' : ''}>Tiếp tân</option>
                                  </select>
                                </div>
                                <div class="col-md-6">
                                  <label class="form-label fw-semibold">Lương (VNĐ)</label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-currency-dollar"></i></span>
                                    <input class="form-control" name="salary" type="number" min="0" value="${s.salary}">
                                  </div>
                                </div>
                                <div class="col-md-6">
                                  <label class="form-label fw-semibold">Ngày vào làm</label>
                                  <input class="form-control" name="hireDate" type="date" value="${fn:escapeXml(s.hireDate)}">
                                </div>
                                <div class="col-12">
                                  <label class="form-label fw-semibold">Trạng thái</label>
                                  <select class="form-select" name="status">
                                    <option value="ACTIVE"   ${s.active  ? 'selected' : ''}>Đang làm việc</option>
                                    <option value="INACTIVE" ${!s.active ? 'selected' : ''}>Đã nghỉ việc</option>
                                  </select>
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
                    <div class="modal fade" id="deleteModal${s.employeeId}" tabindex="-1">
                      <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                          <form method="post" action="${pageContext.request.contextPath}/admin/staff">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id"     value="${s.employeeId}">
                            <div class="modal-header border-0 pb-0">
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-center pt-0">
                              <div class="text-warning fs-1"><i class="bi bi-slash-circle-fill"></i></div>
                              <h6 class="mb-1 mt-2">Đánh dấu nghỉ việc?</h6>
                              <p class="text-muted small mb-0">
                                Nhân viên <strong>${fn:escapeXml(s.fullName)}</strong> sẽ chuyển sang trạng thái
                                <strong>Đã nghỉ việc</strong>.<br>
                                Bạn có thể kích hoạt lại bằng cách <em>Sửa → Đang làm việc</em>.
                              </p>
                            </div>
                            <div class="modal-footer border-0 justify-content-center gap-2">
                              <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Hủy</button>
                              <button type="submit" class="btn btn-warning btn-sm px-4 text-white">
                                <i class="bi bi-slash-circle me-1"></i>Đánh dấu nghỉ việc
                              </button>
                            </div>
                          </form>
                        </div>
                      </div>
                    </div>
                  </c:forEach>
                </c:when>
                <c:otherwise>
                  <tr>
                    <td colspan="8" class="text-center text-muted py-5">
                      <i class="bi bi-people fs-1 d-block mb-2 opacity-25"></i>
                      Chưa có nhân viên nào trong hệ thống.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <div class="text-muted small mt-3" id="pgInfo">Tổng: <strong>${fn:length(staffs)}</strong> nhân viên</div>
        <nav class="mt-2" id="pgNav"></nav>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>

  <style>
    .avatar-circle {
      width: 36px; height: 36px; border-radius: 50%;
      display: flex; align-items: center; justify-content: center;
      font-weight: 700; font-size: .9rem; flex-shrink: 0;
    }
  </style>
  <script>
    let currentPage = 1;
    let pageSize    = 10;

    function filterTable() { currentPage = 1; applyAll(); }

    function applyAll() {
      const q = document.getElementById('searchInput').value.toLowerCase();
      const rows = Array.from(document.querySelectorAll('#staffTable tbody tr'));

      rows.forEach(row => {
        row.dataset.visible = row.textContent.toLowerCase().includes(q) ? '1' : '0';
        row.style.display = 'none';
      });

      const visible = rows.filter(r => r.dataset.visible === '1');
      const total   = visible.length;
      const totalPages = Math.max(1, Math.ceil(total / pageSize));
      currentPage = Math.min(currentPage, totalPages);
      const from = (currentPage - 1) * pageSize;
      visible.forEach((row, idx) => {
        if (idx >= from && idx < from + pageSize) row.style.display = '';
      });
      const to = Math.min(from + pageSize, total);
      document.getElementById('pgInfo').innerHTML =
        'Hiển thị <strong>' + (total===0?0:from+1) + '\u2013' + to + '<\/strong> / <strong>' + total + '<\/strong> nhân viên';
      renderPagination(totalPages);
    }

    function renderPagination(totalPages) {
      const nav = document.getElementById('pgNav');
      if (totalPages <= 1) { nav.innerHTML = ''; return; }
      let html = '<ul class="pagination pagination-sm mb-0">';
      html += '<li class="page-item ' + (currentPage===1?'disabled':'') + '"><a class="page-link" href="#" onclick="goPage(' + (currentPage-1) + ');return false;">&laquo;<\/a><\/li>';
      let start = Math.max(1, currentPage - 3);
      let end   = Math.min(totalPages, start + 6);
      if (end - start < 6) start = Math.max(1, end - 6);
      for (let p = start; p <= end; p++) {
        html += '<li class="page-item ' + (p===currentPage?'active':'') + '"><a class="page-link" href="#" onclick="goPage(' + p + ');return false;">' + p + '<\/a><\/li>';
      }
      html += '<li class="page-item ' + (currentPage===totalPages?'disabled':'') + '"><a class="page-link" href="#" onclick="goPage(' + (currentPage+1) + ');return false;">&raquo;<\/a><\/li><\/ul>';
      nav.innerHTML = html;
    }

    function goPage(p) { currentPage = p; applyAll(); }
    window.addEventListener('DOMContentLoaded', () => applyAll());

    <c:if test="${openModal}">
    document.addEventListener('DOMContentLoaded', function () {
      new bootstrap.Modal(document.getElementById('addStaffModal')).show();
    });
    </c:if>
  </script>
</body>
</html>
