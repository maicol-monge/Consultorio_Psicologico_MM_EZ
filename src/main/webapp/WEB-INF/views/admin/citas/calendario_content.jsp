<!-- Vista de Calendario -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-calendar-week me-2"></i>
                Calendario de Citas
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/citas">Citas</a></li>
                    <li class="breadcrumb-item active">Calendario</li>
                </ol>
            </nav>
        </div>
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/admin/citas/nueva" class="btn btn-primary">
                <i class="bi bi-calendar-plus me-2"></i>Nueva Cita
            </a>
            <a href="${pageContext.request.contextPath}/admin/citas" class="btn btn-outline-secondary">
                <i class="bi bi-list-ul me-2"></i>Vista Lista
            </a>
        </div>
    </div>

    <!-- Filtros del calendario -->
    <div class="card mb-4">
        <div class="card-body">
            <div class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-person-check me-2"></i>Psicólogo
                    </label>
                    <select id="filtroPsicologo" class="form-select" onchange="filtrarCalendario()">
                        <option value="">Todos los psicólogos</option>
                        <c:forEach var="psicologo" items="${psicologos}">
                            <option value="${psicologo.id}">${psicologo.nombre}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-circle-fill me-2"></i>Estado
                    </label>
                    <select id="filtroEstado" class="form-select" onchange="filtrarCalendario()">
                        <option value="">Todos los estados</option>
                        <option value="pendiente">Pendiente</option>
                        <option value="confirmada">Confirmada</option>
                        <option value="realizada">Realizada</option>
                        <option value="cancelada">Cancelada</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">
                        <i class="bi bi-calendar-range me-2"></i>Vista
                    </label>
                    <select id="vistaCalendario" class="form-select" onchange="cambiarVista()">
                        <option value="month">Mes</option>
                        <option value="week">Semana</option>
                        <option value="day">Día</option>
                    </select>
                </div>
                <div class="col-md-3 d-flex align-items-end">
                    <button type="button" class="btn btn-outline-primary" onclick="irHoy()">
                        <i class="bi bi-calendar-date me-2"></i>Hoy
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Leyenda -->
    <div class="card mb-4">
        <div class="card-body py-2">
            <div class="d-flex flex-wrap align-items-center gap-3">
                <small class="text-muted me-2">Estados:</small>
                <span class="badge bg-warning">
                    <i class="bi bi-clock me-1"></i>Pendiente
                </span>
                <span class="badge bg-info">
                    <i class="bi bi-check-circle me-1"></i>Confirmada
                </span>
                <span class="badge bg-success">
                    <i class="bi bi-check-circle-fill me-1"></i>Realizada
                </span>
                <span class="badge bg-danger">
                    <i class="bi bi-x-circle me-1"></i>Cancelada
                </span>
            </div>
        </div>
    </div>

    <!-- Calendario -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center">
                <button type="button" class="btn btn-outline-secondary btn-sm me-2" onclick="navegarCalendario('prev')">
                    <i class="bi bi-chevron-left"></i>
                </button>
                <button type="button" class="btn btn-outline-secondary btn-sm me-3" onclick="navegarCalendario('next')">
                    <i class="bi bi-chevron-right"></i>
                </button>
                <h5 class="mb-0" id="tituloCalendario">
                    <fmt:formatDate value="${fechaActual}" pattern="MMMM yyyy"/>
                </h5>
            </div>
            <div class="text-muted">
                <small>Total de citas: <span id="totalCitas">${citas.size()}</span></small>
            </div>
        </div>
        <div class="card-body p-0">
            <div id="calendario"></div>
        </div>
    </div>
</div>

