<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Formulario de usuario -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <i class="bi bi-person${usuario != null ? '-gear' : '-plus'} me-2"></i>
                ${usuario != null ? 'Editar Usuario' : 'Nuevo Usuario'}
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/usuarios">Usuarios</a></li>
                    <li class="breadcrumb-item active">${usuario != null ? 'Editar' : 'Nuevo'}</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Volver
        </a>
    </div>

    <!-- Formulario -->
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="bi bi-person-lines-fill me-2"></i>
                        Datos del Usuario
                    </h5>
                </div>
                <div class="card-body">
                    <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/guardar">
                        <c:if test="${usuario != null}">
                            <input type="hidden" name="id" value="${usuario.id}">
                        </c:if>
                        
                        <div class="row g-3">
                            <!-- Información básica -->
                            <div class="col-12">
                                <h6 class="text-muted mb-3">
                                    <i class="bi bi-info-circle me-2"></i>Información Básica
                                </h6>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-person me-2"></i>Nombre completo *
                                </label>
                                <input type="text" name="nombre" class="form-control" 
                                       value="${usuario.nombre}" required maxlength="100"
                                       placeholder="Ingrese nombre completo">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-envelope me-2"></i>Email *
                                </label>
                                <input type="email" name="email" class="form-control" 
                                       value="${usuario.email}" required maxlength="100"
                                       placeholder="usuario@ejemplo.com">
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-lock me-2"></i>Contraseña *
                                </label>
                                <input type="password" name="password" class="form-control" 
                                       value="${usuario.passwordd}" ${usuario != null ? '' : 'required'} 
                                       minlength="6" placeholder="••••••••">
                                <c:if test="${usuario != null}">
                                    <small class="form-text text-muted">Dejar vacío para mantener la actual</small>
                                </c:if>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-shield-check me-2"></i>Rol *
                                </label>
                                <select name="rol" class="form-select" required onchange="togglePsicologoFields()">
                                    <option value="">Seleccionar rol</option>
                                    <option value="admin" ${usuario.rol == 'admin' ? 'selected' : ''}>Administrador</option>
                                    <option value="psicologo" ${usuario.rol == 'psicologo' ? 'selected' : ''}>Psicólogo</option>
                                </select>
                            </div>
                            
                            <div class="col-md-6">
                                <label class="form-label">
                                    <i class="bi bi-toggle-on me-2"></i>Estado *
                                </label>
                                <select name="estado" class="form-select" required>
                                    <option value="activo" ${usuario.estado == 'activo' ? 'selected' : ''}>Activo</option>
                                    <option value="inactivo" ${usuario.estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
                                </select>
                            </div>
                            
                            <!-- Campos específicos para psicólogo -->
                            <div id="camposPsicologo" style="display: none;">
                                <div class="col-12 mt-4">
                                    <h6 class="text-muted mb-3">
                                        <i class="bi bi-heart-pulse me-2"></i>Información Profesional (Solo para Psicólogos)
                                    </h6>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        <i class="bi bi-mortarboard me-2"></i>Especialidad
                                    </label>
                                    <select name="especialidad" class="form-select">
                                        <option value="">Seleccionar especialidad</option>
                                        <option value="Psicología Clínica" ${psicologo.especialidad == 'Psicología Clínica' ? 'selected' : ''}>Psicología Clínica</option>
                                        <option value="Psicoterapia" ${psicologo.especialidad == 'Psicoterapia' ? 'selected' : ''}>Psicoterapia</option>
                                        <option value="Neuropsicología" ${psicologo.especialidad == 'Neuropsicología' ? 'selected' : ''}>Neuropsicología</option>
                                        <option value="Psicología Infantil" ${psicologo.especialidad == 'Psicología Infantil' ? 'selected' : ''}>Psicología Infantil</option>
                                        <option value="Psicología Organizacional" ${psicologo.especialidad == 'Psicología Organizacional' ? 'selected' : ''}>Psicología Organizacional</option>
                                        <option value="Terapia de Pareja" ${psicologo.especialidad == 'Terapia de Pareja' ? 'selected' : ''}>Terapia de Pareja</option>
                                        <option value="Psicología Educativa" ${psicologo.especialidad == 'Psicología Educativa' ? 'selected' : ''}>Psicología Educativa</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-6">
                                    <label class="form-label">
                                        <i class="bi bi-clock-history me-2"></i>Horario
                                    </label>
                                    <input type="text" name="horario" class="form-control" 
                                           value="${psicologo.horario}" placeholder="Ej: Lun-Vie 09:00-17:00">
                                </div>
                                
                                <div class="col-12">
                                    <label class="form-label">
                                        <i class="bi bi-journal-text me-2"></i>Experiencia
                                    </label>
                                    <textarea name="experiencia" class="form-control" rows="3"
                                              placeholder="Descripción de experiencia profesional">${psicologo.experiencia}</textarea>
                                </div>
                            </div>
                            
                            <!-- Botones -->
                            <div class="col-12 mt-4">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-check-lg me-2"></i>
                                        ${usuario != null ? 'Actualizar' : 'Crear'} Usuario
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/usuarios" class="btn btn-outline-secondary">
                                        <i class="bi bi-x-lg me-2"></i>Cancelar
                                    </a>
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
function togglePsicologoFields() {
    const rol = document.querySelector('[name="rol"]').value;
    const camposPsicologo = document.getElementById('camposPsicologo');
    
    if (rol === 'psicologo') {
        camposPsicologo.style.display = 'block';
        // Hacer requeridos los campos de psicólogo si es nuevo usuario
        const esNuevo = !document.querySelector('[name="id"]');
        if (esNuevo) {
            document.querySelector('[name="especialidad"]').required = true;
        }
    } else {
        camposPsicologo.style.display = 'none';
        document.querySelector('[name="especialidad"]').required = false;
    }
}

// Ejecutar al cargar la página
document.addEventListener('DOMContentLoaded', function() {
    togglePsicologoFields();
});
</script>