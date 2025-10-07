<!-- Template base con sidebar y navegación -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${param.title != null ? param.title : 'Consultorio Psicológico'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/consultorio.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <style>
      /* Sidebar scroll behavior */
      #sidebar { display: flex; flex-direction: column; height: 100vh; overflow: hidden; }
      #sidebar .sidebar-body { flex: 1 1 auto; min-height: 0; overflow-y: auto; }
    </style>
</head>
<body>
<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="p-3 sidebar-body">
        <div class="d-flex align-items-center mb-4">
            <i class="bi bi-heart-pulse-fill fs-2 me-3"></i>
            <div class="sidebar-text">
                <h5 class="mb-0 text-white">Consultorio</h5>
                <small class="text-white-50">Psicológico</small>
            </div>
        </div>

        <!-- Menú Psicólogo -->
        <nav class="nav flex-column">
            <a class="nav-link ${param.activeMenu == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/dashboard">
                <i class="bi bi-speedometer2 me-2"></i><span class="sidebar-text">Dashboard</span>
            </a>

            <div class="nav-item">
                <span class="nav-link text-white-50 fw-bold small">
                    <i class="bi bi-calendar-check me-2"></i><span class="sidebar-text">AGENDA</span>
                </span>
                <a class="nav-link ms-3 ${param.activeMenu == 'agenda' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/agenda">
                    <i class="bi bi-calendar3 me-2"></i><span class="sidebar-text">Mi Agenda</span>
                </a>
                <a class="nav-link ms-3 ${param.activeMenu == 'pacientes' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/pacientes">
                    <i class="bi bi-person-heart me-2"></i><span class="sidebar-text">Pacientes</span>
                </a>
                <a class="nav-link ms-3 ${param.activeMenu == 'calendario' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/agenda/calendario">
                    <i class="bi bi-calendar3-week me-2"></i><span class="sidebar-text">Calendario</span>
                </a>
            </div>

            <div class="nav-item">
                <span class="nav-link text-white-50 fw-bold small">
                    <i class="bi bi-credit-card me-2"></i><span class="sidebar-text">PAGOS</span>
                </span>
                <a class="nav-link ms-3 ${param.activeMenu == 'pagos' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/pagos">
                    <i class="bi bi-cash-stack me-2"></i><span class="sidebar-text">Mis Pagos</span>
                </a>
            </div>

            <!-- Se elimina la entrada de Evaluaciones en el menú según solicitud -->

            <div class="nav-item">
                <span class="nav-link text-white-50 fw-bold small">
                    <i class="bi bi-graph-up me-2"></i><span class="sidebar-text">REPORTES</span>
                </span>
                <a class="nav-link ms-3 ${param.activeMenu == 'reportes' ? 'active' : ''}" href="${pageContext.request.contextPath}/psico/reportes">
                    <i class="bi bi-file-earmark-bar-graph me-2"></i><span class="sidebar-text">Mis Reportes</span>
                </a>
            </div>
        </nav>
    </div>
    
    <!-- User info y logout -->
    <div class="mt-auto p-3 border-top border-white border-opacity-25">
        <div class="d-flex align-items-center mb-2">
            <i class="bi bi-person-circle fs-4 me-2"></i>
            <div class="sidebar-text">
                <div class="text-white small">${sessionScope.user != null ? sessionScope.user.nombre : ''}</div>
                <div class="text-white-50 small text-capitalize">${sessionScope.user != null ? sessionScope.user.rol : ''}</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-light btn-sm d-grid">
            <i class="bi bi-box-arrow-right me-2"></i><span class="sidebar-text">Salir</span>
        </a>
    </div>
</div>

<!-- Main Content -->
<div class="main-content" id="mainContent">
    <!-- Top bar móvil -->
    <div class="d-flex justify-content-between align-items-center mb-4 d-md-none">
        <button class="btn btn-outline-primary" onclick="toggleSidebar()">
            <i class="bi bi-list"></i>
        </button>
        <h5 class="mb-0">${param.title}</h5>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
            <i class="bi bi-box-arrow-right"></i>
        </a>
    </div>
    
    <!-- Content -->
    <jsp:include page="${param.content}" />
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    const mainContent = document.getElementById('mainContent');
    
    if (window.innerWidth <= 768) {
        sidebar.classList.toggle('show');
    } else {
        sidebar.classList.toggle('collapsed');
        mainContent.classList.toggle('expanded');
    }
}

// Cerrar sidebar en móvil al hacer click fuera
document.addEventListener('click', function(e) {
    if (window.innerWidth <= 768) {
        const sidebar = document.getElementById('sidebar');
        const target = e.target;
        
        if (!sidebar.contains(target) && !target.closest('[onclick="toggleSidebar()"]')) {
            sidebar.classList.remove('show');
        }
    }
});
</script>
</body>
</html>