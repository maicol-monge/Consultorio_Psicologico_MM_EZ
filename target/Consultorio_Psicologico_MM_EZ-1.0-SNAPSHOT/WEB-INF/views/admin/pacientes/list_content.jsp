<!-- Gestión de Pacientes -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-person-heart me-2"></i>
                Gestión de Pacientes
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active">Pacientes</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pacientes/nuevo" class="btn btn-primary">
            <i class="bi bi-person-plus me-2"></i>Nuevo Paciente
        </a>
    </div>

    <!-- Filtros -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/pacientes" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">
                        <i class="bi bi-search me-2"></i>Buscar
                    </label>
                    <input type="text" name="buscar" class="form-control" 
                           value="${param.buscar}" placeholder="Nombre, email o teléfono">
                </div>
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-toggle-on me-2"></i>Estado
                    </label>
                    <select name="estado" class="form-select">
                        <option value="">Todos</option>
                        <option value="activo" ${param.estado == 'activo' ? 'selected' : ''}>Activo</option>
                        <option value="inactivo" ${param.estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-heart-pulse me-2"></i>Psicólogo
                    </label>
                    <select name="psicologo" class="form-select">
                        <option value="">Todos</option>
                        <c:forEach var="psicologo" items="${psicologos}">
                            <option value="${psicologo.id}" ${param.psicologo == psicologo.id ? 'selected' : ''}>
                                ${psicologo.nombre}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <button type="submit" class="btn btn-outline-primary w-100">
                        <i class="bi bi-search"></i> Filtrar
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Alertas -->
    <c:if test="${param.success != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-2"></i>
            <c:choose>
                <c:when test="${param.success == 'created'}">Paciente creado correctamente</c:when>
                <c:when test="${param.success == 'updated'}">Paciente actualizado correctamente</c:when>
                <c:when test="${param.success == 'deleted'}">Paciente eliminado correctamente</c:when>
                <c:when test="${param.success == 'estado'}">Estado del paciente cambiado correctamente</c:when>
                <c:otherwise>${param.success}</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>
            ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- Tabla de pacientes -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="bi bi-table me-2"></i>
                Listado de Pacientes (${pacientes.size()})
            </h5>
            <div class="btn-group btn-group-sm">
                <button type="button" class="btn btn-outline-success" onclick="exportarPacientes('excel')">
                    <i class="bi bi-file-earmark-excel"></i> Excel
                </button>
                <button type="button" class="btn btn-outline-danger" onclick="exportarPacientes('pdf')">
                    <i class="bi bi-file-earmark-pdf"></i> PDF
                </button>
            </div>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty pacientes}">
                    <div class="text-center py-5">
                        <i class="bi bi-person-x display-1 text-muted"></i>
                        <h5 class="mt-3 text-muted">No se encontraron pacientes</h5>
                        <p class="text-muted">Ajusta los filtros o agrega un nuevo paciente</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Paciente</th>
                                    <th>Contacto</th>
                                    <th>Código Acceso</th>
                                    <th>Psicólogo Asignado</th>
                                    <th>Estado</th>
                                    <th>Registro</th>
                                    <th width="150">Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="paciente" items="${pacientes}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="avatar-sm bg-primary-subtle rounded-circle d-flex align-items-center justify-content-center me-2">
                                                    <i class="bi bi-person text-primary"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-semibold">${paciente.nombre}</div>
                                                    <small class="text-muted">${paciente.edad} años</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <i class="bi bi-envelope me-1"></i>
                                                <small>${paciente.email}</small>
                                            </div>
                                            <div>
                                                <i class="bi bi-telephone me-1"></i>
                                                <small>${paciente.telefono}</small>
                                            </div>
                                        </td>
                                        <td>
                                            <code class="bg-info-subtle px-2 py-1 rounded">${paciente.codigoAcceso}</code>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${paciente.psicologoNombre != null}">
                                                    <span class="badge bg-success-subtle text-success">
                                                        <i class="bi bi-person-check me-1"></i>
                                                        ${paciente.psicologoNombre}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning">
                                                        <i class="bi bi-person-dash me-1"></i>
                                                        Sin asignar
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <span class="badge ${paciente.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">
                                                <i class="bi bi-${paciente.estado == 'activo' ? 'check' : 'x'}-circle me-1"></i>
                                                ${paciente.estado}
                                            </span>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${paciente.fechaRegistro}" pattern="dd/MM/yyyy"/>
                                            </small>
                                        </td>
                                        <td>
                                            <div class="btn-group btn-group-sm">
                                                <a href="${pageContext.request.contextPath}/admin/pacientes/editar/${paciente.id}" 
                                                   class="btn btn-outline-primary" title="Editar">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                                <button type="button" class="btn btn-outline-warning" 
                                                        onclick="cambiarEstadoPaciente(${paciente.id}, '${paciente.estado == 'activo' ? 'inactivo' : 'activo'}')"
                                                        title="${paciente.estado == 'activo' ? 'Desactivar' : 'Activar'}">
                                                    <i class="bi bi-${paciente.estado == 'activo' ? 'pause' : 'play'}-circle"></i>
                                                </button>
                                                <div class="btn-group btn-group-sm">
                                                    <button type="button" class="btn btn-outline-secondary dropdown-toggle" 
                                                            data-bs-toggle="dropdown">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/pacientes/ver/${paciente.id}">
                                                                <i class="bi bi-eye me-2"></i>Ver Detalle
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/citas?paciente=${paciente.id}">
                                                                <i class="bi bi-calendar me-2"></i>Ver Citas
                                                            </a>
                                                        </li>
                                                        <li><hr class="dropdown-divider"></li>
                                                        <li>
                                                            <button class="dropdown-item text-danger" 
                                                                    onclick="confirmarEliminar(${paciente.id}, '${paciente.nombre}')">
                                                                <i class="bi bi-trash me-2"></i>Eliminar
                                                            </button>
                                                        </li>
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

