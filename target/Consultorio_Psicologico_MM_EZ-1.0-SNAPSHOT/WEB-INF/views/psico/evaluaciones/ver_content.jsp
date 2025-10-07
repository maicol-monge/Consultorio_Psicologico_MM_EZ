<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-clipboard2-pulse me-2"></i>Evaluación</h2>
      <div class="text-muted">Cita #${cita.id} · <span class="fecha" data-ts="${cita.fechaHora.time}"></span> · ${cita.pacienteNombre}</div>
    </div>
    <div class="btn-group">
      <a href="${pageContext.request.contextPath}/psico/agenda" class="btn btn-outline-secondary">Volver</a>
      <form method="post" action="${pageContext.request.contextPath}/psico/agenda/cambiarEstado" onsubmit="return validarMarcarRealizadaEvaluacion(this)" data-ts="${cita.fechaHora.time}">
        <input type="hidden" name="id" value="${cita.id}"/>
        <input type="hidden" name="estado" value="realizada"/>
        <button class="btn btn-success marcar-realizada-eval" ${cita.estadoCita!='pendiente'?'disabled':''} title="Marcar realizada"><i class="bi bi-check2-circle me-1"></i>Marcar realizada</button>
      </form>
    </div>
  </div>

  <div class="row g-3">
    <div class="col-12 col-lg-7">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>Registrar Evaluación</span>
          <span class="badge ${cita.estadoCita=='pendiente'?'bg-warning text-dark':cita.estadoCita=='realizada'?'bg-success':'bg-danger'}">${cita.estadoCita}</span>
        </div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/psico/evaluaciones/guardar">
            <input type="hidden" name="idCita" value="${cita.id}"/>
            <div class="mb-3">
              <label class="form-label">Estado emocional (1-10)</label>
              <input type="number" class="form-control" name="estadoEmocional" min="1" max="10" value="" ${cita.estadoCita!='pendiente'?'disabled':''} required/>
            </div>
            <div class="mb-3">
              <label class="form-label">Comentarios</label>
              <textarea class="form-control" name="comentarios" rows="4" ${cita.estadoCita!='pendiente'?'disabled':''}></textarea>
            </div>
            <button class="btn btn-primary" ${cita.estadoCita!='pendiente'?'disabled':''}>Guardar</button>
          </form>
        </div>
      </div>
      <div class="card mt-3">
        <div class="card-header">Historial de Evaluaciones</div>
        <div class="card-body p-0">
          <c:choose>
            <c:when test="${empty evaluaciones}">
              <div class="p-3 text-muted">No hay evaluaciones registradas.</div>
            </c:when>
            <c:otherwise>
              <div class="table-responsive">
                <table class="table table-sm mb-0">
                  <thead class="table-light">
                    <tr>
                      <th>#</th>
                      <th>Estado emocional</th>
                      <th>Comentarios</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="e" items="${evaluaciones}" varStatus="st">
                      <tr>
                        <td>${st.index + 1}</td>
                        <td>${e.estadoEmocional}</td>
                        <td>${e.comentarios}</td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>

    <div class="col-12 col-lg-5">
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <span>Motivo de consulta</span>
          <small class="text-muted">Solo editable cuando la cita está pendiente</small>
        </div>
        <div class="card-body">
          <form method="post" action="${pageContext.request.contextPath}/psico/agenda/editarMotivo">
            <input type="hidden" name="idCita" value="${cita.id}"/>
            <textarea class="form-control" name="motivoConsulta" rows="6" ${cita.estadoCita!='pendiente'?'disabled':''}>${cita.motivoConsulta}</textarea>
            <div class="text-end mt-2">
              <button class="btn btn-outline-primary btn-sm" ${cita.estadoCita!='pendiente'?'disabled':''}>Actualizar motivo</button>
            </div>
          </form>
        </div>
      </div>
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

function dateKeyInTz(date, tz){
  const f=new Intl.DateTimeFormat('en-CA',{timeZone:tz, year:'numeric', month:'2-digit', day:'2-digit'});
  const parts=f.formatToParts(date);
  const map=Object.fromEntries(parts.map(p=>[p.type,p.value]));
  return `${map.year}-${map.month}-${map.day}`;
}
function validarMarcarRealizadaEvaluacion(form){
  const tz='America/El_Salvador';
  const tsStr=form.getAttribute('data-ts');
  const citaKey=dateKeyInTz(new Date(parseInt(tsStr,10)), tz);
  const hoyKey=dateKeyInTz(new Date(), tz);
  if (citaKey > hoyKey){
    alert('No se puede marcar como realizada una cita futura.');
    return false;
  }
  return confirm('¿Marcar como realizada?');
}

// Deshabilitar visualmente el botón cuando la FECHA es futura
(function(){
  const tz='America/El_Salvador';
  const form=document.querySelector('form[action$="/psico/agenda/cambiarEstado"][data-ts]');
  if(!form) return;
  const ts=form.getAttribute('data-ts');
  const btn=form.querySelector('.marcar-realizada-eval');
  if(!btn||!ts) return;
  const citaKey=dateKeyInTz(new Date(parseInt(ts,10)), tz);
  const hoyKey=dateKeyInTz(new Date(), tz);
  if (citaKey > hoyKey){
    btn.setAttribute('disabled','disabled');
    btn.title = 'No disponible para fechas futuras';
  }
})();
</script>
