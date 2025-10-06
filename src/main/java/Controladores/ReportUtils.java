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
        Calendar cal = Calendar.getInstance();
        java.util.Date hasta;
        java.util.Date desde;
        try {
            if (hastaStr != null) hasta = sdf.parse(hastaStr); else hasta = cal.getTime();
            if (desdeStr != null) desde = sdf.parse(desdeStr); else { cal.add(Calendar.DAY_OF_MONTH, -defaultDaysBack); desde = cal.getTime(); }
        } catch (ParseException e) { cal = Calendar.getInstance(); hasta = cal.getTime(); cal.add(Calendar.DAY_OF_MONTH, -defaultDaysBack); desde = cal.getTime(); }
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
