<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="vi">
<head>
  <title>Phụ tùng | MotoFix Admin</title>
  <%@ include file="_head.jspf" %>
</head>
<body>
  <div class="layout">
    <c:set scope="request" var="activeMenu" value="inventory"/>
    <c:set scope="request" var="pageTitle"  value="Kho phụ tùng"/>
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
        <div class="d-flex justify-content-between align-items-center mb-3">
          <div class="input-group" style="max-width:360px;">
            <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
            <input class="form-control" id="searchInput" placeholder="Tìm theo tên phụ tùng..." oninput="filterTable()" />
          </div>
          <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addPartModal">
            <i class="bi bi-plus-lg"></i> Thêm phụ tùng
          </button>
        </div>

        <!-- ===== ADD MODAL ===== -->
        <div class="modal fade" id="addPartModal" tabindex="-1">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <form method="post" action="${pageContext.request.contextPath}/admin/inventory">
                <div class="modal-header">
                  <h5 class="modal-title"><i class="bi bi-box-seam me-2 text-primary"></i>Thêm phụ tùng mới</h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                  <div class="row g-3">
                    <div class="col-12">
                      <label class="form-label fw-semibold">Tên phụ tùng <span class="text-danger">*</span></label>
                      <input class="form-control" name="name" placeholder="VD: Lọc dầu Honda" required>
                    </div>
                    <div class="col-12">
                      <label class="form-label fw-semibold">Mô tả</label>
                      <textarea class="form-control" name="description" rows="2" placeholder="Mô tả ngắn về phụ tùng..."></textarea>
                    </div>
                    <div class="col-md-4">
                      <label class="form-label fw-semibold">Giá nhập (VNĐ)</label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-arrow-down-circle text-secondary"></i></span>
                        <input class="form-control" name="importPrice" type="number" min="0" placeholder="50000">
                      </div>
                    </div>
                    <div class="col-md-4">
                      <label class="form-label fw-semibold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-tag text-primary"></i></span>
                        <input class="form-control" name="price" type="number" min="0" placeholder="80000" required>
                      </div>
                    </div>
                    <div class="col-md-4">
                      <label class="form-label fw-semibold">Tồn kho <span class="text-danger">*</span></label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-boxes text-success"></i></span>
                        <input class="form-control" name="stock" type="number" min="0" placeholder="10" required>
                      </div>
                    </div>
                    <div class="col-md-8">
                      <label class="form-label fw-semibold">URL hình ảnh</label>
                      <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-image"></i></span>
                        <input class="form-control" name="imageUrl" placeholder="https://...">
                      </div>
                    </div>
                    <div class="col-md-4">
                      <label class="form-label fw-semibold">Trạng thái</label>
                      <select class="form-select" name="isActive">
                        <option value="1" selected>Đang bán</option>
                        <option value="0">Ngừng bán</option>
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
          <table class="table align-middle" id="partsTable">
            <thead class="table-light">
              <tr>
                <th>#</th>
                <th>Phụ tùng</th>
                <th class="text-end">Giá nhập</th>
                <th class="text-end">Giá bán</th>
                <th class="text-center">Tồn kho</th>
                <th class="text-center">Trạng thái</th>
                <th class="text-end">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${not empty parts}">
                  <c:forEach var="p" items="${parts}" varStatus="st">
                    <c:set var="lowStock" value="${p.stockQuantity lt 5}"/>
                    <tr>
                      <td class="text-muted small">${st.count}</td>
                      <td>
                        <div class="d-flex align-items-center gap-2">
                          <c:choose>
                            <c:when test="${not empty p.imageUrl}">
                              <img src="${fn:escapeXml(p.imageUrl)}" class="rounded" width="40" height="40"
                                   style="object-fit:cover;" onerror="this.style.display='none'">
                            </c:when>
                            <c:otherwise>
                              <div class="part-icon bg-light rounded d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
                                <i class="bi bi-gear text-secondary"></i>
                              </div>
                            </c:otherwise>
                          </c:choose>
                          <div>
                            <div class="fw-semibold"><c:out value="${p.partName}"/></div>
                            <c:if test="${not empty p.description}">
                              <small class="text-muted">
                                <c:out value="${fn:length(p.description) gt 50 ? fn:substring(p.description,0,50) : p.description}"/>
                                <c:if test="${fn:length(p.description) gt 50}">…</c:if>
                              </small>
                            </c:if>
                          </div>
                        </div>
                      </td>
                      <td class="text-end text-muted small">
                        <c:choose>
                          <c:when test="${p.importPrice gt 0}">
                            <fmt:formatNumber value="${p.importPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                          </c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-end fw-semibold text-primary">
                        <fmt:formatNumber value="${p.sellingPrice}" type="number" maxFractionDigits="0" groupingUsed="true"/>đ
                      </td>
                      <td class="text-center">
                        <c:choose>
                          <c:when test="${lowStock}">
                            <span class="badge bg-danger-subtle text-danger border border-danger-subtle">
                              <i class="bi bi-exclamation-triangle-fill me-1"></i>${p.stockQuantity}
                            </span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-success-subtle text-success border border-success-subtle">${p.stockQuantity}</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-center">
                        <c:choose>
                          <c:when test="${p.active}">
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle">Đang bán</span>
                          </c:when>
                          <c:otherwise>
                            <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle">Ngừng bán</span>
                          </c:otherwise>
                        </c:choose>
                      </td>
                      <td class="text-end">
                        <button class="btn btn-sm btn-outline-primary" title="Sửa"
                                data-bs-toggle="modal" data-bs-target="#editModal${p.partId}">
                          <i class="bi bi-pencil"></i>
                        </button>
                        <c:choose>
                          <c:when test="${p.active}">
                            <button class="btn btn-sm btn-outline-warning" title="Ngừng bán"
                                    data-bs-toggle="modal" data-bs-target="#deleteModal${p.partId}">
                              <i class="bi bi-slash-circle"></i>
                            </button>
                          </c:when>
                          <c:otherwise>
                            <button class="btn btn-sm btn-outline-secondary" disabled
                                    title="Phụ tùng đã được dùng trong phiếu sửa. Kích hoạt lại bằng Sửa.">
                              <i class="bi bi-lock-fill"></i>
                            </button>
                          </c:otherwise>
                        </c:choose>
                      </td>
                    </tr>

                    <!-- EDIT MODAL -->
                    <div class="modal fade" id="editModal${p.partId}" tabindex="-1">
                      <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                          <form method="post" action="${pageContext.request.contextPath}/admin/inventory">
                            <input type="hidden" name="action" value="edit">
                            <input type="hidden" name="id"     value="${p.partId}">
                            <div class="modal-header">
                              <h5 class="modal-title"><i class="bi bi-pencil me-2 text-primary"></i>Sửa phụ tùng</h5>
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                              <div class="row g-3">
                                <div class="col-12">
                                  <label class="form-label fw-semibold">Tên phụ tùng <span class="text-danger">*</span></label>
                                  <input class="form-control" name="name" value="${fn:escapeXml(p.partName)}" required>
                                </div>
                                <div class="col-12">
                                  <label class="form-label fw-semibold">Mô tả</label>
                                  <textarea class="form-control" name="description" rows="2"><c:out value="${p.description}"/></textarea>
                                </div>
                                <div class="col-md-4">
                                  <label class="form-label fw-semibold">Giá nhập (VNĐ)</label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-arrow-down-circle text-secondary"></i></span>
                                    <input class="form-control" name="importPrice" type="number" min="0" value="${p.importPrice}">
                                  </div>
                                </div>
                                <div class="col-md-4">
                                  <label class="form-label fw-semibold">Giá bán (VNĐ) <span class="text-danger">*</span></label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-tag text-primary"></i></span>
                                    <input class="form-control" name="price" type="number" min="0" value="${p.sellingPrice}" required>
                                  </div>
                                </div>
                                <div class="col-md-4">
                                  <label class="form-label fw-semibold">Tồn kho <span class="text-danger">*</span></label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-boxes text-success"></i></span>
                                    <input class="form-control" name="stock" type="number" min="0" value="${p.stockQuantity}" required>
                                  </div>
                                </div>
                                <div class="col-md-8">
                                  <label class="form-label fw-semibold">URL hình ảnh</label>
                                  <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-image"></i></span>
                                    <input class="form-control" name="imageUrl" value="${fn:escapeXml(p.imageUrl)}">
                                  </div>
                                </div>
                                <div class="col-md-4">
                                  <label class="form-label fw-semibold">Trạng thái</label>
                                  <select class="form-select" name="isActive">
                                    <option value="1" ${p.active  ? 'selected' : ''}>Đang bán</option>
                                    <option value="0" ${!p.active ? 'selected' : ''}>Ngừng bán</option>
                                  </select>
                                </div>
                                <c:if test="${not empty p.imageUrl}">
                                  <div class="col-12">
                                    <label class="form-label fw-semibold">Xem trước ảnh</label><br>
                                    <img src="${fn:escapeXml(p.imageUrl)}" class="rounded border" height="80"
                                         style="object-fit:cover;" onerror="this.style.display='none'">
                                  </div>
                                </c:if>
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
                    <div class="modal fade" id="deleteModal${p.partId}" tabindex="-1">
                      <div class="modal-dialog modal-sm">
                        <div class="modal-content">
                          <form method="post" action="${pageContext.request.contextPath}/admin/inventory">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="id"     value="${p.partId}">
                            <div class="modal-header border-0 pb-0">
                              <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body text-center pt-0">
                              <div class="text-warning fs-1"><i class="bi bi-slash-circle-fill"></i></div>
                              <h6 class="mb-1 mt-2">Ngừng bán phụ tùng?</h6>
                              <p class="text-muted small mb-0">
                                Phụ tùng <strong><c:out value="${p.partName}"/></strong> sẽ chuyển sang trạng thái
                                <strong>Ngừng bán</strong>.<br>
                                Bạn có thể kích hoạt lại bằng cách <em>Sửa → Đang bán</em>.
                              </p>
                            </div>
                            <div class="modal-footer border-0 justify-content-center gap-2">
                              <button type="button" class="btn btn-secondary btn-sm px-4" data-bs-dismiss="modal">Hủy</button>
                              <button type="submit" class="btn btn-warning btn-sm px-4 text-white">
                                <i class="bi bi-slash-circle me-1"></i>Ngừng bán
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
                    <td colspan="7" class="text-center text-muted py-5">
                      <i class="bi bi-box-seam fs-1 d-block mb-2 opacity-25"></i>
                      Kho chưa có phụ tùng nào.
                    </td>
                  </tr>
                </c:otherwise>
              </c:choose>
            </tbody>
          </table>
        </div>

        <div class="text-muted small mt-2">
          Tổng: <strong>${fn:length(parts)}</strong> loại phụ tùng
        </div>
      </div>

      <%@ include file="_footer.jspf" %>
    </main>
  </div>

  <script>
    function filterTable() {
      const q = document.getElementById('searchInput').value.toLowerCase();
      document.querySelectorAll('#partsTable tbody tr').forEach(row => {
        row.style.display = row.textContent.toLowerCase().includes(q) ? '' : 'none';
      });
    }
  </script>
</body>
</html>
