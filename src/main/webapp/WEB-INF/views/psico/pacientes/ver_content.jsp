<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="mb-3">
  <a class="btn btn-link" href="${pageContext.request.contextPath}/psico/pacientes"><i class="bi bi-arrow-left"></i> Volver</a>
</div>

<div class="card mb-3">
  <div class="card-body">
    <div class="d-flex justify-content-between">
      <div>
        <h5 class="card-title mb-1">${paciente.nombre}</h5>
        <div class="text-muted small">DUI: ${paciente.dui} • ${paciente.email} • ${paciente.telefono}</div>
        <div class="text-muted small">Dirección: ${paciente.direccion}</div>
      </div>
      <span class="badge align-self-start bg-${paciente.estado == 'activo' ? 'success' : 'secondary'}">${paciente.estado}</span>
    </div>
  </div>
</div>

<h6 class="mb-2">Historial de citas</h6>
<div class="table-responsive" style="max-height: 60vh; overflow:auto;">
<table class="table table-sm table-striped align-middle">
  <thead class="table-light position-sticky top-0">
    <tr>
      <th>Fecha y hora</th>
      <th>Psicólogo</th>
      <th>Estado</th>
      <th>Motivo</th>
    <th>Pago</th>
    <th>Evaluaciones</th>
    <th>Notas</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="cita" items="${historial}">
      <tr>
        <td>
          <c:set var="ts" value="${cita.fechaHora.time}"/>
          <span class="fecha" data-ts="${ts}"></span>
        </td>
        <td>${cita.psicologoNombre}</td>
        <td><span class="badge bg-${cita.estadoCita == 'realizada' ? 'success' : (cita.estadoCita == 'pendiente' ? 'warning text-dark' : 'secondary')}">${cita.estadoCita}</span></td>
        <td>${cita.motivoConsulta}</td>
        <td>
          <c:choose>
            <c:when test="${not empty cita.pagoMontoTotal}">
              <span class="badge ${cita.pagoEstado=='pagado' ? 'bg-success' : 'bg-warning text-dark'}">${cita.pagoEstado}</span>
              <span class="ms-1">$ ${cita.pagoMontoTotal}</span>
            </c:when>
            <c:otherwise><span class="text-muted">Sin registro</span></c:otherwise>
          </c:choose>
        </td>
        <td>
          <button class="btn btn-outline-primary btn-sm" type="button" data-bs-toggle="collapse" data-bs-target="#eval-${cita.id}">
            Ver evaluaciones
          </button>
        </td>
        <td>${empty cita.evaluacionComentarios ? '-' : cita.evaluacionComentarios}</td>
      </tr>
      <tr class="collapse" id="eval-${cita.id}">
        <td colspan="7">
          <div class="card card-body">
            <div class="text-muted small mb-2">Detalle de evaluaciones registradas (solo lectura)</div>
            <c:choose>
              <c:when test="${empty cita.estadoEmocional && empty cita.evaluacionComentarios}">
                <div class="text-muted">Sin evaluaciones registradas.</div>
              </c:when>
              <c:otherwise>
                <div><strong>Última evaluación:</strong> <span class="badge bg-info text-dark">${empty cita.estadoEmocional ? '-' : cita.estadoEmocional}/10</span></div>
                <div class="mt-2"><strong>Comentarios:</strong><br/>${empty cita.evaluacionComentarios ? '-' : cita.evaluacionComentarios}</div>
                <div class="mt-2">
                  <a class="btn btn-sm btn-outline-secondary" href="${pageContext.request.contextPath}/psico/evaluaciones/ver?id=${cita.id}">Ver detalle</a>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </td>
      </tr>
    </c:forEach>
    <c:if test="${empty historial}"><tr><td colspan="4" class="text-center text-muted">Sin citas registradas.</td></tr></c:if>
  </tbody>
</table>
</div>

<script>
(function(){
  const tz = 'America/El_Salvador';
  document.querySelectorAll('.fecha').forEach(el => {
    const ts = parseInt(el.dataset.ts,10);
    const d = new Date(ts);
    const s = new Intl.DateTimeFormat('es-SV', { dateStyle: 'full', timeStyle: 'short', timeZone: tz }).format(d);
    el.textContent = s;
  });
})();
</script>
