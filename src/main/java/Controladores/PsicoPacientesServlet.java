package Controladores;

import Modelos.Cita;
import Modelos.Paciente;
import Modelos.Usuario;
import ModelosDAO.CitaDAO;
import ModelosDAO.PacienteDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "PsicoPacientesServlet", urlPatterns = {
        "/psico/pacientes", "/psico/pacientes/ver"
})
public class PsicoPacientesServlet extends HttpServlet {
    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();
    private final CitaDAO citaDAO = new CitaDAO();

    private int currentPsicologoId(HttpServletRequest req){
        Usuario u = (Usuario) req.getSession().getAttribute("user");
        return (u!=null && psicologoDAO.obtenerPorUsuarioId(u.getId())!=null) ? psicologoDAO.obtenerPorUsuarioId(u.getId()).getId() : 0;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        int idPs = currentPsicologoId(req);
        if (idPs == 0) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }

        if ("/psico/pacientes".equals(path)) {
            String buscar = Optional.ofNullable(req.getParameter("buscar")).orElse("");
            List<Paciente> pacientes = (buscar.isEmpty()) ? pacienteDAO.listarPorPsicologo(idPs) : pacienteDAO.buscarPorPsicologo(buscar, idPs);
            req.setAttribute("pacientes", pacientes);
            req.setAttribute("busqueda", buscar);
            req.getRequestDispatcher("/WEB-INF/views/psico/pacientes/index.jsp").forward(req, resp);
            return;
        }
        if ("/psico/pacientes/ver".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Paciente p = pacienteDAO.obtenerPorId(id);
            if (p == null) { resp.sendRedirect(req.getContextPath()+"/psico/pacientes?error=Paciente no encontrado"); return; }
            List<Cita> historial = citaDAO.listarPorPacienteConNombres(id);
            req.setAttribute("paciente", p);
            req.setAttribute("historial", historial);
            req.getRequestDispatcher("/WEB-INF/views/psico/pacientes/ver.jsp").forward(req, resp);
            return;
        }
        resp.sendError(404);
    }
}
