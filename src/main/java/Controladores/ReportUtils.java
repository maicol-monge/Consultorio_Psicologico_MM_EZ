package Controladores;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import javax.servlet.http.HttpServletRequest;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class ReportUtils {
    public static java.util.Date[] rango(HttpServletRequest req, int defaultDaysBack) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String desdeStr = req.getParameter("desde");
        String hastaStr = req.getParameter("hasta");
        java.util.Date desde;
        java.util.Date hasta;
        try {
            // Calcular DESDE al inicio del día
            if (desdeStr != null && !desdeStr.isEmpty()) {
                java.util.Date d = sdf.parse(desdeStr);
                Calendar cDesde = Calendar.getInstance();
                cDesde.setTime(d);
                cDesde.set(Calendar.HOUR_OF_DAY, 0);
                cDesde.set(Calendar.MINUTE, 0);
                cDesde.set(Calendar.SECOND, 0);
                cDesde.set(Calendar.MILLISECOND, 0);
                desde = cDesde.getTime();
            } else {
                Calendar cDesde = Calendar.getInstance();
                cDesde.add(Calendar.DAY_OF_MONTH, -defaultDaysBack);
                cDesde.set(Calendar.HOUR_OF_DAY, 0);
                cDesde.set(Calendar.MINUTE, 0);
                cDesde.set(Calendar.SECOND, 0);
                cDesde.set(Calendar.MILLISECOND, 0);
                desde = cDesde.getTime();
            }

            // Calcular HASTA al final del día
            if (hastaStr != null && !hastaStr.isEmpty()) {
                java.util.Date h = sdf.parse(hastaStr);
                Calendar cHasta = Calendar.getInstance();
                cHasta.setTime(h);
                cHasta.set(Calendar.HOUR_OF_DAY, 23);
                cHasta.set(Calendar.MINUTE, 59);
                cHasta.set(Calendar.SECOND, 59);
                cHasta.set(Calendar.MILLISECOND, 999);
                hasta = cHasta.getTime();
            } else {
                Calendar cHasta = Calendar.getInstance();
                cHasta.set(Calendar.HOUR_OF_DAY, 23);
                cHasta.set(Calendar.MINUTE, 59);
                cHasta.set(Calendar.SECOND, 59);
                cHasta.set(Calendar.MILLISECOND, 999);
                hasta = cHasta.getTime();
            }

            // Si por error el rango viene invertido, intercambiar
            if (desde.after(hasta)) {
                java.util.Date tmp = desde; desde = hasta; hasta = tmp;
            }
        } catch (ParseException e) {
            // En caso de error de parseo, usar último "defaultDaysBack" días
            Calendar cHasta = Calendar.getInstance();
            cHasta.set(Calendar.HOUR_OF_DAY, 23);
            cHasta.set(Calendar.MINUTE, 59);
            cHasta.set(Calendar.SECOND, 59);
            cHasta.set(Calendar.MILLISECOND, 999);
            hasta = cHasta.getTime();

            Calendar cDesde = Calendar.getInstance();
            cDesde.add(Calendar.DAY_OF_MONTH, -defaultDaysBack);
            cDesde.set(Calendar.HOUR_OF_DAY, 0);
            cDesde.set(Calendar.MINUTE, 0);
            cDesde.set(Calendar.SECOND, 0);
            cDesde.set(Calendar.MILLISECOND, 0);
            desde = cDesde.getTime();
        }
        return new java.util.Date[]{desde, hasta};
    }

    public static void addTable(Document doc, String title, String[] headers, java.util.List<String[]> rows) throws DocumentException {
        if (title != null && !title.isEmpty()) {
            Paragraph p = new Paragraph(title, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14));
            p.setSpacingAfter(10);
            doc.add(p);
        }
        PdfPTable table = new PdfPTable(headers.length);
        table.setWidthPercentage(100);
        for (String h : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(h, FontFactory.getFont(FontFactory.HELVETICA_BOLD, 10)));
            cell.setBackgroundColor(new java.awt.Color(230,230,230));
            table.addCell(cell);
        }
        for (String[] row : rows) {
            for (String col : row) table.addCell(new Phrase(col == null ? "" : col));
        }
        doc.add(table);
    }
}
