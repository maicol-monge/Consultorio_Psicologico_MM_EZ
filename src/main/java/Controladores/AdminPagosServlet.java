package Controladores;

import Modelos.Cita;
import Modelos.Pago;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.TicketPagoDAO;
import Modelos.TicketPago;
import ModelosDAO.PagoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.UUID;
import java.util.List;

@WebServlet(name = "AdminPagosServlet", urlPatterns = {"/admin/pagos", "/admin/pagos/*", "/admin/tickets", "/admin/tickets/*"})
public class AdminPagosServlet extends HttpServlet {
    private PagoDAO pagoDAO;
    private CitaDAOCompleto citaDAO;
    private TicketPagoDAO ticketPagoDAO;

    @Override
    public void init() throws ServletException {
        try {
            pagoDAO = new PagoDAO();
            citaDAO = new CitaDAOCompleto();
            ticketPagoDAO = new TicketPagoDAO();
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String path = req.getPathInfo();
        if ("/admin/tickets".equals(servletPath)) {
            if (path == null || "/".equals(path)) {
                listarTickets(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            }
            return;
        }
        if (path == null || "/".equals(path)) {
            listar(req, resp);
        } else if ("/nuevo".equals(path)) {
            mostrarNuevo(req, resp);
        } else if ("/pendientes".equals(path)) {
            listarPendientes(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String servletPath = req.getServletPath();
        String path = req.getPathInfo();
        if ("/admin/tickets".equals(servletPath)) {
            if ("/emitir".equals(path)) {
                emitirTicket(req, resp);
                return;
            }
            resp.sendError(404);
            return;
        }
        if (path == null) { resp.sendError(404); return; }
        switch (path) {
            case "/crear": crear(req, resp); break;
            case "/marcar-pagado": marcarPagado(req, resp); break;
            default: resp.sendError(404);
        }
    }

    private void listar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    String fechaInicio = req.getParameter("fechaInicio");
    String fechaFin = req.getParameter("fechaFin");
    String estadoPago = req.getParameter("estadoPago");
    String paciente = req.getParameter("paciente");
    String psicologo = req.getParameter("psicologo");

    boolean hasFilters = (fechaInicio != null && !fechaInicio.isEmpty()) ||
        (fechaFin != null && !fechaFin.isEmpty()) ||
        (estadoPago != null && !estadoPago.isEmpty()) ||
        (paciente != null && !paciente.isEmpty()) ||
        (psicologo != null && !psicologo.isEmpty());

    List<Pago> pagos = hasFilters
        ? pagoDAO.listarFiltrado(fechaInicio, fechaFin, estadoPago != null && !estadoPago.isEmpty() ? estadoPago.toLowerCase() : null, paciente, psicologo)
        : pagoDAO.listar(null);

    req.setAttribute("pagos", pagos);
    // Keep filter values to persist in the form
    req.setAttribute("fechaInicio", fechaInicio);
    req.setAttribute("fechaFin", fechaFin);
    req.setAttribute("estadoPagoFiltro", estadoPago);
    req.setAttribute("pacienteFiltro", paciente);
    req.setAttribute("psicologoFiltro", psicologo);
    req.getRequestDispatcher("/WEB-INF/views/admin/pagos/list.jsp").forward(req, resp);
    }

    private void listarPendientes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Pago> pagos = pagoDAO.listar("pendiente");
        req.setAttribute("pagos", pagos);
        req.getRequestDispatcher("/WEB-INF/views/admin/pagos/pendientes.jsp").forward(req, resp);
    }

    private void mostrarNuevo(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String idCitaStr = req.getParameter("cita");
            Cita cita = null;
            if (idCitaStr != null && !idCitaStr.isEmpty()) {
                cita = citaDAO.buscarPorId(Integer.parseInt(idCitaStr));
            }
            req.setAttribute("cita", cita);
            // Filtros para las citas en el formulario (solo realizadas)
            String fIni = req.getParameter("fIni");
            String fFin = req.getParameter("fFin");
            String pLike = req.getParameter("p");
            String sLike = req.getParameter("s");
            List<Cita> citas = citaDAO.listarParaPagoFiltrado(fIni, fFin, pLike, sLike);
            req.setAttribute("citas", citas);
            req.setAttribute("fIni", fIni);
            req.setAttribute("fFin", fFin);
            req.setAttribute("pLike", pLike);
            req.setAttribute("sLike", sLike);
            req.getRequestDispatcher("/WEB-INF/views/admin/pagos/form.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void crear(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String idCita = req.getParameter("idCita");
            String montoBase = req.getParameter("montoBase");
            String montoTotal = req.getParameter("montoTotal");
            String estadoPago = req.getParameter("estadoPago");
            Pago p = new Pago();
            p.setIdCita(idCita != null && !idCita.isEmpty() ? Integer.parseInt(idCita) : null);
            p.setMontoBase(montoBase != null && !montoBase.isEmpty() ? new BigDecimal(montoBase) : BigDecimal.ZERO);
            p.setMontoTotal(montoTotal != null && !montoTotal.isEmpty() ? new BigDecimal(montoTotal) : p.getMontoBase());
            p.setFecha(new Date());
            p.setEstadoPago((estadoPago != null && !estadoPago.isEmpty()) ? estadoPago.toLowerCase() : "pagado");
            p.setEstado("activo");
            boolean ok = pagoDAO.crear(p);
            if (ok) {
                // Si el pago quedó como pagado, generar ticket inmediatamente
                if ("pagado".equalsIgnoreCase(p.getEstadoPago())) {
                    try {
                        String numero = String.format("T%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS-%2$d", new Date(), p.getId());
                        String codigo = "PG-" + p.getId() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
                        String qr = "PAGO:" + p.getId();
                        TicketPago t = new TicketPago();
                        t.setIdPago(p.getId());
                        t.setNumeroTicket(numero);
                        t.setCodigo(codigo);
                        t.setQrCode(qr);
                        t.setEstado("activo");
                        ticketPagoDAO.crear(t);
                        resp.sendRedirect(req.getContextPath() + "/ticket?n=" + numero);
                        return;
                    } catch (Exception ex) {
                        // Si falla la emisión de ticket, continuar a la lista con aviso
                        resp.sendRedirect(req.getContextPath() + "/admin/pagos?success=Pago registrado (ticket no emitido)");
                        return;
                    }
                }
                resp.sendRedirect(req.getContextPath() + "/admin/pagos?success=Pago registrado");
            } else {
                req.setAttribute("error", "No se pudo registrar el pago");
                mostrarNuevo(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void marcarPagado(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        boolean ok = pagoDAO.marcarPagado(id);
        resp.sendRedirect(req.getContextPath() + "/admin/pagos?" + (ok ? "success=Pago marcado como pagado" : "error=No se pudo actualizar"));
    }

    private void listarTickets(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Por ahora, redirigir a listado de pagos con estado pagado como tickets disponibles
        List<Pago> pagos = pagoDAO.listar("pagado");
        req.setAttribute("pagos", pagos);
        req.getRequestDispatcher("/WEB-INF/views/admin/tickets/list.jsp").forward(req, resp);
    }

    private void emitirTicket(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            int idPago = Integer.parseInt(req.getParameter("idPago"));
            Pago p = pagoDAO.obtener(idPago);
            if (p == null) { resp.sendError(404, "Pago no encontrado"); return; }
            if (!"pagado".equalsIgnoreCase(p.getEstadoPago())) {
                resp.sendRedirect(req.getContextPath()+"/admin/pagos?error=Solo se emiten tickets de pagos pagados");
                return;
            }
            // Ver si ya existe ticket
            TicketPago existente = ticketPagoDAO.obtenerPorPago(idPago);
            if (existente != null && existente.getNumeroTicket() != null) {
                resp.sendRedirect(req.getContextPath()+"/ticket?n="+existente.getNumeroTicket());
                return;
            }
            String numero = String.format("T%1$tY%1$tm%1$td-%1$tH%1$tM%1$tS-%2$d", new Date(), p.getId());
            String codigo = "PG-" + p.getId() + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            String qr = "PAGO:" + p.getId();
            TicketPago t = new TicketPago();
            t.setIdPago(p.getId());
            t.setNumeroTicket(numero);
            t.setCodigo(codigo);
            t.setQrCode(qr);
            t.setEstado("activo");
            ticketPagoDAO.crear(t);
            resp.sendRedirect(req.getContextPath()+"/ticket?n="+numero);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}