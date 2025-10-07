<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="d-flex justify-content-between align-items-center mb-3">
  <h4 class="mb-0">Mis Pacientes</h4>
  <form class="row g-2" method="get" action="${pageContext.request.contextPath}/psico/pacientes">
    <div class="col-12 col-md-6">
      <div class="input-group">
        <span class="input-group-text"><i class="bi bi-search"></i></span>
        <input type="text" class="form-control" name="buscar" placeholder="Buscar por nombre, email o DUI" value="${busqueda}">
      </div>
    </div>
    <div class="col-12 col-md-auto">
      <button class="btn btn-primary" type="submit">Buscar</button>
    </div>
  </form>
</div>

<div class="table-responsive" style="max-height: 60vh; overflow: auto;">
<table class="table table-hover align-middle">
  <thead class="table-light position-sticky top-0">
    <tr>
      <th>Nombre</th>
      <th>Email</th>
      <th>Teléfono</th>
      <th>Estado</th>
  <th>Género</th>
  <th>Edad</th>
  <th></th>
    </tr>
  </thead>
  <tbody>
  <c:forEach var="p" items="${pacientes}">
    <tr>
      <td>${p.nombre}</td>
      <td>${p.email}</td>
      <td>${p.telefono}</td>
      <td>${p.genero}</td>
      <td>
        <c:choose>
          <c:when test="${p.fechaNacimiento != null}">
            <span class="edad" data-nac="${p.fechaNacimiento.time}"></span>
          </c:when>
          <c:otherwise>-</c:otherwise>
        </c:choose>
      </td>
      <td><span class="badge bg-${p.estado == 'activo' ? 'success' : 'secondary'}">${p.estado}</span></td>
      <td class="text-end">
        <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/psico/pacientes/ver?id=${p.id}"><i class="bi bi-folder2-open"></i> Ver expediente</a>
      </td>
    </tr>
  </c:forEach>
  <c:if test="${empty pacientes}">
    <tr><td colspan="5" class="text-center text-muted">No hay pacientes para mostrar.</td></tr>
  </c:if>
  </tbody>
</table>
</div>

<script>
(function(){
  document.querySelectorAll('.edad').forEach(el=>{
    const ms=parseInt(el.dataset.nac,10); if(!ms) return;
    const d=new Date(ms); const diff=Date.now()-d.getTime();
    const edad=Math.floor(diff/31557600000); el.textContent = edad+' años';
  });
})();
</script>
