<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-speedometer2 me-2"></i>Dashboard Psicólogo</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/dashboard">Inicio</a></li>
          <li class="breadcrumb-item active">Dashboard</li>
        </ol>
      </nav>
    </div>
  </div>

  <div class="row g-4 mb-4">
    <div class="col-6 col-lg-4">
      <div class="stat-card">
        <div class="d-flex align-items-center">
          <div class="flex-grow-1">
            <div id="stat-realizadas" class="stat-number">${citasRealizadas}</div>
            <div class="stat-label">Citas Realizadas</div>
          </div>
          <i class="bi bi-check2-circle fs-1 text-success opacity-25"></i>
        </div>
      </div>
    </div>
    <div class="col-6 col-lg-4">
      <div class="stat-card">
        <div class="d-flex align-items-center">
          <div class="flex-grow-1">
            <div id="stat-pendientes" class="stat-number">${citasPendientes}</div>
            <div class="stat-label">Citas Pendientes</div>
          </div>
          <i class="bi bi-clock-history fs-1 text-warning opacity-25"></i>
        </div>
      </div>
    </div>
    <div class="col-12 col-lg-4">
      <div class="stat-card">
        <div class="d-flex align-items-center">
          <div class="flex-grow-1">
            <div id="stat-canceladas" class="stat-number">0</div>
            <div class="stat-label">Citas Canceladas</div>
          </div>
          <i class="bi bi-x-circle fs-1 text-danger opacity-25"></i>
        </div>
      </div>
    </div>
  </div>

  <div class="mb-4 d-flex gap-2 flex-wrap">
    <a href="${pageContext.request.contextPath}/psico/agenda" class="btn btn-outline-primary">
      <i class="bi bi-calendar-week me-2"></i>Ver Agenda
    </a>
    <a href="${pageContext.request.contextPath}/psico/agenda/nueva" class="btn btn-primary">
      <i class="bi bi-plus-circle me-2"></i>Nueva Cita
    </a>
  </div>

  <div class="row g-4 mb-4">
    <div class="col-12 col-lg-6">
      <div class="card h-100">
        <div class="card-header"><i class="bi bi-graph-up-arrow me-2"></i>Citas por Mes</div>
        <div class="card-body">
          <canvas id="chartCitasMes" style="max-height: 300px;"></canvas>
        </div>
      </div>
    </div>
    <div class="col-12 col-lg-6">
      <div class="card h-100">
        <div class="card-header"><i class="bi bi-pie-chart me-2"></i>Estado de Citas</div>
        <div class="card-body">
          <canvas id="chartEstado" style="max-height: 300px;"></canvas>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
 document.addEventListener('DOMContentLoaded', async function() {
   const commonOptions = {
     responsive: true,
     maintainAspectRatio: false,
     interaction: { mode: 'index', intersect: false },
     plugins: {
       legend: { position: 'bottom' },
       tooltip: { callbacks: { label: (ctx) => `${ctx.dataset.label || ''} ${ctx.raw}`.trim() } }
     },
     scales: { x: { grid: { display: false } }, y: { beginAtZero: true } }
   };

   // Citas por Mes
   try {
     const resMes = await fetch('${pageContext.request.contextPath}/psico/chart/mes');
     if (!resMes.ok) throw new Error('No se pudo obtener datos de Citas por Mes');
     const dataMes = await resMes.json();
     new Chart(document.getElementById('chartCitasMes'), {
       type: 'line',
       data: {
         labels: Object.keys(dataMes),
         datasets: [{
           label: 'Citas',
           data: Object.values(dataMes),
           borderColor: '#2E86AB',
           backgroundColor: 'rgba(46,134,171,0.12)',
           fill: true,
           tension: 0.35,
           pointRadius: 3,
           pointHoverRadius: 5
         }]
       },
       options: { ...commonOptions }
     });
   } catch (err) {
     console.warn(err);
   }

   // Estado de Citas + actualizar KPIs
   try {
     const resStatus = await fetch('${pageContext.request.contextPath}/psico/chart/status');
     if (!resStatus.ok) throw new Error('No se pudo obtener datos de Estado de Citas');
     const dataStatus = await resStatus.json(); // [realizadas, pendientes, canceladas]

     // Actualizar tarjetas si existen
     const elReal = document.getElementById('stat-realizadas');
     const elPend = document.getElementById('stat-pendientes');
     const elCanc = document.getElementById('stat-canceladas');
     if (Array.isArray(dataStatus)) {
       if (elReal && typeof dataStatus[0] !== 'undefined') elReal.textContent = dataStatus[0];
       if (elPend && typeof dataStatus[1] !== 'undefined') elPend.textContent = dataStatus[1];
       if (elCanc && typeof dataStatus[2] !== 'undefined') elCanc.textContent = dataStatus[2];
     }

     new Chart(document.getElementById('chartEstado'), {
       type: 'doughnut',
       data: {
         labels: ['Realizadas','Pendientes','Canceladas'],
         datasets: [{
           data: dataStatus,
           backgroundColor: ['#64B570','#F18F01','#E63946'],
           borderColor: '#fff',
           borderWidth: 2
         }]
       },
       options: { ...commonOptions }
     });
   } catch (err) {
     console.warn(err);
   }
 });
</script>