<!-- Modal de confirmación para eliminar -->
<div class="modal fade" id="eliminarPacienteModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-exclamation-triangle text-danger me-2"></i>
                    Confirmar Eliminación
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>¿Está seguro que desea eliminar al paciente <strong id="nombrePacienteEliminar"></strong>?</p>
                <div class="alert alert-warning">
                    <i class="bi bi-exclamation-triangle me-2"></i>
                    Esta acción no se puede deshacer y eliminará también:
                    <ul class="mt-2 mb-0">
                        <li>Todas las citas del paciente</li>
                        <li>Los pagos asociados</li>
                        <li>Las evaluaciones realizadas</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-danger" onclick="eliminarPaciente()">
                    <i class="bi bi-trash me-2"></i>Sí, Eliminar
                </button>
            </div>
        </div>
    </div>
</div>

<script>
let pacienteIdEliminar = null;

function cambiarEstadoPaciente(id, nuevoEstado) {
    if (confirm(`¿Cambiar estado del paciente a ${nuevoEstado}?`)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/pacientes/cambiar-estado';
        
        const inputId = document.createElement('input');
        inputId.type = 'hidden';
        inputId.name = 'id';
        inputId.value = id;
        
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

function confirmarEliminar(id, nombre) {
    pacienteIdEliminar = id;
    document.getElementById('nombrePacienteEliminar').textContent = nombre;
    new bootstrap.Modal(document.getElementById('eliminarPacienteModal')).show();
}

function eliminarPaciente() {
    if (pacienteIdEliminar) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/pacientes/eliminar';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = pacienteIdEliminar;
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

function exportarPacientes(tipo) {
    const params = new URLSearchParams(window.location.search);
    params.set('export', tipo);
    window.open('${pageContext.request.contextPath}/admin/pacientes/export?' + params.toString(), '_blank');
}
</script>