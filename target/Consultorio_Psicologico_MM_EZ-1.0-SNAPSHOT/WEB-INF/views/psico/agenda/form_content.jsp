<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-calendar-plus me-2"></i>Nueva Cita</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/psico/agenda">Agenda</a></li>
          <li class="breadcrumb-item active">Nueva</li>
        </ol>
      </nav>
    </div>
  </div>

  <div class="card">
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/psico/agenda/crear" class="row g-3 needs-validation" novalidate>
        <div class="col-md-6">
          <label class="form-label">Paciente</label>
          <div class="input-group">
            <span class="input-group-text"><i class="bi bi-person-heart"></i></span>
            <select name="idPaciente" class="form-select" required>
              <option value="">Seleccionar...</option>
              <c:forEach var="p" items="${pacientes}">
                <option value="${p.id}" data-telefono="${p.telefono}" data-email="${p.email}" data-nacimiento="${p.fechaNacimiento}">${p.nombre}</option>
              </c:forEach>
            </select>
          </div>
          <div class="mt-2">
            <input type="text" id="buscarPacientePsico" class="form-control form-control-sm" placeholder="Buscar paciente... (nombre o email)" />
          </div>
          <div id="infoPaciente" class="form-text mt-1" style="display:none;">
            <span class="me-3"><i class="bi bi-telephone"></i> <span id="telefonoPaciente">-</span></span>
            <span class="me-3"><i class="bi bi-envelope"></i> <span id="emailPaciente">-</span></span>
            <span class="me-3"><i class="bi bi-cake"></i> <span id="edadPaciente">-</span></span>
          </div>
        </div>
        <div class="col-md-3">
          <label class="form-label">Fecha</label>
          <input type="date" name="fecha" class="form-control" required />
        </div>
        <div class="col-md-3">
          <label class="form-label">Hora</label>
          <select id="selectHora" name="hora" class="form-select" required>
            <option value="">Seleccionar...</option>
          </select>
        </div>
        <div class="col-12">
          <label class="form-label">Motivo de consulta</label>
          <textarea name="motivoConsulta" class="form-control" rows="2" placeholder="Opcional..."></textarea>
        </div>
        <div class="col-12 d-flex gap-2">
          <button class="btn btn-primary" type="submit">Crear</button>
          <a href="${pageContext.request.contextPath}/psico/agenda" class="btn btn-outline-secondary">Cancelar</a>
        </div>
      </form>
    </div>
  </div>

  <script>
  (function(){
    const ctx='${pageContext.request.contextPath}';
    const selPaciente=document.querySelector('select[name="idPaciente"]');
    const inpBuscar=document.getElementById('buscarPacientePsico');
    const inpFecha=document.querySelector('input[name="fecha"]');
    const selHora=document.getElementById('selectHora');
    function cargarInfoPaciente(){
      const opt = selPaciente.selectedOptions[0];
      const infoDiv = document.getElementById('infoPaciente');
      if (!opt || !opt.value){ infoDiv.style.display='none'; return; }
      document.getElementById('telefonoPaciente').textContent = opt.dataset.telefono||'-';
      document.getElementById('emailPaciente').textContent = opt.dataset.email||'-';
      const nac = opt.dataset.nacimiento;
      if (nac){
        try{
          const d = new Date(nac);
          const edad = Math.floor((Date.now()-d.getTime())/31557600000);
          document.getElementById('edadPaciente').textContent = edad+' años';
        } catch(e){ document.getElementById('edadPaciente').textContent='-'; }
      } else { document.getElementById('edadPaciente').textContent='-'; }
      infoDiv.style.display='block';
    }
    if (inpBuscar){
      inpBuscar.addEventListener('input', function(){
        const q=(this.value||'').toLowerCase();
        Array.from(selPaciente.options).forEach(function(o){
          if (!o.value) return;
          const hay=(o.textContent||'').toLowerCase().includes(q) || (o.getAttribute('data-email')||'').toLowerCase().includes(q);
          o.hidden = !hay;
        });
      });
    }
    function cargarHoras(){
      selHora.innerHTML = '<option value="">Cargando...</option>';
      const f = inpFecha.value;
      if (!f){ selHora.innerHTML='<option value="">Seleccionar...</option>'; return; }
      // Endpoint admin reutilizable: calcular por psicólogo actual via servidor PSICO horas? Creamos un endpoint por ahora en agenda servlet
      fetch(ctx + '/psico/agenda/horas?fecha='+encodeURIComponent(f))
        .then(r=>r.ok?r.json():[])
        .then(data=>{
          selHora.innerHTML='';
          const list = Array.isArray(data)?data:(data.disponibles||[]);
          if (!list.length){ selHora.innerHTML='<option value="">Sin horarios</option>'; return; }
          selHora.appendChild(new Option('Seleccionar...',''));
          list.forEach(h=> selHora.appendChild(new Option(h,h)) );
        }).catch(()=> selHora.innerHTML='<option value="">Error</option>');
    }
    if (selPaciente){ selPaciente.addEventListener('change', cargarInfoPaciente); }
    if (inpFecha){ inpFecha.addEventListener('change', cargarHoras); }
  })();
  </script>
</div>
