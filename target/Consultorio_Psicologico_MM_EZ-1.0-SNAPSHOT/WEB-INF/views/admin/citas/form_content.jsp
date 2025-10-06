<!-- Formulario de Cita -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-calendar-plus me-2"></i>
                ${cita != null ? 'Editar Cita' : 'Nueva Cita'}
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/citas">Citas</a></li>
                    <li class="breadcrumb-item active">${cita != null ? 'Editar' : 'Nueva'}</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Volver
        </a>
    </div>

    <!-- Alertas -->
    <c:if test="${param.error != null}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle me-2"></i>
            ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/admin/citas/${cita != null ? 'editar' : 'nueva'}" 
          id="formCita" class="needs-validation" novalidate>
        
        <!-- ID oculto para edición -->
        <c:if test="${cita != null}">
            <input type="hidden" name="id" value="${cita.id}">
        </c:if>

        <div class="row">
            <!-- Información del Paciente -->
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-person-heart text-info me-2"></i>
                            Información del Paciente
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-person-fill me-2"></i>Paciente *
                            </label>
                            <select name="idPaciente" class="form-select" required onchange="cargarInfoPaciente(this.value)">
                                <option value="">Seleccionar paciente...</option>
                                <c:forEach var="paciente" items="${pacientes}">
                                    <option value="${paciente.id}" 
                                            ${cita != null && cita.idPaciente == paciente.id ? 'selected' : ''}
                                            data-telefono="${paciente.telefono}"
                                            data-email="${paciente.email}"
                                            data-edad="${paciente.edad}">
                                        ${paciente.nombre}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor selecciona un paciente
                            </div>
                        </div>

                        <!-- Info adicional del paciente -->
                        <div id="infoPaciente" class="mt-3" style="display: none;">
                            <div class="bg-light rounded p-3">
                                <h6 class="mb-2">
                                    <i class="bi bi-info-circle text-primary me-2"></i>
                                    Información del Paciente
                                </h6>
                                <div class="row">
                                    <div class="col-sm-6">
                                        <small class="text-muted">Teléfono:</small>
                                        <div id="telefonoPaciente" class="fw-semibold">-</div>
                                    </div>
                                    <div class="col-sm-6">
                                        <small class="text-muted">Email:</small>
                                        <div id="emailPaciente" class="fw-semibold">-</div>
                                    </div>
                                    <div class="col-sm-6 mt-2">
                                        <small class="text-muted">Edad:</small>
                                        <div id="edadPaciente" class="fw-semibold">-</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Búsqueda rápida de pacientes -->
                        <div class="mt-3">
                            <label class="form-label">
                                <i class="bi bi-search me-2"></i>Buscar paciente por nombre
                            </label>
                            <input type="text" class="form-control" placeholder="Escribir para filtrar..." 
                                   onkeyup="filtrarPacientes(this.value)">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Información del Psicólogo -->
            <div class="col-lg-6">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="bi bi-person-check text-success me-2"></i>
                            Información del Psicólogo
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-person-badge me-2"></i>Psicólogo *
                            </label>
                            <select name="idPsicologo" class="form-select" required onchange="cargarInfoPsicologo(this.value)">
                                <option value="">Seleccionar psicólogo...</option>
                                <c:forEach var="psicologo" items="${psicologos}">
                                    <option value="${psicologo.id}" 
                                            ${cita != null && cita.idPsicologo == psicologo.id ? 'selected' : ''}
                                            data-especialidad="${psicologo.especialidad}"
                                            data-telefono="${psicologo.telefono}"
                                            data-email="${psicologo.email}">
                                        ${psicologo.nombre}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor selecciona un psicólogo
                            </div>
                        </div>

                        <!-- Info adicional del psicólogo -->
                        <div id="infoPsicologo" class="mt-3" style="display: none;">
                            <div class="bg-light rounded p-3">
                                <h6 class="mb-2">
                                    <i class="bi bi-info-circle text-primary me-2"></i>
                                    Información del Psicólogo
                                </h6>
                                <div class="row">
                                    <div class="col-12 mb-2">
                                        <small class="text-muted">Especialidad:</small>
                                        <div id="especialidadPsicologo" class="fw-semibold">-</div>
                                    </div>
                                    <div class="col-sm-6">
                                        <small class="text-muted">Teléfono:</small>
                                        <div id="telefonoPsicologo" class="fw-semibold">-</div>
                                    </div>
                                    <div class="col-sm-6">
                                        <small class="text-muted">Email:</small>
                                        <div id="emailPsicologo" class="fw-semibold">-</div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Verificar disponibilidad -->
                        <div class="mt-3">
                            <button type="button" class="btn btn-outline-info btn-sm" onclick="verificarDisponibilidad()">
                                <i class="bi bi-calendar-check me-2"></i>Verificar Disponibilidad
                            </button>
                        </div>
                    </div>
                </div>
            </div>
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
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-calendar-date me-2"></i>Fecha *
                            </label>
                            <input type="date" name="fecha" class="form-control" required
                                   value="<fmt:formatDate value='${cita.fechaHora}' pattern='yyyy-MM-dd'/>"
                                   min="<fmt:formatDate value='${fechaMinima}' pattern='yyyy-MM-dd'/>"
                                   onchange="validarFecha(this.value)">
                            <div class="invalid-feedback">
                                Por favor selecciona una fecha válida
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-clock me-2"></i>Hora *
                            </label>
                            <select name="hora" class="form-select" required>
                                <option value="">Seleccionar hora...</option>
                                <c:forEach var="hora" begin="8" end="17">
                                    <c:forEach var="minuto" items="00,30">
                                        <c:set var="horaCompleta" value="${hora}:${minuto}"/>
                                        <option value="${horaCompleta}" 
                                                ${cita != null && hora == hora_seleccionada && minuto == minuto_seleccionado ? 'selected' : ''}>
                                            ${horaCompleta}
                                        </option>
                                    </c:forEach>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor selecciona una hora
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-clock-history me-2"></i>Duración (minutos)
                            </label>
                            <select name="duracion" class="form-select">
                                <option value="30" ${cita != null && cita.duracion == 30 ? 'selected' : ''}>30 minutos</option>
                                <option value="45" ${cita != null && cita.duracion == 45 ? 'selected' : ''}>45 minutos</option>
                                <option value="60" ${cita != null && cita.duracion == 60 ? 'selected' : 'selected'}>60 minutos</option>
                                <option value="90" ${cita != null && cita.duracion == 90 ? 'selected' : ''}>90 minutos</option>
                            </select>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-circle-fill me-2"></i>Estado
                            </label>
                            <select name="estadoCita" class="form-select">
                                <option value="pendiente" ${cita == null || cita.estadoCita == 'pendiente' ? 'selected' : ''}>Pendiente</option>
                                <option value="confirmada" ${cita != null && cita.estadoCita == 'confirmada' ? 'selected' : ''}>Confirmada</option>
                                <c:if test="${cita != null}">
                                    <option value="realizada" ${cita.estadoCita == 'realizada' ? 'selected' : ''}>Realizada</option>
                                    <option value="cancelada" ${cita.estadoCita == 'cancelada' ? 'selected' : ''}>Cancelada</option>
                                </c:if>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        <i class="bi bi-chat-left-text me-2"></i>Motivo de Consulta *
                    </label>
                    <textarea name="motivoConsulta" class="form-control" rows="3" required 
                              placeholder="Describe el motivo de la consulta...">${cita != null ? cita.motivoConsulta : ''}</textarea>
                    <div class="invalid-feedback">
                        Por favor describe el motivo de la consulta
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        <i class="bi bi-journal-text me-2"></i>Observaciones
                    </label>
                    <textarea name="observaciones" class="form-control" rows="2" 
                              placeholder="Observaciones adicionales (opcional)...">${cita != null ? cita.observaciones : ''}</textarea>
                </div>
            </div>
        </div>

        <!-- Botones de acción -->
        <div class="card">
            <div class="card-body">
                <div class="d-flex justify-content-between">
                    <div>
                        <c:if test="${cita != null}">
                            <button type="button" class="btn btn-outline-danger" onclick="confirmarEliminacion()">
                                <i class="bi bi-trash me-2"></i>Eliminar Cita
                            </button>
                        </c:if>
                    </div>
                    <div>
                        <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-secondary me-2">
                            <i class="bi bi-x-lg me-2"></i>Cancelar
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg me-2"></i>
                            ${cita != null ? 'Actualizar' : 'Guardar'} Cita
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- Modal de disponibilidad -->
<div class="modal fade" id="disponibilidadModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-calendar-check text-info me-2"></i>
                    Disponibilidad del Psicólogo
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="disponibilidadContent">
                    <div class="text-center">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Cargando...</span>
                        </div>
                        <p class="mt-2">Verificando disponibilidad...</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Validación de formulario
