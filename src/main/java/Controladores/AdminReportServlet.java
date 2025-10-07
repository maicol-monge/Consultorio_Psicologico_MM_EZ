package Controladores;

import Modelos.Cita;
import Modelos.Pago;
import ModelosDAO.CitaDAO;
import ModelosDAO.PagoDAO;
import Modelos.HorarioPsicologico;
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
    "/admin/reportes",
    "/admin/report/pacientesPorPsicologo",
    "/admin/report/disponibilidadHorarios",
    "/admin/report/citasPorRango",
    "/admin/report/ingresosPorMes",
    "/admin/report/ingresosPorEspecialidad",
    "/admin/report/pagosPendientes"
})
public class AdminReportServlet extends HttpServlet {
    private final CitaDAO citaDAO = new CitaDAO();
    private final PagoDAO pagoDAO = new PagoDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        String format = Optional.ofNullable(req.getParameter("format")).orElse("preview");
        if ("/admin/reportes".equals(path)) {
            req.getRequestDispatcher("/WEB-INF/views/admin/reportes/index.jsp").forward(req, resp);
            return;
        }
        if (path.endsWith("pacientesPorPsicologo")) {
            Map<String,Integer> datos = citaDAO.pacientesAtendidosPorPsicologoNombres();
            String titulo = "Pacientes atendidos por psicólogo";
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, new String[]{"Psicólogo","Pacientes"}, toRows(datos)); return; }
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, new String[]{"Psicólogo","Pacientes"}, toRows(datos)); return; }
            pdfSimple(resp, titulo, new String[]{"Psicólogo","Pacientes"}, toRows(datos)); return;
        }
        if (path.endsWith("citasPorRango")) {
            java.util.Date[] r = ReportUtils.rango(req, 30);
            List<Cita> citas = citaDAO.listarPorRangoConNombres(r[0], r[1]);
            String[] headers = {"ID","Paciente","Psicólogo","Fecha","Estado"};
            List<String[]> rows = new ArrayList<>();
            for (Cita c : citas) rows.add(new String[]{String.valueOf(c.getId()), c.getPacienteNombre(), c.getPsicologoNombre(), String.valueOf(c.getFechaHora()), c.getEstadoCita()});
            String titulo = "Citas del " + r[0] + " al " + r[1];
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, headers, rows); return; }
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("disponibilidadHorarios")) {
            // Reporte de disponibilidad real: para una semana base (o el día indicado), calcula slots libres vs ocupados por psicólogo y día.
            // Filtros opcionales: fecha (yyyy-MM-dd) para centrar semana; id_psicologo (int) para un psicólogo específico.
            String fechaBase = req.getParameter("fecha");
            String idPsStr = req.getParameter("id_psicologo");

            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
            java.util.Calendar cal = java.util.Calendar.getInstance();
            if (fechaBase != null && !fechaBase.isEmpty()) {
                try { cal.setTime(sdf.parse(fechaBase)); } catch (Exception ignore) {}
            }
            // Mover a lunes de esa semana
            cal.set(java.util.Calendar.HOUR_OF_DAY, 0);
            cal.set(java.util.Calendar.MINUTE, 0);
            cal.set(java.util.Calendar.SECOND, 0);
            cal.set(java.util.Calendar.MILLISECOND, 0);
            cal.set(java.util.Calendar.DAY_OF_WEEK, java.util.Calendar.MONDAY);
            java.util.Date lunes = cal.getTime();
            java.util.Date[] dias = new java.util.Date[7];
            dias[0] = lunes;
            for (int i=1;i<7;i++) { cal.add(java.util.Calendar.DAY_OF_MONTH, 1); dias[i] = cal.getTime(); }

            String[] headers = {"Psicólogo","Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"};
            List<String[]> rows = new ArrayList<>();

            // Construir lista de psicólogos a considerar
            StringBuilder sbPs = new StringBuilder("SELECT ps.id, u.nombre FROM Psicologo ps JOIN Usuario u ON u.id=ps.id_usuario WHERE u.estado='activo'");
            if (idPsStr != null && !idPsStr.isEmpty()) sbPs.append(" AND ps.id=").append(idPsStr); // simple filtro opcional
            sbPs.append(" ORDER BY u.nombre");
            List<int[]> psicologos = new ArrayList<>(); // [id, index en nombres]
            List<String> nombres = new ArrayList<>();
            try (java.sql.Connection c = DB.cn.getConnection(); java.sql.Statement st = c.createStatement(); java.sql.ResultSet rs = st.executeQuery(sbPs.toString())) {
                while (rs.next()) { psicologos.add(new int[]{rs.getInt(1)}); nombres.add(rs.getString(2)); }
            } catch (Exception ignore) {}

            // Por cada psicólogo, calcular slots disponibles por día
            for (int idx=0; idx<psicologos.size(); idx++) {
                int idPs = psicologos.get(idx)[0];
                String nombre = nombres.get(idx);
                String[] row = new String[8];
                row[0] = nombre;

                for (int d=0; d<7; d++) {
                    // Determinar nombre día para consultar horarios
                    java.util.Calendar cd = java.util.Calendar.getInstance();
                    cd.setTime(dias[d]);
                    String[] diasEs = {"domingo","lunes","martes","miércoles","jueves","viernes","sábado"};
                    String diaNombre = diasEs[cd.get(java.util.Calendar.DAY_OF_WEEK)-1];

                    // Obtener horarios activos de ese día (soportando acentos en nombres)
                    List<HorarioPsicologico> hs = new ArrayList<>();
                    String sqlH = "SELECT * FROM HorarioPsicologico WHERE id_psicologo=? AND estado='activo' AND dia_semana IN (?,?)";
                    try (java.sql.Connection c = DB.cn.getConnection(); java.sql.PreparedStatement ps = c.prepareStatement(sqlH)) {
                        ps.setInt(1, idPs);
                        ps.setString(2, diaNombre);
                        // Variante sin acento para miércoles/sábado por si la BD lo guarda sin tilde
                        String diaAlt = diaNombre;
                        if ("miércoles".equals(diaNombre)) diaAlt = "miercoles";
                        else if ("sábado".equals(diaNombre)) diaAlt = "sabado";
                        ps.setString(3, diaAlt);
                        try (java.sql.ResultSet rs = ps.executeQuery()) { while (rs.next()) {
                            HorarioPsicologico h = new HorarioPsicologico();
                            h.setId(rs.getInt("id"));
                            h.setIdPsicologo(rs.getInt("id_psicologo"));
                            h.setDiaSemana(rs.getString("dia_semana"));
                            h.setHoraInicio(rs.getTime("hora_inicio"));
                            h.setHoraFin(rs.getTime("hora_fin"));
                            h.setEstado(rs.getString("estado"));
                            hs.add(h);
                        }}
                    } catch (Exception ignore) {}

                    int totalSlots = 0;
                    int ocupados = 0;
                    // Para cada bloque horario, contar slots de 30 min y los ocupados por citas no canceladas
                    for (HorarioPsicologico h : hs) {
                        java.util.Calendar c0 = java.util.Calendar.getInstance();
                        c0.setTime(dias[d]);
                        java.util.Calendar c1 = (java.util.Calendar) c0.clone();
                        java.util.Calendar c2 = (java.util.Calendar) c0.clone();
                        c1.set(java.util.Calendar.HOUR_OF_DAY, h.getHoraInicio().toLocalTime().getHour());
                        c1.set(java.util.Calendar.MINUTE, h.getHoraInicio().toLocalTime().getMinute());
                        c1.set(java.util.Calendar.SECOND, 0);
                        c1.set(java.util.Calendar.MILLISECOND, 0);
                        c2.set(java.util.Calendar.HOUR_OF_DAY, h.getHoraFin().toLocalTime().getHour());
                        c2.set(java.util.Calendar.MINUTE, h.getHoraFin().toLocalTime().getMinute());
                        c2.set(java.util.Calendar.SECOND, 0);
                        c2.set(java.util.Calendar.MILLISECOND, 0);

                        long millis = c2.getTimeInMillis() - c1.getTimeInMillis();
                        int slots = (int) (millis / (30 * 60 * 1000));
                        if (slots < 0) slots = 0;
                        totalSlots += slots;

                        // Citas ocupadas en ese rango (no canceladas)
                        String sqlC = "SELECT COUNT(*) FROM Cita WHERE id_psicologo=? AND estado<>'inactivo' AND estado_cita<>'cancelada' AND fecha_hora>=? AND fecha_hora<?";
                        try (java.sql.Connection c = DB.cn.getConnection(); java.sql.PreparedStatement ps = c.prepareStatement(sqlC)) {
                            ps.setInt(1, idPs);
                            ps.setTimestamp(2, new java.sql.Timestamp(c1.getTimeInMillis()));
                            ps.setTimestamp(3, new java.sql.Timestamp(c2.getTimeInMillis()));
                            try (java.sql.ResultSet rs = ps.executeQuery()) { if (rs.next()) ocupados += rs.getInt(1); }
                        } catch (Exception ignore) {}
                    }

                    int libres = Math.max(totalSlots - ocupados, 0);
                    row[d+1] = libres + "/" + totalSlots; // formato libres/total
                }
                rows.add(row);
            }

            String titulo = "Disponibilidad de horarios (semana)";
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, headers, rows); return; }
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("ingresosPorMes")) {
            int anio = java.time.Year.now().getValue();
            Map<String, Double> ingresos = pagoDAO.ingresosPorMes(anio);
            String titulo = "Ingresos por mes " + anio;
            String[] headers = {"Mes","Total"};
            List<String[]> rows = new ArrayList<>();
            for (Map.Entry<String, Double> e : ingresos.entrySet()) rows.add(new String[]{e.getKey(), String.valueOf(e.getValue())});
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, headers, rows); return; }
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("ingresosPorEspecialidad")) {
            // Comparativo de ingresos por especialidad (requiere especialidad en Psicologo y join con pago)
            String sql = "SELECT ps.especialidad, SUM(pg.monto_total) total FROM Pago pg " +
                    "JOIN Cita c ON pg.id_cita=c.id " +
                    "JOIN Psicologo ps ON c.id_psicologo=ps.id " +
                    "WHERE pg.estado='activo' AND pg.estado_pago='pagado' GROUP BY ps.especialidad";
            List<String[]> rows = new ArrayList<>();
            try (java.sql.Connection c = DB.cn.getConnection(); java.sql.Statement st = c.createStatement(); java.sql.ResultSet rs = st.executeQuery(sql)) {
                while (rs.next()) rows.add(new String[]{rs.getString(1), String.valueOf(rs.getBigDecimal(2))});
            } catch (Exception ignore) {}
            String titulo = "Ingresos por especialidad";
            String[] headers = {"Especialidad","Total"};
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, headers, rows); return; }
            if ("xlsx".equalsIgnoreCase(format)) { excelSimple(resp, titulo, headers, rows); return; }
            pdfSimple(resp, titulo, headers, rows); return;
        }
        if (path.endsWith("pagosPendientes")) {
            List<Pago> list = pagoDAO.listarPendientes();
            String[] headers = {"ID","Cita","Monto Base","Monto Total","Estado"};
            List<String[]> rows = new ArrayList<>();
            for (Pago p : list) rows.add(new String[]{String.valueOf(p.getId()), String.valueOf(p.getIdCita()), String.valueOf(p.getMontoBase()), String.valueOf(p.getMontoTotal()), p.getEstadoPago()});
            String titulo = "Pagos pendientes";
            if ("preview".equalsIgnoreCase(format)) { preview(req, resp, titulo, headers, rows); return; }
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

    private void preview(HttpServletRequest req, HttpServletResponse resp, String titulo, String[] headers, List<String[]> rows) throws IOException, ServletException {
        req.setAttribute("titulo", titulo);
        req.setAttribute("headers", headers);
        req.setAttribute("rows", rows);
        req.getRequestDispatcher("/WEB-INF/views/admin/reportes/preview.jsp").forward(req, resp);
    }
}
