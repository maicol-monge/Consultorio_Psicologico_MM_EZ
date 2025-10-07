<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="fade-in-up">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1"><i class="bi bi-hourglass-split me-2"></i>Pagos Pendientes</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/pagos">Pagos</a></li>
                    <li class="breadcrumb-item active">Pendientes</li>
                </ol>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/admin/pagos" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-2"></i>Volver
        </a>
    </div>

    <div class="card">
        <div class="card-header">
            <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Pagos (${pagos.size()})</h5>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty pagos}">
                    <div class="text-center py-5 text-muted">No hay pagos pendientes</div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>Fecha</th>
                                    <th>Paciente</th>
                                    <th>Psicólogo</th>
                                    <th>Monto Base</th>
                                    <th>Monto Total</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="p" items="${pagos}">
                                    <tr>
                                        <td><fmt:formatDate value="${p.fecha}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>${p.pacienteNombre}</td>
                                        <td>${p.psicologoNombre}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty p.montoBase}">$ <fmt:formatNumber value="${p.montoBase}" type="number" minFractionDigits="2"/></c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>$ <fmt:formatNumber value="${p.montoTotal}" type="number" minFractionDigits="2"/></td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/pagos/marcar-pagado" style="display:inline-block;">
                                                <input type="hidden" name="id" value="${p.id}">
                                                <button type="submit" class="btn btn-sm btn-success">
                                                    <i class="bi bi-check2-circle me-1"></i>Marcar Pagado
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
