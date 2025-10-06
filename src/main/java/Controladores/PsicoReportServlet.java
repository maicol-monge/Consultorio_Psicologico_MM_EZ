package Controladores;

import Modelos.Usuario;
import ModelosDAO.CitaDAO;
import ModelosDAO.PsicologoDAO;
import ModelosDAO.EvaluacionDAO;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Optional;

@WebServlet(name = "PsicoReportServlet", urlPatterns = {
        "/psico/report/sesionesPorRango",
        "/psico/report/citasPorMes",
        "/psico/report/resumenEvaluaciones"
})
public class PsicoReportServlet extends HttpServlet {
    private final CitaDAO citaDAO = new CitaDAO();
    private final PsicologoDAO psicologoDAO = new PsicologoDAO();
    private final EvaluacionDAO evaluacionDAO = new EvaluacionDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Usuario u = (Usuario) req.getSession().getAttribute("user");
        if (u == null) { resp.sendRedirect(req.getContextPath()+"/login.jsp"); return; }
        int idPsicologo = Optional.ofNullable(psicologoDAO.obtenerPorUsuarioId(u.getId())).map(p->p.getId()).orElse(0);
        String format = Optional.ofNullable(req.getParameter("format")).orElse("pdf");
        String path = req.getServletPath();
        if (path.endsWith("sesionesPorRango")) {
            java.util.Date[] r = ReportUtils.rango(req, 30);
            int realizadas = citaDAO.contarPorEstadoYPsicologo("realizada", idPsicologo);
            int pendientes = citaDAO.contarPorEstadoYPsicologo("pendiente", idPsicologo);
            String[] headers = {"Estado","Cantidad"};
            List<String[]> rows = java.util.Arrays.asList(new String[]{"Realizadas", String.valueOf(realizadas)}, new String[]{"Pendientes", String.valueOf(pendientes)});
            String titulo = "Sesiones por rango (" + r[0] + " a " + r[1] + ")";
            if ("xlsx".equalsIgnoreCase(format)) { excel(resp, titulo, headers, rows); return; }
            pdf(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("citasPorMes")) {
            int anio = java.time.Year.now().getValue();
            Map<String,Integer> datos = citaDAO.citasPorMesPorPsicologo(idPsicologo, anio);
            String[] headers = {"Mes","Citas"};
            List<String[]> rows = new ArrayList<>();
            for (Map.Entry<String,Integer> e : datos.entrySet()) rows.add(new String[]{e.getKey(), String.valueOf(e.getValue())});
            String titulo = "Citas por mes";
            if ("xlsx".equalsIgnoreCase(format)) { excel(resp, titulo, headers, rows); return; }
            pdf(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("resumenEvaluaciones")) {
            java.util.Date[] r = ReportUtils.rango(req, 90);
            EvaluacionDAO.ResumenEval re = evaluacionDAO.resumenPorPsicologoYRango(idPsicologo, r[0], r[1]);
            String[] headers = {"Cantidad evaluaciones","Promedio estado emocional"};
            List<String[]> rows = new java.util.ArrayList<>();
            rows.add(new String[]{String.valueOf(re.cantidad), String.format(Locale.US, "%.2f", re.promedio)});
            String titulo = "Resumen de evaluaciones";
            if ("xlsx".equalsIgnoreCase(format)) { excel(resp, titulo, headers, rows); return; }
            pdf(resp, titulo, headers, rows); return;
        }
        resp.sendError(404);
    }

    private void pdf(HttpServletResponse resp, String titulo, String[] headers, List<String[]> rows) throws IOException {
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=reporte.pdf");
        try {
            Document doc = new Document(PageSize.A4);
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();
            ReportUtils.addTable(doc, titulo, headers, rows);
            doc.close();
        } catch (Exception e) { throw new IOException(e); }
    }
    private void excel(HttpServletResponse resp, String titulo, String[] headers, List<String[]> rows) throws IOException {
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=reporte.xlsx");
        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("Reporte");
            int r = 0;
            org.apache.poi.ss.usermodel.Row rtitle = sh.createRow(r++); rtitle.createCell(0).setCellValue(titulo);
            org.apache.poi.ss.usermodel.Row rh = sh.createRow(r++);
            for (int i=0;i<headers.length;i++) rh.createCell(i).setCellValue(headers[i]);
            for (String[] row : rows) {
                org.apache.poi.ss.usermodel.Row rr = sh.createRow(r++);
                for (int i=0;i<row.length;i++) rr.createCell(i).setCellValue(row[i]);
            }
            wb.write(resp.getOutputStream());
        }
    }
}
