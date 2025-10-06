package Controladores;

import Modelos.Pago;
import Modelos.TicketPago;
import Modelos.Cita;
import Modelos.Paciente;
import ModelosDAO.PagoDAOCompleto;
import ModelosDAO.TicketDAOCompleto;
import ModelosDAO.CitaDAO;
import ModelosDAO.PacienteDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import java.util.Date;
import java.math.BigDecimal;
import java.util.UUID;

@WebServlet(name = "AdminPagosServlet", urlPatterns = {"/admin/pagos", "/admin/pagos/*"})
public class AdminPagosServlet extends HttpServlet {
    
    private PagoDAOCompleto pagoDAO;
    private TicketDAOCompleto ticketDAO;
    private CitaDAO citaDAO;
    private PacienteDAO pacienteDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            pagoDAO = new PagoDAOCompleto();
            ticketDAO = new TicketDAOCompleto();
            citaDAO = new CitaDAO();
            pacienteDAO = new PacienteDAO();
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
                listarPagos(request, response);
            } else if (pathInfo.equals("/nuevo")) {
                mostrarFormularioNuevo(request, response);
            } else if (pathInfo.equals("/tickets")) {
                listarTickets(request, response);
            } else if (pathInfo.startsWith("/ticket/")) {
                verTicket(request, response);
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
                if (pathInfo.equals("/registrar")) {
                    registrarPago(request, response);
                } else if (pathInfo.equals("/generar-ticket")) {
                    generarTicket(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void listarPagos(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            String metodo = request.getParameter("metodo");
            String pacienteId = request.getParameter("paciente");
            
            List<Pago> pagos = pagoDAO.buscarConFiltros(fechaInicio, fechaFin, metodo, 
                pacienteId != null && !pacienteId.isEmpty() ? Integer.parseInt(pacienteId) : null);
            
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            
            request.setAttribute("pagos", pagos);
            request.setAttribute("pacientes", pacientes);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/pagos/index.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void mostrarFormularioNuevo(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            List<Cita> citasPendientes = citaDAO.listarPorRango(
                new Date(System.currentTimeMillis() - 30L * 24 * 60 * 60 * 1000), // 30 días atrás
                new Date()
            );
            
            request.setAttribute("pacientes", pacientes);
            request.setAttribute("citasPendientes", citasPendientes);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/pagos/nuevo.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void listarTickets(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String fechaInicio = request.getParameter("fechaInicio");
            String fechaFin = request.getParameter("fechaFin");
            
            List<TicketPago> tickets = ticketDAO.buscarConFiltros(fechaInicio, fechaFin);
            
            request.setAttribute("tickets", tickets);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/pagos/tickets.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void verTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String codigoTicket = request.getPathInfo().substring("/ticket/".length());
            
            TicketPago ticket = ticketDAO.buscarPorCodigo(codigoTicket);
            if (ticket == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            request.setAttribute("ticket", ticket);
            request.getRequestDispatcher("/WEB-INF/views/admin/pagos/ticket-detalle.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void registrarPago(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int idPaciente = Integer.parseInt(request.getParameter("idPaciente"));
            Integer idCita = null;
            String citaParam = request.getParameter("idCita");
            if (citaParam != null && !citaParam.isEmpty()) {
                idCita = Integer.parseInt(citaParam);
            }
            
            BigDecimal monto = new BigDecimal(request.getParameter("monto"));
            String metodoPago = request.getParameter("metodoPago");
            String concepto = request.getParameter("concepto");
            String observaciones = request.getParameter("observaciones");
            boolean generarTicket = "on".equals(request.getParameter("generarTicket"));
            
            // Crear el pago
            Pago pago = new Pago();
            pago.setIdPaciente(idPaciente);
            pago.setIdCita(idCita);
            pago.setMonto(monto);
            pago.setMetodoPago(metodoPago);
            pago.setConcepto(concepto);
            pago.setObservaciones(observaciones);
            pago.setFechaPago(new Date());
            pago.setEstado("completado");
            
            boolean success = pagoDAO.crear(pago);
            
            if (success && generarTicket) {
                // Generar ticket
                TicketPago ticket = new TicketPago();
                ticket.setIdPago(pago.getId());
                ticket.setCodigo(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                ticket.setFechaEmision(new Date());
                ticket.setEstado("activo");
                
                ticketDAO.crear(ticket);
                
                response.sendRedirect(request.getContextPath() + "/admin/pagos/ticket/" + ticket.getCodigo());
            } else if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/pagos?success=Pago registrado correctamente");
            } else {
                request.setAttribute("error", "Error al registrar el pago");
                mostrarFormularioNuevo(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void generarTicket(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int idPago = Integer.parseInt(request.getParameter("idPago"));
            
            Pago pago = pagoDAO.buscarPorId(idPago);
            if (pago == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                return;
            }
            
            // Verificar si ya existe un ticket para este pago
            TicketPago ticketExistente = ticketDAO.buscarPorIdPago(idPago);
            if (ticketExistente != null) {
                response.sendRedirect(request.getContextPath() + "/admin/pagos/ticket/" + ticketExistente.getCodigo());
                return;
            }
            
            // Crear nuevo ticket
            TicketPago ticket = new TicketPago();
            ticket.setIdPago(idPago);
            ticket.setCodigo(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            ticket.setFechaEmision(new Date());
            ticket.setEstado("activo");
            
            boolean success = ticketDAO.crear(ticket);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/admin/pagos/ticket/" + ticket.getCodigo());
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/pagos?error=Error al generar ticket");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}