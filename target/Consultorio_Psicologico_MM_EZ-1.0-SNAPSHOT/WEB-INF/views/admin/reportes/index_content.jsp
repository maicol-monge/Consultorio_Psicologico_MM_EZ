<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-file-earmark-bar-graph me-2"></i>Reportes</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Reportes</li>
        </ol>
      </nav>
    </div>
  </div>

  <div class="row g-3">
    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-header">Pacientes atendidos por psicólogo</div>
        <div class="card-body">
          <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/admin/report/pacientesPorPsicologo">
            <input type="hidden" name="format" value="preview"/>
            <button class="btn btn-primary" type="submit">Previsualizar</button>
            <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/admin/report/pacientesPorPsicologo?format=xlsx">Excel</a>
            <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}/admin/report/pacientesPorPsicologo?format=pdf">PDF</a>
          </form>
        </div>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-header">Disponibilidad de horarios</div>
        <div class="card-body">
          <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/admin/report/disponibilidadHorarios">
            <div class="col-auto">
              <label class="form-label small">Fecha base (semana)</label>
              <input type="date" class="form-control form-control-sm" name="fecha"/>
            </div>
            <div class="col-auto">
              <label class="form-label small">ID Psicólogo (opcional)</label>
              <input type="number" class="form-control form-control-sm" name="id_psicologo" min="1"/>
            </div>
            <div class="col-12 d-flex gap-2">
              <button class="btn btn-primary" type="submit" name="format" value="preview">Previsualizar</button>
              <button class="btn btn-outline-success" type="submit" name="format" value="xlsx">Excel</button>
              <button class="btn btn-outline-danger" type="submit" name="format" value="pdf">PDF</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-header">Citas por rango de fechas</div>
        <div class="card-body">
          <form class="row g-2" method="get" action="${pageContext.request.contextPath}/admin/report/citasPorRango">
            <div class="col-auto">
              <label class="form-label small">Desde</label>
              <input type="date" class="form-control form-control-sm" name="desde"/>
            </div>
            <div class="col-auto">
              <label class="form-label small">Hasta</label>
              <input type="date" class="form-control form-control-sm" name="hasta"/>
            </div>
            <div class="col-12 d-flex gap-2">
              <button class="btn btn-primary" type="submit" name="format" value="preview">Previsualizar</button>
              <button class="btn btn-outline-success" type="submit" name="format" value="xlsx">Excel</button>
              <button class="btn btn-outline-danger" type="submit" name="format" value="pdf">PDF</button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-header">Ingresos por mes</div>
        <div class="card-body">
          <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/admin/report/ingresosPorMes">
            <button class="btn btn-primary" type="submit" name="format" value="preview">Previsualizar</button>
            <button class="btn btn-outline-success" type="submit" name="format" value="xlsx">Excel</button>
            <button class="btn btn-outline-danger" type="submit" name="format" value="pdf">PDF</button>
          </form>
        </div>
      </div>
    </div>

    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-header">Comparativo de ingresos por especialidad</div>
        <div class="card-body">
          <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/admin/report/ingresosPorEspecialidad">
            <button class="btn btn-primary" type="submit" name="format" value="preview">Previsualizar</button>
            <button class="btn btn-outline-success" type="submit" name="format" value="xlsx">Excel</button>
            <button class="btn btn-outline-danger" type="submit" name="format" value="pdf">PDF</button>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
