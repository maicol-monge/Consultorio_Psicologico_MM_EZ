package Controladores;

import Modelos.Usuario;
import ModelosDAO.CitaDAO;
import ModelosDAO.PsicologoDAO;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "PsicoDashboardServlet", urlPatterns = {"/psico/dashboard", 
        "/psico/chart/status", 
        "/psico/chart/mes"})
public class PsicoDashboardServlet extends HttpServlet {
    private final CitaDAO citaDAO = new CitaDAO();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/psico/dashboard".equals(path)) {
            Usuario u = (Usuario) req.getSession().getAttribute("user");
            int idPsicologo = (u!=null && psicologoDAO.obtenerPorUsuarioId(u.getId())!=null) ? psicologoDAO.obtenerPorUsuarioId(u.getId()).getId() : 0;
            req.setAttribute("citasRealizadas", citaDAO.contarPorEstadoYPsicologo("realizada", idPsicologo));
            req.setAttribute("citasPendientes", citaDAO.contarPorEstadoYPsicologo("pendiente", idPsicologo));
            req.getRequestDispatcher("/WEB-INF/views/psico/dashboard.jsp").forward(req, resp);
            return;
        }
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            Gson gson = new Gson();
            Usuario u = (Usuario) req.getSession().getAttribute("user");
            int idPsicologo = (u!=null && psicologoDAO.obtenerPorUsuarioId(u.getId())!=null) ? psicologoDAO.obtenerPorUsuarioId(u.getId()).getId() : 0;
            if ("/psico/chart/status".equals(path)) {
                out.print(gson.toJson(new int[]{
                        citaDAO.contarPorEstadoYPsicologo("realizada", idPsicologo),
                        citaDAO.contarPorEstadoYPsicologo("pendiente", idPsicologo),
                        citaDAO.contarPorEstadoYPsicologo("cancelada", idPsicologo)
                }));
                return;
            }
            if ("/psico/chart/mes".equals(path)) {
                int anio = java.time.Year.now().getValue();
                out.print(gson.toJson(citaDAO.citasPorMesPorPsicologo(idPsicologo, anio)));
                return;
            }
        }
    }
}
