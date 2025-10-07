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
    <div class="col-6 col-lg-3">
      <div class="stat-card">
        <div class="d-flex align-items-center">
          <div class="flex-grow-1">
            <div class="stat-number">${citasRealizadas}</div>
            <div class="stat-label">Citas Realizadas</div>
          </div>
          <i class="bi bi-check2-circle fs-1 text-success opacity-25"></i>
        </div>
      </div>
    </div>
    <div class="col-6 col-lg-3">
      <div class="stat-card">
        <div class="d-flex align-items-center">
          <div class="flex-grow-1">
            <div class="stat-number">${citasPendientes}</div>
            <div class="stat-label">Citas Pendientes</div>
          </div>
          <i class="bi bi-clock-history fs-1 text-warning opacity-25"></i>
        </div>
      </div>
    </div>
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
   const commonOptions = { responsive:true, maintainAspectRatio:false, plugins:{ legend:{ position:'bottom' }}};
   const resMes = await fetch('${pageContext.request.contextPath}/psico/chart/mes');
   const dataMes = await resMes.json();
   new Chart(document.getElementById('chartCitasMes'), {
     type: 'line',
     data: { labels: Object.keys(dataMes), datasets: [{ label: 'Citas', data: Object.values(dataMes), borderColor: '#2E86AB', backgroundColor: 'rgba(46,134,171,0.1)', fill:true, tension:0.4 }] },
     options: { ...commonOptions }
   });
   const resStatus = await fetch('${pageContext.request.contextPath}/psico/chart/status');
   const dataStatus = await resStatus.json();
   new Chart(document.getElementById('chartEstado'), {
     type: 'doughnut',
     data: { labels: ['Realizadas','Pendientes','Canceladas'], datasets: [{ data: dataStatus, backgroundColor: ['#64B570','#F18F01','#E63946'], borderColor:'#fff', borderWidth:2 }]},
     options: { ...commonOptions }
   });
 });
</script>
