package ModelosDAO;

import DB.cn;
import Modelos.Cita;
import java.sql.*;
import java.util.*;

public class CitaDAOCompleto {
    private Connection connection;
    
    public CitaDAOCompleto() {
        try {
            this.connection = cn.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public CitaDAOCompleto(Connection connection) {
        this.connection = connection;
    }
    
    // Método para crear una nueva cita
    public boolean crear(Cita cita) {
        String sql = "INSERT INTO Cita (id_paciente, id_psicologo, fecha_hora, motivo_consulta, estado_cita, observaciones) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, cita.getIdPaciente());
            stmt.setInt(2, cita.getIdPsicologo());
            stmt.setTimestamp(3, new Timestamp(cita.getFechaHora().getTime()));
            stmt.setString(4, cita.getMotivoConsulta());
            stmt.setString(5, cita.getEstadoCita());
            stmt.setString(6, cita.getObservaciones());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    cita.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para actualizar una cita
    public boolean actualizar(Cita cita) {
        String sql = "UPDATE Cita SET id_paciente = ?, id_psicologo = ?, fecha_hora = ?, motivo_consulta = ?, estado_cita = ?, observaciones = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, cita.getIdPaciente());
            stmt.setInt(2, cita.getIdPsicologo());
            stmt.setTimestamp(3, new Timestamp(cita.getFechaHora().getTime()));
            stmt.setString(4, cita.getMotivoConsulta());
            stmt.setString(5, cita.getEstadoCita());
            stmt.setString(6, cita.getObservaciones());
            stmt.setInt(7, cita.getId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para buscar cita por ID
    public Cita buscarPorId(int id) {
        String sql = "SELECT c.*, p.nombre as paciente_nombre, u.nombre as psicologo_nombre " +
                    "FROM Cita c " +
                    "LEFT JOIN Paciente p ON c.id_paciente = p.id " +
                    "LEFT JOIN Psicologo ps ON c.id_psicologo = ps.id " +
                    "LEFT JOIN Usuario u ON ps.id_usuario = u.id " +
                    "WHERE c.id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearCita(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Método para listar todas las citas
    public List<Cita> listarTodos() {
        List<Cita> citas = new ArrayList<>();
        String sql = "SELECT c.*, p.nombre as paciente_nombre, u.nombre as psicologo_nombre " +
                    "FROM Cita c " +
                    "LEFT JOIN Paciente p ON c.id_paciente = p.id " +
                    "LEFT JOIN Psicologo ps ON c.id_psicologo = ps.id " +
                    "LEFT JOIN Usuario u ON ps.id_usuario = u.id " +
                    "ORDER BY c.fecha_hora DESC";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                citas.add(mapearCita(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }
    
    // Método para buscar citas con filtros
    public List<Cita> buscarConFiltros(String fechaInicio, String fechaFin, String estado, Integer idPaciente, Integer idPsicologo) {
        List<Cita> citas = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT c.*, p.nombre as paciente_nombre, u.nombre as psicologo_nombre " +
            "FROM Cita c " +
            "LEFT JOIN Paciente p ON c.id_paciente = p.id " +
            "LEFT JOIN Psicologo ps ON c.id_psicologo = ps.id " +
            "LEFT JOIN Usuario u ON ps.id_usuario = u.id WHERE 1=1"
        );
        
        List<Object> parametros = new ArrayList<>();
        
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sql.append(" AND DATE(c.fecha_hora) >= ?");
            parametros.add(fechaInicio);
        }
        
        if (fechaFin != null && !fechaFin.isEmpty()) {
            sql.append(" AND DATE(c.fecha_hora) <= ?");
            parametros.add(fechaFin);
        }
        
        if (estado != null && !estado.isEmpty()) {
            sql.append(" AND c.estado_cita = ?");
            parametros.add(estado);
        }
        
        if (idPaciente != null) {
            sql.append(" AND c.id_paciente = ?");
            parametros.add(idPaciente);
        }
        
        if (idPsicologo != null) {
            sql.append(" AND c.id_psicologo = ?");
            parametros.add(idPsicologo);
        }
        
        sql.append(" ORDER BY c.fecha_hora DESC");
        
        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametros.size(); i++) {
                stmt.setObject(i + 1, parametros.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                citas.add(mapearCita(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return citas;
    }
    
    // Método para verificar disponibilidad del psicólogo
    public boolean verificarDisponibilidad(int idPsicologo, java.util.Date fechaHora) {
        String sql = "SELECT COUNT(*) FROM Cita WHERE id_psicologo = ? AND fecha_hora = ? AND estado_cita != 'cancelada'";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idPsicologo);
            stmt.setTimestamp(2, new Timestamp(fechaHora.getTime()));
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 0; // Disponible si no hay citas en esa fecha
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para cambiar estado de una cita
    public boolean cambiarEstado(int id, String estado) {
        String sql = "UPDATE Cita SET estado_cita = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, estado);
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para reasignar psicólogo
    public boolean reasignarPsicologo(int idCita, int nuevoIdPsicologo) {
        String sql = "UPDATE Cita SET id_psicologo = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, nuevoIdPsicologo);
            stmt.setInt(2, idCita);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para eliminar una cita
    public boolean eliminar(int id) {
        String sql = "DELETE FROM Cita WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método auxiliar para mapear ResultSet a objeto Cita
    private Cita mapearCita(ResultSet rs) throws SQLException {
        Cita cita = new Cita();
        cita.setId(rs.getInt("id"));
        cita.setIdPaciente(rs.getInt("id_paciente"));
        cita.setIdPsicologo(rs.getInt("id_psicologo"));
        cita.setFechaHora(rs.getTimestamp("fecha_hora"));
        cita.setMotivoConsulta(rs.getString("motivo_consulta"));
        cita.setEstadoCita(rs.getString("estado_cita"));
        cita.setObservaciones(rs.getString("observaciones"));
        cita.setQrCode(rs.getString("qr_code"));
        cita.setEstado(rs.getString("estado"));
        
        // Campos adicionales de las consultas con JOIN
        try {
            cita.setPacienteNombre(rs.getString("paciente_nombre"));
            cita.setPsicologoNombre(rs.getString("psicologo_nombre"));
        } catch (SQLException e) {
            // Ignorar si no existen estos campos
        }
        
        return cita;
    }
}