package Controladores;

import Modelos.Paciente;
import ModelosDAO.PacienteDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "AdminPacientesServlet", urlPatterns = {
    "/admin/pacientes", "/admin/pacientes/nuevo", "/admin/pacientes/editar",
    "/admin/pacientes/guardar", "/admin/pacientes/buscar",
    "/admin/pacientes/ver", "/admin/pacientes/cambiar-estado"
})
public class AdminPacientesServlet extends HttpServlet {
    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        
        if ("/admin/pacientes".equals(path)) {
            // Soportar búsqueda simple con el parámetro 'buscar'
            String busqueda = req.getParameter("buscar");
            List<Paciente> pacientes;
            
            if (busqueda != null && !busqueda.trim().isEmpty()) {
                pacientes = pacienteDAO.buscar(busqueda.trim());
                req.setAttribute("busqueda", busqueda);
            } else {
                pacientes = pacienteDAO.listarTodos();
            }
            
            req.setAttribute("pacientes", pacientes);
            // Usar wrapper existente 'index.jsp' que incluye el layout y el contenido
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/index.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/pacientes/nuevo".equals(path)) {
            // Usar wrapper existente 'nuevo.jsp'
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/nuevo.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/pacientes/editar".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Paciente paciente = pacienteDAO.obtenerPorId(id);
            if (paciente == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/pacientes?error=Paciente no encontrado");
                return;
            }
            req.setAttribute("paciente", paciente);
            // Usar wrapper existente 'editar.jsp'
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/editar.jsp").forward(req, resp);
            return;
        }

        if ("/admin/pacientes/ver".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Paciente paciente = pacienteDAO.obtenerPorId(id);
            if (paciente == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/pacientes?error=Paciente no encontrado");
                return;
            }
            req.setAttribute("paciente", paciente);
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/ver.jsp").forward(req, resp);
            return;
        }
        
    resp.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        
    if ("/admin/pacientes/guardar".equals(path)) {
            String idStr = req.getParameter("id");
            String nombre = req.getParameter("nombre");
            String email = req.getParameter("email");
            String telefono = req.getParameter("telefono");
            String direccion = req.getParameter("direccion");
            String estado = req.getParameter("estado");
            String dui = req.getParameter("dui");
            String fechaNacStr = req.getParameter("fecha_nacimiento");
            String genero = req.getParameter("genero");
            String historialClinico = req.getParameter("historial_clinico");
            
            Paciente paciente = new Paciente();
            paciente.setNombre(nombre);
            paciente.setEmail(email);
            paciente.setTelefono(telefono);
            paciente.setDireccion(direccion);
            paciente.setEstado(estado);
            paciente.setDui(dui);
            paciente.setGenero(genero);
            paciente.setHistorialClinico(historialClinico);
            
            try {
                if (fechaNacStr != null && !fechaNacStr.isEmpty()) {
                    paciente.setFechaNacimiento(sdf.parse(fechaNacStr));
                }
            } catch (ParseException e) {
                req.setAttribute("error", "Fecha de nacimiento inválida");
                List<Paciente> pacientes = pacienteDAO.listarTodos();
                req.setAttribute("pacientes", pacientes);
                req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/index.jsp").forward(req, resp);
                return;
            }
            
            boolean exito;
            if (idStr != null && !idStr.isEmpty()) {
                // Actualizar
                paciente.setId(Integer.parseInt(idStr));
                exito = pacienteDAO.actualizar(paciente);
            } else {
                // Insertar - generar código de acceso
                paciente.setCodigoAcceso(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                exito = pacienteDAO.insertar(paciente);
            }
            
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            req.setAttribute("pacientes", pacientes);
            req.setAttribute(exito ? "success" : "error", exito ? "Paciente guardado correctamente" : "Error al guardar paciente");
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/index.jsp").forward(req, resp);
            return;
        }

        if ("/admin/pacientes/cambiar-estado".equals(path)) {
            String idStr = req.getParameter("id");
            String nuevoEstado = req.getParameter("estado");
            boolean exito = false;
            if (idStr != null) {
                int id = Integer.parseInt(idStr);
                Paciente p = pacienteDAO.obtenerPorId(id);
                if (p != null) {
                    p.setEstado(nuevoEstado);
                    exito = pacienteDAO.actualizar(p);
                }
            }
            List<Paciente> pacientes = pacienteDAO.listarTodos();
            req.setAttribute("pacientes", pacientes);
            req.setAttribute(exito ? "success" : "error", exito ? "Estado actualizado" : "No se pudo actualizar el estado");
            req.getRequestDispatcher("/WEB-INF/views/admin/pacientes/index.jsp").forward(req, resp);
            return;
        }
        
        resp.sendError(404);
    }
}