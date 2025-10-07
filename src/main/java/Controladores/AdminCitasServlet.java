package Controladores;

import Modelos.Cita;
import Modelos.Paciente;
import Modelos.Psicologo;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.PacienteDAO;
import ModelosDAO.PsicologoDAO;
import ModelosDAO.HorarioPsicologicoDAO;
import Modelos.HorarioPsicologico;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Calendar;
import java.util.Set;

@WebServlet(name = "AdminCitasServlet", urlPatterns = {"/admin/citas", "/admin/citas/*"})
public class AdminCitasServlet extends HttpServlet {
    
    private CitaDAOCompleto citaDAO;
    private PacienteDAO pacienteDAO;
    private PsicologoDAO psicologoDAO;
    private HorarioPsicologicoDAO horarioDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            citaDAO = new CitaDAOCompleto();
            pacienteDAO = new PacienteDAO();
            psicologoDAO = new PsicologoDAO();
            horarioDAO = new HorarioPsicologicoDAO();
        } catch (Exception e) {
            throw new ServletException("Error al inicializar DAOs", e);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo == null || pathInfo.equals("/")) {
                listarCitas(request, response);
            } else if (pathInfo.equals("/nueva")) {
                mostrarFormularioNueva(request, response);
            } else if (pathInfo.startsWith("/editar/")) {
                mostrarFormularioEditar(request, response);
            } else if (pathInfo.startsWith("/ver/")) {
                verDetalleCita(request, response);
            } else if (pathInfo.equals("/calendario")) {
                mostrarCalendario(request, response);
            } else if (pathInfo.equals("/horas")) {
                responderHorasDisponibles(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        
        try {
            if (pathInfo != null) {
                if (pathInfo.equals("/nueva") || pathInfo.equals("/editar")) {
                    guardarCita(request, response);
                } else if (pathInfo.equals("/cambiar-estado")) {
                    cambiarEstado(request, response);
                } else if (pathInfo.equals("/reasignar")) {
                    reasignarPsicologo(request, response);
                } else if (pathInfo.equals("/eliminar")) {
                    eliminarCita(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void listarCitas(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            String estado = request.getParameter("estado");
            String pacienteId = request.getParameter("paciente");
            String psicologoId = request.getParameter("psicologo");
            // Mapear mensajes de query params a atributos de request para alertas dinámicas
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            if (successMsg != null && !successMsg.isEmpty()) {
                request.setAttribute("success", successMsg);
            }
            if (errorMsg != null && !errorMsg.isEmpty()) {
                request.setAttribute("error", errorMsg);
            }
            
            List<Cita> citas = citaDAO.buscarConFiltros(fechaInicio, fechaFin, estado, 
                pacienteId != null && !pacienteId.isEmpty() ? Integer.parseInt(pacienteId) : null,
                psicologoId != null && !psicologoId.isEmpty() ? Integer.parseInt(psicologoId) : null);
            
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            List<Psicologo> psicologos = psicologoDAO.listarTodos();
            
            request.setAttribute("citas", citas);
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("psicologos", psicologos);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void mostrarFormularioNueva(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            List<Psicologo> psicologos = psicologoDAO.listarTodos();
            
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("psicologos", psicologos);
            // fecha mínima = hoy (sin horas)
            Date hoy = new Date();
            request.setAttribute("fechaMinima", hoy);
            // slots por defecto vacíos hasta que el usuario seleccione fecha/psicólogo
            request.setAttribute("horasDisponibles", java.util.Collections.emptyList());
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String pi = request.getPathInfo();
            if (pi == null || !pi.startsWith("/editar/") || pi.length() <= "/editar/".length()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parámetro de edición inválido");
                return;
            }
            String idStr = pi.substring("/editar/".length());
            int id = Integer.parseInt(idStr);
            
            Cita cita = citaDAO.buscarPorId(id);
            if (cita == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            List<Psicologo> psicologos = psicologoDAO.listarTodos();
            
            request.setAttribute("cita", cita);
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("psicologos", psicologos);
            Date hoy = new Date();
            request.setAttribute("fechaMinima", hoy);
            // calcular horas disponibles para el día/psicólogo de la cita, incluyendo la hora actual de la cita
            List<String> horas = calcularHorasDisponibles(cita.getIdPsicologo(), cita.getFechaHora());
            // aseguremos que la hora actual esté presente
            java.text.SimpleDateFormat hhmm = new java.text.SimpleDateFormat("HH:mm");
            String actual = hhmm.format(cita.getFechaHora());
            if (!horas.contains(actual)) horas.add(actual);
            java.util.Collections.sort(horas);
            request.setAttribute("horasDisponibles", horas);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // Utilidad: calcular slots disponibles de 30 min basados en HorarioPsicologico y excluyendo citas confirmadas
    private List<String> calcularHorasDisponibles(int idPsicologo, Date fecha) {
        List<String> disponibles = new java.util.ArrayList<>();
        if (idPsicologo <= 0 || fecha == null) return disponibles;

        Calendar cal = Calendar.getInstance();
        cal.setTime(fecha);
        int dow = cal.get(Calendar.DAY_OF_WEEK);
        String dia;
        switch (dow) {
            case Calendar.MONDAY: dia = "lunes"; break;
            case Calendar.TUESDAY: dia = "martes"; break;
            case Calendar.WEDNESDAY: dia = "miércoles"; break;
            case Calendar.THURSDAY: dia = "jueves"; break;
            case Calendar.FRIDAY: dia = "viernes"; break;
            case Calendar.SATURDAY: dia = "sábado"; break;
            default: dia = "domingo"; break;
        }
        // horarios activos del día
        List<HorarioPsicologico> horarios = horarioDAO.listarPorPsicologo(idPsicologo);
        // horas ocupadas confirmadas
        Set<String> ocupadas = citaDAO.obtenerHorasOcupadasConfirmadas(idPsicologo, fecha);
        java.text.SimpleDateFormat hhmm = new java.text.SimpleDateFormat("HH:mm");

        for (HorarioPsicologico h : horarios) {
            if (!"activo".equalsIgnoreCase(h.getEstado())) continue;
            if (!dia.equalsIgnoreCase(h.getDiaSemana())) continue;
            Calendar cur = Calendar.getInstance();
            cur.setTime(fecha);
            Calendar fin = Calendar.getInstance();
            fin.setTime(fecha);
            cur.set(Calendar.HOUR_OF_DAY, h.getHoraInicio().toLocalTime().getHour());
            cur.set(Calendar.MINUTE, h.getHoraInicio().toLocalTime().getMinute());
            cur.set(Calendar.SECOND, 0);
            fin.set(Calendar.HOUR_OF_DAY, h.getHoraFin().toLocalTime().getHour());
            fin.set(Calendar.MINUTE, h.getHoraFin().toLocalTime().getMinute());
            fin.set(Calendar.SECOND, 0);
            while (cur.before(fin)) {
                String slot = hhmm.format(cur.getTime());
                if (!ocupadas.contains(slot)) {
                    disponibles.add(slot);
                }
                cur.add(Calendar.MINUTE, 30);
            }
        }
        java.util.Collections.sort(disponibles);
        return disponibles;
    }
    
    private void verDetalleCita(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String idStr = request.getPathInfo().substring("/ver/".length());
            int id = Integer.parseInt(idStr);
            
            Cita cita = citaDAO.buscarPorId(id);
            if (cita == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Obtener datos adicionales del paciente y psicólogo
            Paciente paciente = pacienteDAO.obtenerPorId(cita.getIdPaciente());
            Psicologo psicologo = psicologoDAO.obtenerPorId(cita.getIdPsicologo());
            List<Psicologo> psicologos = psicologoDAO.listarTodos(); // Para reasignación
            // Mapear mensajes de query params a atributos de request para alertas dinámicas
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            if (successMsg != null && !successMsg.isEmpty()) {
                request.setAttribute("success", successMsg);
            }
            if (errorMsg != null && !errorMsg.isEmpty()) {
                request.setAttribute("error", errorMsg);
            }
            
            request.setAttribute("cita", cita);
            request.setAttribute("paciente", paciente);
            request.setAttribute("psicologo", psicologo);
            request.setAttribute("psicologos", psicologos);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/detalle.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void mostrarCalendario(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Cita> citas = citaDAO.listarTodos();
            List<Psicologo> psicologos = psicologoDAO.listarTodos();
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            // Mapear mensajes de query params a atributos de request para alertas dinámicas
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
            if (successMsg != null && !successMsg.isEmpty()) {
                request.setAttribute("success", successMsg);
            }
            if (errorMsg != null && !errorMsg.isEmpty()) {
                request.setAttribute("error", errorMsg);
            }
            
            request.setAttribute("citas", citas);
            request.setAttribute("psicologos", psicologos);
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("fechaActual", new Date());
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/calendario.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void guardarCita(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String id = request.getParameter("id");
            String idPaciente = request.getParameter("idPaciente");
            String idPsicologo = request.getParameter("idPsicologo");
            String fecha = request.getParameter("fecha");
            String hora = request.getParameter("hora");
            String motivoConsulta = request.getParameter("motivoConsulta");
            String estadoCita = request.getParameter("estadoCita");
            String observaciones = request.getParameter("observaciones");
            
            // Validaciones básicas (motivoConsulta es opcional)
            if (idPaciente == null || idPaciente.trim().isEmpty() ||
                idPsicologo == null || idPsicologo.trim().isEmpty() ||
                fecha == null || fecha.trim().isEmpty() ||
                hora == null || hora.trim().isEmpty()) {
                
                request.setAttribute("error", "Por favor completa todos los campos obligatorios");
                if (id == null || id.trim().isEmpty()) {
                    mostrarFormularioNueva(request, response);
                } else {
                    mostrarFormularioEditar(request, response);
                }
                return;
            }
            
            Cita cita;
            boolean isNew = (id == null || id.trim().isEmpty());
            
            if (isNew) {
                cita = new Cita();
                cita.setFechaCreacion(new Date());
            } else {
                cita = citaDAO.buscarPorId(Integer.parseInt(id));
                if (cita == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                    return;
                }
            }
            
            // Combinar fecha y hora
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date fechaHora = sdf.parse(fecha + " " + hora);
            // Validar que no sea pasado
            if (fechaHora.before(new Date())) {
                request.setAttribute("error", "No puedes seleccionar una fecha u hora pasada");
                if (isNew) {
                    mostrarFormularioNueva(request, response);
                } else {
                    mostrarFormularioEditar(request, response);
                }
                return;
            }
            
            // Validar disponibilidad del psicólogo
            if (isNew || !cita.getFechaHora().equals(fechaHora) || 
                cita.getIdPsicologo() != Integer.parseInt(idPsicologo)) {
                if (!citaDAO.verificarDisponibilidad(Integer.parseInt(idPsicologo), fechaHora)) {
                    request.setAttribute("error", "El psicólogo no está disponible en esa fecha y hora");
                    if (isNew) {
                        mostrarFormularioNueva(request, response);
                    } else {
                        mostrarFormularioEditar(request, response);
                    }
                    return;
                }
            }
            
            cita.setIdPaciente(Integer.parseInt(idPaciente));
            cita.setIdPsicologo(Integer.parseInt(idPsicologo));
            cita.setFechaHora(fechaHora);
            // motivo de consulta opcional
            cita.setMotivoConsulta(motivoConsulta != null && !motivoConsulta.trim().isEmpty() ? motivoConsulta : null);
            cita.setEstadoCita(estadoCita != null && !estadoCita.isEmpty() ? estadoCita : "pendiente");
            // observaciones se conserva solo en memoria si el modelo lo usa en vistas
            cita.setObservaciones(observaciones);
            
            boolean success;
            if (isNew) {
                success = citaDAO.crear(cita);
            } else {
                success = citaDAO.actualizar(cita);
            }
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/citas?success=" + 
                    (isNew ? "created" : "updated"));
            } else {
                request.setAttribute("error", "Error al " + (isNew ? "crear" : "actualizar") + " la cita");
                if (isNew) {
                    mostrarFormularioNueva(request, response);
                } else {
                    mostrarFormularioEditar(request, response);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno del servidor: " + e.getMessage());
            mostrarFormularioNueva(request, response);
        }
    }

    // Endpoint JSON: lista de horas disponibles (slots de 30 min) para un psicólogo en una fecha
    private void responderHorasDisponibles(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idPsStr = request.getParameter("psicologo");
        String fechaStr = request.getParameter("fecha"); // yyyy-MM-dd
        response.setContentType("application/json; charset=UTF-8");
        try {
            if (idPsStr == null || idPsStr.isEmpty() || fechaStr == null || fechaStr.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("[]");
                return;
            }
            int idPs = Integer.parseInt(idPsStr);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date fecha = sdf.parse(fechaStr);
            // No permitir fechas pasadas
            Calendar hoy = Calendar.getInstance();
            hoy.set(Calendar.HOUR_OF_DAY, 0);
            hoy.set(Calendar.MINUTE, 0);
            hoy.set(Calendar.SECOND, 0);
            hoy.set(Calendar.MILLISECOND, 0);
            Calendar fc = Calendar.getInstance();
            fc.setTime(fecha);
            if (fc.before(hoy)) {
                response.getWriter().write("[]");
                return;
            }
            List<String> disponibles = calcularHorasDisponibles(idPs, fecha);
            Set<String> ocupadas = citaDAO.obtenerHorasOcupadasConfirmadas(idPs, fecha);
            // Emitir JSON objeto {disponibles:[], ocupadas:[]}
            StringBuilder sb = new StringBuilder();
            sb.append('{');
            sb.append("\"disponibles\":[");
            for (int i = 0; i < disponibles.size(); i++) {
                if (i > 0) sb.append(',');
                sb.append('"').append(disponibles.get(i)).append('"');
            }
            sb.append(']');
            sb.append(',');
            sb.append("\"ocupadas\":[");
            int idx = 0;
            for (String h : ocupadas) {
                if (idx++ > 0) sb.append(',');
                sb.append('"').append(h).append('"');
            }
            sb.append(']');
            sb.append('}');
            response.getWriter().write(sb.toString());
        } catch (Exception ex) {
            ex.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
    
    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");
            try {
                if ("realizada".equalsIgnoreCase(estado)) {
                    ModelosDAO.CitaDAOCompleto cdao = this.citaDAO; // reuse
                    Modelos.Cita c = cdao.buscarPorId(id);
                    if (c != null) {
                        java.util.TimeZone tz = java.util.TimeZone.getTimeZone("America/El_Salvador");
                        java.util.Calendar hoy = java.util.Calendar.getInstance(tz);
                        int y=hoy.get(java.util.Calendar.YEAR), m=hoy.get(java.util.Calendar.MONTH)+1, d=hoy.get(java.util.Calendar.DAY_OF_MONTH);
                        int hoyKey = y*10000 + m*100 + d;
                        java.util.Calendar cc = java.util.Calendar.getInstance(tz);
                        cc.setTime(c.getFechaHora());
                        int cy=cc.get(java.util.Calendar.YEAR), cm=cc.get(java.util.Calendar.MONTH)+1, cd=cc.get(java.util.Calendar.DAY_OF_MONTH);
                        int citaKey = cy*10000 + cm*100 + cd;
                        if (citaKey > hoyKey) {
                            response.sendRedirect(request.getContextPath()+"/admin/citas?error=No se puede marcar como realizada una cita futura");
                            return;
                        }
                    }
                }
            } catch (Exception ignore) {}
            
            boolean success = citaDAO.cambiarEstado(id, estado);
            String mensaje = success ? "Estado de la cita cambiado correctamente" : "Error al cambiar estado";
            
            response.sendRedirect(request.getContextPath() + "/admin/citas?" + 
                (success ? "success" : "error") + "=" + mensaje);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void reasignarPsicologo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int nuevoIdPsicologo = Integer.parseInt(request.getParameter("nuevoIdPsicologo"));
            String nuevaHora = request.getParameter("nuevaHora"); // HH:mm
            String fechaParam = request.getParameter("fecha"); // yyyy-MM-dd (opcional)
            
            Cita cita = citaDAO.buscarPorId(id);
            if (cita == null) {
                response.sendRedirect(request.getContextPath() + "/admin/citas?error=Cita no encontrada");
                return;
            }

            // Determinar fecha-hora destino
            java.util.Date fechaHoraDestino = cita.getFechaHora();
            try {
                java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("yyyy-MM-dd");
                java.text.SimpleDateFormat sdfDateTime = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                String fechaBase = (fechaParam != null && !fechaParam.isEmpty()) 
                        ? fechaParam 
                        : sdfDate.format(cita.getFechaHora());
                if (nuevaHora != null && !nuevaHora.isEmpty()) {
                    fechaHoraDestino = sdfDateTime.parse(fechaBase + " " + nuevaHora);
                }
            } catch (Exception ignore) {
                // Mantener fechaHoraDestino original si falla el parseo
            }

            // Validar disponibilidad para el nuevo psicólogo en la fecha/hora destino
            if (citaDAO.verificarDisponibilidad(nuevoIdPsicologo, fechaHoraDestino)) {
                // Actualizar cita con nuevo psicólogo y hora (si aplica)
                cita.setIdPsicologo(nuevoIdPsicologo);
                cita.setFechaHora(fechaHoraDestino);
                boolean success = citaDAO.actualizar(cita);
                String mensaje = success ? "Psicólogo/horario reasignado correctamente" : "Error al reasignar la cita";
                response.sendRedirect(request.getContextPath() + "/admin/citas?" + 
                    (success ? "success" : "error") + "=" + mensaje);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/citas?error=El psicólogo no está disponible en esa fecha y hora");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void eliminarCita(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            boolean success = citaDAO.eliminar(id);
            String mensaje = success ? "Cita eliminada correctamente" : "Error al eliminar la cita";
            
            response.sendRedirect(request.getContextPath() + "/admin/citas?" + 
                (success ? "success" : "error") + "=" + mensaje);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}