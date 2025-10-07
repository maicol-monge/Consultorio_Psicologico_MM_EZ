package ModelosDAO;

import DB.cn;
import Modelos.Cita;
import java.sql.*;
import java.util.*;

public class CitaDAO {
    public int contarPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM Cita WHERE estado_cita=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String,Integer> citasPorPsicologo() {
        String sql = "SELECT u.nombre AS psicologo, COUNT(*) AS total " +
                "FROM Cita c " +
                "JOIN Psicologo p ON p.id=c.id_psicologo " +
                "JOIN Usuario u ON u.id=p.id_usuario " +
                "GROUP BY u.nombre " +
                "ORDER BY u.nombre";
        Map<String,Integer> map = new LinkedHashMap<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) map.put(rs.getString("psicologo"), rs.getInt("total"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public List<Cita> listarPorRango(java.util.Date inicio, java.util.Date fin) {
        String sql = "SELECT * FROM Cita WHERE fecha_hora BETWEEN ? AND ? ORDER BY fecha_hora";
        List<Cita> list = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(inicio.getTime()));
            ps.setTimestamp(2, new Timestamp(fin.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita ci = new Cita();
                    ci.setId(rs.getInt("id"));
                    ci.setIdPaciente(rs.getInt("id_paciente"));
                    ci.setIdPsicologo(rs.getInt("id_psicologo"));
                    ci.setFechaHora(rs.getTimestamp("fecha_hora"));
                    ci.setEstadoCita(rs.getString("estado_cita"));
                    ci.setMotivoConsulta(rs.getString("motivo_consulta"));
                    ci.setQrCode(rs.getString("qr_code"));
                    ci.setEstado(rs.getString("estado"));
                    list.add(ci);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int contarPorEstadoYPsicologo(String estado, int idPsicologo) {
        String sql = "SELECT COUNT(*) FROM Cita WHERE estado_cita=? AND id_psicologo=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, idPsicologo);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Map<String,Integer> citasPorMesPorPsicologo(int idPsicologo, int anio) {
        String sql = "SELECT DATE_FORMAT(fecha_hora, '%Y-%m') ym, COUNT(*) cnt FROM Cita WHERE id_psicologo=? AND YEAR(fecha_hora)=? GROUP BY ym ORDER BY ym";
        Map<String,Integer> map = new LinkedHashMap<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            ps.setInt(2, anio);
            try (ResultSet rs = ps.executeQuery()) { while (rs.next()) map.put(rs.getString(1), rs.getInt(2)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public Map<String,Integer> pacientesAtendidosPorPsicologo() {
        String sql = "SELECT id_psicologo, COUNT(DISTINCT id_paciente) total FROM Cita WHERE estado_cita='realizada' GROUP BY id_psicologo";
        Map<String,Integer> map = new LinkedHashMap<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                map.put("Psicologo " + rs.getInt(1), rs.getInt(2));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    // Versión con nombres
    public Map<String,Integer> pacientesAtendidosPorPsicologoNombres() {
        String sql = "SELECT u.nombre AS psicologo, COUNT(DISTINCT c.id_paciente) AS total " +
                "FROM Cita c JOIN Psicologo ps ON ps.id=c.id_psicologo JOIN Usuario u ON u.id=ps.id_usuario " +
                "WHERE c.estado_cita='realizada' GROUP BY u.nombre ORDER BY u.nombre";
        Map<String,Integer> map = new LinkedHashMap<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) map.put(rs.getString("psicologo"), rs.getInt("total"));
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }

    public List<Cita> listarPorRangoConNombres(java.util.Date inicio, java.util.Date fin) {
        String sql = "SELECT c.*, p.nombre AS paciente_nombre, u.nombre AS psicologo_nombre FROM Cita c " +
                "LEFT JOIN Paciente p ON p.id=c.id_paciente " +
                "LEFT JOIN Psicologo ps ON ps.id=c.id_psicologo " +
                "LEFT JOIN Usuario u ON u.id=ps.id_usuario " +
                "WHERE c.fecha_hora BETWEEN ? AND ? ORDER BY c.fecha_hora";
        List<Cita> list = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(inicio.getTime()));
            ps.setTimestamp(2, new Timestamp(fin.getTime()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Cita ci = new Cita();
                    ci.setId(rs.getInt("id"));
                    ci.setIdPaciente(rs.getInt("id_paciente"));
                    ci.setIdPsicologo(rs.getInt("id_psicologo"));
                    ci.setFechaHora(rs.getTimestamp("fecha_hora"));
                    ci.setEstadoCita(rs.getString("estado_cita"));
                    ci.setMotivoConsulta(rs.getString("motivo_consulta"));
                    ci.setQrCode(rs.getString("qr_code"));
                    ci.setEstado(rs.getString("estado"));
                    try { ci.setPacienteNombre(rs.getString("paciente_nombre")); } catch (SQLException ignore) {}
                    try { ci.setPsicologoNombre(rs.getString("psicologo_nombre")); } catch (SQLException ignore) {}
                    list.add(ci);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
