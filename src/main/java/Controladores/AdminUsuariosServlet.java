package Controladores;

import Modelos.Usuario;
import Modelos.Psicologo;
import ModelosDAO.UsuarioDAO;
import ModelosDAO.PsicologoDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminUsuariosServlet", urlPatterns = {
    "/admin/usuarios", "/admin/usuarios/nuevo", "/admin/usuarios/editar", 
    "/admin/usuarios/guardar", "/admin/usuarios/cambiar-estado", "/admin/usuarios/restablecer-password"
})
public class AdminUsuariosServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        
        if ("/admin/usuarios".equals(path)) {
            String q = req.getParameter("q");
            String rol = req.getParameter("rol");
            String estado = req.getParameter("estado");
            List<Usuario> usuarios = (q != null || (rol != null && !rol.isEmpty()) || (estado != null && !estado.isEmpty()))
                    ? usuarioDAO.buscar(q, rol, estado)
                    : usuarioDAO.listarTodos();
            req.setAttribute("usuarios", usuarios);
            req.setAttribute("q", q);
            req.setAttribute("rol", rol);
            req.setAttribute("estado", estado);
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/listar.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/usuarios/nuevo".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/form.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/usuarios/editar".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            Usuario usuario = usuarioDAO.obtenerPorId(id);
            if (usuario == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/usuarios?error=Usuario no encontrado");
                return;
            }
            req.setAttribute("usuario", usuario);
            // Cargar datos de Psicólogo si aplica
            if ("psicologo".equalsIgnoreCase(usuario.getRol())) {
                Psicologo p = psicologoDAO.obtenerPorUsuarioId(usuario.getId());
                if (p != null) {
                    req.setAttribute("psicologo", p);
                }
            }
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/form.jsp").forward(req, resp);
            return;
        }
        
        resp.sendError(404);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();
        
        if ("/admin/usuarios/guardar".equals(path)) {
            String idStr = req.getParameter("id");
            String nombre = req.getParameter("nombre");
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String rol = req.getParameter("rol");
            String estado = req.getParameter("estado");
            
            Usuario usuario = new Usuario();
            usuario.setNombre(nombre);
            usuario.setEmail(email);
            usuario.setPasswordd(password);
            usuario.setRol(rol);
            usuario.setEstado(estado);
            
            boolean exito;
            if (idStr != null && !idStr.isEmpty()) {
                // Actualizar
                usuario.setId(Integer.parseInt(idStr));
                exito = usuarioDAO.actualizar(usuario);
                // Si es psicólogo, actualizar/insertar su información profesional
                if (exito && "psicologo".equals(rol)) {
                    Psicologo existente = psicologoDAO.obtenerPorUsuarioId(usuario.getId());
                    if (existente != null) {
                        existente.setEspecialidad(req.getParameter("especialidad"));
                        existente.setExperiencia(req.getParameter("experiencia"));
                        existente.setHorario(req.getParameter("horario"));
                        // Mantener estado si ya existe
                        if (existente.getEstado() == null || existente.getEstado().isEmpty()) {
                            existente.setEstado("activo");
                        }
                        psicologoDAO.actualizar(existente);
                    } else {
                        Psicologo nuevo = new Psicologo();
                        nuevo.setIdUsuario(usuario.getId());
                        nuevo.setEspecialidad(req.getParameter("especialidad"));
                        nuevo.setExperiencia(req.getParameter("experiencia"));
                        nuevo.setHorario(req.getParameter("horario"));
                        nuevo.setEstado("activo");
                        psicologoDAO.insertar(nuevo);
                    }
                }
            } else {
                // Insertar
                exito = usuarioDAO.insertar(usuario);
                
                // Si es psicólogo, crear registro en tabla Psicologo
                if (exito && "psicologo".equals(rol)) {
                    Psicologo psicologo = new Psicologo();
                    psicologo.setIdUsuario(usuario.getId());
                    psicologo.setEspecialidad(req.getParameter("especialidad"));
                    psicologo.setExperiencia(req.getParameter("experiencia"));
                    psicologo.setHorario(req.getParameter("horario"));
                    psicologo.setEstado("activo");
                    psicologoDAO.insertar(psicologo);
                }
            }
            
            // Mostrar mensaje dinámico sin usar parámetros en la URL
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            req.setAttribute("usuarios", usuarios);
            req.setAttribute(exito ? "success" : "error", exito ? "Usuario guardado correctamente" : "Error al guardar usuario");
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/listar.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/usuarios/cambiar-estado".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String estado = req.getParameter("estado");
            
            boolean exito = usuarioDAO.cambiarEstado(id, estado);
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            req.setAttribute("usuarios", usuarios);
            req.setAttribute(exito ? "success" : "error", exito ? "Estado cambiado correctamente" : "Error al cambiar estado");
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/listar.jsp").forward(req, resp);
            return;
        }
        
        if ("/admin/usuarios/restablecer-password".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String nuevaPassword = req.getParameter("nueva-password");
            
            boolean exito = usuarioDAO.restablecerPassword(id, nuevaPassword);
            List<Usuario> usuarios = usuarioDAO.listarTodos();
            req.setAttribute("usuarios", usuarios);
            req.setAttribute(exito ? "success" : "error", exito ? "Contraseña restablecida correctamente" : "Error al restablecer contraseña");
            req.getRequestDispatcher("/WEB-INF/views/admin/usuarios/listar.jsp").forward(req, resp);
            return;
        }
        
        resp.sendError(404);
    }
}