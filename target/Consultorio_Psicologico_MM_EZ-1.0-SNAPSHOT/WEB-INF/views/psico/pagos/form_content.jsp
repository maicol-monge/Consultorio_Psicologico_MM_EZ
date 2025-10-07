<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-plus me-2"></i>Nuevo Pago</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/pagos">Pagos</a></li>
          <li class="breadcrumb-item active">Nuevo</li>
        </ol>
      </nav>
    </div>
  </div>

  <div class="card">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/psico/pagos/crear" class="row g-3">
        <div class="col-md-6">
          <label class="form-label">Cita (realizada)</label>
          <select name="idCita" class="form-select" required>
            <option value="">Seleccionar...</option>
            <c:forEach var="c" items="${citas}">
              <option value="${c.id}">${c.fechaHora} - ${c.pacienteNombre}</option>
            </c:forEach>
          </select>
        </div>
        <div class="col-md-3">
          <label class="form-label">Monto base</label>
          <input type="number" step="0.01" min="0" name="montoBase" class="form-control" required />
        </div>
        <div class="col-md-3">
          <label class="form-label">Monto total</label>
          <input type="number" step="0.01" min="0" name="montoTotal" class="form-control" required />
        </div>
        <div class="col-12 d-flex gap-2">
          <button class="btn btn-primary" type="submit">Guardar</button>
          <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/psico/pagos">Cancelar</a>
        </div>
      </form>
    </div>
  </div>
</div>
