<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="fade-in-up">
  <div class="d-flex justify-content-between align-items-center mb-4">
    <div>
      <h2 class="mb-1"><i class="bi bi-receipt me-2"></i>Tickets</h2>
      <nav aria-label="breadcrumb">
        <ol class="breadcrumb mb-0">
          <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
          <li class="breadcrumb-item active">Tickets</li>
        </ol>
      </nav>
    </div>
    <a href="${pageContext.request.contextPath}/admin/pagos" class="btn btn-outline-secondary">
      <i class="bi bi-cash"></i> Ir a Pagos
    </a>
  </div>

  <div class="card">
    <div class="card-header">
      <h5 class="mb-0">Pagos con ticket disponible (${pagos.size()})</h5>
    </div>
    <div class="card-body p-0">
      <c:choose>
        <c:when test="${empty pagos}">
          <div class="text-center py-5 text-muted">No hay pagos registrados</div>
        </c:when>
        <c:otherwise>
          <div class="table-responsive">
            <table class="table table-hover mb-0">
              <thead class="table-light">
                <tr>
                  <th>Fecha</th>
                  <th>Paciente</th>
                  <th>Psicólogo</th>
                  <th>Monto</th>
                  <th>Ticket</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="p" items="${pagos}">
                  <tr>
                    <td><fmt:formatDate value="${p.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>${p.pacienteNombre}</td>
                    <td>${p.psicologoNombre}</td>
                    <td>$ <fmt:formatNumber value="${p.montoTotal}" type="number" minFractionDigits="2"/></td>
                    <td>
                      <form method="post" action="${pageContext.request.contextPath}/admin/tickets/emitir" class="d-inline">
                        <input type="hidden" name="idPago" value="${p.id}">
                        <button class="btn btn-sm btn-primary">
                          <i class="bi bi-receipt-cutoff me-1"></i> Emitir / Ver
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
