<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Contenido del dashboard admin -->
<div class="fade-in-up">
    <!-- Header con breadcrumb -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">Dashboard Administrativo</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><i class="bi bi-house-door me-1"></i>Inicio</li>
                    <li class="breadcrumb-item active">Dashboard</li>
                </ol>
            </nav>
        </div>
        <div class="text-end">
            <small class="text-muted">Última actualización: ${now}</small>
        </div>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-6 col-lg-3">
            <div class="stat-card">
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1">
                        <div class="stat-number">${usuariosActivos}</div>
                        <div class="stat-label">Usuarios Activos</div>
                    </div>
                    <i class="bi bi-people-fill fs-1 text-success opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="stat-card">
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1">
                        <div class="stat-number">${usuariosInactivos}</div>
                        <div class="stat-label">Usuarios Inactivos</div>
                    </div>
                    <i class="bi bi-person-x-fill fs-1 text-danger opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="stat-card">
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1">
                        <div class="stat-number">${citasRealizadas}</div>
                        <div class="stat-label">Citas Realizadas</div>
                    </div>
                    <i class="bi bi-calendar-check-fill fs-1 text-primary opacity-25"></i>
                </div>
            </div>
        </div>
        <div class="col-6 col-lg-3">
            <div class="stat-card">
                <div class="d-flex align-items-center">
                    <div class="flex-grow-1">
                        <div class="stat-number">${citasCanceladas}</div>
                        <div class="stat-label">Citas Canceladas</div>
                    </div>
                    <i class="bi bi-calendar-x-fill fs-1 text-warning opacity-25"></i>
                </div>
            </div>
        </div>
    </div>

    <!-- Accesos rápidos -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0"><i class="bi bi-lightning-charge me-2"></i>Accesos Rápidos</h5>
                </div>
                <div class="card-body">
                    <div class="row g-3">
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/pacientes/nuevo" class="btn btn-outline-primary w-100 py-3">
                                <i class="bi bi-person-plus fs-4 d-block mb-2"></i>
                                <small>Nuevo Paciente</small>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/citas/nueva" class="btn btn-outline-success w-100 py-3">
                                <i class="bi bi-calendar-plus fs-4 d-block mb-2"></i>
                                <small>Nueva Cita</small>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/pagos/nuevo" class="btn btn-outline-warning w-100 py-3">
                                <i class="bi bi-cash-stack fs-4 d-block mb-2"></i>
                                <small>Registrar Pago</small>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/psicologos/nuevo" class="btn btn-outline-info w-100 py-3">
                                <i class="bi bi-person-badge fs-4 d-block mb-2"></i>
                                <small>Nuevo Psicólogo</small>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/reportes" class="btn btn-outline-secondary w-100 py-3">
                                <i class="bi bi-graph-up fs-4 d-block mb-2"></i>
                                <small>Ver Reportes</small>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="${pageContext.request.contextPath}/admin/tickets" class="btn btn-outline-dark w-100 py-3">
                                <i class="bi bi-receipt fs-4 d-block mb-2"></i>
                                <small>Consultar Tickets</small>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Gráficos -->
    <div class="row g-4 mb-4">
        <div class="col-12 col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-bar-chart me-2"></i>Citas por Psicólogo</h6>
                </div>
                <div class="card-body">
                    <canvas id="chartCitas" style="max-height: 300px;"></canvas>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-pie-chart me-2"></i>Estado de Usuarios</h6>
                </div>
                <div class="card-body">
                    <canvas id="chartUsuarios" style="max-height: 300px;"></canvas>
                </div>
            </div>
        </div>
    </div>
    
    <div class="row g-4">
        <div class="col-12 col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-graph-up me-2"></i>Ingresos por Mes</h6>
                </div>
                <div class="card-body">
                    <canvas id="chartIngresos" style="max-height: 300px;"></canvas>
                </div>
            </div>
        </div>
        <div class="col-12 col-lg-6">
            <div class="card h-100">
                <div class="card-header">
                    <h6 class="mb-0"><i class="bi bi-pie-chart-fill me-2"></i>Estado de Citas</h6>
                </div>
                <div class="card-body">
                    <canvas id="chartCitasStatus" style="max-height: 300px;"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Scripts para gráficos -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    initDashboardCharts();
});

async function fetchJson(url) {
    try {
        const response = await fetch(url);
        return await response.json();
    } catch (error) {
        console.error('Error fetching data:', error);
        return {};
    }
}

async function initDashboardCharts() {
    // Configuración común para gráficos
    const commonOptions = {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                position: 'bottom'
            }
        }
    };

    try {
        // Gráfico de citas por psicólogo
        const citasData = await fetchJson('${pageContext.request.contextPath}/admin/chart/citas');
        new Chart(document.getElementById('chartCitas'), {
            type: 'bar',
            data: {
                labels: Object.keys(citasData),
                datasets: [{
                    label: 'Citas',
                    data: Object.values(citasData),
                    backgroundColor: 'rgba(46, 134, 171, 0.8)',
                    borderColor: 'rgba(46, 134, 171, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                ...commonOptions,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });

        // Gráfico de usuarios activos/inactivos
        const usuariosData = await fetchJson('${pageContext.request.contextPath}/admin/chart/usuarios');
        new Chart(document.getElementById('chartUsuarios'), {
            type: 'doughnut',
            data: {
                labels: ['Activos', 'Inactivos'],
                datasets: [{
                    data: usuariosData,
                    backgroundColor: ['#64B570', '#E63946'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: commonOptions
        });

        // Gráfico de ingresos por mes
        const ingresosData = await fetchJson('${pageContext.request.contextPath}/admin/chart/ingresos');
        new Chart(document.getElementById('chartIngresos'), {
            type: 'line',
            data: {
                labels: Object.keys(ingresosData),
                datasets: [{
                    label: '$ Ingresos',
                    data: Object.values(ingresosData),
                    borderColor: '#64B570',
                    backgroundColor: 'rgba(100, 181, 112, 0.1)',
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                ...commonOptions,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '$' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });

        // Gráfico de estado de citas
        const statusData = await fetchJson('${pageContext.request.contextPath}/admin/chart/citas_status');
        new Chart(document.getElementById('chartCitasStatus'), {
            type: 'pie',
            data: {
                labels: ['Realizadas', 'Pendientes', 'Canceladas'],
                datasets: [{
                    data: statusData,
                    backgroundColor: ['#2E86AB', '#F18F01', '#E63946'],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: commonOptions
        });
    } catch (error) {
        console.error('Error initializing charts:', error);
    }
}
</script>