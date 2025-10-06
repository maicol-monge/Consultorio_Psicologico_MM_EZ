package Controladores;

import Modelos.Usuario;
import ModelosDAO.UsuarioDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "AuthServlet", urlPatterns = {"/auth"})
public class AuthServlet extends HttpServlet {
    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("login".equals(action)) {
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            Usuario u = usuarioDAO.login(email, password);
            if (u != null) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", u);
                if ("admin".equals(u.getRol())) resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
                else resp.sendRedirect(req.getContextPath() + "/psico/dashboard");
            } else {
                req.setAttribute("error", "Credenciales inválidas");
                req.getRequestDispatcher("/login.jsp").forward(req, resp);
            }
            return;
        }
        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        resp.sendError(400, "Acción no soportada");
    }
}
