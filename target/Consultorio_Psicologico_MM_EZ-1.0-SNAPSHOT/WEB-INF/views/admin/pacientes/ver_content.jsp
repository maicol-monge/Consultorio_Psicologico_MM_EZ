<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1">
        <i class="bi bi-person-vcard me-2"></i>
        Detalle del Paciente
      </h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/pacientes">Pacientes</a></li>
          <li class="breadcrumb-item active">Detalle</li>
        </ol>
      </nav>
    </div>
    <a href="${pageContext.request.contextPath}/admin/pacientes" class="btn btn-outline-secondary">
      <i class="bi bi-arrow-left me-2"></i>Volver
    </a>
  </div>

  <div class="card">
    <div class="card-body">
      <div class="row g-3">
        <div class="col-md-6">
          <label class="form-label fw-semibold">Nombre</label>
          <div>${paciente.nombre}</div>
        </div>
        <div class="col-md-3">
          <label class="form-label fw-semibold">Fecha de Nacimiento</label>
          <div>
            <c:if test="${not empty paciente.fechaNacimiento}">
              <fmt:formatDate value="${paciente.fechaNacimiento}" pattern="dd/MM/yyyy"/>
            </c:if>
          </div>
        </div>
        <div class="col-md-3">
          <label class="form-label fw-semibold">Estado</label>
          <div>
            <span class="badge ${paciente.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">${paciente.estado}</span>
          </div>
        </div>

        <div class="col-md-6">
          <label class="form-label fw-semibold">Email</label>
          <div>${paciente.email}</div>
        </div>
        <div class="col-md-3">
          <label class="form-label fw-semibold">Teléfono</label>
          <div>${paciente.telefono}</div>
        </div>
        <div class="col-md-3">
          <label class="form-label fw-semibold">DUI</label>
          <div>${paciente.dui}</div>
        </div>

        <div class="col-12">
          <label class="form-label fw-semibold">Dirección</label>
          <div>${paciente.direccion}</div>
        </div>

        <div class="col-12">
          <label class="form-label fw-semibold">Historial Clínico</label>
          <div class="border rounded p-2 bg-light">${paciente.historialClinico}</div>
        </div>
      </div>
    </div>
  </div>
</div>
