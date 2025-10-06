package Controladores;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        procesarLogout(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        procesarLogout(request, response);
    }
    
    private void procesarLogout(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Obtener la sesión actual
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Invalidar la sesión
            session.invalidate();
        }
        
        // Redirigir al login con mensaje de logout exitoso
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=logout_success");
    }
}