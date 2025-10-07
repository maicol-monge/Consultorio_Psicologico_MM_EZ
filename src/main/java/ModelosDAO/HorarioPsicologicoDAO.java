package ModelosDAO;

import DB.cn;
import Modelos.HorarioPsicologico;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HorarioPsicologicoDAO {
    public List<HorarioPsicologico> listarPorPsicologo(int idPsicologo) {
        String sql = "SELECT * FROM HorarioPsicologico WHERE id_psicologo=? ORDER BY FIELD(dia_semana,'lunes','martes','miércoles','jueves','viernes','sábado','domingo'), hora_inicio";
        List<HorarioPsicologico> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    lista.add(map(rs));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public HorarioPsicologico obtenerPorId(int id) {
        String sql = "SELECT * FROM HorarioPsicologico WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(HorarioPsicologico h) {
        if (existeTraslape(h.getIdPsicologo(), h.getDiaSemana(), h.getHoraInicio(), h.getHoraFin(), 0)) return false;
        String sql = "INSERT INTO HorarioPsicologico (id_psicologo, dia_semana, hora_inicio, hora_fin, estado) VALUES (?,?,?,?,?)";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, h.getIdPsicologo());
            ps.setString(2, h.getDiaSemana());
            ps.setTime(3, h.getHoraInicio());
            ps.setTime(4, h.getHoraFin());
            ps.setString(5, h.getEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean actualizar(HorarioPsicologico h) {
        if (existeTraslape(h.getIdPsicologo(), h.getDiaSemana(), h.getHoraInicio(), h.getHoraFin(), h.getId())) return false;
        String sql = "UPDATE HorarioPsicologico SET dia_semana=?, hora_inicio=?, hora_fin=?, estado=? WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, h.getDiaSemana());
            ps.setTime(2, h.getHoraInicio());
            ps.setTime(3, h.getHoraFin());
            ps.setString(4, h.getEstado());
            ps.setInt(5, h.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean eliminar(int id) {
        String sql = "DELETE FROM HorarioPsicologico WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean cambiarEstado(int id, String estado) {
        String sql = "UPDATE HorarioPsicologico SET estado=? WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, estado);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    // Valida traslapes para un psicólogo en un día; excluye un ID si es actualización
    public boolean existeTraslape(int idPsicologo, String diaSemana, Time inicio, Time fin, int excluirId) {
        String sql = "SELECT COUNT(*) FROM HorarioPsicologico WHERE id_psicologo=? AND dia_semana=? AND id<>? AND estado='activo' AND ( (hora_inicio < ? AND hora_fin > ?) OR (hora_inicio < ? AND hora_fin > ?) OR (hora_inicio >= ? AND hora_fin <= ?) )";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            ps.setString(2, diaSemana);
            ps.setInt(3, excluirId);
            ps.setTime(4, fin);
            ps.setTime(5, fin);
            ps.setTime(6, inicio);
            ps.setTime(7, inicio);
            ps.setTime(8, inicio);
            ps.setTime(9, fin);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private HorarioPsicologico map(ResultSet rs) throws SQLException {
        HorarioPsicologico h = new HorarioPsicologico();
        h.setId(rs.getInt("id"));
        h.setIdPsicologo(rs.getInt("id_psicologo"));
        h.setDiaSemana(rs.getString("dia_semana"));
        h.setHoraInicio(rs.getTime("hora_inicio"));
        h.setHoraFin(rs.getTime("hora_fin"));
        h.setEstado(rs.getString("estado"));
        return h;
    }
}
