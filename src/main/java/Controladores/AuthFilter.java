package Controladores;

import Modelos.Usuario;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/psico/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        Usuario u = (session != null) ? (Usuario) session.getAttribute("user") : null;
        String path = req.getServletPath();
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        if (path.startsWith("/admin/") && !"admin".equals(u.getRol())) {
            resp.sendError(403);
            return;
        }
        if (path.startsWith("/psico/") && !"psicologo".equals(u.getRol())) {
            resp.sendError(403);
            return;
        }
        chain.doFilter(request, response);
    }
}
