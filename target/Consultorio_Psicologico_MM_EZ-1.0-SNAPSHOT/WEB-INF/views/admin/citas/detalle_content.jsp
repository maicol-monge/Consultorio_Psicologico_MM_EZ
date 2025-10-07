<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- Detalle de Cita -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-calendar-event me-2"></i>
                Detalle de Cita #${cita.id}
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/citas">Citas</a></li>
                    <li class="breadcrumb-item active">Detalle</li>
                </ol>
            </nav>
        </div>
        <div class="btn-group">
            <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                <a href="${pageContext.request.contextPath}/admin/citas/editar/${cita.id}" class="btn btn-primary">
                    <i class="bi bi-pencil me-2"></i>Editar
                </a>
            </c:if>
            <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-2"></i>Volver
            </a>
        </div>
    </div>

    <!-- Alertas dinámicas -->
    <c:if test="${not empty requestScope.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>
            ${requestScope.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty requestScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>
            ${requestScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="row">
        <!-- Información Principal -->
        <div class="col-lg-8">
            <!-- Estado y Acciones Rápidas -->
            <div class="card mb-4">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="bi bi-info-circle text-primary me-2"></i>
                        Estado de la Cita
                    </h5>
                    <c:choose>
                        <c:when test="${cita.estadoCita == 'pendiente'}">
                            <span class="badge bg-warning fs-6">
                                <i class="bi bi-clock me-1"></i>Pendiente
                            </span>
                        </c:when>
                        
                        <c:when test="${cita.estadoCita == 'realizada'}">
                            <span class="badge bg-success fs-6">
                                <i class="bi bi-check-circle-fill me-1"></i>Realizada
                            </span>
                        </c:when>
                        <c:when test="${cita.estadoCita == 'cancelada'}">
                            <span class="badge bg-danger fs-6">
                                <i class="bi bi-x-circle me-1"></i>Cancelada
                            </span>
                        </c:when>
                    </c:choose>
                </div>
                <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                                <button class="btn btn-sm btn-success marcar-realizada-detalle" onclick="validarYMarcarRealizadaAdmin()" title="Marcar como Realizada">
                                    <i class="bi bi-check-circle-fill me-2"></i>Marcar como Realizada
                                </button>
                            </c:if>
                            <button class="btn btn-sm btn-outline-warning" onclick="mostrarReasignar()">
                                <i class="bi bi-arrow-repeat me-2"></i>Reasignar Psicólogo
                            </button>
                            <button class="btn btn-sm btn-outline-danger" onclick="cambiarEstado('cancelada')">
                                <i class="bi bi-x-circle me-2"></i>Cancelar Cita
                            </button>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- Información de la Cita -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-calendar-event text-primary me-2"></i>
                        Información de la Cita
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item mb-3">
                                <label class="text-muted small">FECHA Y HORA</label>
                                <div class="fw-semibold fs-5">
                                    <i class="bi bi-calendar-date text-primary me-2"></i>
                                    <fmt:formatDate value="${cita.fechaHora}" pattern="dd 'de' MMMM 'de' yyyy"/>
                                </div>
                                <div class="text-muted">
                                    <i class="bi bi-clock me-2"></i>
                                    <fmt:formatDate value="${cita.fechaHora}" pattern="HH:mm"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="info-item mb-3">
                                <label class="text-muted small">DURACIÓN</label>
                                <div class="fw-semibold">
                                    <i class="bi bi-clock-history text-info me-2"></i>
                                    60 minutos
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-12">
                            <div class="info-item mb-3">
                                <label class="text-muted small">MOTIVO DE CONSULTA</label>
                                <div class="bg-light p-3 rounded">
                                    <i class="bi bi-chat-left-text text-primary me-2"></i>
                                    ${cita.motivoConsulta}
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <c:if test="${not empty cita.observaciones}">
                        <div class="row">
                            <div class="col-12">
                                <div class="info-item mb-3">
                                    <label class="text-muted small">OBSERVACIONES</label>
                                    <div class="bg-light p-3 rounded">
                                        <i class="bi bi-journal-text text-secondary me-2"></i>
                                        ${cita.observaciones}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <label class="text-muted small">FECHA DE CREACIÓN</label>
                                <div class="fw-semibold">
                                    <i class="bi bi-calendar-plus text-success me-2"></i>
                                    <fmt:formatDate value="${cita.fechaCreacion}" pattern="dd/MM/yyyy HH:mm"/>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Historial de Cambios -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-clock-history text-secondary me-2"></i>
                        Historial de Cambios
                    </h5>
                </div>
                <div class="card-body">
                    <div class="timeline">
                        <div class="timeline-item">
                            <div class="timeline-marker bg-success"></div>
                            <div class="timeline-content">
                                <h6 class="mb-1">Cita creada</h6>
                                <p class="text-muted mb-0">
                                    <fmt:formatDate value="${cita.fechaCreacion}" pattern="dd/MM/yyyy HH:mm"/>
                                </p>
                            </div>
                        </div>
                        <!-- Aquí se agregarían más eventos del historial -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Panel Lateral -->
        <div class="col-lg-4">
            <!-- Información del Paciente -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-person-heart text-info me-2"></i>
                        Paciente
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="avatar-lg bg-info-subtle rounded-circle d-flex align-items-center justify-content-center me-3">
                            <i class="bi bi-person fs-3 text-info"></i>
                        </div>
                        <div>
                            <h6 class="mb-1">${paciente.nombre}</h6>
                            <p class="text-muted mb-0">
                                <c:choose>
                                    <c:when test="${not empty paciente.fechaNacimiento}">
                                        Nac.: <fmt:formatDate value="${paciente.fechaNacimiento}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </p>
                        </div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-item mb-2">
                            <i class="bi bi-telephone text-muted me-2"></i>
                            <span class="text-muted">Teléfono:</span>
                            <span class="fw-semibold">${paciente.telefono}</span>
                        </div>
                        <div class="info-item mb-2">
                            <i class="bi bi-envelope text-muted me-2"></i>
                            <span class="text-muted">Email:</span>
                            <span class="fw-semibold">${paciente.email}</span>
                        </div>
                        <div class="info-item">
                            <i class="bi bi-geo-alt text-muted me-2"></i>
                            <span class="text-muted">Dirección:</span>
                            <span class="fw-semibold">${paciente.direccion}</span>
                        </div>
                    </div>
                    
                </div>
            </div>

            <!-- Información del Psicólogo -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-person-check text-success me-2"></i>
                        Psicólogo
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="avatar-lg bg-success-subtle rounded-circle d-flex align-items-center justify-content-center me-3">
                            <i class="bi bi-person-badge fs-3 text-success"></i>
                        </div>
                        <div>
                            <h6 class="mb-1">${psicologo.nombre}</h6>
                            <p class="text-muted mb-0">${psicologo.especialidad}</p>
                        </div>
                    </div>
                    
                    <div class="info-group">
                        <div class="info-item mb-2">
                            <i class="bi bi-envelope text-muted me-2"></i>
                            <span class="text-muted">Email:</span>
                            <span class="fw-semibold">${psicologo.email}</span>
                        </div>
                    </div>
                    
                </div>
            </div>

            <!-- Acciones Rápidas -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-lightning text-warning me-2"></i>
                        Acciones Rápidas
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/admin/citas/nueva?paciente=${paciente.id}" 
                           class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-calendar-plus me-2"></i>Nueva Cita para este Paciente
                        </a>
                        <!-- Botón de Generar Informe removido por solicitud -->
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

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
                    <div class="mb-3">
                        <label class="form-label">Psicólogo actual</label>
                        <div class="bg-light p-2 rounded">
                            ${psicologo.nombre} - ${psicologo.especialidad}
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Psicólogo</label>
                        <input type="text" id="buscarPsicologoReasignarDetalle" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nuevo Psicólogo</label>
                        <select name="nuevoIdPsicologo" id="selectPsicologoReasignarDetalle" class="form-select" required>
                            <option value="">Seleccionar psicólogo</option>
                            <c:forEach var="ps" items="${psicologos}">
                                <c:if test="${ps.id != psicologo.id}">
                                    <option value="${ps.id}">${ps.nombre} - ${ps.especialidad}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Fecha de la cita</label>
                        <input type="text" class="form-control" value="<fmt:formatDate value='${cita.fechaHora}' pattern='dd/MM/yyyy'/>" disabled>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Hora disponible</label>
                        <select name="nuevaHora" id="selectHoraReasignarDetalle" class="form-select" required>
                            <option value="">Seleccionar hora</option>
                        </select>
                        <div class="form-text">Las horas se calculan según el horario del psicólogo seleccionado para la fecha de esta cita.</div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Motivo del cambio</label>
                        <textarea name="motivoCambio" class="form-control" rows="2" 
                                  placeholder="Razón por la cual se reasigna el psicólogo..."></textarea>
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

<style>
.timeline {
    position: relative;
    padding: 0;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 20px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #dee2e6;
}

.timeline-item {
    position: relative;
    padding-left: 50px;
    margin-bottom: 20px;
}

.timeline-marker {
    position: absolute;
    left: 14px;
    top: 0;
    width: 12px;
    height: 12px;
    border-radius: 50%;
    border: 2px solid white;
}

.timeline-content h6 {
    margin-bottom: 5px;
}

.info-item label.small {
    font-weight: 600;
    letter-spacing: 0.5px;
}

.avatar-lg {
    width: 60px;
    height: 60px;
}
</style>

<script>
function cambiarEstado(nuevoEstado) {
    let mensaje = '';
    switch(nuevoEstado) {
        case 'confirmada': mensaje = '¿Confirmar esta cita?'; break;
        case 'realizada': mensaje = '¿Marcar como realizada? Esta acción no se puede deshacer.'; break;
        case 'cancelada': mensaje = '¿Cancelar esta cita? Esta acción no se puede deshacer.'; break;
    }
    
    if (confirm(mensaje)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/citas/cambiar-estado';
        
        const inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = 'id';
        inputId.value = '${cita.id}';
        
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

function mostrarReasignar() {
    const modalEl = document.getElementById('reasignarModal');
    const modal = new bootstrap.Modal(modalEl);
    modal.show();

    // Bind search for psychologists in modal
    (function bindSearch() {
        const input = document.getElementById('buscarPsicologoReasignarDetalle');
        const select = document.getElementById('selectPsicologoReasignarDetalle');
        if (!input || !select) return;
        // Cache all options on first bind
        if (!select._allOptions) {
            select._allOptions = Array.from(select.options).map(o => ({
                value: o.value,
                text: o.text,
                data: (o.getAttribute('data-text')|| (o.text||'')).toLowerCase()
            }));
            // Ensure first option (placeholder) remains at top
            select._placeholder = select._allOptions.shift();
        }
        function apply() {
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
        // Initial apply to ensure options consistent after multiple opens
        apply();
    })();

    // Load hours for selected psychologist
    const selPs = document.getElementById('selectPsicologoReasignarDetalle');
    if (selPs) {
        selPs.removeEventListener('change', cargarHorasReasignacionDetalle);
        selPs.addEventListener('change', cargarHorasReasignacionDetalle);
        cargarHorasReasignacionDetalle();
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
    
    const inputId = document.createElement('input');
    inputId.type = 'hidden';
    inputId.name = 'id';
    inputId.value = '${cita.id}';
    submitForm.appendChild(inputId);
    
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

function verHistorialCitas() {
    window.open('${pageContext.request.contextPath}/admin/citas?paciente=${paciente.id}', '_blank');
}

function enviarRecordatorio() {
    if (confirm('¿Enviar recordatorio de la cita al paciente?')) {
        // Aquí se implementaría la lógica de envío de recordatorio
        alert('Recordatorio enviado correctamente');
    }
}

function generarInforme() {
    window.open('${pageContext.request.contextPath}/admin/citas/informe/${cita.id}', '_blank');
}

// Helpers to fetch and populate available hours in detail modal
const CTX_DETALLE = '${pageContext.request.contextPath}';
const FECHA_CITA_ISO_DETALLE = '<fmt:formatDate value="${cita.fechaHora}" pattern="yyyy-MM-dd"/>';
const FECHA_CITA_TS_DETALLE = ${cita.fechaHora.time};
function dateKeyInTz(date, tz){
    const f=new Intl.DateTimeFormat('en-CA',{timeZone:tz, year:'numeric', month:'2-digit', day:'2-digit'});
    const parts=f.formatToParts(date);
    const map=Object.fromEntries(parts.map(p=>[p.type,p.value]));
    return `${map.year}-${map.month}-${map.day}`;
}
function validarYMarcarRealizadaAdmin(){
    const tz='America/El_Salvador';
    const citaKey=dateKeyInTz(new Date(FECHA_CITA_TS_DETALLE), tz);
    const hoyKey=dateKeyInTz(new Date(), tz);
    if (citaKey > hoyKey){
        alert('No se puede marcar como realizada una cita futura.');
        return;
    }
    cambiarEstado('realizada');
}

// Deshabilitar visualmente el botón si FECHA > hoy (El Salvador)
(function(){
    const tz='America/El_Salvador';
    const btn=document.querySelector('.marcar-realizada-detalle');
    if (!btn) return;
    const citaKey=dateKeyInTz(new Date(FECHA_CITA_TS_DETALLE), tz);
    const hoyKey=dateKeyInTz(new Date(), tz);
    if (citaKey > hoyKey){
        btn.setAttribute('disabled','disabled');
        btn.title = 'No disponible para fechas futuras';
    }
})();
async function cargarHorasReasignacionDetalle() {
    const selPs = document.getElementById('selectPsicologoReasignarDetalle');
    const selHora = document.getElementById('selectHoraReasignarDetalle');
    if (!selPs || !selHora) return;
    const idPs = selPs.value;
    selHora.innerHTML = '<option value="">Cargando...</option>';
    if (!idPs) {
        selHora.innerHTML = '<option value="">Seleccionar hora</option>';
        return;
    }
    try {
        const resp = await fetch(CTX_DETALLE + '/admin/citas/horas?psicologo=' + encodeURIComponent(idPs) + '&fecha=' + encodeURIComponent(FECHA_CITA_ISO_DETALLE));
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