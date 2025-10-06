<!-- Formulario de paciente -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-person${paciente != null ? '-gear' : '-plus'} me-2"></i>
                ${paciente != null ? 'Editar Paciente' : 'Nuevo Paciente'}
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/pacientes">Pacientes</a></li>
                    <li class="breadcrumb-item active">${paciente != null ? 'Editar' : 'Nuevo'}</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pacientes" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Volver
        </a>
    </div>

    <!-- Formulario -->
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-person-heart me-2"></i>
                        Datos del Paciente
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/pacientes/guardar">
                        <c:if test="${paciente != null}">
                            <input type="hidden" name="id" value="${paciente.id}">
                        </c:if>
                        
                        <div class="row g-3">
                            <!-- Información básica -->
                            <div class="col-12">
                                <h6 class="text-muted mb-3">
                                    <i class="bi bi-info-circle me-2"></i>Información Personal
                                </h6>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-person me-2"></i>Nombre completo *
                                </label>
                                <input type="text" name="nombre" class="form-control" 
                                       value="${paciente.nombre}" required maxlength="100"
                                       placeholder="Ingrese nombre completo">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-calendar me-2"></i>Edad *
                                </label>
                                <input type="number" name="edad" class="form-control" 
                                       value="${paciente.edad}" required min="1" max="120"
                                       placeholder="Edad en años">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-gender-ambiguous me-2"></i>Género
                                </label>
                                <select name="genero" class="form-select">
                                    <option value="">Seleccionar género</option>
                                    <option value="masculino" ${paciente.genero == 'masculino' ? 'selected' : ''}>Masculino</option>
                                    <option value="femenino" ${paciente.genero == 'femenino' ? 'selected' : ''}>Femenino</option>
                                    <option value="otro" ${paciente.genero == 'otro' ? 'selected' : ''}>Otro</option>
                                    <option value="prefiero_no_decir" ${paciente.genero == 'prefiero_no_decir' ? 'selected' : ''}>Prefiero no decir</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-envelope me-2"></i>Email *
                                </label>
                                <input type="email" name="email" class="form-control" 
                                       value="${paciente.email}" required maxlength="100"
                                       placeholder="paciente@ejemplo.com">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-telephone me-2"></i>Teléfono *
                                </label>
                                <input type="tel" name="telefono" class="form-control" 
                                       value="${paciente.telefono}" required maxlength="20"
                                       placeholder="Número de teléfono">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-geo-alt me-2"></i>Dirección
                                </label>
                                <input type="text" name="direccion" class="form-control" 
                                       value="${paciente.direccion}" maxlength="255"
                                       placeholder="Dirección completa">
                            </div>
                            
                            <!-- Información médica -->
                            <div class="col-12 mt-4">
                                <h6 class="text-muted mb-3">
                                    <i class="bi bi-heart-pulse me-2"></i>Información Médica
                                </h6>
                            </div>
                            
                            <div class="col-12">
                                <label class="form-label">
                                    <i class="bi bi-file-medical me-2"></i>Historial Médico
                                </label>
                                <textarea name="historialMedico" class="form-control" rows="3"
                                          placeholder="Antecedentes médicos relevantes, medicamentos, alergias, etc.">${paciente.historialMedico}</textarea>
                            </div>
                            
                            <!-- Asignación de psicólogo -->
                            <div class="col-12 mt-4">
                                <h6 class="text-muted mb-3">
                                    <i class="bi bi-person-check me-2"></i>Asignación Profesional
                                </h6>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-person-heart me-2"></i>Psicólogo Asignado
                                </label>
                                <select name="idPsicologo" class="form-select">
                                    <option value="">Sin asignar</option>
                                    <c:forEach var="psicologo" items="${psicologos}">
                                        <option value="${psicologo.id}" 
                                                ${paciente.idPsicologo == psicologo.id ? 'selected' : ''}>
                                            ${psicologo.nombre} - ${psicologo.especialidad}
                                        </option>
                                    </c:forEach>
                                </select>
                                <small class="form-text text-muted">
                                    El paciente será asignado a este psicólogo para sus sesiones
                                </small>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-toggle-on me-2"></i>Estado *
                                </label>
                                <select name="estado" class="form-select" required>
                                    <option value="activo" ${paciente.estado == 'activo' ? 'selected' : ''}>Activo</option>
                                    <option value="inactivo" ${paciente.estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
                                </select>
                            </div>
                            
                            <!-- Código de acceso -->
                            <c:if test="${paciente != null}">
                                <div class="col-12 mt-4">
                                    <h6 class="text-muted mb-3">
                                        <i class="bi bi-key me-2"></i>Código de Acceso
                                    </h6>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        <i class="bi bi-qr-code me-2"></i>Código Actual
                                    </label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" value="${paciente.codigoAcceso}" readonly>
                                        <button type="button" class="btn btn-outline-primary" onclick="generarNuevoCodigo()">
                                            <i class="bi bi-arrow-clockwise me-2"></i>Regenerar
                                        </button>
                                    </div>
                                    <small class="form-text text-muted">
                                        Este código permite al paciente acceder a su información
                                    </small>
                                </div>
                            </c:if>
                            
                            <!-- Botones -->
                            <div class="col-12 mt-4">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-lg me-2"></i>
                                        ${paciente != null ? 'Actualizar' : 'Crear'} Paciente
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/pacientes" class="btn btn-outline-secondary">
                                        <i class="bi bi-x-lg me-2"></i>Cancelar
                                    </a>
                                    <c:if test="${paciente != null}">
                                        <a href="${pageContext.request.contextPath}/admin/citas?paciente=${paciente.id}" 
                                           class="btn btn-outline-info ms-auto">
                                            <i class="bi bi-calendar me-2"></i>Ver Citas
                                        </a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function generarNuevoCodigo() {
    if (confirm('¿Está seguro de regenerar el código de acceso? El código anterior dejará de funcionar.')) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin/pacientes/regenerar-codigo';
        
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'id';
        input.value = '${paciente.id}';
        
        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
}
</script>