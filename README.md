# Consultorio Psicológico (Admin + Psicólogo)

Este proyecto es un esqueleto funcional para gestionar un consultorio psicológico con dos roles (admin y psicólogo), usando Servlets (controladores), JSP (vistas), modelos y DAOs (JDBC). Incluye:

- Login con control de sesión y filtro por rol.
- Dashboards con estadísticas y gráficos (Chart.js) para ambos roles.
- Reportes exportables a PDF y Excel (OpenPDF + Apache POI).
- Generación/consulta de tickets tipo supermercado en PNG con QR (ZXing), con opciones de descargar/imprimir.
- Vistas responsive con Bootstrap 5.

## Configuración

1. Base de datos MySQL

   - Cree la BD `psicologia2` con el script proporcionado por el usuario.
   - Configure credenciales en `src/main/java/DB/cn.java` (USER y PASS).

2. Build
   - Use Maven (Java 8). Dependencias en `pom.xml`.

## Rutas principales

- `/login.jsp` (página de inicio de sesión)
- `/auth` (POST: action=login/logout)
- `/admin/dashboard` (dashboard administrador)
- `/psico/dashboard` (dashboard psicólogo)
- `/admin/report/*` (3 reportes de admin PDF/XLSX)
- `/psico/report/*` (3 reportes personales PDF/XLSX)
- `/ticket?n=<numero_ticket>` (vista del ticket)
- `/ticket.png?n=<numero_ticket>&dl=1` (descarga PNG)

## Notas

- Ajuste las consultas SQL y agregue métodos en DAOs según sea necesario.
- Para ambiente productivo reemplace OpenPDF si su licencia no es adecuada.
- Integre seguridad adicional (hash de contraseñas, validación inputs) antes de producción.
