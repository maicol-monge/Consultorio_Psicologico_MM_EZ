<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard Psicólogo</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Psicólogo</a>
    <form class="ms-auto" method="post" action="${pageContext.request.contextPath}/auth">
        <input type="hidden" name="action" value="logout"/>
        <button class="btn btn-outline-light btn-sm" type="submit">Salir</button>
    </form>
  </div>
</nav>
<div class="container py-4">
    <div class="mb-3">
        <div class="btn-group" role="group">
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/psico/report/sesionesPorRango?format=pdf">Sesiones por rango (PDF)</a>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/psico/report/citasPorMes?format=pdf">Citas por mes (PDF)</a>
            <a class="btn btn-outline-primary btn-sm" href="${pageContext.request.contextPath}/psico/report/resumenEvaluaciones?format=pdf">Resumen de evaluaciones (PDF)</a>
        </div>
    </div>
    <div class="row g-3">
        <div class="col-6 col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <div class="fw-bold">Citas Realizadas</div>
                    <div class="display-6">${citasRealizadas}</div>
                </div>
            </div>
        </div>
        <div class="col-6 col-md-3">
            <div class="card text-center">
                <div class="card-body">
                    <div class="fw-bold">Citas Pendientes</div>
                    <div class="display-6">${citasPendientes}</div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
