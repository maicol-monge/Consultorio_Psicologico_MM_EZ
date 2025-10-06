package Controladores;

import Modelos.Cita;
import Modelos.Paciente;
import Modelos.Psicologo;
import ModelosDAO.CitaDAOCompleto;
import ModelosDAO.PacienteDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AdminCitasServlet", urlPatterns = {"/admin/citas", "/admin/citas/*"})
public class AdminCitasServlet extends HttpServlet {
    
    private CitaDAOCompleto citaDAO;
    private PacienteDAO pacienteDAO;
    private PsicologoDAO psicologoDAO;
    
    @Override
    public void init() throws ServletException {
        try {
            citaDAO = new CitaDAOCompleto();
            pacienteDAO = new PacienteDAO();
            psicologoDAO = new PsicologoDAO();
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
            request.setAttribute("fechaMinima", new Date());
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
    
    private void mostrarFormularioEditar(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String idStr = request.getPathInfo().substring("/editar/".length());
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
            request.setAttribute("fechaMinima", new Date());
            
            request.getRequestDispatcher("/WEB-INF/views/admin/citas/form.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
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
            
            // Validaciones básicas
            if (idPaciente == null || idPaciente.trim().isEmpty() ||
                idPsicologo == null || idPsicologo.trim().isEmpty() ||
                fecha == null || fecha.trim().isEmpty() ||
                hora == null || hora.trim().isEmpty() ||
                motivoConsulta == null || motivoConsulta.trim().isEmpty()) {
                
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
            cita.setMotivoConsulta(motivoConsulta);
            cita.setEstadoCita(estadoCita != null && !estadoCita.isEmpty() ? estadoCita : "pendiente");
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
    
    private void cambiarEstado(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String estado = request.getParameter("estado");
            
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
            
            Cita cita = citaDAO.buscarPorId(id);
            if (cita != null && citaDAO.verificarDisponibilidad(nuevoIdPsicologo, cita.getFechaHora())) {
                boolean success = citaDAO.reasignarPsicologo(id, nuevoIdPsicologo);
                String mensaje = success ? "Psicólogo reasignado correctamente" : "Error al reasignar psicólogo";
                
                response.sendRedirect(request.getContextPath() + "/admin/citas?" + 
                    (success ? "success" : "error") + "=" + mensaje);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/citas?error=El psicólogo no está disponible en esa fecha");
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