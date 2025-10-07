<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="fade-in-up">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1"><i class="bi bi-cash-stack me-2"></i>Pagos</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    <li class="breadcrumb-item active">Pagos</li>
                </ol>
            </nav>
        </div>
        <div class="btn-group">
            <a href="${pageContext.request.contextPath}/admin/pagos/nuevo" class="btn btn-primary">
                <i class="bi bi-plus-circle me-2"></i>Registrar Pago
            </a>
            <a href="${pageContext.request.contextPath}/admin/pagos/pendientes" class="btn btn-outline-warning">
                <i class="bi bi-hourglass-split me-2"></i>Pendientes
            </a>
        </div>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success">${success}</div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-header">
            <div class="d-flex flex-column flex-lg-row align-items-lg-center justify-content-between gap-3">
                <h5 class="mb-0"><i class="bi bi-list-ul me-2"></i>Pagos Registrados (${pagos.size()})</h5>
                <form class="row g-2" method="get" action="${pageContext.request.contextPath}/admin/pagos">
                    <div class="col-6 col-lg-auto">
                        <input type="date" class="form-control" name="fechaInicio" value="${fechaInicio}">
                    </div>
                    <div class="col-6 col-lg-auto">
                        <input type="date" class="form-control" name="fechaFin" value="${fechaFin}">
                    </div>
                    <div class="col-6 col-lg-auto">
                        <select class="form-select" name="estadoPago">
                            <option value="">Todos</option>
                            <option value="pagado" ${"pagado" == estadoPagoFiltro ? 'selected' : ''}>Pagado</option>
                            <option value="pendiente" ${"pendiente" == estadoPagoFiltro ? 'selected' : ''}>Pendiente</option>
                        </select>
                    </div>
                    <div class="col-6 col-lg-auto">
                        <input type="text" class="form-control" name="paciente" placeholder="Paciente" value="${pacienteFiltro}">
                    </div>
                    <div class="col-6 col-lg-auto">
                        <input type="text" class="form-control" name="psicologo" placeholder="Psicólogo" value="${psicologoFiltro}">
                    </div>
                    <div class="col-12 col-lg-auto d-flex gap-2">
                        <button class="btn btn-outline-primary" type="submit"><i class="bi bi-search"></i></button>
                        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/admin/pagos"><i class="bi bi-x-lg"></i></a>
                    </div>
                </form>
            </div>
        </div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty pagos}">
                    <div class="text-center py-5 text-muted">No hay pagos</div>
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
                                    <th>Estado</th>
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
                                        <td>
                                            <span class="fw-semibold">$ <fmt:formatNumber value="${p.montoTotal}" type="number" minFractionDigits="2"/></span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${p.estadoPago == 'pagado'}"><span class="badge bg-success">Pagado</span></c:when>
                                                <c:otherwise><span class="badge bg-warning">Pendiente</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:if test="${p.estadoPago == 'pagado'}">
                                                <form method="post" action="${pageContext.request.contextPath}/admin/tickets/emitir" class="d-inline">
                                                    <input type="hidden" name="idPago" value="${p.id}">
                                                    <button class="btn btn-sm btn-primary">
                                                        <i class="bi bi-receipt-cutoff me-1"></i> Emitir / Ver Ticket
                                                    </button>
                                                </form>
                                            </c:if>
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
