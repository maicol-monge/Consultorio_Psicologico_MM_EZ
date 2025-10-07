package ModelosDAO;

import DB.cn;
import Modelos.Pago;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class PagoDAO {
    private final Connection connection;

    public PagoDAO() {
        Connection c = null;
        try { c = cn.getConnection(); } catch (Exception e) { e.printStackTrace(); }
        this.connection = c;
    }

    public boolean crear(Pago p) {
        String sql = "INSERT INTO Pago (id_cita, monto_base, monto_total, fecha, estado_pago, estado) VALUES (?,?,?,?,?,?)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setObject(1, p.getIdCita(), Types.INTEGER);
            ps.setBigDecimal(2, p.getMontoBase());
            ps.setBigDecimal(3, p.getMontoTotal());
            ps.setTimestamp(4, p.getFecha() != null ? new Timestamp(p.getFecha().getTime()) : new Timestamp(System.currentTimeMillis()));
            ps.setString(5, p.getEstadoPago() != null ? p.getEstadoPago() : "pagado");
            ps.setString(6, p.getEstado() != null ? p.getEstado() : "activo");
            int n = ps.executeUpdate();
            if (n > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) p.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Pago> listar(String estadoPago) {
        List<Pago> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT pg.*, c.fecha_hora as cita_fecha_hora, p.nombre as paciente_nombre, u.nombre as psicologo_nombre ");
        sb.append("FROM Pago pg ");
        sb.append("LEFT JOIN Cita c ON pg.id_cita=c.id ");
        sb.append("LEFT JOIN Paciente p ON c.id_paciente=p.id ");
        sb.append("LEFT JOIN Psicologo ps ON c.id_psicologo=ps.id ");
        sb.append("LEFT JOIN Usuario u ON ps.id_usuario=u.id ");
        sb.append("WHERE pg.estado='activo' ");
        if (estadoPago != null && !estadoPago.isEmpty()) {
            sb.append("AND pg.estado_pago=? ");
        }
        sb.append("ORDER BY pg.fecha DESC");
        try (PreparedStatement ps = connection.prepareStatement(sb.toString())) {
            if (estadoPago != null && !estadoPago.isEmpty()) ps.setString(1, estadoPago);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Pago> listarFiltrado(String fechaInicio, String fechaFin, String estadoPago, String pacienteLike, String psicologoLike) {
        List<Pago> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder();
        sb.append("SELECT pg.*, c.fecha_hora as cita_fecha_hora, p.nombre as paciente_nombre, u.nombre as psicologo_nombre ");
        sb.append("FROM Pago pg ");
        sb.append("LEFT JOIN Cita c ON pg.id_cita=c.id ");
        sb.append("LEFT JOIN Paciente p ON c.id_paciente=p.id ");
        sb.append("LEFT JOIN Psicologo ps ON c.id_psicologo=ps.id ");
        sb.append("LEFT JOIN Usuario u ON ps.id_usuario=u.id ");
        sb.append("WHERE pg.estado='activo' ");
        List<Object> params = new ArrayList<>();
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sb.append("AND DATE(pg.fecha) >= ? ");
            params.add(fechaInicio);
        }
        if (fechaFin != null && !fechaFin.isEmpty()) {
            sb.append("AND DATE(pg.fecha) <= ? ");
            params.add(fechaFin);
        }
        if (estadoPago != null && !estadoPago.isEmpty()) {
            sb.append("AND pg.estado_pago = ? ");
            params.add(estadoPago);
        }
        if (pacienteLike != null && !pacienteLike.isEmpty()) {
            sb.append("AND p.nombre LIKE ? ");
            params.add("%" + pacienteLike + "%");
        }
        if (psicologoLike != null && !psicologoLike.isEmpty()) {
            sb.append("AND u.nombre LIKE ? ");
            params.add("%" + psicologoLike + "%");
        }
        sb.append("ORDER BY pg.fecha DESC");
        try (PreparedStatement ps = connection.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Pago> listarPendientes() {
        return listar("pendiente");
    }

    public Pago obtener(int id) {
        String q = "SELECT pg.*, c.fecha_hora as cita_fecha_hora, p.nombre as paciente_nombre, u.nombre as psicologo_nombre " +
                "FROM Pago pg " +
                "LEFT JOIN Cita c ON pg.id_cita=c.id " +
                "LEFT JOIN Paciente p ON c.id_paciente=p.id " +
                "LEFT JOIN Psicologo ps ON c.id_psicologo=ps.id " +
                "LEFT JOIN Usuario u ON ps.id_usuario=u.id WHERE pg.id=?";
        try (PreparedStatement ps = connection.prepareStatement(q)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean marcarPagado(int id) {
        String sql = "UPDATE Pago SET estado_pago='pagado' WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Pago map(ResultSet rs) throws SQLException {
        Pago p = new Pago();
        p.setId(rs.getInt("id"));
        int idCita = rs.getInt("id_cita");
        p.setIdCita(rs.wasNull() ? null : idCita);
        p.setMontoBase(rs.getBigDecimal("monto_base"));
        p.setMontoTotal(rs.getBigDecimal("monto_total"));
        Timestamp f = rs.getTimestamp("fecha");
        p.setFecha(f != null ? new java.util.Date(f.getTime()) : null);
        p.setEstadoPago(rs.getString("estado_pago"));
        p.setEstado(rs.getString("estado"));
        Timestamp cf = rs.getTimestamp("cita_fecha_hora");
        if (cf != null) p.setCitaFechaHora(new java.util.Date(cf.getTime()));
        p.setPacienteNombre(rs.getString("paciente_nombre"));
        p.setPsicologoNombre(rs.getString("psicologo_nombre"));
        return p;
    }

    public java.util.Map<String, Double> ingresosPorMes(int anio) {
        java.util.Map<String, Double> mapa = new java.util.LinkedHashMap<>();
        // Inicializar 12 meses con 0.0
        for (int m = 1; m <= 12; m++) {
            String key = (m < 10 ? "0" + m : String.valueOf(m));
            mapa.put(key, 0.0);
        }
        String sql = "SELECT MONTH(fecha) as mes, SUM(monto_total) as total " +
                "FROM Pago WHERE estado='activo' AND estado_pago='pagado' AND YEAR(fecha)=? GROUP BY MONTH(fecha)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, anio);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int mes = rs.getInt("mes");
                    double total = rs.getBigDecimal("total").doubleValue();
                    String key = (mes < 10 ? "0" + mes : String.valueOf(mes));
                    mapa.put(key, total);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return mapa;
    }
}
