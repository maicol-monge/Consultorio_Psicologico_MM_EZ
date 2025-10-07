<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/admin/citas/nueva" class="btn btn-primary">
                <i class="bi bi-calendar-plus me-2"></i>Nueva Cita
            </a>
            <a href="${pageContext.request.contextPath}/admin/citas/calendario" class="btn btn-outline-info">
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
                        <option value="confirmada" ${param.estado == 'confirmada' ? 'selected' : ''}>Confirmada</option>
                        <option value="realizada" ${param.estado == 'realizada' ? 'selected' : ''}>Realizada</option>
                        <option value="cancelada" ${param.estado == 'cancelada' ? 'selected' : ''}>Cancelada</option>
                    </select>
                </div>
                <div class="w-100"></div>
                <div class="col-md-4">
                    <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Paciente</label>
                    <input type="text" id="buscarPaciente" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                </div>
                <div class="col-md-2">
                    <label class="form-label"><i class="bi bi-person-heart me-2"></i>Paciente</label>
                    <select name="paciente" id="selectPaciente" class="form-select">
                        <option value="">Todos</option>
                        <c:forEach var="paciente" items="${pacientes}">
                            <option value="${paciente.id}" data-text="${paciente.nombre} ${paciente.email}" ${param.paciente == paciente.id ? 'selected' : ''}>${paciente.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label"><i class="bi bi-search me-2"></i>Buscar Psicólogo</label>
                    <input type="text" id="buscarPsicologo" class="form-control" placeholder="Nombre o correo" autocomplete="off">
                </div>
                <div class="col-md-2">
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
                                                <c:when test="${cita.estadoCita == 'confirmada'}">
                                                    <span class="badge bg-info">
                                                        <i class="bi bi-check-circle me-1"></i>Confirmada
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
                                                        <c:if test="${cita.estadoCita == 'pendiente'}">
                                                            <li>
                                                                <button class="dropdown-item" 
                                                                        onclick="cambiarEstado(${cita.id}, 'confirmada')">
                                                                    <i class="bi bi-check-circle me-2"></i>Confirmar
                                                                </button>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${cita.estadoCita == 'confirmada'}">
                                                            <li>
                                                                <button class="dropdown-item text-success" 
                                                                        onclick="cambiarEstado(${cita.id}, 'realizada')">
                                                                    <i class="bi bi-check-circle-fill me-2"></i>Marcar Realizada
                                                                </button>
                                                            </li>
                                                        </c:if>
                                                        <c:if test="${cita.estadoCita != 'realizada' && cita.estadoCita != 'cancelada'}">
                                                            <li><hr class="dropdown-divider"></li>
                                                            <li>
                                                                <button class="dropdown-item text-warning" 
                                                                        onclick="mostrarReasignar(${cita.id})">
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
                    <div class="mb-3">
                        <label class="form-label">Nuevo Psicólogo</label>
                        <select name="nuevoIdPsicologo" class="form-select" required>
                            <option value="">Seleccionar psicólogo</option>
                            <c:forEach var="psicologo" items="${psicologos}">
                                <option value="${psicologo.id}">${psicologo.nombre} - ${psicologo.especialidad}</option>
                            </c:forEach>
                        </select>
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

function mostrarReasignar(idCita) {
    document.getElementById('citaIdReasignar').value = idCita;
    new bootstrap.Modal(document.getElementById('reasignarModal')).show();
}

function ejecutarReasignacion() {
    const form = document.getElementById('formReasignar');
    const formData = new FormData(form);
    
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
</script>