(function() {
    'use strict';
    window.addEventListener('load', function() {
        var forms = document.getElementsByClassName('needs-validation');
        var validation = Array.prototype.filter.call(forms, function(form) {
            form.addEventListener('submit', function(event) {
                if (form.checkValidity() === false) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
        });
    }, false);
})();

function cargarInfoPaciente(idPaciente) {
    const select = document.querySelector('select[name="idPaciente"]');
    const selectedOption = select.querySelector(`option[value="${idPaciente}"]`);
    const infoDiv = document.getElementById('infoPaciente');
    
    if (selectedOption && idPaciente) {
        document.getElementById('telefonoPaciente').textContent = selectedOption.dataset.telefono || '-';
        document.getElementById('emailPaciente').textContent = selectedOption.dataset.email || '-';
        document.getElementById('edadPaciente').textContent = selectedOption.dataset.edad ? selectedOption.dataset.edad + ' años' : '-';
        infoDiv.style.display = 'block';
    } else {
        infoDiv.style.display = 'none';
    }
}

function cargarInfoPsicologo(idPsicologo) {
    const select = document.querySelector('select[name="idPsicologo"]');
    const selectedOption = select.querySelector(`option[value="${idPsicologo}"]`);
    const infoDiv = document.getElementById('infoPsicologo');
    
    if (selectedOption && idPsicologo) {
        document.getElementById('especialidadPsicologo').textContent = selectedOption.dataset.especialidad || '-';
        document.getElementById('telefonoPsicologo').textContent = selectedOption.dataset.telefono || '-';
        document.getElementById('emailPsicologo').textContent = selectedOption.dataset.email || '-';
        infoDiv.style.display = 'block';
    } else {
        infoDiv.style.display = 'none';
    }
}

function filtrarPacientes(texto) {
    const select = document.querySelector('select[name="idPaciente"]');
    const options = select.querySelectorAll('option');
    
    options.forEach(option => {
        if (option.value === '') return; // Mantener opción vacía
        
        const nombre = option.textContent.toLowerCase();
        if (nombre.includes(texto.toLowerCase())) {
            option.style.display = '';
        } else {
            option.style.display = 'none';
        }
    });
}

function validarFecha(fecha) {
    const fechaSeleccionada = new Date(fecha);
    const hoy = new Date();
    const diaSemana = fechaSeleccionada.getDay();
    
    // Validar que no sea domingo (0) o sábado (6)
    if (diaSemana === 0 || diaSemana === 6) {
        alert('No se pueden programar citas los fines de semana');
        document.querySelector('input[name="fecha"]').value = '';
        return false;
    }
    
    return true;
}

function verificarDisponibilidad() {
    const idPsicologo = document.querySelector('select[name="idPsicologo"]').value;
    const fecha = document.querySelector('input[name="fecha"]').value;
    
    if (!idPsicologo || !fecha) {
        alert('Por favor selecciona un psicólogo y una fecha');
        return;
    }
    
    // Mostrar modal
    const modal = new bootstrap.Modal(document.getElementById('disponibilidadModal'));
    modal.show();
    
    // Simular carga de disponibilidad (aquí se haría una petición AJAX real)
    setTimeout(() => {
        const content = document.getElementById('disponibilidadContent');
        content.innerHTML = `
            <h6>Disponibilidad para ${fecha}</h6>
            <div class="row">
                <div class="col-md-6">
                    <h6 class="text-success">
                        <i class="bi bi-check-circle me-2"></i>Horarios Disponibles
                    </h6>
                    <div class="list-group">
                        <div class="list-group-item">09:00 - 10:00</div>
                        <div class="list-group-item">11:30 - 12:30</div>
                        <div class="list-group-item">14:00 - 15:00</div>
                        <div class="list-group-item">16:30 - 17:30</div>
                    </div>
                </div>
                <div class="col-md-6">
                    <h6 class="text-danger">
                        <i class="bi bi-x-circle me-2"></i>Horarios Ocupados
                    </h6>
                    <div class="list-group">
                        <div class="list-group-item">08:00 - 09:00</div>
                        <div class="list-group-item">10:00 - 11:00</div>
                        <div class="list-group-item">15:00 - 16:00</div>
                    </div>
                </div>
            </div>
        `;
    }, 1000);
}

function confirmarEliminacion() {
    if (confirm('¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/citas/eliminar';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = '${cita.id}';
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

// Cargar información inicial si estamos editando
document.addEventListener('DOMContentLoaded', function() {
    const idPaciente = document.querySelector('select[name="idPaciente"]').value;
    const idPsicologo = document.querySelector('select[name="idPsicologo"]').value;
    
    if (idPaciente) cargarInfoPaciente(idPaciente);
    if (idPsicologo) cargarInfoPsicologo(idPsicologo);
});
</script>