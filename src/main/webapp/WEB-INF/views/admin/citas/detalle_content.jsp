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
                        <c:when test="${cita.estadoCita == 'confirmada'}">
                            <span class="badge bg-info fs-6">
                                <i class="bi bi-check-circle me-1"></i>Confirmada
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
                            <c:if test="${cita.estadoCita == 'pendiente'}">
                                <button class="btn btn-sm btn-info" onclick="cambiarEstado('confirmada')">
                                    <i class="bi bi-check-circle me-2"></i>Confirmar Cita
                                </button>
                            </c:if>
                            <c:if test="${cita.estadoCita == 'confirmada'}">
                                <button class="btn btn-sm btn-success" onclick="cambiarEstado('realizada')">
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
                                    ${cita.duracion != null ? cita.duracion : 60} minutos
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
                            <p class="text-muted mb-0">${paciente.edad} años</p>
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
                    
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/admin/pacientes/ver/${paciente.id}" 
                           class="btn btn-outline-info btn-sm">
                            <i class="bi bi-eye me-2"></i>Ver Perfil Completo
                        </a>
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
                            <i class="bi bi-telephone text-muted me-2"></i>
                            <span class="text-muted">Teléfono:</span>
                            <span class="fw-semibold">${psicologo.telefono}</span>
                        </div>
                        <div class="info-item mb-2">
                            <i class="bi bi-envelope text-muted me-2"></i>
                            <span class="text-muted">Email:</span>
                            <span class="fw-semibold">${psicologo.email}</span>
                        </div>
                        <div class="info-item">
                            <i class="bi bi-award text-muted me-2"></i>
                            <span class="text-muted">Licencia:</span>
                            <span class="fw-semibold">${psicologo.numeroLicencia}</span>
                        </div>
                    </div>
                    
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/admin/psicologos/ver/${psicologo.id}" 
                           class="btn btn-outline-success btn-sm">
                            <i class="bi bi-eye me-2"></i>Ver Perfil Completo
                        </a>
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
                        <button type="button" class="btn btn-outline-info btn-sm" onclick="verHistorialCitas()">
                            <i class="bi bi-clock-history me-2"></i>Historial de Citas
                        </button>
                        <button type="button" class="btn btn-outline-warning btn-sm" onclick="enviarRecordatorio()">
                            <i class="bi bi-bell me-2"></i>Enviar Recordatorio
                        </button>
                        <c:if test="${cita.estadoCita == 'realizada'}">
                            <button type="button" class="btn btn-outline-success btn-sm" onclick="generarInforme()">
                                <i class="bi bi-file-earmark-text me-2"></i>Generar Informe
                            </button>
                        </c:if>
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
                        <label class="form-label">Nuevo Psicólogo</label>
                        <select name="nuevoIdPsicologo" class="form-select" required>
                            <option value="">Seleccionar psicólogo</option>
                            <c:forEach var="ps" items="${psicologos}">
                                <c:if test="${ps.id != psicologo.id}">
                                    <option value="${ps.id}">${ps.nombre} - ${ps.especialidad}</option>
                                </c:if>
                            </c:forEach>
                        </select>
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
    new bootstrap.Modal(document.getElementById('reasignarModal')).show();
}

function ejecutarReasignacion() {
    const form = document.getElementById('formReasignar');
    const formData = new FormData(form);
    
    if (!formData.get('nuevoIdPsicologo')) {
        alert('Por favor selecciona un psicólogo');
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
</script>