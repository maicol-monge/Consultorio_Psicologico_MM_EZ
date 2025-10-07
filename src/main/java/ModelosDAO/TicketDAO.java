package ModelosDAO;

import DB.cn;
import Modelos.TicketPago;
import java.sql.*;

public class TicketDAO {
    public TicketPago obtenerPorNumero(String numero) {
    String sql = "SELECT t.*, p.monto_base, p.monto_total, pa.nombre as paciente_nombre, u.nombre as psicologo_nombre, c.fecha_hora as cita_fecha_hora " +
                "FROM Ticket_Pago t " +
                "LEFT JOIN Pago p ON t.id_pago=p.id " +
                "LEFT JOIN Cita c ON p.id_cita=c.id " +
                "LEFT JOIN Paciente pa ON c.id_paciente=pa.id " +
                "LEFT JOIN Psicologo ps ON c.id_psicologo=ps.id " +
                "LEFT JOIN Usuario u ON ps.id_usuario=u.id " +
                "WHERE t.numero_ticket=?";
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
                    try { t.setMontoBase(rs.getDouble("monto_base")); } catch (SQLException ignore) {}
                    try { t.setMontoTotal(rs.getDouble("monto_total")); } catch (SQLException ignore) {}
                    try { t.setMonto(rs.getDouble("monto_total")); } catch (SQLException ignore) {}
                    try { t.setPacienteNombre(rs.getString("paciente_nombre")); } catch (SQLException ignore) {}
                    try { t.setPsicologoNombre(rs.getString("psicologo_nombre")); } catch (SQLException ignore) {}
                    try {
                        java.sql.Timestamp ts = rs.getTimestamp("cita_fecha_hora");
                        if (ts != null) t.setCitaFechaHora(new java.util.Date(ts.getTime()));
                    } catch (SQLException ignore) {}
                    return t;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }
}