<!-- Modal para ver detalles de la cita -->
<div class="modal fade" id="detalleCitaModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-calendar-event text-primary me-2"></i>
                    Detalles de la Cita
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="contenidoDetalleCita">
                    <!-- Contenido cargado dinámicamente -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cerrar</button>
                <button type="button" class="btn btn-primary" id="btnEditarCita" style="display: none;">
                    <i class="bi bi-pencil me-2"></i>Editar
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal para crear cita rápida -->
<div class="modal fade" id="citaRapidaModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="bi bi-calendar-plus text-success me-2"></i>
                    Cita Rápida
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="formCitaRapida">
                    <input type="hidden" id="fechaSeleccionada" name="fecha">
                    <input type="hidden" id="horaSeleccionada" name="hora">
                    
                    <div class="mb-3">
                        <label class="form-label">Fecha y Hora</label>
                        <div class="bg-light p-2 rounded">
                            <span id="fechaHoraDisplay" class="fw-semibold"></span>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Paciente</label>
                        <select name="idPaciente" class="form-select" required>
                            <option value="">Seleccionar paciente...</option>
                            <c:forEach var="paciente" items="${pacientes}">
                                <option value="${paciente.id}">${paciente.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Psicólogo</label>
                        <select name="idPsicologo" class="form-select" required>
                            <option value="">Seleccionar psicólogo...</option>
                            <c:forEach var="psicologo" items="${psicologos}">
                                <option value="${psicologo.id}">${psicologo.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Motivo de Consulta</label>
                        <textarea name="motivoConsulta" class="form-control" rows="2" required 
                                  placeholder="Describe brevemente el motivo..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-success" onclick="guardarCitaRapida()">
                    <i class="bi bi-check-lg me-2"></i>Guardar Cita
                </button>
            </div>
        </div>
    </div>
</div>

<style>
#calendario {
    background: white;
}

.calendario-mes {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 1px;
    background: #dee2e6;
}

.calendario-dia {
    background: white;
    min-height: 120px;
    padding: 8px;
    border: 1px solid #dee2e6;
    position: relative;
    cursor: pointer;
    transition: background-color 0.2s;
}

.calendario-dia:hover {
    background-color: #f8f9fa;
}

.calendario-dia.otro-mes {
    background-color: #f8f9fa;
    color: #6c757d;
}

.calendario-dia.hoy {
    background-color: #e3f2fd;
    border-color: #2196f3;
}

.calendario-dia .numero {
    font-weight: 600;
    font-size: 0.9rem;
    margin-bottom: 4px;
}

.calendario-dia .cita {
    background: #007bff;
    color: white;
    padding: 2px 6px;
    border-radius: 3px;
    font-size: 0.75rem;
    margin-bottom: 2px;
    cursor: pointer;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    transition: transform 0.2s;
}

.calendario-dia .cita:hover {
    transform: scale(1.05);
}

.calendario-dia .cita.pendiente {
    background: #ffc107;
    color: #000;
}

.calendario-dia .cita.confirmada {
    background: #17a2b8;
}

.calendario-dia .cita.realizada {
    background: #28a745;
}

.calendario-dia .cita.cancelada {
    background: #dc3545;
}

.calendario-semana {
    display: grid;
    grid-template-columns: 80px repeat(7, 1fr);
    gap: 1px;
    background: #dee2e6;
}

.calendario-hora {
    background: white;
    padding: 8px;
    border-right: 1px solid #dee2e6;
    font-size: 0.8rem;
    color: #6c757d;
    display: flex;
    align-items: center;
    justify-content: center;
}

.calendario-dia-semana {
    background: white;
    min-height: 60px;
    padding: 4px;
    border: 1px solid #dee2e6;
    position: relative;
}

.calendario-header {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 1px;
    background: #dee2e6;
    margin-bottom: 1px;
}

.calendario-header-dia {
    background: #495057;
    color: white;
    padding: 12px 8px;
    text-align: center;
    font-weight: 600;
}
</style>

<script>
let fechaActual = new Date();
let vistaActual = 'month';
let citasData = [];

// Datos de citas del servidor
<c:set var="citasJson" value="["/>
<c:forEach var="cita" items="${citas}" varStatus="status">
    <c:set var="citasJson" value="${citasJson}{"/>
    <c:set var="citasJson" value='${citasJson}"id": ${cita.id},'/>
    <c:set var="citasJson" value='${citasJson}"fechaHora": "${cita.fechaHora}",'/>
    <c:set var="citasJson" value='${citasJson}"pacienteNombre": "${cita.pacienteNombre}",'/>
    <c:set var="citasJson" value='${citasJson}"psicologoNombre": "${cita.psicologoNombre}",'/>
    <c:set var="citasJson" value='${citasJson}"motivoConsulta": "${cita.motivoConsulta}",'/>
    <c:set var="citasJson" value='${citasJson}"estadoCita": "${cita.estadoCita}",'/>
    <c:set var="citasJson" value='${citasJson}"idPsicologo": ${cita.idPsicologo}'/>
    <c:set var="citasJson" value="${citasJson}}"/>
    <c:if test="${!status.last}">
        <c:set var="citasJson" value="${citasJson},"/>
    </c:if>
</c:forEach>
<c:set var="citasJson" value="${citasJson}]"/>

citasData = ${citasJson};

document.addEventListener('DOMContentLoaded', function() {
    renderizarCalendario();
});

function renderizarCalendario() {
    const container = document.getElementById('calendario');
    
    if (vistaActual === 'month') {
        renderizarMes(container);
    } else if (vistaActual === 'week') {
        renderizarSemana(container);
    } else {
        renderizarDia(container);
    }
    
    actualizarTitulo();
}

function renderizarMes(container) {
    const primer = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 1);
    const ultimo = new Date(fechaActual.getFullYear(), fechaActual.getMonth() + 1, 0);
    const primerDiaSemana = primer.getDay();
    const ultimoDia = ultimo.getDate();
    
    let html = '<div class="calendario-header">';
    const diasSemana = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    diasSemana.forEach(dia => {
        html += `<div class="calendario-header-dia">${dia}</div>`;
    });
    html += '</div>';
    
    html += '<div class="calendario-mes">';
    
    // Días del mes anterior
    const mesAnterior = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), 0);
    for (let i = primerDiaSemana - 1; i >= 0; i--) {
        const dia = mesAnterior.getDate() - i;
        html += `<div class="calendario-dia otro-mes">
            <div class="numero">${dia}</div>
        </div>`;
    }
    
    // Días del mes actual
    for (let dia = 1; dia <= ultimoDia; dia++) {
        const fecha = new Date(fechaActual.getFullYear(), fechaActual.getMonth(), dia);
        const esHoy = esMismaFecha(fecha, new Date());
        const citasDelDia = obtenerCitasDelDia(fecha);
        
        html += `<div class="calendario-dia ${esHoy ? 'hoy' : ''}" onclick="abrirCitaRapida('${formatearFecha(fecha)}')">
            <div class="numero">${dia}</div>`;
            
        citasDelDia.forEach(cita => {
            const hora = new Date(cita.fechaHora).toLocaleTimeString('es-ES', {hour: '2-digit', minute: '2-digit'});
            html += `<div class="cita ${cita.estadoCita}" onclick="event.stopPropagation(); verDetalleCita(${cita.id})" 
                         title="${hora} - ${cita.pacienteNombre}">
                ${hora} ${cita.pacienteNombre}
            </div>`;
        });
        
        html += '</div>';
    }
    
    // Días del siguiente mes
    const diasRestantes = 42 - (primerDiaSemana + ultimoDia);
    for (let dia = 1; dia <= diasRestantes; dia++) {
        html += `<div class="calendario-dia otro-mes">
            <div class="numero">${dia}</div>
        </div>`;
    }
    
    html += '</div>';
    container.innerHTML = html;
}

