package Controladores;

import Modelos.Cita;
import Modelos.Pago;
import ModelosDAO.CitaDAO;
import ModelosDAO.PagoDAO;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.util.Map;
import java.util.Optional;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "AdminReportServlet", urlPatterns = {
        "/admin/report/pacientesPorPsicologo",
        "/admin/report/citasPorRango",
        "/admin/report/pagosPendientes"
})
public class AdminReportServlet extends HttpServlet {
    private final CitaDAO citaDAO = new CitaDAO();
    private final PagoDAO pagoDAO = new PagoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String format = Optional.ofNullable(req.getParameter("format")).orElse("pdf");
        if (path.endsWith("pacientesPorPsicologo")) {
            Map<String,Integer> datos = citaDAO.pacientesAtendidosPorPsicologo();
            String titulo = "Pacientes atendidos por psicólogo";
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, new String[]{"Psicólogo","Pacientes"}, toRows(datos)); return; }
            pdfSimple(resp, titulo, new String[]{"Psicólogo","Pacientes"}, toRows(datos)); return;
        }
        if (path.endsWith("citasPorRango")) {
            java.util.Date[] r = ReportUtils.rango(req, 30);
            List<Cita> citas = citaDAO.listarPorRango(r[0], r[1]);
            String[] headers = {"ID","Paciente","Psicólogo","Fecha","Estado"};
            List<String[]> rows = new ArrayList<>();
            for (Cita c : citas) rows.add(new String[]{String.valueOf(c.getId()), String.valueOf(c.getIdPaciente()), String.valueOf(c.getIdPsicologo()), String.valueOf(c.getFechaHora()), c.getEstadoCita()});
            String titulo = "Citas del " + r[0] + " al " + r[1];
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("pagosPendientes")) {
            List<Pago> list = pagoDAO.listarPendientes();
            String[] headers = {"ID","Cita","Monto Base","Monto Total","Estado"};
            List<String[]> rows = new ArrayList<>();
            for (Pago p : list) rows.add(new String[]{String.valueOf(p.getId()), String.valueOf(p.getIdCita()), String.valueOf(p.getMontoBase()), String.valueOf(p.getMontoTotal()), p.getEstadoPago()});
            String titulo = "Pagos pendientes";
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        resp.sendError(404);
    }

    private List<String[]> toRows(Map<String,?> map){
        List<String[]> rows = new ArrayList<>();
        for (Map.Entry<String,? extends Object> e : map.entrySet()) rows.add(new String[]{e.getKey(), String.valueOf(e.getValue())});
        return rows;
    }

    private void pdfSimple(HttpServletResponse resp, String titulo, String[] headers, List<String[]> rows) throws IOException {
        resp.setContentType("application/pdf");
        resp.setHeader("Content-Disposition", "attachment; filename=reporte.pdf");
        try {
            Document doc = new Document(PageSize.A4.rotate());
            PdfWriter.getInstance(doc, resp.getOutputStream());
            doc.open();
            ReportUtils.addTable(doc, titulo, headers, rows);
            doc.close();
        } catch (Exception e) { throw new IOException(e); }
    }

    private void excelSimple(HttpServletResponse resp, String titulo, String[] headers, List<String[]> rows) throws IOException {
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
