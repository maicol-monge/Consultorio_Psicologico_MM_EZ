<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- Gestión de Citas -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-calendar-check me-2"></i>
                Gestión de Citas
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active">Citas</li>
                </ol>
            </nav>
        </div>
        <c:url value="/admin/citas/nueva" var="urlNueva"/>
        <c:url value="/admin/citas/calendario" var="urlCalendario"/>
        <div class="btn-group">
            <a href="${urlNueva}" class="btn btn-primary">
                <i class="bi bi-calendar-plus me-2"></i>Nueva Cita
            </a>
            <a href="${urlCalendario}" class="btn btn-outline-info">
                <i class="bi bi-calendar-week me-2"></i>Vista Calendario
            </a>
        </div>
    </div>

    <!-- Filtros -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/citas" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-calendar-date me-2"></i>Fecha Inicio
                    </label>
                    <input type="date" name="fechaInicio" class="form-control" value="${param.fechaInicio}">
                </div>
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-calendar-date me-2"></i>Fecha Fin
                    </label>
                    <input type="date" name="fechaFin" class="form-control" value="${param.fechaFin}">
                </div>
                <div class="col-md-2">
                    <label class="form-label">
                        <i class="bi bi-circle-fill me-2"></i>Estado
                    </label>
                    <select name="estado" class="form-select">
                        <option value="">Todos</option>
                        <option value="pendiente" ${param.estado == 'pendiente' ? 'selected' : ''}>Pendiente</option>
                        <option value="realizada" ${param.estado == 'realizada' ? 'selected' : ''}>Realizada</option>
                        <option value="cancelada" ${param.estado == 'cancelada' ? 'selected' : ''}>Cancelada</option>
                    </select>
                </div>
                <div class="w-100"></div>
                <div class="col-md-2">
                    <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Paciente</label>
                    <input type="text" id="buscarPaciente" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                </div>
                <div class="col-md-4">
                    <label class="form-label"><i class="bi bi-person-heart me-2"></i>Paciente</label>
                    <select name="paciente" id="selectPaciente" class="form-select">
                        <option value="">Todos</option>
                        <c:forEach var="paciente" items="${pacientes}">
                            <option value="${paciente.id}" data-text="${paciente.nombre} ${paciente.email}" ${param.paciente == paciente.id ? 'selected' : ''}>${paciente.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2">
                    <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Psicólogo</label>
                    <input type="text" id="buscarPsicologo" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                </div>
                <div class="col-md-4">
                    <label class="form-label"><i class="bi bi-person-check me-2"></i>Psicólogo</label>
                    <select name="psicologo" id="selectPsicologo" class="form-select">
                        <option value="">Todos</option>
                        <c:forEach var="psicologo" items="${psicologos}">
                            <option value="${psicologo.id}" data-text="${psicologo.nombre} ${psicologo.email}" ${param.psicologo == psicologo.id ? 'selected' : ''}>${psicologo.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn btn-outline-primary">
                        <i class="bi bi-search me-2"></i>Filtrar
                    </button>
                    <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-clockwise me-2"></i>Limpiar
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Alertas dinámicas -->
    <c:if test="${not empty requestScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>${requestScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>${requestScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Lista de citas -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="bi bi-list-ul me-2"></i>
                Citas Registradas (${citas.size()})
            </h5>
            <div class="btn-group btn-group-sm">
                <button type="button" class="btn btn-outline-success" onclick="exportarCitas('excel')">
                    <i class="bi bi-file-earmark-excel"></i> Excel
                </button>
                <button type="button" class="btn btn-outline-danger" onclick="exportarCitas('pdf')">
                    <i class="bi bi-file-earmark-pdf"></i> PDF
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty citas}">
                    <div class="text-center py-5">
                        <i class="bi bi-calendar-x display-1 text-muted"></i>
                        <h5 class="mt-3 text-muted">No se encontraron citas</h5>
                        <p class="text-muted">Ajusta los filtros o programa una nueva cita</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha y Hora</th>
                                    <th>Paciente</th>
                                    <th>Psicólogo</th>
                                    <th>Motivo</th>
                                    <th>Estado</th>
                                    <th width="150">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="cita" items="${citas}">
                                    <tr>
                                        <td>
                                            <div class="fw-semibold">
                                                <fmt:formatDate value="${cita.fechaHora}" pattern="dd/MM/yyyy"/>
                                            </div>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${cita.fechaHora}" pattern="HH:mm"/>
                                            </small>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-sm bg-info-subtle rounded-circle d-flex align-items-center justify-content-center me-2">
                                                    <i class="bi bi-person text-info"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">${cita.pacienteNombre}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-sm bg-success-subtle rounded-circle d-flex align-items-center justify-content-center me-2">
                                                    <i class="bi bi-person-check text-success"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">${cita.psicologoNombre}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="text-truncate d-inline-block" style="max-width: 200px;" title="${cita.motivoConsulta}">
                                                ${cita.motivoConsulta}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${cita.estadoCita == 'pendiente'}">
                                                    <span class="badge bg-warning">
                                                        <i class="bi bi-clock me-1"></i>Pendiente
                                                    </span>
                                                </c:when>
                                                
                                                <c:when test="${cita.estadoCita == 'realizada'}">
                                                    <span class="badge bg-success">
                                                        <i class="bi bi-check-circle-fill me-1"></i>Realizada
                                                    </span>
                                                </c:when>
                                                <c:when test="${cita.estadoCita == 'cancelada'}">
                                                    <span class="badge bg-danger">
                                                        <i class="bi bi-x-circle me-1"></i>Cancelada
                                                    </span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/admin/citas/ver/${cita.id}" 
                                                   class="btn btn-outline-info" title="Ver Detalle">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                                <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                                                    <a href="${pageContext.request.contextPath}/admin/citas/editar/${cita.id}" 
                                                       class="btn btn-outline-primary" title="Editar">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                </c:if>
                                                <div class="btn-group btn-group-sm">
                                                    <button type="button" class="btn btn-outline-secondary dropdown-toggle" 
                                                            data-bs-toggle="dropdown">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                                                            <li>
                                                                <button class="dropdown-item text-success marcar-realizada-admin" 
                                                                        data-id="${cita.id}" data-ts="${cita.fechaHora.time}" title="Marcar Realizada"
                                                                        onclick="validarYMarcarRealizada(${cita.id}, ${cita.fechaHora.time})">
                                                                    <i class="bi bi-check-circle-fill me-2"></i>Marcar Realizada
                                                                </button>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <button class="dropdown-item text-warning" 
                                                                        onclick="mostrarReasignar(${cita.id}, '<fmt:formatDate value='${cita.fechaHora}' pattern='yyyy-MM-dd'/>')">
                                                                    <i class="bi bi-arrow-repeat me-2"></i>Reasignar Psicólogo
                                                                </button>
                                                            </li>
                                                            <li>
                                                                <button class="dropdown-item text-danger" 
                                                                        onclick="cambiarEstado(${cita.id}, 'cancelada')">
                                                                    <i class="bi bi-x-circle me-2"></i>Cancelar
                                                                </button>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </div>
                                            </div>
                                        </td>
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

<script>
    (function(){
        function bindSearch(inputId, selectId) {
            const input = document.getElementById(inputId);
            const select = document.getElementById(selectId);
            if (!input || !select) return;
            const allOpts = Array.from(select.options).map(o => ({ value: o.value, text: o.text, data: (o.getAttribute('data-text')||'').toLowerCase() }));
            const placeholder = allOpts.shift(); // remove first (Todos)
            function apply(){
                const q = (input.value||'').toLowerCase().trim();
                const current = select.value;
                // rebuild
                select.innerHTML = '';
                const ph = document.createElement('option');
                ph.value = placeholder.value; ph.text = placeholder.text; select.appendChild(ph);
                allOpts.forEach(o => {
                    if (!q || o.text.toLowerCase().includes(q) || o.data.includes(q)) {
                        const opt = document.createElement('option');
                        opt.value = o.value; opt.text = o.text;
                        opt.setAttribute('data-text', o.data);
                        if (o.value === current) opt.selected = true;
                        select.appendChild(opt);
                    }
                });
            }
            input.addEventListener('input', apply);
        }
        bindSearch('buscarPaciente','selectPaciente');
        bindSearch('buscarPsicologo','selectPsicologo');
    })();
</script>

<!-- Modal para reasignar psicólogo -->
<div class="modal fade" id="reasignarModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-arrow-repeat text-warning me-2"></i>
                    Reasignar Psicólogo
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="formReasignar">
                    <input type="hidden" id="citaIdReasignar" name="id">
                    <input type="hidden" id="fechaCitaReasignar" name="fecha">
                    <div class="mb-3">
                        <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Psicólogo</label>
                        <input type="text" id="buscarPsicologoReasignarLista" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nuevo Psicólogo</label>
                        <select name="nuevoIdPsicologo" id="selectPsicologoReasignarLista" class="form-select" required>
                            <option value="">Seleccionar psicólogo</option>
                            <c:forEach var="psicologo" items="${psicologos}">
                                <option value="${psicologo.id}" data-text="${psicologo.nombre} ${psicologo.email}">${psicologo.nombre} - ${psicologo.especialidad}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hora disponible</label>
                        <select name="nuevaHora" id="selectHoraReasignarLista" class="form-select" required>
                            <option value="">Seleccionar hora</option>
                        </select>
                        <div class="form-text">Las horas se calculan según el horario del psicólogo para la fecha de la cita.</div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-warning" onclick="ejecutarReasignacion()">
                    <i class="bi bi-arrow-repeat me-2"></i>Reasignar
                </button>
            </div>
        </div>
    </div>
</div>

<script>
function cambiarEstado(idCita, nuevoEstado) {
    let mensaje = '';
    switch(nuevoEstado) {
        case 'confirmada': mensaje = '¿Confirmar esta cita?'; break;
        case 'realizada': mensaje = '¿Marcar como realizada?'; break;
        case 'cancelada': mensaje = '¿Cancelar esta cita?'; break;
    }
    
    if (confirm(mensaje)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/citas/cambiar-estado';
        
        const inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = 'id';
        inputId.value = idCita;
        
        const inputEstado = document.createElement('input');
        inputEstado.type = 'hidden';
        inputEstado.name = 'estado';
        inputEstado.value = nuevoEstado;
        
        form.appendChild(inputId);
        form.appendChild(inputEstado);
        document.body.appendChild(form);
        form.submit();
    }
}

// Validación: solo permitir marcar como realizada si la fecha/hora de la cita es hoy o pasada (zona America/El_Salvador)
function dateKeyInTz(date, tz){
    const f=new Intl.DateTimeFormat('en-CA',{timeZone:tz, year:'numeric', month:'2-digit', day:'2-digit'});
    const parts=f.formatToParts(date);
    const map=Object.fromEntries(parts.map(p=>[p.type,p.value]));
    return `${map.year}-${map.month}-${map.day}`;
}
function validarYMarcarRealizada(idCita, ts){
    const tz='America/El_Salvador';
    const citaKey=dateKeyInTz(new Date(parseInt(ts,10)), tz);
    const hoyKey=dateKeyInTz(new Date(), tz);
    if (citaKey > hoyKey){
        alert('No se puede marcar como realizada una cita futura.');
        return;
    }
    if (confirm('¿Marcar como realizada?')){
        cambiarEstado(idCita, 'realizada');
    }
}

// Deshabilitar visualmente en la lista cuando FECHA > hoy (El Salvador)
(function(){
    const tz='America/El_Salvador';
    document.querySelectorAll('.marcar-realizada-admin[data-ts]').forEach(btn=>{
        const ts=btn.getAttribute('data-ts');
        const citaKey=dateKeyInTz(new Date(parseInt(ts,10)), tz);
        const hoyKey=dateKeyInTz(new Date(), tz);
        if (citaKey > hoyKey){
            btn.setAttribute('disabled','disabled');
            btn.title = 'No disponible para fechas futuras';
        }
    });
})();

function mostrarReasignar(idCita, fechaIso) {
    document.getElementById('citaIdReasignar').value = idCita;
    document.getElementById('fechaCitaReasignar').value = fechaIso || '';
    const modalEl = document.getElementById('reasignarModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();

    // Bind search
    (function bindSearch() {
        const input = document.getElementById('buscarPsicologoReasignarLista');
        const select = document.getElementById('selectPsicologoReasignarLista');
        if (!input || !select) return;
        if (!select._allOptions) {
            select._allOptions = Array.from(select.options).map(o => ({
                value: o.value,
                text: o.text,
                data: (o.getAttribute('data-text')|| (o.text||'')).toLowerCase()
            }));
            select._placeholder = select._allOptions.shift();
        }
        function apply(){
            const q = (input.value||'').toLowerCase().trim();
            const current = select.value;
            select.innerHTML = '';
            const ph = document.createElement('option');
            ph.value = select._placeholder.value || '';
            ph.text = select._placeholder.text || 'Seleccionar psicólogo';
            select.appendChild(ph);
            select._allOptions.forEach(o => {
                if (!q || o.text.toLowerCase().includes(q) || o.data.includes(q)) {
                    const opt = document.createElement('option');
                    opt.value = o.value; opt.text = o.text;
                    opt.setAttribute('data-text', o.data);
                    if (o.value === current) opt.selected = true;
                    select.appendChild(opt);
                }
            });
        }
        if (!input._bound) {
            input.addEventListener('input', apply);
            input._bound = true;
        }
        apply();
    })();

    // Hours load
    const selPs = document.getElementById('selectPsicologoReasignarLista');
    if (selPs) {
        selPs.removeEventListener('change', cargarHorasReasignacionLista);
        selPs.addEventListener('change', cargarHorasReasignacionLista);
        cargarHorasReasignacionLista();
    }
}

function ejecutarReasignacion() {
    const form = document.getElementById('formReasignar');
    const formData = new FormData(form);
    
    if (!formData.get('nuevoIdPsicologo')) {
        alert('Por favor selecciona un psicólogo');
        return;
    }
    if (!formData.get('nuevaHora')) {
        alert('Por favor selecciona una hora disponible');
        return;
    }

    const submitForm = document.createElement('form');
    submitForm.method = 'POST';
    submitForm.action = '${pageContext.request.contextPath}/admin/citas/reasignar';
    
    for (let [key, value] of formData.entries()) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = value;
        submitForm.appendChild(input);
    }
    
    document.body.appendChild(submitForm);
    submitForm.submit();
}

function exportarCitas(tipo) {
    const params = new URLSearchParams(window.location.search);
    params.set('export', tipo);
    window.open('${pageContext.request.contextPath}/admin/citas/export?' + params.toString(), '_blank');
}

// Helpers to fetch available hours for list modal
const CTX_LISTA = '${pageContext.request.contextPath}';
async function cargarHorasReasignacionLista() {
    const selPs = document.getElementById('selectPsicologoReasignarLista');
    const selHora = document.getElementById('selectHoraReasignarLista');
    const fecha = document.getElementById('fechaCitaReasignar').value;
    if (!selPs || !selHora) return;
    const idPs = selPs.value;
    selHora.innerHTML = '<option value="">Cargando...</option>';
    if (!idPs || !fecha) {
        selHora.innerHTML = '<option value="">Seleccionar hora</option>';
        return;
    }
    try {
        const resp = await fetch(CTX_LISTA + '/admin/citas/horas?psicologo=' + encodeURIComponent(idPs) + '&fecha=' + encodeURIComponent(fecha));
        const data = await resp.json();
        const disponibles = Array.isArray(data) ? data : (data.disponibles || []);
        selHora.innerHTML = '';
        if (!disponibles.length) {
            selHora.innerHTML = '<option value="">Sin horas disponibles</option>';
            return;
        }
        const ph = document.createElement('option');
        ph.value = ''; ph.text = 'Seleccionar hora';
        selHora.appendChild(ph);
        disponibles.forEach(h => {
            const opt = document.createElement('option');
            opt.value = h; opt.text = h;
            selHora.appendChild(opt);
        });
    } catch (e) {
        selHora.innerHTML = '<option value="">Error al cargar horas</option>';
        console.error('Error cargando horas disponibles:', e);
    }
}
</script>