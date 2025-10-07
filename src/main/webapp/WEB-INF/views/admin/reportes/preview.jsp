<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Previsualización</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container py-4">
  <div class="d-flex justify-content-between align-items-center mb-3">
    <h4 class="mb-0">${titulo}</h4>
    <form class="btn-group" method="get">
      <c:forEach var="entry" items="${paramValues}">
        <c:if test="${entry.key ne 'format'}">
          <c:forEach var="v" items="${entry.value}">
            <input type="hidden" name="${entry.key}" value="${v}"/>
          </c:forEach>
        </c:if>
      </c:forEach>
      <button type="submit" class="btn btn-sm btn-outline-success" name="format" value="xlsx">Descargar Excel</button>
      <button type="submit" class="btn btn-sm btn-outline-danger" name="format" value="pdf">Descargar PDF</button>
    </form>
  </div>
  <div class="card">
    <div class="table-responsive">
      <table class="table table-striped table-sm mb-0">
        <thead class="table-light">
          <tr>
            <c:forEach var="h" items="${headers}"><th>${h}</th></c:forEach>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="r" items="${rows}">
            <tr>
              <c:forEach var="col" items="${r}"><td>${col}</td></c:forEach>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
