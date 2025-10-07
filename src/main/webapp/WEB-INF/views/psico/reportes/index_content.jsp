<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="mb-4">
    <h2 class="mb-1"><i class="bi bi-graph-up me-2"></i>Mis Reportes</h2>
    <p class="text-muted mb-0">Exporta a PDF o Excel desde cada tarjeta.</p>
  </div>
  <div class="row g-3">
    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-body">
          <h5>Sesiones por rango</h5>
          <form class="row g-2" method="get" action="${pageContext.request.contextPath}/psico/report/sesionesPorRango">
            <div class="col-6"><input type="date" name="desde" class="form-control form-control-sm"/></div>
            <div class="col-6"><input type="date" name="hasta" class="form-control form-control-sm"/></div>
            <div class="col-12 d-flex gap-2">
              <button class="btn btn-sm btn-outline-danger" name="format" value="pdf" type="submit">PDF</button>
              <button class="btn btn-sm btn-outline-success" name="format" value="xlsx" type="submit">Excel</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-body">
          <h5>Citas por mes (año actual)</h5>
          <a class="btn btn-sm btn-outline-danger" href="${pageContext.request.contextPath}/psico/report/citasPorMes?format=pdf">PDF</a>
          <a class="btn btn-sm btn-outline-success" href="${pageContext.request.contextPath}/psico/report/citasPorMes?format=xlsx">Excel</a>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-body">
          <h5>Resumen de evaluaciones</h5>
          <form class="row g-2" method="get" action="${pageContext.request.contextPath}/psico/report/resumenEvaluaciones">
            <div class="col-6"><input type="date" name="desde" class="form-control form-control-sm"/></div>
            <div class="col-6"><input type="date" name="hasta" class="form-control form-control-sm"/></div>
            <div class="col-12 d-flex gap-2">
              <button class="btn btn-sm btn-outline-danger" name="format" value="pdf" type="submit">PDF</button>
              <button class="btn btn-sm btn-outline-success" name="format" value="xlsx" type="submit">Excel</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div class="col-md-6">
      <div class="card h-100">
        <div class="card-body">
          <h5>Citas por estado</h5>
          <form class="row g-2" method="get" action="${pageContext.request.contextPath}/psico/report/citasPorEstado">
            <div class="col-6">
              <select name="estado" class="form-select form-select-sm">
                <option value="">Todos</option>
                <option value="pendiente">Pendiente</option>
                <option value="realizada">Realizada</option>
                <option value="cancelada">Cancelada</option>
              </select>
            </div>
            <div class="col-12 d-flex gap-2">
              <button class="btn btn-sm btn-outline-danger" name="format" value="pdf" type="submit">PDF</button>
              <button class="btn btn-sm btn-outline-success" name="format" value="xlsx" type="submit">Excel</button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
