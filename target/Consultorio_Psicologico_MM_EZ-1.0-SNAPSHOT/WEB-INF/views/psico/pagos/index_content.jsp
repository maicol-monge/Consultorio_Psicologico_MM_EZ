<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-cash-stack me-2"></i>Mis Pagos</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Pagos</li>
        </ol>
      </nav>
    </div>
    <a href="${pageContext.request.contextPath}/psico/pagos/nuevo" class="btn btn-primary"><i class="bi bi-plus me-2"></i>Nuevo Pago</a>
  </div>

  <div class="card">
    <div class="table-responsive">
      <table class="table table-striped align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Fecha</th>
            <th>Paciente</th>
            <th>Monto Base</th>
            <th>Monto Total</th>
            <th>Estado</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="p" items="${pagos}">
            <tr>
              <td>${p.id}</td>
              <td>${p.fecha}</td>
              <td>${p.pacienteNombre}</td>
              <td>$ ${p.montoBase}</td>
              <td>$ ${p.montoTotal}</td>
              <td><span class="badge ${p.estadoPago=='pagado'?'bg-success':'bg-warning text-dark'}">${p.estadoPago}</span></td>
            </tr>
          </c:forEach>
          <c:if test="${empty pagos}"><tr><td colspan="6" class="text-center text-muted">Sin pagos registrados</td></tr></c:if>
        </tbody>
      </table>
    </div>
  </div>
</div>
