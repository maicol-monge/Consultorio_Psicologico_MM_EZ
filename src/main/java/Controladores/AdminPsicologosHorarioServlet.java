package Controladores;

import Modelos.HorarioPsicologico;
import Modelos.Psicologo;
import ModelosDAO.HorarioPsicologicoDAO;
import ModelosDAO.PsicologoDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Time;
import java.util.List;

@WebServlet(name = "AdminPsicologosHorarioServlet", urlPatterns = {
        "/admin/psicologos"
})
public class AdminPsicologosHorarioServlet extends HttpServlet {
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();
    private final HorarioPsicologicoDAO horarioDAO = new HorarioPsicologicoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String idPsicoStr = req.getParameter("psicologo");
        List<Psicologo> psicologos = psicologoDAO.listarTodos();
        req.setAttribute("psicologos", psicologos);

        if (idPsicoStr != null && !idPsicoStr.isEmpty()) {
            int idPsico = Integer.parseInt(idPsicoStr);
            req.setAttribute("idPsicologo", idPsico);
            req.setAttribute("horarios", horarioDAO.listarPorPsicologo(idPsico));
        }

        req.getRequestDispatcher("/WEB-INF/views/admin/psicologos/horarios.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String idPsicoStr = req.getParameter("id_psicologo");
        int idPsicologo = idPsicoStr != null && !idPsicoStr.isEmpty() ? Integer.parseInt(idPsicoStr) : 0;

        if ("guardar".equals(action)) {
            String idStr = req.getParameter("id");
            String dia = req.getParameter("dia_semana");
            Time inicio = Time.valueOf(req.getParameter("hora_inicio") + ":00"); // HH:mm
            Time fin = Time.valueOf(req.getParameter("hora_fin") + ":00");
            String estado = req.getParameter("estado");

            HorarioPsicologico h = new HorarioPsicologico();
            h.setIdPsicologo(idPsicologo);
            h.setDiaSemana(dia);
            h.setHoraInicio(inicio);
            h.setHoraFin(fin);
            h.setEstado(estado != null ? estado : "activo");

            boolean ok;
            if (idStr != null && !idStr.isEmpty()) {
                h.setId(Integer.parseInt(idStr));
                ok = horarioDAO.actualizar(h);
            } else {
                ok = horarioDAO.insertar(h);
            }
            req.setAttribute(ok ? "success" : "error", ok ? "Horario guardado" : "Traslape detectado o datos inválidos");
        } else if ("eliminar".equals(action)) {
            String idStr = req.getParameter("id");
            if (idStr != null && !idStr.isEmpty()) {
                horarioDAO.eliminar(Integer.parseInt(idStr));
                req.setAttribute("success", "Horario eliminado");
            }
        } else if ("cambiar-estado".equals(action)) {
            String idStr = req.getParameter("id");
            String estado = req.getParameter("estado");
            if (idStr != null && estado != null) {
                horarioDAO.cambiarEstado(Integer.parseInt(idStr), estado);
                req.setAttribute("success", "Estado actualizado");
            }
        }

        List<Psicologo> psicologos = psicologoDAO.listarTodos();
        req.setAttribute("psicologos", psicologos);
        if (idPsicologo > 0) {
            req.setAttribute("idPsicologo", idPsicologo);
            req.setAttribute("horarios", horarioDAO.listarPorPsicologo(idPsicologo));
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/psicologos/horarios.jsp").forward(req, resp);
    }
}
