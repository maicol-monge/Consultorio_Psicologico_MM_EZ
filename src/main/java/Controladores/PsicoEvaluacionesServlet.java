package Controladores;

import Modelos.Cita;
import Modelos.Evaluacion;
import Modelos.Usuario;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.EvaluacionDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PsicoEvaluacionesServlet", urlPatterns = {
        "/psico/evaluaciones", "/psico/evaluaciones/ver", "/psico/evaluaciones/guardar"
})
public class PsicoEvaluacionesServlet extends HttpServlet {
    private final EvaluacionDAO evaluacionDAO = new EvaluacionDAO();
    private final CitaDAOCompleto citaDAO = new CitaDAOCompleto();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();

    private int currentPsicologoId(HttpServletRequest req){
        Usuario u = (Usuario) req.getSession().getAttribute("user");
        return (u!=null && psicologoDAO.obtenerPorUsuarioId(u.getId())!=null) ? psicologoDAO.obtenerPorUsuarioId(u.getId()).getId() : 0;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int idPs = currentPsicologoId(req);
        if ("/psico/evaluaciones".equals(path)) {
            // Listar citas del psicólogo (todas), la restricción para crear eval será solo cuando esté pendiente
            List<Cita> citas = citaDAO.buscarConFiltros(null, null, null, null, idPs);
            req.setAttribute("citas", citas);
            req.getRequestDispatcher("/WEB-INF/views/psico/evaluaciones/index.jsp").forward(req, resp);
            return;
        }
        if ("/psico/evaluaciones/ver".equals(path)) {
            int idCita = Integer.parseInt(req.getParameter("id"));
            Cita cita = citaDAO.buscarPorId(idCita);
            if (cita == null || cita.getIdPsicologo() != idPs) { resp.sendError(404); return; }
            java.util.List<Evaluacion> evaluaciones = evaluacionDAO.listarPorCita(idCita);
            req.setAttribute("cita", cita);
            req.setAttribute("evaluaciones", evaluaciones);
            req.getRequestDispatcher("/WEB-INF/views/psico/evaluaciones/ver.jsp").forward(req, resp);
            return;
        }
        resp.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int idPs = currentPsicologoId(req);
        if ("/psico/evaluaciones/guardar".equals(path)) {
            try {
                int idCita = Integer.parseInt(req.getParameter("idCita"));
                Cita cita = citaDAO.buscarPorId(idCita);
                if (cita == null || cita.getIdPsicologo() != idPs) { resp.sendError(403); return; }
                // Solo permitir agregar evaluaciones y editar motivo cuando la cita está pendiente
                if (!"pendiente".equalsIgnoreCase(cita.getEstadoCita())) {
                    req.getSession().setAttribute("error","Solo se puede evaluar/editar motivo en citas pendientes");
                    resp.sendRedirect(req.getContextPath()+"/psico/evaluaciones/ver?id="+idCita);
                    return;
                }
                int estadoEmocional = Integer.parseInt(req.getParameter("estadoEmocional"));
                String comentarios = req.getParameter("comentarios");
                Evaluacion e = new Evaluacion();
                e.setIdCita(idCita);
                e.setEstadoEmocional(estadoEmocional);
                e.setComentarios(comentarios);
                e.setEstado("activo");
                boolean ok = evaluacionDAO.crear(e);
                req.getSession().setAttribute(ok?"success":"error", ok?"Evaluación guardada":"No se pudo guardar");
                resp.sendRedirect(req.getContextPath()+"/psico/evaluaciones/ver?id="+idCita);
                return;
            } catch (Exception ex) {
                req.getSession().setAttribute("error","Datos inválidos: "+ex.getMessage());
                resp.sendRedirect(req.getContextPath()+"/psico/evaluaciones");
                return;
            }
        }
        resp.sendError(404);
    }
}
