package Controladores;

import Modelos.Cita;
import Modelos.Paciente;
import Modelos.Usuario;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.PacienteDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "PsicoAgendaServlet", urlPatterns = {
        "/psico/agenda",
        "/psico/agenda/nueva",
        "/psico/agenda/crear",
        "/psico/agenda/horas",
    "/psico/agenda/calendario",
    "/psico/agenda/cambiarEstado",
    "/psico/agenda/editarMotivo"
})
public class PsicoAgendaServlet extends HttpServlet {
    private final CitaDAOCompleto citaDAO = new CitaDAOCompleto();
    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();
    private final java.text.SimpleDateFormat sdfDate = new java.text.SimpleDateFormat("yyyy-MM-dd");

    private int currentPsicologoId(HttpServletRequest req){
        Usuario u = (Usuario) req.getSession().getAttribute("user");
        return (u!=null && psicologoDAO.obtenerPorUsuarioId(u.getId())!=null) ? psicologoDAO.obtenerPorUsuarioId(u.getId()).getId() : 0;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int idPs = currentPsicologoId(req);
        if ("/psico/agenda".equals(path)) {
            String desde = req.getParameter("desde");
            String hasta = req.getParameter("hasta");
            String estado = req.getParameter("estado");
            List<Cita> citas = citaDAO.buscarConFiltros(desde, hasta, estado, null, idPs);
            req.setAttribute("citas", citas);
            req.getRequestDispatcher("/WEB-INF/views/psico/agenda/index.jsp").forward(req, resp);
            return;
        }
        if ("/psico/agenda/nueva".equals(path)) {
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            req.setAttribute("pacientes", pacientes);
            req.getRequestDispatcher("/WEB-INF/views/psico/agenda/form.jsp").forward(req, resp);
            return;
        }
        if ("/psico/agenda/crear".equals(path)) {
            // Acceso por GET a /crear: redirigir a /nueva para evitar 404
            resp.sendRedirect(req.getContextPath()+"/psico/agenda/nueva");
            return;
        }
        if ("/psico/agenda/calendario".equals(path)) {
            List<Cita> citas = citaDAO.buscarConFiltros(null, null, null, null, idPs);
            req.setAttribute("citas", citas);
            req.getRequestDispatcher("/WEB-INF/views/psico/agenda/calendario.jsp").forward(req, resp);
            return;
        }
        if ("/psico/agenda/horas".equals(path)) {
            int idPsLocal = currentPsicologoId(req);
            String fecha = req.getParameter("fecha");
            java.util.List<String> horas = new java.util.ArrayList<>(); // se calcula en base a horas ocupadas SOLO por citas 'pendiente'
            try {
                java.util.Date d = sdfDate.parse(fecha);
                // reutilizar lógica del AdminCitasServlet indirectamente: pedimos horas libres del DAO por día
                java.util.Set<String> ocupadas = citaDAO.obtenerHorasOcupadasConfirmadas(idPsLocal, d);
                // para slots, consultamos horarios del día via HorarioPsicologicoDAO desde aquí
                ModelosDAO.HorarioPsicologicoDAO hdao = new ModelosDAO.HorarioPsicologicoDAO();
                java.util.Calendar cal = java.util.Calendar.getInstance();
                cal.setTime(d);
                int dow = cal.get(java.util.Calendar.DAY_OF_WEEK);
                String dia = dow==java.util.Calendar.MONDAY?"lunes":
                             dow==java.util.Calendar.TUESDAY?"martes":
                             dow==java.util.Calendar.WEDNESDAY?"miércoles":
                             dow==java.util.Calendar.THURSDAY?"jueves":
                             dow==java.util.Calendar.FRIDAY?"viernes":
                             dow==java.util.Calendar.SATURDAY?"sábado":"domingo";
                java.text.SimpleDateFormat hhmm = new java.text.SimpleDateFormat("HH:mm");
                for (Modelos.HorarioPsicologico h : hdao.listarPorPsicologo(idPsLocal)) {
                    if (!"activo".equalsIgnoreCase(h.getEstado())) continue;
                    if (!dia.equalsIgnoreCase(h.getDiaSemana())) continue;
                    java.util.Calendar cur = java.util.Calendar.getInstance();
                    cur.setTime(d);
                    java.util.Calendar fin = java.util.Calendar.getInstance(); fin.setTime(d);
                    cur.set(java.util.Calendar.HOUR_OF_DAY, h.getHoraInicio().toLocalTime().getHour());
                    cur.set(java.util.Calendar.MINUTE, h.getHoraInicio().toLocalTime().getMinute());
                    cur.set(java.util.Calendar.SECOND, 0);
                    fin.set(java.util.Calendar.HOUR_OF_DAY, h.getHoraFin().toLocalTime().getHour());
                    fin.set(java.util.Calendar.MINUTE, h.getHoraFin().toLocalTime().getMinute());
                    fin.set(java.util.Calendar.SECOND, 0);
                    while (cur.before(fin)) {
                        String slot = hhmm.format(cur.getTime());
                        if (!ocupadas.contains(slot)) horas.add(slot);
                        cur.add(java.util.Calendar.MINUTE, 30);
                    }
                }
                java.util.Collections.sort(horas);
            } catch (Exception ignore) {}
            resp.setContentType("application/json");
            resp.getWriter().write(new com.google.gson.Gson().toJson(horas));
            return;
        }
        resp.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int idPs = currentPsicologoId(req);
        if ("/psico/agenda/crear".equals(path)) {
            try {
                int idPaciente = Integer.parseInt(req.getParameter("idPaciente"));
                String fecha = req.getParameter("fecha");
                String hora = req.getParameter("hora");
                String motivo = Optional.ofNullable(req.getParameter("motivoConsulta")).orElse("");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                java.util.Date fh = sdf.parse(fecha + " " + hora);
                if (!citaDAO.verificarDisponibilidad(idPs, fh)) {
                    req.setAttribute("error", "El horario seleccionado no está disponible (fuera de horario o ya ocupado).");
                    doGet(req, resp); // volver a lista
                    return;
                }
                Cita c = new Cita();
                c.setIdPaciente(idPaciente);
                c.setIdPsicologo(idPs);
                c.setFechaHora(new Timestamp(fh.getTime()));
                c.setMotivoConsulta(motivo);
                c.setEstadoCita("pendiente");
                boolean ok = citaDAO.crear(c);
                req.getSession().setAttribute(ok?"success":"error", ok?"Cita creada":"No se pudo crear la cita");
                resp.sendRedirect(req.getContextPath()+"/psico/agenda");
                return;
            } catch (Exception e) {
                req.getSession().setAttribute("error","Datos inválidos: "+e.getMessage());
                resp.sendRedirect(req.getContextPath()+"/psico/agenda");
                return;
            }
        }
        if ("/psico/agenda/cambiarEstado".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String estado = req.getParameter("estado");
            try {
                Cita c = citaDAO.buscarPorId(id);
                if (c == null || c.getIdPsicologo() != idPs) { resp.sendError(403); return; }
                if ("realizada".equalsIgnoreCase(estado)) {
                    // Validar solo por FECHA en zona America/El_Salvador (no permitir futuras)
                    TimeZone tz = TimeZone.getTimeZone("America/El_Salvador");
                    Calendar hoy = Calendar.getInstance(tz);
                    int y = hoy.get(Calendar.YEAR);
                    int m = hoy.get(Calendar.MONTH) + 1;
                    int d = hoy.get(Calendar.DAY_OF_MONTH);
                    int hoyKey = y*10000 + m*100 + d;

                    Calendar cc = Calendar.getInstance(tz);
                    cc.setTime(c.getFechaHora());
                    int cy = cc.get(Calendar.YEAR);
                    int cm = cc.get(Calendar.MONTH) + 1;
                    int cd = cc.get(Calendar.DAY_OF_MONTH);
                    int citaKey = cy*10000 + cm*100 + cd;

                    if (citaKey > hoyKey) {
                        req.getSession().setAttribute("error","No se puede marcar como realizada una cita futura.");
                        resp.sendRedirect(req.getContextPath()+"/psico/agenda");
                        return;
                    }
                }
                boolean ok = citaDAO.cambiarEstado(id, estado);
                req.getSession().setAttribute(ok?"success":"error", ok?"Estado actualizado":"No se pudo actualizar el estado");
            } catch (Exception ex) {
                req.getSession().setAttribute("error","No se pudo actualizar el estado");
            }
            resp.sendRedirect(req.getContextPath()+"/psico/agenda");
            return;
        }
        if ("/psico/agenda/editarMotivo".equals(path)) {
            try {
                int idCita = Integer.parseInt(req.getParameter("idCita"));
                String motivo = Optional.ofNullable(req.getParameter("motivoConsulta")).orElse("");
                Cita c = citaDAO.buscarPorId(idCita);
                if (c == null || c.getIdPsicologo() != idPs) { resp.sendError(403); return; }
                c.setMotivoConsulta(motivo);
                boolean ok = citaDAO.actualizar(c);
                req.getSession().setAttribute(ok?"success":"error", ok?"Motivo actualizado":"No se pudo actualizar motivo");
                resp.sendRedirect(req.getContextPath()+"/psico/evaluaciones/ver?id="+idCita);
                return;
            } catch (Exception ex) {
                req.getSession().setAttribute("error","Datos inválidos");
                resp.sendRedirect(req.getContextPath()+"/psico/evaluaciones");
                return;
            }
        }
        resp.sendError(404);
    }
}
