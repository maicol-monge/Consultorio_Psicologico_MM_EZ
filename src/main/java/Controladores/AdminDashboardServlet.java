package Controladores;

import ModelosDAO.CitaDAO;
import ModelosDAO.PagoDAO;
import ModelosDAO.UsuarioDAO;
import com.google.gson.Gson;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.Year;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", urlPatterns = {"/admin/dashboard", 
    "/admin/chart/citas", 
    "/admin/chart/ingresos",
    "/admin/chart/usuarios",
    "/admin/chart/citas_status"})
public class AdminDashboardServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final CitaDAO citaDAO = new CitaDAO();
    private final PagoDAO pagoDAO = new PagoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/dashboard".equals(path)) {
            req.setAttribute("usuariosActivos", usuarioDAO.contarUsuariosPorEstado("activo"));
            req.setAttribute("usuariosInactivos", usuarioDAO.contarUsuariosPorEstado("inactivo"));
            req.setAttribute("citasRealizadas", citaDAO.contarPorEstado("realizada"));
            req.setAttribute("citasCanceladas", citaDAO.contarPorEstado("cancelada"));
            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
            return;
        }
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter out = resp.getWriter()) {
            Gson gson = new Gson();
            if ("/admin/chart/citas".equals(path)) {
                Map<String,Integer> porPsicologo = citaDAO.citasPorPsicologo();
                out.print(gson.toJson(porPsicologo));
                return;
            }
            if ("/admin/chart/ingresos".equals(path)) {
                int anio = Year.now().getValue();
                Map<String, Double> ingresos = pagoDAO.ingresosPorMes(anio);
                out.print(gson.toJson(ingresos));
                return;
            }
            if ("/admin/chart/usuarios".equals(path)) {
                out.print(gson.toJson(new int[]{
                        usuarioDAO.contarUsuariosPorEstado("activo"),
                        usuarioDAO.contarUsuariosPorEstado("inactivo")
                }));
                return;
            }
            if ("/admin/chart/citas_status".equals(path)) {
                out.print(gson.toJson(new int[]{
                        citaDAO.contarPorEstado("realizada"),
                        citaDAO.contarPorEstado("pendiente"),
                        citaDAO.contarPorEstado("cancelada")
                }));
                return;
            }
        }
    }
}
