package Controladores;

import Modelos.Usuario;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.Normalizer;

@WebFilter(filterName = "AuthFilter", urlPatterns = {"/admin/*", "/psico/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
    HttpSession session = req.getSession(false);
    Usuario u = (session != null) ? (Usuario) session.getAttribute("user") : null;
    // Use URI without context path for robust matching
    String uri = req.getRequestURI();
    String ctx = req.getContextPath();
    String path = (uri != null && ctx != null && uri.startsWith(ctx)) ? uri.substring(ctx.length()) : req.getServletPath();
        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        String rol = "";
        if (u.getRol() != null) {
            String raw = u.getRol();
            String withoutDiacritics = Normalizer.normalize(raw, Normalizer.Form.NFD).replaceAll("\\p{M}", "");
            rol = withoutDiacritics.trim().toLowerCase();
        }
        if (path != null && path.startsWith("/admin/") && !"admin".equals(rol)) {
            resp.sendError(403);
            return;
        }
        if (path != null && path.startsWith("/psico/") && !"psicologo".equals(rol)) {
            resp.sendError(403);
            return;
        }
        chain.doFilter(request, response);
    }
}
