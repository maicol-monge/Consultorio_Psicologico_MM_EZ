package Controladores;

import Modelos.Cita;
import Modelos.Pago;
import Modelos.Usuario;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.PagoDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

@WebServlet(name="PsicoPagosServlet", urlPatterns={
        "/psico/pagos", "/psico/pagos/nuevo", "/psico/pagos/crear"
})
public class PsicoPagosServlet extends HttpServlet {
    private final PagoDAO pagoDAO = new PagoDAO();
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
        if ("/psico/pagos".equals(path)) {
            Usuario u = (Usuario) req.getSession().getAttribute("user");
            // Obtener solo pagos del psicólogo: usar filtro por nombre en DAO y reforzar en memoria
            List<Pago> pagos = pagoDAO.listarFiltrado(null, null, null, null, u != null ? u.getNombre() : null);
            if (u != null) pagos.removeIf(p -> p.getPsicologoNombre()==null || !p.getPsicologoNombre().equals(u.getNombre()));
            req.setAttribute("pagos", pagos);
            req.getRequestDispatcher("/WEB-INF/views/psico/pagos/index.jsp").forward(req, resp);
            return;
        }
        if ("/psico/pagos/nuevo".equals(path)) {
            // Solo citas realizadas del psicólogo
            List<Cita> citas = citaDAO.buscarConFiltros(null, null, "realizada", null, idPs);
            req.setAttribute("citas", citas);
            req.getRequestDispatcher("/WEB-INF/views/psico/pagos/form.jsp").forward(req, resp);
            return;
        }
        resp.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/psico/pagos/crear".equals(path)) {
            try {
                int idCita = Integer.parseInt(req.getParameter("idCita"));
                BigDecimal montoBase = new BigDecimal(Optional.ofNullable(req.getParameter("montoBase")).orElse("0"));
                BigDecimal montoTotal = new BigDecimal(Optional.ofNullable(req.getParameter("montoTotal")).orElse("0"));
                Pago p = new Pago();
                p.setIdCita(idCita);
                p.setMontoBase(montoBase);
                p.setMontoTotal(montoTotal);
                p.setEstadoPago("pendiente"); // SIEMPRE pendiente; admin confirma
                boolean ok = pagoDAO.crear(p);
                req.getSession().setAttribute(ok?"success":"error", ok?"Pago registrado en pendiente":"No se pudo registrar el pago");
                resp.sendRedirect(req.getContextPath()+"/psico/pagos");
                return;
            } catch (Exception e) {
                req.getSession().setAttribute("error","Datos inválidos: "+e.getMessage());
                resp.sendRedirect(req.getContextPath()+"/psico/pagos/nuevo");
                return;
            }
        }
        resp.sendError(404);
    }
}
