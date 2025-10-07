package Controladores;

import Modelos.TicketPago;
import ModelosDAO.TicketDAO;
import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;

import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.TimeZone;

@WebServlet(name = "TicketServlet", urlPatterns = {"/ticket", "/ticket.png"})
public class TicketServlet extends HttpServlet {
    private final TicketDAO ticketDAO = new TicketDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String numero = req.getParameter("n");
        if (numero == null || numero.isEmpty()) { resp.sendError(400, "Falta numero de ticket"); return; }
        TicketPago t = ticketDAO.obtenerPorNumero(numero);
        if (t == null) { resp.sendError(404, "Ticket no encontrado"); return; }

        if ("/ticket.png".equals(req.getServletPath())) {
            // Compose a supermarket-style narrow ticket 384px width (typical thermal printers)
            int width = 384, height = 600;
            BufferedImage img = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
            Graphics2D g = img.createGraphics();
            g.setColor(Color.WHITE); g.fillRect(0,0,width,height);
            g.setColor(Color.BLACK);
            g.setFont(new Font("Monospaced", Font.BOLD, 20));
            int y = 30;
            g.drawString("CONSULTORIO PSI", 80, y); y += 30;
            g.setFont(new Font("Monospaced", Font.PLAIN, 14));
            // Timezone formatting for El Salvador
            SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm");
            df.setTimeZone(TimeZone.getTimeZone("America/El_Salvador"));
            String fechaEmision = t.getFechaEmision() != null ? df.format(t.getFechaEmision()) : "-";
            String fechaCita = t.getCitaFechaHora() != null ? df.format(t.getCitaFechaHora()) : "-";
            DecimalFormat money = new DecimalFormat("$ #,##0.00");
            String montoBase = money.format(t.getMontoBase());
            String montoTotal = money.format(t.getMontoTotal());

            g.drawString("Ticket: " + t.getNumeroTicket(), 10, y); y += 20;
            g.drawString("Código: " + (t.getCodigo()!=null?t.getCodigo():"-"), 10, y); y += 20;
            g.drawString("Emisión: " + fechaEmision, 10, y); y += 20;
            y += 10;
            g.drawLine(0, y, width, y); y += 10;
            // Details
            g.drawString("Paciente: " + (t.getPacienteNombre()!=null?t.getPacienteNombre():"-"), 10, y); y += 20;
            g.drawString("Psicólogo: " + (t.getPsicologoNombre()!=null?t.getPsicologoNombre():"-"), 10, y); y += 20;
            g.drawString("Cita: " + fechaCita, 10, y); y += 20;
            g.drawString("Monto base: " + montoBase, 10, y); y += 20;
            g.drawString("Monto total: " + montoTotal, 10, y); y += 25;
            g.drawLine(0, y, width, y); y += 10;
            g.drawString("Gracias por su pago", 80, y); y += 20;
            // QR
            try {
                String qrData = (t.getQrCode()!=null? t.getQrCode() : ("TICKET:"+t.getNumeroTicket()));
                BitMatrix matrix = new MultiFormatWriter().encode(qrData, BarcodeFormat.QR_CODE, 160, 160);
                BufferedImage qr = MatrixToImageWriter.toBufferedImage(matrix);
                g.drawImage(qr, (width-160)/2, y, null); y += 180;
            } catch (Exception e) { /* ignore QR failure */ }
            g.drawString("www.consultorio.local", 80, y);
            g.dispose();

            resp.setContentType("image/png");
            String dl = req.getParameter("dl");
            if ("1".equals(dl)) {
                resp.setHeader("Content-Disposition", "attachment; filename=ticket-"+t.getNumeroTicket()+".png");
            }
            ImageIO.write(img, "png", resp.getOutputStream());
            return;
        }
        req.setAttribute("ticket", t);
        req.getRequestDispatcher("/WEB-INF/views/ticket.jsp").forward(req, resp);
    }
}
