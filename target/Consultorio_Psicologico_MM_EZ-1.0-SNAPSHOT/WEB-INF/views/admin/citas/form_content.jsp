<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

    <c:set var="accionCita" value="${cita != null ? 'editar' : 'nueva'}"/>
    <form method="post" action="${pageContext.request.contextPath}/admin/citas/${accionCita}" 
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
                                    <fmt:formatDate value="${paciente.fechaNacimiento}" pattern="yyyy-MM-dd" var="fnac"/>
                                    <option value="${paciente.id}"
                                            ${ (cita != null && cita.idPaciente == paciente.id) || (cita == null && param.paciente == paciente.id) ? 'selected' : '' }
                                            data-telefono="${paciente.telefono}"
                                            data-email="${paciente.email}"
                                            data-nacimiento="${fnac}">
                                        ${paciente.nombre}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor selecciona un paciente
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
                                            data-email="${psicologo.email}">
                                        ${psicologo.nombre}
                                    </option>
                                </c:forEach>
                            </select>
                            <div class="invalid-feedback">
                                Por favor selecciona un psicólogo
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
                <!-- Preformateo de fechas para evitar tags dentro de atributos (null-safe) -->
                <c:set var="fechaValor" value=""/>
                <c:if test="${not empty cita}">
                    <fmt:formatDate value='${cita.fechaHora}' pattern='yyyy-MM-dd' var='fechaValor' />
                </c:if>
                <fmt:formatDate value='${fechaMinima}' pattern='yyyy-MM-dd' var='fechaMin' />
                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="bi bi-calendar-date me-2"></i>Fecha *
                            </label>
                <input type="date" name="fecha" class="form-control" required
                    value="${fechaValor}"
                    min="${fechaMin}"
                    onchange="onFechaOrPsicoChange()">
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
                            <select name="hora" id="selectHora" class="form-select" required>
                                <option value="">Seleccionar hora...</option>
                                <c:forEach var="h" items="${horasDisponibles}">
                                    <option value="${h}">${h}</option>
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
                                <i class="bi bi-circle-fill me-2"></i>Estado
                            </label>
                            <select name="estadoCita" class="form-select">
                                <option value="pendiente" ${cita == null || cita.estadoCita == 'pendiente' ? 'selected' : ''}>Pendiente</option>
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
                        <i class="bi bi-chat-left-text me-2"></i>Motivo de Consulta 
                    </label>
                    <textarea name="motivoConsulta" class="form-control" rows="3"
                              placeholder="Describe el motivo de la consulta (opcional)...">${cita != null ? cita.motivoConsulta : ''}</textarea>
                    <div class="form-text">Opcional</div>
                </div>

                <div class="mb-3">
                    <label class="form-label">
                        <i class="bi bi-journal-text me-2"></i>Observaciones
                    </label>
                    <textarea name="observaciones" class="form-control" rows="2" 
                              placeholder="Observaciones adicionales (opcional)...">${cita != null ? cita.observaciones : ''}</textarea>
                    <div class="form-text">Campo opcional (no se persiste si la columna no existe en BD)</div>
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

        // Si hay un paciente preseleccionado (por query param o en edición), cargar su info
        try {
            var selPac = document.querySelector('select[name="idPaciente"]');
            if (selPac && selPac.value) {
                cargarInfoPaciente(selPac.value);
            }
        } catch (e) { /* noop */ }
    }, false);
})();

// Context path seguro para construir URLs sin conflicto con template literals
const ctx = '<c:out value="${pageContext.request.contextPath}"/>';

function cargarInfoPaciente(idPaciente) {
    const select = document.querySelector('select[name="idPaciente"]');
    let selectedOption = select.querySelector(`option[value="${idPaciente}"]`);
    if (!selectedOption) selectedOption = select.selectedOptions && select.selectedOptions[0] ? select.selectedOptions[0] : null;
    const infoDiv = document.getElementById('infoPaciente');
    
    if (selectedOption && idPaciente) {
        document.getElementById('telefonoPaciente').textContent = selectedOption.dataset.telefono || '-';
        document.getElementById('emailPaciente').textContent = selectedOption.dataset.email || '-';
        const nac = selectedOption.dataset.nacimiento;
        if (nac) {
            const hoy = new Date();
            const dn = new Date(nac);
            let edad = hoy.getFullYear() - dn.getFullYear();
            const m = hoy.getMonth() - dn.getMonth();
            if (m < 0 || (m === 0 && hoy.getDate() < dn.getDate())) edad--;
            document.getElementById('edadPaciente').textContent = edad + ' años';
        } else {
            document.getElementById('edadPaciente').textContent = '-';
        }
        infoDiv.style.display = 'block';
    } else {
        infoDiv.style.display = 'none';
    }
}

