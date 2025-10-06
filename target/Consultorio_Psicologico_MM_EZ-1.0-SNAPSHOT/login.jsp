<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Consultorio Psicológico - Iniciar Sesión</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/consultorio.css">
</head>
<body class="login-container">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-12 col-sm-8 col-md-6 col-lg-4">
            <div class="login-card fade-in-up">
                <div class="login-header">
                    <i class="bi bi-heart-pulse-fill fs-1 mb-3"></i>
                    <h1 class="h4 mb-2">Consultorio Psicológico</h1>
                    <p class="mb-0 opacity-75">Sistema de Gestión Integral</p>
                </div>
                <div class="login-body">
                    <form method="post" action="${pageContext.request.contextPath}/auth">
                        <input type="hidden" name="action" value="login" />
                        <div class="mb-3">
                            <label class="form-label"><i class="bi bi-envelope me-2"></i>Email</label>
                            <input type="email" name="email" class="form-control" placeholder="admin@demo.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><i class="bi bi-lock me-2"></i>Contraseña</label>
                            <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                        </div>
                        <button class="btn btn-primary w-100 py-2" type="submit">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Iniciar Sesión
                        </button>
                    </form>
                    ${error != null ? '<div class="alert alert-danger mt-3 mb-0"><i class="bi bi-exclamation-triangle me-2"></i>' + error + '</div>' : ''}
                    <div class="mt-4 pt-3 border-top text-center">
                        <small class="text-muted">
                            <strong>Demo:</strong> admin@demo.com / admin123<br>
                            <strong>Psicólogo:</strong> ana@demo.com / psico123
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
