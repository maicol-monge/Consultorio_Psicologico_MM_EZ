package ModelosDAO;

import DB.cn;
import Modelos.TicketPago;
import java.sql.*;

public class TicketDAO {
    public TicketPago obtenerPorNumero(String numero) {
        String sql = "SELECT * FROM Ticket_Pago WHERE numero_ticket=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, numero);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TicketPago t = new TicketPago();
                    t.setId(rs.getInt("id"));
                    t.setIdPago(rs.getInt("id_pago"));
                    t.setCodigo(rs.getString("codigo"));
                    t.setFechaEmision(rs.getTimestamp("fecha_emision"));
                    t.setNumeroTicket(rs.getString("numero_ticket"));
                    t.setQrCode(rs.getString("qr_code"));
                    t.setEstado(rs.getString("estado"));
                    return t;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
