package ModelosDAO;

import DB.cn;
import Modelos.Pago;
import java.sql.*;
import java.util.*;

public class PagoDAO {
    public Map<String, Double> ingresosPorMes(int anio) {
        String sql = "SELECT DATE_FORMAT(fecha, '%Y-%m') ym, SUM(monto_total) total FROM Pago WHERE YEAR(fecha)=? AND estado='activo' AND estado_pago='pagado' GROUP BY ym ORDER BY ym";
        Map<String, Double> map = new LinkedHashMap<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, anio);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) map.put(rs.getString(1), rs.getDouble(2)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public java.util.List<Pago> listarPendientes() {
        String sql = "SELECT * FROM Pago WHERE estado_pago='pendiente' AND estado='activo' ORDER BY fecha DESC";
        java.util.List<Pago> list = new java.util.ArrayList<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Pago p = new Pago();
                p.setId(rs.getInt("id"));
                p.setIdCita(rs.getInt("id_cita"));
                p.setMontoBase(rs.getDouble("monto_base"));
                p.setMontoTotal(rs.getDouble("monto_total"));
                p.setFecha(rs.getTimestamp("fecha"));
                p.setEstadoPago(rs.getString("estado_pago"));
                p.setEstado(rs.getString("estado"));
                list.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
