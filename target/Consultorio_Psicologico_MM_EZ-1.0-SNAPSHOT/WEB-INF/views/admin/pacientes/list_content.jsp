<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
                <div class="col-md-6">
                    <label class="form-label">
                        <i class="bi bi-search me-2"></i>Buscar
                    </label>
                    <input type="text" name="buscar" class="form-control" 
                           value="${param.buscar}" placeholder="Nombre, email o teléfono">
                </div>
                <div class="col-md-4">
                    <label class="form-label">
                        <i class="bi bi-toggle-on me-2"></i>Estado
                    </label>
                    <select name="estado" class="form-select">
                        <option value="">Todos</option>
                        <option value="activo" ${param.estado == 'activo' ? 'selected' : ''}>Activo</option>
                        <option value="inactivo" ${param.estado == 'inactivo' ? 'selected' : ''}>Inactivo</option>
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

    <!-- Tabla de pacientes -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="bi bi-table me-2"></i>
                Listado de Pacientes (${pacientes.size()})
            </h5>
            <c:url var="exportExcelUrl" value="/admin/pacientes/export">
                <c:param name="buscar" value="${param.buscar}"/>
                <c:param name="estado" value="${param.estado}"/>
                <c:param name="psicologo" value="${param.psicologo}"/>
                <c:param name="export" value="excel"/>
            </c:url>
            <c:url var="exportPdfUrl" value="/admin/pacientes/export">
                <c:param name="buscar" value="${param.buscar}"/>
                <c:param name="estado" value="${param.estado}"/>
                <c:param name="psicologo" value="${param.psicologo}"/>
                <c:param name="export" value="pdf"/>
            </c:url>
            <div class="btn-group btn-group-sm">
                <a class="btn btn-outline-success" href="${pageContext.request.contextPath}${exportExcelUrl}" target="_blank">
                    <i class="bi bi-file-earmark-excel"></i> Excel
                </a>
                <a class="btn btn-outline-danger" href="${pageContext.request.contextPath}${exportPdfUrl}" target="_blank">
                    <i class="bi bi-file-earmark-pdf"></i> PDF
                </a>
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
                                    <th>Estado</th>
                                    <th>Fecha Nacimiento</th>
                                    <th width="240">Acciones</th>
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
                                            <span class="badge ${paciente.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">
                                                <i class="bi bi-${paciente.estado == 'activo' ? 'check' : 'x'}-circle me-1"></i>
                                                ${paciente.estado}
                                            </span>
                                        </td>
                                        <td>
                                            <small class="text-muted">
                                                <c:if test="${not empty paciente.fechaNacimiento}">
                                                    <fmt:formatDate value="${paciente.fechaNacimiento}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                            </small>
                                        </td>
                                        <td>
                                            <div class="d-flex gap-1 flex-wrap">
                                                <a href="${pageContext.request.contextPath}/admin/pacientes/editar?id=${paciente.id}"
                                                   class="btn btn-sm btn-outline-primary" title="Editar">
                                                    <i class="bi bi-pencil"></i>
                                                </a>

                                                <c:set var="estadoNuevo" value="${paciente.estado == 'activo' ? 'inactivo' : 'activo'}" />
                                                <form method="post" action="${pageContext.request.contextPath}/admin/pacientes/cambiar-estado" class="d-inline">
                                                    <input type="hidden" name="id" value="${paciente.id}" />
                                                    <input type="hidden" name="estado" value="${estadoNuevo}" />
                                                    <button type="submit" class="btn btn-sm btn-outline-warning"
                                                            title="${paciente.estado == 'activo' ? 'Desactivar' : 'Activar'}"
                                                            onclick="return confirm('¿Cambiar estado del paciente a ${estadoNuevo}?');">
                                                        <i class="bi bi-${paciente.estado == 'activo' ? 'pause' : 'play'}-circle"></i>
                                                    </button>
                                                </form>

                                                <div class="btn-group btn-group-sm">
                                                    <button type="button" class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown">
                                                        <i class="bi bi-three-dots-vertical"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/pacientes/ver?id=${paciente.id}">
                                                                <i class="bi bi-eye me-2"></i>Ver Detalle
                                                            </a>
                                                        </li>
                                                        <li>
                                                            <a class="dropdown-item" href="${pageContext.request.contextPath}/admin/citas?paciente=${paciente.id}">
                                                                <i class="bi bi-calendar me-2"></i>Ver Citas
                                                            </a>
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
