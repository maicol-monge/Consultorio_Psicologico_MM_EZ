<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="d-flex align-items-center justify-content-between mb-3">
  <div>
    <h4 class="mb-1"><i class="bi bi-cash-coin me-2"></i>Registrar pago</h4>
    <div class="text-muted small">Solo se pueden registrar pagos de citas realizadas.</div>
  </div>
  <div>
    <a href="${pageContext.request.contextPath}/admin/pagos" class="btn btn-outline-secondary btn-sm">
      <i class="bi bi-arrow-left"></i> Volver a pagos
    </a>
  </div>
  
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>
<c:if test="${not empty success}">
  <div class="alert alert-success">${success}</div>
</c:if>

<div class="card shadow-sm mb-3">
  <div class="card-header">
    <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/pagos/nuevo">
      <input type="hidden" name="cita" value="${param.cita}">
      <div class="col-6 col-lg-auto">
        <label class="form-label small">Desde</label>
        <input type="date" class="form-control form-control-sm" name="fIni" value="${fIni}">
      </div>
      <div class="col-6 col-lg-auto">
        <label class="form-label small">Hasta</label>
        <input type="date" class="form-control form-control-sm" name="fFin" value="${fFin}">
      </div>
      <div class="col-6 col-lg-auto">
        <label class="form-label small">Paciente</label>
        <input type="text" class="form-control form-control-sm" name="p" value="${pLike}" placeholder="Nombre paciente">
      </div>
      <div class="col-6 col-lg-auto">
        <label class="form-label small">Psicólogo</label>
        <input type="text" class="form-control form-control-sm" name="s" value="${sLike}" placeholder="Nombre psicólogo">
      </div>
      <div class="col-12 col-lg-auto">
        <button class="btn btn-sm btn-outline-primary"><i class="bi bi-search"></i></button>
        <a href="${pageContext.request.contextPath}/admin/pagos/nuevo" class="btn btn-sm btn-outline-secondary"><i class="bi bi-x-lg"></i></a>
      </div>
    </form>
  </div>
  <div class="card-body">
<form action="${pageContext.request.contextPath}/admin/pagos/crear" method="post" class="needs-validation" novalidate>
  <div class="row g-3">
    <div class="col-md-6">
      <label for="idCita" class="form-label">Cita realizada</label>
      <select class="form-select" id="idCita" name="idCita" required>
        <option value="" disabled <c:if test='${empty param.cita && (empty cita || empty cita.id)}'>selected</c:if>>Seleccione una cita...</option>
        <c:forEach items="${citas}" var="c">
          <option value="${c.id}" <c:if test='${param.cita == c.id || (not empty cita and cita.id == c.id)}'>selected</c:if>>
            #${c.id} - ${c.pacienteNombre} con ${c.psicologoNombre} - 
            <fmt:formatDate value="${c.fechaHora}" pattern="dd/MM/yyyy HH:mm"/>
          </option>
        </c:forEach>
      </select>
      <div class="invalid-feedback">Seleccione una cita válida.</div>
    </div>

    <div class="col-md-3">
      <label for="montoBase" class="form-label">Monto base</label>
      <input type="number" step="0.01" min="0" class="form-control" id="montoBase" name="montoBase" required />
      <div class="invalid-feedback">Ingrese el monto base.</div>
    </div>

    <div class="col-md-3">
      <label for="montoTotal" class="form-label">Monto total</label>
      <input type="number" step="0.01" min="0" class="form-control" id="montoTotal" name="montoTotal" required />
      <div class="invalid-feedback">Ingrese el monto total.</div>
      <div class="form-text">Incluye descuentos/recargos si aplica.</div>
    </div>

    <div class="col-md-6">
      <label for="estadoPago" class="form-label">Estado de pago</label>
      <select class="form-select" id="estadoPago" name="estadoPago" required>
        <option value="pendiente" <c:if test='${param.estadoPago == "pendiente"}'>selected</c:if>>Pendiente</option>
        <option value="pagado" <c:if test='${param.estadoPago == "pagado"}'>selected</c:if>>Pagado</option>
      </select>
    </div>

    <div class="col-12">
      <button type="submit" class="btn btn-primary">
        <i class="bi bi-cash-coin"></i> Guardar pago
      </button>
    </div>
  </div>
</form>
  </div>
</div>

<script>
(() => {
  'use strict';
  const forms = document.querySelectorAll('.needs-validation');
  Array.from(forms).forEach(form => {
    form.addEventListener('submit', event => {
      if (!form.checkValidity()) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });
})();
</script>
