package ModelosDAO;

import DB.cn;
import Modelos.TicketPago;

import java.sql.*;

public class TicketPagoDAO {
    private final Connection connection;

    public TicketPagoDAO() throws Exception {
        this.connection = cn.getConnection();
    }

    public boolean crear(TicketPago t) {
        String sql = "INSERT INTO Ticket_Pago (id_pago, codigo, numero_ticket, qr_code, estado) VALUES (?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, t.getIdPago());
            ps.setString(2, t.getCodigo());
            ps.setString(3, t.getNumeroTicket());
            ps.setString(4, t.getQrCode());
            ps.setString(5, t.getEstado() != null ? t.getEstado() : "activo");
            int n = ps.executeUpdate();
            if (n > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) t.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public TicketPago obtenerPorPago(int idPago) {
        String sql = "SELECT * FROM Ticket_Pago WHERE id_pago=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, idPago);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private TicketPago map(ResultSet rs) throws SQLException {
        TicketPago t = new TicketPago();
        t.setId(rs.getInt("id"));
        t.setIdPago(rs.getInt("id_pago"));
        t.setCodigo(rs.getString("codigo"));
        t.setNumeroTicket(rs.getString("numero_ticket"));
        t.setQrCode(rs.getString("qr_code"));
        t.setEstado(rs.getString("estado"));
        Timestamp fe = rs.getTimestamp("fecha_emision");
        if (fe != null) t.setFechaEmision(new java.util.Date(fe.getTime()));
        return t;
    }
}