function cargarInfoPsicologo(idPsicologo) {
    const select = document.querySelector('select[name="idPsicologo"]');
    let selectedOption = select.querySelector(`option[value="${idPsicologo}"]`);
    if (!selectedOption) selectedOption = select.selectedOptions && select.selectedOptions[0] ? select.selectedOptions[0] : null;
    const infoDiv = document.getElementById('infoPsicologo');
    
    if (selectedOption && idPsicologo) {
        document.getElementById('especialidadPsicologo').textContent = selectedOption.dataset.especialidad || '-';
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
    // Cargar disponibilidad real (evitar evaluar EL de JSP dentro de template literals)
    fetch(ctx + '/admin/citas/horas?psicologo=' + encodeURIComponent(idPsicologo) + '&fecha=' + encodeURIComponent(fecha), { headers: { 'Accept': 'application/json' }})
        .then(r => r.ok ? r.json() : { disponibles: [], ocupadas: [] })
        .then(data => {
            const content = document.getElementById('disponibilidadContent');
            const isArr = Array.isArray(data);
            const disp = isArr ? data : (data.disponibles || []);
            const occ = isArr ? [] : (data.ocupadas || []);
            const items = xs => (xs && xs.length)
                ? xs.map(function(h){ return '<div class="list-group-item">' + h + '</div>'; }).join('')
                : '<div class="text-muted small">Sin registros</div>';
            content.innerHTML =
                '<div class="row">'
                + '  <div class="col-md-6">'
                + '    <h6 class="text-success"><i class="bi bi-check-circle me-2"></i>Horarios Disponibles</h6>'
                + '    <div class="list-group">' + items(disp) + '</div>'
                + '  </div>'
                + '  <div class="col-md-6">'
                + '    <h6 class="text-danger"><i class="bi bi-x-circle me-2"></i>Horarios Ocupados</h6>'
                + '    <div class="list-group">' + items(occ) + '</div>'
                + '  </div>'
                + '</div>';
        })
        .catch(() => {
            document.getElementById('disponibilidadContent').innerHTML = '<div class="text-danger">No se pudo cargar la disponibilidad</div>';
        });
}

function confirmarEliminacion() {
    if (confirm('¿Estás seguro de que deseas eliminar esta cita? Esta acción no se puede deshacer.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/citas/eliminar';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        const idHidden = document.querySelector('input[name="id"]');
        input.value = idHidden ? idHidden.value : '';
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}

// Cargar información inicial si estamos editando
document.addEventListener('DOMContentLoaded', function() {
    const idPaciente = document.querySelector('select[name="idPaciente"]').value;
    const idPsicologo = document.querySelector('select[name="idPsicologo"]').value;
    const fecha = document.querySelector('input[name="fecha"]').value;
    
    if (idPaciente) cargarInfoPaciente(idPaciente);
    if (idPsicologo) cargarInfoPsicologo(idPsicologo);
    // Si hay psicólogo y fecha preseleccionados (modo edición), cargar horas
    if (idPsicologo && fecha) onFechaOrPsicoChange();
});
</script>
<script>
function onFechaOrPsicoChange(){
    const idPs = document.querySelector('select[name="idPsicologo"]').value;
    const fecha = document.querySelector('input[name="fecha"]').value;
    const selectHora = document.getElementById('selectHora');
    if (!idPs || !fecha) return;
    // limpiar
    const prev = selectHora.value;
    selectHora.innerHTML = '<option value="">Cargando...</option>';
    fetch(ctx + '/admin/citas/horas?psicologo=' + encodeURIComponent(idPs) + '&fecha=' + encodeURIComponent(fecha), { headers: { 'Accept': 'application/json' }})
        .then(r => r.ok ? r.json() : { disponibles: [] })
        .then(data => {
            selectHora.innerHTML = '<option value="">Seleccionar hora...</option>';
            const horas = Array.isArray(data) ? data : (data.disponibles || []);
            if (Array.isArray(horas)) {
                horas.forEach(h => {
                    const opt = document.createElement('option');
                    opt.value = h; opt.textContent = h;
                    selectHora.appendChild(opt);
                });
                // Restaurar selección previa si aún está disponible
                if (prev && horas.includes(prev)) {
                    selectHora.value = prev;
                }
            }
            if (!horas || horas.length === 0) {
                const opt = document.createElement('option');
                opt.value = '';
                opt.textContent = 'Sin horarios disponibles';
                opt.disabled = true;
                selectHora.appendChild(opt);
            }
        })
        .catch(() => {
            selectHora.innerHTML = '<option value="">Sin horarios disponibles</option>';
        });
}
// También cuando cambia el psicólogo
const psSel = document.querySelector('select[name="idPsicologo"]');
if (psSel) psSel.addEventListener('change', onFechaOrPsicoChange);
// Cuando cambia el paciente, actualizar panel de información
const pacienteSel = document.querySelector('select[name="idPaciente"]');
if (pacienteSel) pacienteSel.addEventListener('change', function(){
    cargarInfoPaciente(this.value);
});
</script>