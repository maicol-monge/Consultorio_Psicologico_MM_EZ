<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Contenido listado de usuarios -->
<div class="fade-in-up">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1"><i class="bi bi-people me-2"></i>Gestión de Usuarios</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active">Usuarios</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/usuarios/nuevo" class="btn btn-primary">
            <i class="bi bi-person-plus me-2"></i>Nuevo Usuario
        </a>
    </div>

    <!-- Alertas dinámicas (usando atributos de request) -->
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

    <!-- Filtros de búsqueda -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="get" action="${pageContext.request.contextPath}/admin/usuarios" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label"><i class="bi bi-search me-2"></i>Buscar</label>
                    <input type="text" name="q" class="form-control" value="${q}" placeholder="Nombre o email">
                </div>
                <div class="col-md-3">
                    <label class="form-label"><i class="bi bi-shield-check me-2"></i>Rol</label>
                    <select name="rol" class="form-select">
                        <option value="">Todos</option>
                        <option value="admin" ${rol == 'admin' ? 'selected' : ''}>Administrador</option>
                        <option value="psicologo" ${rol == 'psicologo' ? 'selected' : ''}>Psicólogo</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label"><i class="bi bi-toggle-on me-2"></i>Estado</label>
                    <select name="estado" class="form-select">
                        <option value="">Todos</option>
                        <option value="activo" ${estado == 'activo' ? 'selected' : ''}>Activo</option>
                        <option value="inactivo" ${estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
                    </select>
                </div>
                <div class="col-md-2 d-flex align-items-end">
                    <div class="d-grid w-100">
                        <button type="submit" class="btn btn-outline-primary"><i class="bi bi-filter me-2"></i>Filtrar</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Tabla de usuarios -->
    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-table me-2"></i>Lista de Usuarios</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nombre</th>
                            <th>Email</th>
                            <th>Rol</th>
                            <th>Estado</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="usuario" items="${usuarios}">
                            <tr>
                                <td>${usuario.id}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-person-circle me-2 fs-5"></i>
                                        <strong>${usuario.nombre}</strong>
                                    </div>
                                </td>
                                <td>${usuario.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${usuario.rol == 'admin'}">
                                            <span class="badge bg-primary"><i class="bi bi-shield-check me-1"></i>Admin</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-info"><i class="bi bi-person-badge me-1"></i>Psicólogo</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${usuario.estado == 'activo'}">
                                            <span class="badge bg-success status-activo">
                                                <i class="bi bi-check-circle me-1"></i>Activo
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-danger status-inactivo">
                                                <i class="bi bi-x-circle me-1"></i>Inactivo
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm" role="group">
                                        <a href="${pageContext.request.contextPath}/admin/usuarios/editar?id=${usuario.id}" 
                                           class="btn btn-outline-primary" title="Editar">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        
                                        <c:choose>
                                            <c:when test="${usuario.estado == 'activo'}">
                                                <button type="button" class="btn btn-outline-warning" 
                                                        onclick="cambiarEstado(${usuario.id}, 'inactivo')" title="Desactivar">
                                                    <i class="bi bi-pause"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn btn-outline-success" 
                                                        onclick="cambiarEstado(${usuario.id}, 'activo')" title="Activar">
                                                    <i class="bi bi-play"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <button type="button" class="btn btn-outline-secondary" 
                                                onclick="restablecerPassword(${usuario.id}, '${usuario.nombre}')" title="Restablecer contraseña">
                                            <i class="bi bi-key"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty usuarios}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                    No hay usuarios registrados
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal para cambiar estado -->
<div class="modal fade" id="modalCambiarEstado" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Cambiar Estado</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p id="mensajeCambioEstado"></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/cambiar-estado" style="display: inline;">
                    <input type="hidden" id="estadoUsuarioId" name="id">
                    <input type="hidden" id="nuevoEstado" name="estado">
                    <button type="submit" class="btn btn-primary">Confirmar</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Modal para restablecer contraseña -->
<div class="modal fade" id="modalRestablecerPassword" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Restablecer Contraseña</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/admin/usuarios/restablecer-password">
                <div class="modal-body">
                    <p>Restablecer contraseña para: <strong id="nombreUsuarioPassword"></strong></p>
                    <input type="hidden" id="passwordUsuarioId" name="id">
                    <div class="mb-3">
                        <label class="form-label">Nueva contraseña</label>
                        <input type="password" class="form-control" name="nueva-password" required minlength="6">
                        <small class="form-text text-muted">Mínimo 6 caracteres</small>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <button type="submit" class="btn btn-warning">Restablecer</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function cambiarEstado(usuarioId, estado) {
    document.getElementById('estadoUsuarioId').value = usuarioId;
    document.getElementById('nuevoEstado').value = estado;
    
    const accion = estado === 'activo' ? 'activar' : 'desactivar';
    document.getElementById('mensajeCambioEstado').textContent = 
        `¿Está seguro que desea ${accion} este usuario?`;
    
    new bootstrap.Modal(document.getElementById('modalCambiarEstado')).show();
}

function restablecerPassword(usuarioId, nombreUsuario) {
    document.getElementById('passwordUsuarioId').value = usuarioId;
    document.getElementById('nombreUsuarioPassword').textContent = nombreUsuario;
    
    new bootstrap.Modal(document.getElementById('modalRestablecerPassword')).show();
}
</script>