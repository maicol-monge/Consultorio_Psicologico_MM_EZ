<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1">
        <i class="bi bi-person-badge me-2"></i>
        Horarios de Psicólogos
      </h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Psicólogos</li>
        </ol>
      </nav>
    </div>
  </div>

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

  <div class="card mb-3">
    <div class="card-body">
      <form method="get" action="${pageContext.request.contextPath}/admin/psicologos" class="row g-3 align-items-end">
        <div class="col-md-3">
          <label class="form-label">
            <i class="bi bi-search me-2"></i>Buscar psicólogo
          </label>
          <input type="text" id="buscarPsicologo" class="form-control" placeholder="Nombre o correo" autocomplete="off">
        </div>
        <div class="col-md-3">
          <label class="form-label">
            <i class="bi bi-mortarboard me-2"></i>Especialidad
          </label>
          <select id="filtroEspecialidad" class="form-select">
            <option value="">Todas</option>
          </select>
        </div>
        <div class="col-md">
          <label class="form-label">
            <i class="bi bi-person-check me-2"></i>Seleccionar Psicólogo
          </label>
          <small class="text-muted">Escribe y/o filtra para encontrar rápidamente</small>
          <select name="psicologo" id="selectPsicologo" class="form-select" onchange="this.form.submit()">
            <option value="">-- Seleccionar --</option>
            <c:forEach var="p" items="${psicologos}">
              <option value="${p.id}" data-especialidad="${p.especialidad}" ${param.psicologo == p.id ? 'selected' : (idPsicologo == p.id ? 'selected' : '')}>${empty p.nombre ? (empty p.email ? ('ID '+p.id) : p.email) : p.nombre} (${p.especialidad})</option>
            </c:forEach>
          </select>
        </div>
      </form>
    </div>
  </div>

  <c:if test="${not empty idPsicologo}">
    <div class="row">
      <div class="col-lg-5">
        <div class="card">
          <div class="card-header"><i class="bi bi-plus-circle me-2"></i>Agregar / Editar Horario</div>
          <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/admin/psicologos">
              <input type="hidden" name="action" value="guardar"/>
              <input type="hidden" name="id_psicologo" value="${idPsicologo}"/>
              <input type="hidden" name="id" value="${horario != null ? horario.id : ''}"/>
              <div class="mb-3">
                <label class="form-label">Día de la semana</label>
                <select name="dia_semana" class="form-select" required>
                  <c:set var="dias" value="lunes,martes,miércoles,jueves,viernes,sábado,domingo"/>
                  <c:forTokens var="d" items="${dias}" delims="," >
                    <option value="${d}" ${horario != null && horario.diaSemana == d ? 'selected' : ''}>${d}</option>
                  </c:forTokens>
                </select>
              </div>
              <div class="row g-2">
                <div class="col">
                  <label class="form-label">Hora inicio</label>
                  <input type="time" name="hora_inicio" class="form-control" required />
                </div>
                <div class="col">
                  <label class="form-label">Hora fin</label>
                  <input type="time" name="hora_fin" class="form-control" required />
                </div>
              </div>
              <div class="mt-3">
                <label class="form-label">Estado</label>
                <select name="estado" class="form-select">
                  <option value="activo">Activo</option>
                  <option value="inactivo">Inactivo</option>
                </select>
              </div>
              <div class="mt-3 d-flex gap-2">
                <button class="btn btn-primary" type="submit"><i class="bi bi-check-lg me-2"></i>Guardar</button>
              </div>
            </form>
          </div>
        </div>
      </div>
      <div class="col-lg-7">
        <div class="card">
          <div class="card-header"><i class="bi bi-table me-2"></i>Horarios del psicólogo</div>
          <div class="card-body p-0">
            <c:choose>
              <c:when test="${empty horarios}">
                <div class="text-center py-4 text-muted">No hay horarios registrados</div>
              </c:when>
              <c:otherwise>
                <div class="table-responsive">
                  <table class="table table-hover mb-0">
                    <thead class="table-light">
                      <tr>
                        <th>Día</th>
                        <th>Inicio</th>
                        <th>Fin</th>
                        <th>Estado</th>
                        <th class="text-end">Acciones</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="h" items="${horarios}">
                        <tr>
                          <td>${h.diaSemana}</td>
                          <td>${h.horaInicio}</td>
                          <td>${h.horaFin}</td>
                          <td>
                            <span class="badge ${h.estado == 'activo' ? 'bg-success' : 'bg-secondary'}">${h.estado}</span>
                          </td>
                          <td class="text-end">
                            <form method="post" action="${pageContext.request.contextPath}/admin/psicologos" class="d-inline">
                              <input type="hidden" name="action" value="cambiar-estado"/>
                              <input type="hidden" name="id_psicologo" value="${idPsicologo}"/>
                              <input type="hidden" name="id" value="${h.id}"/>
                              <input type="hidden" name="estado" value="${h.estado == 'activo' ? 'inactivo' : 'activo'}"/>
                              <button class="btn btn-sm btn-outline-warning" type="submit" title="${h.estado == 'activo' ? 'Desactivar' : 'Activar'}">
                                <i class="bi bi-${h.estado == 'activo' ? 'pause' : 'play'}-circle"></i>
                              </button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/admin/psicologos" class="d-inline" onsubmit="return confirm('¿Eliminar horario?');">
                              <input type="hidden" name="action" value="eliminar"/>
                              <input type="hidden" name="id_psicologo" value="${idPsicologo}"/>
                              <input type="hidden" name="id" value="${h.id}"/>
                              <button class="btn btn-sm btn-outline-danger" type="submit" title="Eliminar">
                                <i class="bi bi-trash"></i>
                              </button>
                            </form>
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
    </div>
  </c:if>
</div>

<script>
  (function() {
    const sel = document.getElementById('selectPsicologo');
    if (!sel) return;
    const input = document.getElementById('buscarPsicologo');
    const filtroEsp = document.getElementById('filtroEspecialidad');

    // Cachear opciones originales
    const allOptions = Array.from(sel.options)
      .filter(o => o.value !== '')
      .map(o => ({
        value: o.value,
        text: o.text,
        esp: (o.getAttribute('data-especialidad') || '').toLowerCase()
      }));

    // Poblar especialidades únicas
    const especialidades = Array.from(new Set(allOptions.map(o => o.esp).filter(Boolean))).sort();
    especialidades.forEach(esp => {
      const opt = document.createElement('option');
      opt.value = esp;
      opt.textContent = esp.charAt(0).toUpperCase() + esp.slice(1);
      filtroEsp.appendChild(opt);
    });

    function applyFilter() {
      const q = (input.value || '').toLowerCase().trim();
      const esp = (filtroEsp.value || '').toLowerCase();
      const selectedVal = sel.value;

      // Limpiar y reconstruir manteniendo el placeholder
      const placeholder = sel.options[0];
      sel.innerHTML = '';
      sel.appendChild(placeholder);

      const filtered = allOptions.filter(o => {
        const matchQ = !q || o.text.toLowerCase().includes(q);
        const matchE = !esp || o.esp === esp;
        return matchQ && matchE;
      });

      filtered.forEach(o => {
        const opt = document.createElement('option');
        opt.value = o.value;
        opt.textContent = o.text;
        opt.setAttribute('data-especialidad', o.esp);
        if (o.value === selectedVal) opt.selected = true;
        sel.appendChild(opt);
      });
    }

    input.addEventListener('input', applyFilter);
    filtroEsp.addEventListener('change', applyFilter);
  })();
</script>
