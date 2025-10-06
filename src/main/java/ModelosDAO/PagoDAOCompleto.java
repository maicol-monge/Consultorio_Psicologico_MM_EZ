package ModelosDAO;

import DB.cn;
import Modelos.Pago;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class PagoDAOCompleto {
    private Connection connection;
    
    public PagoDAOCompleto() {
        try {
            this.connection = cn.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public PagoDAOCompleto(Connection connection) {
        this.connection = connection;
    }
    
    // Método para crear un nuevo pago
    public boolean crear(Pago pago) {
        String sql = "INSERT INTO Pago (id_cita, monto_base, monto_total, fecha, estado_pago, estado) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (pago.getIdCita() != null) {
                stmt.setInt(1, pago.getIdCita());
            } else {
                stmt.setNull(1, Types.INTEGER);
            }
            stmt.setDouble(2, pago.getMonto().doubleValue());
            stmt.setDouble(3, pago.getMonto().doubleValue());
            stmt.setTimestamp(4, new Timestamp(pago.getFechaPago().getTime()));
            stmt.setString(5, pago.getEstado());
            stmt.setString(6, "activo");
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    pago.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para buscar pago por ID
    public Pago buscarPorId(int id) {
        String sql = "SELECT p.*, c.motivo_consulta as cita_info, pa.nombre as paciente_nombre " +
                    "FROM Pago p " +
                    "LEFT JOIN Cita c ON p.id_cita = c.id " +
                    "LEFT JOIN Paciente pa ON c.id_paciente = pa.id " +
                    "WHERE p.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearPago(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Método para buscar pagos con filtros
    public List<Pago> buscarConFiltros(String fechaInicio, String fechaFin, String metodoPago, Integer idPaciente) {
        List<Pago> pagos = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, c.motivo_consulta as cita_info, pa.nombre as paciente_nombre " +
            "FROM Pago p " +
            "LEFT JOIN Cita c ON p.id_cita = c.id " +
            "LEFT JOIN Paciente pa ON c.id_paciente = pa.id WHERE p.estado = 'activo'"
        );
        
        List<Object> parametros = new ArrayList<>();
        
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sql.append(" AND DATE(p.fecha) >= ?");
            parametros.add(fechaInicio);
        }
        
        if (fechaFin != null && !fechaFin.isEmpty()) {
            sql.append(" AND DATE(p.fecha) <= ?");
            parametros.add(fechaFin);
        }
        
        if (idPaciente != null) {
            sql.append(" AND c.id_paciente = ?");
            parametros.add(idPaciente);
        }
        
        sql.append(" ORDER BY p.fecha DESC");
        
        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametros.size(); i++) {
                stmt.setObject(i + 1, parametros.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                pagos.add(mapearPago(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return pagos;
    }
    
    // Método auxiliar para mapear ResultSet a objeto Pago
    private Pago mapearPago(ResultSet rs) throws SQLException {
        Pago pago = new Pago();
        pago.setId(rs.getInt("id"));
        
        // Manejar id_cita que puede ser null
        int idCita = rs.getInt("id_cita");
        if (!rs.wasNull()) {
            pago.setIdCita(idCita);
        }
        
        pago.setMontoBase(rs.getDouble("monto_base"));
        pago.setMontoTotal(rs.getDouble("monto_total"));
        pago.setMonto(BigDecimal.valueOf(rs.getDouble("monto_base")));
        pago.setFecha(rs.getTimestamp("fecha"));
        pago.setFechaPago(rs.getTimestamp("fecha"));
        pago.setEstadoPago(rs.getString("estado_pago"));
        pago.setEstado(rs.getString("estado_pago"));
        
        try {
            pago.setCitaInfo(rs.getString("cita_info"));
            pago.setPacienteNombre(rs.getString("paciente_nombre"));
        } catch (SQLException e) {
            // Ignorar si no existen estos campos
        }
        
        return pago;
    }
}