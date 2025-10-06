package Controladores;

import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.pdf.PdfWriter;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;

@WebServlet(name = "ExportServlet", urlPatterns = {"/export/pdf", "/export/excel"})
public class ExportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String type = req.getServletPath().endsWith("excel") ? "excel" : "pdf";
        String name = req.getParameter("name");
        if (name == null) name = "reporte";
        if ("pdf".equals(type)) {
            resp.setContentType("application/pdf");
            resp.setHeader("Content-Disposition", "attachment; filename=" + name + ".pdf");
            try {
                Document document = new Document(PageSize.A4);
                PdfWriter.getInstance(document, resp.getOutputStream());
                document.open();
                document.add(new Paragraph("Reporte: " + name));
                document.add(new Paragraph("Este es un ejemplo de PDF exportado."));
                document.close();
            } catch (Exception e) { throw new IOException(e); }
            return;
        }
        // Excel
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=" + name + ".xlsx");
        try (Workbook wb = new XSSFWorkbook()) {
            Sheet sh = wb.createSheet("Datos");
            org.apache.poi.ss.usermodel.Row r0 = sh.createRow(0); r0.createCell(0).setCellValue("Columna A"); r0.createCell(1).setCellValue("Columna B");
            org.apache.poi.ss.usermodel.Row r1 = sh.createRow(1); r1.createCell(0).setCellValue("Ejemplo"); r1.createCell(1).setCellValue(123);
            wb.write(resp.getOutputStream());
        }
    }
}
