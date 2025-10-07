package Controladores;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Asegurar UTF-8 en todas las peticiones y respuestas
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        if (response instanceof HttpServletResponse) {
            HttpServletResponse resp = (HttpServletResponse) response;
            // Solo establece content-type si no está ya establecido por la vista
            String ct = resp.getContentType();
            if (ct == null || !ct.toLowerCase().contains("charset")) {
                resp.setContentType("text/html; charset=UTF-8");
            }
        }
        chain.doFilter(request, response);
    }
}
