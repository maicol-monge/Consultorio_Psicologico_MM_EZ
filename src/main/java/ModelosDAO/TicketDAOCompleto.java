package ModelosDAO;

import DB.cn;
import Modelos.TicketPago;
import java.sql.*;
import java.util.*;

public class TicketDAOCompleto {
    private Connection connection;
    
    public TicketDAOCompleto() {
        try {
            this.connection = cn.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public TicketDAOCompleto(Connection connection) {
        this.connection = connection;
    }
    
    // Método para crear un nuevo ticket
    public boolean crear(TicketPago ticket) {
        String sql = "INSERT INTO Ticket_Pago (id_pago, codigo, fecha_emision, estado) VALUES (?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, ticket.getIdPago());
            stmt.setString(2, ticket.getCodigo());
            stmt.setTimestamp(3, new Timestamp(ticket.getFechaEmision().getTime()));
            stmt.setString(4, ticket.getEstado());
            
            int result = stmt.executeUpdate();
            if (result > 0) {
                ResultSet rs = stmt.getGeneratedKeys();
                if (rs.next()) {
                    ticket.setId(rs.getInt(1));
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Método para buscar ticket por código
    public TicketPago buscarPorCodigo(String codigo) {
        String sql = "SELECT t.*, p.monto_total, pa.nombre as paciente_nombre " +
                    "FROM Ticket_Pago t " +
                    "JOIN Pago p ON t.id_pago = p.id " +
                    "LEFT JOIN Cita c ON p.id_cita = c.id " +
                    "LEFT JOIN Paciente pa ON c.id_paciente = pa.id " +
                    "WHERE t.codigo = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, codigo);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearTicket(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Método para buscar ticket por ID de pago
    public TicketPago buscarPorIdPago(int idPago) {
        String sql = "SELECT t.*, p.monto_total, pa.nombre as paciente_nombre " +
                    "FROM Ticket_Pago t " +
                    "JOIN Pago p ON t.id_pago = p.id " +
                    "LEFT JOIN Cita c ON p.id_cita = c.id " +
                    "LEFT JOIN Paciente pa ON c.id_paciente = pa.id " +
                    "WHERE t.id_pago = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, idPago);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapearTicket(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Método para buscar tickets con filtros
    public List<TicketPago> buscarConFiltros(String fechaInicio, String fechaFin) {
        List<TicketPago> tickets = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT t.*, p.monto_total, pa.nombre as paciente_nombre " +
            "FROM Ticket_Pago t " +
            "JOIN Pago p ON t.id_pago = p.id " +
            "LEFT JOIN Cita c ON p.id_cita = c.id " +
            "LEFT JOIN Paciente pa ON c.id_paciente = pa.id WHERE 1=1"
        );
        
        List<Object> parametros = new ArrayList<>();
        
        if (fechaInicio != null && !fechaInicio.isEmpty()) {
            sql.append(" AND DATE(t.fecha_emision) >= ?");
            parametros.add(fechaInicio);
        }
        
        if (fechaFin != null && !fechaFin.isEmpty()) {
            sql.append(" AND DATE(t.fecha_emision) <= ?");
            parametros.add(fechaFin);
        }
        
        sql.append(" ORDER BY t.fecha_emision DESC");
        
        try (PreparedStatement stmt = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < parametros.size(); i++) {
                stmt.setObject(i + 1, parametros.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                tickets.add(mapearTicket(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return tickets;
    }
    
    // Método auxiliar para mapear ResultSet a objeto TicketPago
    private TicketPago mapearTicket(ResultSet rs) throws SQLException {
        TicketPago ticket = new TicketPago();
        ticket.setId(rs.getInt("id"));
        ticket.setIdPago(rs.getInt("id_pago"));
        ticket.setCodigo(rs.getString("codigo"));
        ticket.setFechaEmision(rs.getTimestamp("fecha_emision"));
        ticket.setEstado(rs.getString("estado"));
        
        try {
            ticket.setMonto(rs.getDouble("monto_total"));
            ticket.setPacienteNombre(rs.getString("paciente_nombre"));
        } catch (SQLException e) {
            // Ignorar si no existen estos campos
        }
        
        return ticket;
    }
}