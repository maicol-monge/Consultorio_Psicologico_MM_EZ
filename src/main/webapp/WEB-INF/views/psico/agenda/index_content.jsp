<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-calendar3 me-2"></i>Mi Agenda</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Agenda</li>
        </ol>
      </nav>
    </div>
    <a href="${pageContext.request.contextPath}/psico/agenda/nueva" class="btn btn-primary"><i class="bi bi-calendar-plus me-2"></i>Nueva Cita</a>
  </div>

  <div class="card mb-3">
    <div class="card-body">
      <c:set var="desdeSel" value="${not empty param.desde ? param.desde : (not empty defaultDesde ? defaultDesde : '')}"/>
      <c:set var="hastaSel" value="${not empty param.hasta ? param.hasta : (not empty defaultHasta ? defaultHasta : '')}"/>
      <c:set var="estadoSel" value="${not empty param.estado ? param.estado : (not empty defaultEstado ? defaultEstado : '')}"/>
      <form class="row g-2 align-items-end" method="get" action="${pageContext.request.contextPath}/psico/agenda">
        <div class="col-6 col-md-auto">
          <label class="form-label small">Desde</label>
          <input type="date" class="form-control form-control-sm" name="desde" value="${desdeSel}"/>
        </div>
        <div class="col-6 col-md-auto">
          <label class="form-label small">Hasta</label>
          <input type="date" class="form-control form-control-sm" name="hasta" value="${hastaSel}"/>
        </div>
        <div class="col-12 col-md-auto">
          <label class="form-label small">Estado</label>
          <select name="estado" class="form-select form-select-sm">
            <option value="" ${(empty estadoSel) ? 'selected' : ''}>Todos</option>
            <option value="pendiente" ${estadoSel=='pendiente'?'selected':''}>Pendiente</option>
            <option value="realizada" ${estadoSel=='realizada'?'selected':''}>Realizada</option>
            <option value="cancelada" ${estadoSel=='cancelada'?'selected':''}>Cancelada</option>
          </select>
        </div>
        <div class="col-12 col-md-auto">
          <button class="btn btn-outline-secondary btn-sm" type="submit"><i class="bi bi-funnel me-1"></i>Filtrar</button>
        </div>
        <div class="col-12 col-md-auto ms-auto">
          <a href="${pageContext.request.contextPath}/psico/agenda/calendario" class="btn btn-outline-info btn-sm"><i class="bi bi-calendar3 me-1"></i> Calendario</a>
        </div>
      </form>
    </div>
  </div>

  <div class="card">
    <div class="table-responsive">
      <table class="table table-striped table-hover align-middle mb-0">
        <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Fecha y Hora</th>
            <th>Paciente</th>
            <th>Motivo</th>
            <th>Estado</th>
            <th style="width: 160px;">Acciones</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="c" items="${citas}">
            <tr>
              <td>${c.id}</td>
              <td><span class="fecha" data-ts="${c.fechaHora.time}"></span></td>
              <td>${c.pacienteNombre}</td>
              <td>${c.motivoConsulta}</td>
              <td>
                <span class="badge ${c.estadoCita=='realizada'?'bg-success':c.estadoCita=='cancelada'?'bg-danger':'bg-warning text-dark'}">${c.estadoCita}</span>
              </td>
              <td>
                <div class="btn-group btn-group-sm">
                  <a class="btn btn-outline-primary" title="${c.estadoCita=='pendiente'?'Ver/Evaluar':'Ver'}" href="${pageContext.request.contextPath}/psico/evaluaciones/ver?id=${c.id}"><i class="bi bi-eye"></i></a>
                  <button class="btn btn-outline-secondary dropdown-toggle dropdown-toggle-split" data-bs-toggle="dropdown" aria-expanded="false">
                    <span class="visually-hidden">Toggle</span>
                  </button>
                  <ul class="dropdown-menu dropdown-menu-end">
                    <li>
                      <form class="px-3 py-1" method="post" action="${pageContext.request.contextPath}/psico/agenda/cambiarEstado" data-ts="${c.fechaHora.time}" onsubmit="return validarMarcarRealizadaForm(this)">
                        <input type="hidden" name="id" value="${c.id}"/>
                        <input type="hidden" name="estado" value="realizada"/>
                        <button class="dropdown-item d-flex align-items-center marcar-realizada-btn" ${c.estadoCita!='pendiente'?'disabled':''} title="Marcar Realizada">
                          <i class="bi bi-check2-circle text-success me-2"></i>Marcar Realizada
                        </button>
                      </form>
                    </li>
                    <li><hr class="dropdown-divider"/></li>
                    <li>
                      <form class="px-3 py-1" method="post" action="${pageContext.request.contextPath}/psico/agenda/cambiarEstado" onsubmit="return confirm('¿Cancelar esta cita?')">
                        <input type="hidden" name="id" value="${c.id}"/>
                        <input type="hidden" name="estado" value="cancelada"/>
                        <button class="dropdown-item d-flex align-items-center" ${c.estadoCita!='pendiente'?'disabled':''}>
                          <i class="bi bi-x-circle text-danger me-2"></i>Cancelar
                        </button>
                      </form>
                    </li>
                  </ul>
                </div>
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

// Validación: solo permitir marcar como realizada si la FECHA de la cita es hoy o pasada (El Salvador)
function dateKeyInTz(date, tz){
  const f=new Intl.DateTimeFormat('en-CA',{timeZone:tz, year:'numeric', month:'2-digit', day:'2-digit'});
  const parts=f.formatToParts(date);
  const map=Object.fromEntries(parts.map(p=>[p.type,p.value]));
  return `${map.year}-${map.month}-${map.day}`;
}
function validarMarcarRealizadaForm(form){
  const tz='America/El_Salvador';
  const tsStr=form.getAttribute('data-ts');
  const citaKey=dateKeyInTz(new Date(parseInt(tsStr,10)), tz);
  const hoyKey=dateKeyInTz(new Date(), tz);
  if (citaKey > hoyKey){
    alert('No se puede marcar como realizada una cita futura.');
    return false;
  }
  return confirm('¿Marcar realizada?');
}

// Deshabilitar visualmente botón cuando la cita es futura (fecha > hoy en El Salvador)
(function(){
  const tz='America/El_Salvador';
  document.querySelectorAll('form[action$="/psico/agenda/cambiarEstado"][data-ts] .marcar-realizada-btn').forEach(btn=>{
    const form=btn.closest('form');
    const ts=form?.getAttribute('data-ts');
    if(!ts) return;
    const citaKey=dateKeyInTz(new Date(parseInt(ts,10)), tz);
    const hoyKey=dateKeyInTz(new Date(), tz);
    if (citaKey > hoyKey){
      btn.setAttribute('disabled','disabled');
      btn.title = 'No disponible para fechas futuras';
    }
  });
})();
</script>
