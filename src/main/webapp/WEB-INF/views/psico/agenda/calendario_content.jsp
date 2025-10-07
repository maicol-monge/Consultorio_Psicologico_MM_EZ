<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-calendar3 me-2"></i>Mi Calendario</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Calendario</li>
        </ol>
      </nav>
    </div>
    <div class="btn-group">
      <button class="btn btn-outline-secondary" onclick="navegarCalendario('prev')"><i class="bi bi-chevron-left"></i></button>
      <button class="btn btn-outline-secondary" onclick="irHoy()">Hoy</button>
      <button class="btn btn-outline-secondary" onclick="navegarCalendario('next')"><i class="bi bi-chevron-right"></i></button>
    </div>
  </div>

  <div class="card mb-3">
    <div class="card-body d-flex gap-2 align-items-center">
      <select id="vistaCalendario" class="form-select form-select-sm" onchange="cambiarVista()" style="max-width:160px">
        <option value="month">Mes</option>
        <option value="week">Semana</option>
        <option value="day">Día</option>
      </select>
      <span class="ms-auto text-muted">Total: <strong id="totalCitas"></strong></span>
    </div>
  </div>

  <div class="card">
    <div class="card-header d-flex justify-content-between">
      <h5 id="tituloCalendario" class="mb-0">&nbsp;</h5>
    </div>
    <div class="card-body" id="calendario"></div>
  </div>
</div>

<script>
let fechaActual=new Date(); let vistaActual='month'; let citasData=[];
<c:set var="citasJson" value="["/>
<c:forEach var="cita" items="${citas}" varStatus="status">
  <c:set var="citasJson" value="${citasJson}{"/>
  <c:set var="citasJson" value='${citasJson}"id": ${cita.id},'/>
  <c:set var="citasJson" value='${citasJson}"fechaHora": "${cita.fechaHora}",'/>
  <c:set var="citasJson" value='${citasJson}"fechaDia": "${fn:substring(cita.fechaHora, 0, 10)}",'/>
  <c:set var="citasJson" value='${citasJson}"pacienteNombre": "${cita.pacienteNombre}",'/>
  <c:set var="citasJson" value='${citasJson}"motivoConsulta": "${cita.motivoConsulta}",'/>
  <c:set var="citasJson" value='${citasJson}"estadoCita": "${cita.estadoCita}"'/>
  <c:set var="citasJson" value='${citasJson}}'/>
  <c:if test="${!status.last}"><c:set var="citasJson" value='${citasJson},'/></c:if>
</c:forEach>
<c:set var="citasJson" value="${citasJson}]"/>

citasData = ${citasJson};

document.addEventListener('DOMContentLoaded', renderizarCalendario);

function renderizarCalendario(){
  const container=document.getElementById('calendario');
  if (vistaActual==='month') renderizarMes(container);
  else if (vistaActual==='week') renderizarSemana(container);
  else renderizarDia(container);
  actualizarTitulo();
  const totalSpan=document.getElementById('totalCitas'); if(totalSpan) totalSpan.textContent=citasData.length;
}
function renderizarMes(container){
  const primer=new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1);
  const ultimo=new Date(fechaActual.getFullYear(), fechaActual.getMonth()+1, 0);
  const primerDiaSemana=primer.getDay(); const ultimoDia=ultimo.getDate();
  let html='<div class="calendario-header">';
  ['Dom','Lun','Mar','Mié','Jue','Vie','Sáb'].forEach(d=> html += '<div class="calendario-header-dia">'+d+'</div>');
  html+='</div><div class="calendario-mes">';
  for(let i=0;i<primerDiaSemana;i++){ html+='<div class="calendario-dia otro-mes"></div>'; }
  for(let dia=1; dia<=ultimoDia; dia++){
    const fecha = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), dia);
    const clases = ['calendario-dia']; if (esMismaFecha(fecha, new Date())) clases.push('hoy');
    html += '<div class="'+clases.join(' ')+'"><div class="numero">'+dia+'</div>';
    const ymd=dateToYMD_TZ(fecha,'America/El_Salvador');
    obtenerCitasDelDia(ymd).forEach(c=> html += '<div class="cita '+c.estadoCita+'">'+formatHoraES(c.fechaHora)+' - '+c.pacienteNombre+'</div>');
    html += '</div>';
  }
  const totalCells = primerDiaSemana + ultimoDia; const remaining = 42 - totalCells; for(let i=0;i<remaining;i++){ html+='<div class="calendario-dia otro-mes"></div>'; }
  html+='</div>'; container.innerHTML = html;
}
function renderizarSemana(container){ container.innerHTML = '<div class="text-muted">Vista semanal en desarrollo</div>'; }
function renderizarDia(container){ container.innerHTML = '<div class="text-muted">Vista diaria en desarrollo</div>'; }
function actualizarTitulo(){ const t=document.getElementById('tituloCalendario'); t.textContent=new Intl.DateTimeFormat('es-SV',{year:'numeric',month:'long'}).format(fechaActual); }
function navegarCalendario(dir){ if(dir==='prev') fechaActual.setMonth(fechaActual.getMonth()-1); else fechaActual.setMonth(fechaActual.getMonth()+1); renderizarCalendario(); }
function cambiarVista(){ vistaActual=document.getElementById('vistaCalendario').value; renderizarCalendario(); }
function irHoy(){ fechaActual=new Date(); renderizarCalendario(); }
function esMismaFecha(a,b){ return dateToYMD_TZ(a,'America/El_Salvador')===dateToYMD_TZ(b,'America/El_Salvador'); }
function dateToYMD_TZ(date,timeZone){ return new Intl.DateTimeFormat('sv-SE',{timeZone,year:'numeric',month:'2-digit',day:'2-digit'}).format(date); }
function obtenerCitasDelDia(ymd){ return citasData.filter(c=> c.fechaDia===ymd); }
function formatHoraES(fh){ const d=new Date(String(fh).replace(' ','T')); return new Intl.DateTimeFormat('es-SV',{timeZone:'America/El_Salvador',hour:'2-digit',minute:'2-digit'}).format(d); }
</script>

<style>
.calendario-mes{display:grid;grid-template-columns:repeat(7,1fr);gap:1px;background:#dee2e6}
.calendario-header{display:grid;grid-template-columns:repeat(7,1fr);gap:1px;background:#dee2e6;margin-bottom:1px}
.calendario-header-dia{background:#495057;color:#fff;padding:8px;text-align:center;font-weight:600}
.calendario-dia{background:#fff;min-height:120px;padding:8px;border:1px solid #dee2e6}
.calendario-dia.hoy{background:#e3f2fd;border-color:#2196f3}
.calendario-dia .numero{font-weight:600;font-size:.9rem;margin-bottom:4px}
.calendario-dia .cita{background:#0d6efd;color:#fff;padding:2px 6px;border-radius:3px;font-size:.75rem;margin-bottom:2px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.calendario-dia .cita.pendiente{background:#ffc107;color:#000}
.calendario-dia .cita.realizada{background:#28a745}
.calendario-dia .cita.cancelada{background:#dc3545}
</style>
