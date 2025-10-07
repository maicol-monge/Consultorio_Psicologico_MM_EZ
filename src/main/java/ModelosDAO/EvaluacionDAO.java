package ModelosDAO;

import DB.cn;
import java.sql.*;

public class EvaluacionDAO {
    public static class ResumenEval {
        public int cantidad; public double promedio;
        public ResumenEval(int c, double p){cantidad=c; promedio=p;}
    }
    public ResumenEval resumenPorPsicologoYRango(int idPsicologo, java.util.Date desde, java.util.Date hasta) {
        String sql = "SELECT COUNT(e.id), AVG(e.estado_emocional) FROM Evaluacion e JOIN Cita c ON c.id=e.id_cita WHERE c.id_psicologo=? AND c.fecha_hora BETWEEN ? AND ?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            ps.setTimestamp(2, new Timestamp(desde.getTime()));
            ps.setTimestamp(3, new Timestamp(hasta.getTime()));
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return new ResumenEval(rs.getInt(1), rs.getDouble(2)); }
        } catch (SQLException e) { e.printStackTrace(); }
        return new ResumenEval(0, 0);
    }

    public java.util.List<Modelos.Evaluacion> listarPorCita(int idCita) {
        java.util.List<Modelos.Evaluacion> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM Evaluacion WHERE id_cita=? AND estado<>'inactivo' ORDER BY id DESC";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idCita);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Modelos.Evaluacion e = new Modelos.Evaluacion();
                    e.setId(rs.getInt("id"));
                    e.setIdCita(rs.getInt("id_cita"));
                    e.setEstadoEmocional(rs.getInt("estado_emocional"));
                    e.setComentarios(rs.getString("comentarios"));
                    e.setEstado(rs.getString("estado"));
                    list.add(e);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean crear(Modelos.Evaluacion eval) {
        String ins = "INSERT INTO Evaluacion (id_cita, estado_emocional, comentarios, estado) VALUES (?,?,?,?)";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(ins)) {
            ps.setInt(1, eval.getIdCita());
            ps.setInt(2, eval.getEstadoEmocional());
            ps.setString(3, eval.getComentarios());
            ps.setString(4, eval.getEstado() == null ? "activo" : eval.getEstado());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