function renderizarSemana(container) {
    // Implementación simplificada de vista semanal
    container.innerHTML = `
        <div class="text-center py-5">
            <i class="bi bi-calendar-week display-1 text-muted"></i>
            <h5 class="mt-3">Vista Semanal</h5>
            <p class="text-muted">Funcionalidad en desarrollo</p>
        </div>
    `;
}

function renderizarDia(container) {
    // Implementación simplificada de vista diaria
    container.innerHTML = `
        <div class="text-center py-5">
            <i class="bi bi-calendar-day display-1 text-muted"></i>
            <h5 class="mt-3">Vista Diaria</h5>
            <p class="text-muted">Funcionalidad en desarrollo</p>
        </div>
    `;
}

function obtenerCitasDelDia(fecha) {
    return citasData.filter(cita => {
        const fechaCita = new Date(cita.fechaHora);
        return esMismaFecha(fecha, fechaCita);
    });
}

function esMismaFecha(fecha1, fecha2) {
    return fecha1.getDate() === fecha2.getDate() &&
           fecha1.getMonth() === fecha2.getMonth() &&
           fecha1.getFullYear() === fecha2.getFullYear();
}

function formatearFecha(fecha) {
    return fecha.toISOString().split('T')[0];
}

function actualizarTitulo() {
    const titulo = document.getElementById('tituloCalendario');
    const opciones = { year: 'numeric', month: 'long' };
    titulo.textContent = fechaActual.toLocaleDateString('es-ES', opciones);
}

