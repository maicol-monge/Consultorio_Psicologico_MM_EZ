<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-clipboard2-pulse me-2"></i>Mis Evaluaciones</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Evaluaciones</li>
        </ol>
      </nav>
    </div>
  </div>

  <div class="card">
    <div class="table-responsive">
      <table class="table table-striped table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>Fecha y Hora</th>
            <th>Paciente</th>
            <th>Estado Cita</th>
            <th style="width:120px">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${citas}">
            <tr>
              <td><span class="fecha" data-ts="${c.fechaHora.time}"></span></td>
              <td>${c.pacienteNombre}</td>
              <td><span class="badge ${c.estadoCita=='realizada'?'bg-success':c.estadoCita=='cancelada'?'bg-danger':'bg-warning text-dark'}">${c.estadoCita}</span></td>
              <td>
                <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/psico/evaluaciones/ver?id=${c.id}"><i class="bi bi-eye"></i></a>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>

<script>
(function(){
  const tz='America/El_Salvador';
  document.querySelectorAll('.fecha').forEach(el=>{
    const ts=parseInt(el.dataset.ts,10); const d=new Date(ts);
    el.textContent=new Intl.DateTimeFormat('es-SV',{dateStyle:'medium', timeStyle:'short', timeZone:tz}).format(d);
  });
})();
</script>
