<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Ticket</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
  <style>
    .ticket { max-width: 384px; background:#fff; border:1px dashed #ccc; margin:auto; padding:12px }
  </style>
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="ticket">
    <h6 class="text-center">Consultorio Psicológico</h6>
    <hr>
    <fmt:setTimeZone value="America/El_Salvador"/>
    <div class="d-flex justify-content-between"><span><strong>N° Ticket:</strong></span><span>${ticket.numeroTicket}</span></div>
    <div class="d-flex justify-content-between"><span><strong>Código:</strong></span><span>${ticket.codigo}</span></div>
    <div class="d-flex justify-content-between"><span><strong>Fecha emisión:</strong></span><span><fmt:formatDate value="${ticket.fechaEmision}" pattern="dd/MM/yyyy HH:mm"/></span></div>
    <hr>
    <div class="mb-1"><strong>Paciente:</strong> ${ticket.pacienteNombre}</div>
    <div class="mb-1"><strong>Psicólogo:</strong> ${ticket.psicologoNombre}</div>
    <div class="mb-1"><strong>Fecha de cita:</strong> <fmt:formatDate value="${ticket.citaFechaHora}" pattern="dd/MM/yyyy HH:mm"/></div>
  <div class="mb-1 d-flex justify-content-between"><span><strong>Monto base:</strong></span><span>$ <fmt:formatNumber value="${ticket.montoBase}" type="number" minFractionDigits="2"/></span></div>
  <div class="mb-2 d-flex justify-content-between"><span><strong>Monto total:</strong></span><span>$ <fmt:formatNumber value="${ticket.montoTotal}" type="number" minFractionDigits="2"/></span></div>
    <div class="text-center my-2">
      <img src="${pageContext.request.contextPath}/ticket.png?n=${ticket.numeroTicket}" class="img-fluid" alt="ticket"/>
    </div>
    <div class="d-flex gap-2">
      <a class="btn btn-primary btn-sm w-50" href="${pageContext.request.contextPath}/ticket.png?n=${ticket.numeroTicket}&dl=1">Descargar PNG</a>
      <button class="btn btn-outline-secondary btn-sm w-50" onclick="window.print()">Imprimir</button>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