function navegarCalendario(direccion) {
    if (direccion === 'prev') {
        fechaActual.setMonth(fechaActual.getMonth() - 1);
    } else {
        fechaActual.setMonth(fechaActual.getMonth() + 1);
    }
    renderizarCalendario();
}

function cambiarVista() {
    vistaActual = document.getElementById('vistaCalendario').value;
    renderizarCalendario();
}

function irHoy() {
    fechaActual = new Date();
    renderizarCalendario();
}

function filtrarCalendario() {
    const filtroPsicologo = document.getElementById('filtroPsicologo').value;
    const filtroEstado = document.getElementById('filtroEstado').value;
    
    // Aplicar filtros a citasData
    // Esta funcionalidad se completaría con lógica de filtrado
    renderizarCalendario();
}

function abrirCitaRapida(fecha) {
    document.getElementById('fechaSeleccionada').value = fecha;
    document.getElementById('fechaHoraDisplay').textContent = new Date(fecha).toLocaleDateString('es-ES');
    new bootstrap.Modal(document.getElementById('citaRapidaModal')).show();
}

function verDetalleCita(idCita) {
    const cita = citasData.find(c => c.id === idCita);
    if (!cita) return;
    
    const contenido = document.getElementById('contenidoDetalleCita');
    const fecha = new Date(cita.fechaHora);
    
    contenido.innerHTML = `
        <div class="row">
            <div class="col-md-6">
                <h6><i class="bi bi-calendar-date me-2"></i>Fecha y Hora</h6>
                <p>${fecha.toLocaleDateString('es-ES')} a las ${fecha.toLocaleTimeString('es-ES', {hour: '2-digit', minute: '2-digit'})}</p>
                
                <h6><i class="bi bi-person-heart me-2"></i>Paciente</h6>
                <p>${cita.pacienteNombre}</p>
                
                <h6><i class="bi bi-person-check me-2"></i>Psicólogo</h6>
                <p>${cita.psicologoNombre}</p>
            </div>
            <div class="col-md-6">
                <h6><i class="bi bi-circle-fill me-2"></i>Estado</h6>
                <p><span class="badge bg-${obtenerColorEstado(cita.estadoCita)}">${cita.estadoCita}</span></p>
                
                <h6><i class="bi bi-chat-left-text me-2"></i>Motivo de Consulta</h6>
                <p>${cita.motivoConsulta}</p>
            </div>
        </div>
    `;
    
    const btnEditar = document.getElementById('btnEditarCita');
    if (cita.estadoCita !== 'realizada' && cita.estadoCita !== 'cancelada') {
        btnEditar.style.display = 'inline-block';
        btnEditar.onclick = () => {
            window.location.href = '${pageContext.request.contextPath}/admin/citas/editar/' + idCita;
        };
    } else {
        btnEditar.style.display = 'none';
    }
    
    new bootstrap.Modal(document.getElementById('detalleCitaModal')).show();
}

function obtenerColorEstado(estado) {
    switch(estado) {
        case 'pendiente': return 'warning';
        case 'confirmada': return 'info';
        case 'realizada': return 'success';
        case 'cancelada': return 'danger';
        default: return 'secondary';
    }
}

function guardarCitaRapida() {
    const form = document.getElementById('formCitaRapida');
    const formData = new FormData(form);
    
    if (!formData.get('idPaciente') || !formData.get('idPsicologo') || !formData.get('motivoConsulta')) {
        alert('Por favor completa todos los campos obligatorios');
        return;
    }
    
    // Crear form para envío
    const submitForm = document.createElement('form');
    submitForm.method = 'POST';
    submitForm.action = '${pageContext.request.contextPath}/admin/citas/nueva';
    
    for (let [key, value] of formData.entries()) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = key;
        input.value = value;
        submitForm.appendChild(input);
    }
    
    // Agregar hora por defecto
    const inputHora = document.createElement('input');
    inputHora.type = 'hidden';
    inputHora.name = 'hora';
    inputHora.value = '09:00';
    submitForm.appendChild(inputHora);
    
    document.body.appendChild(submitForm);
    submitForm.submit();
}
</script>