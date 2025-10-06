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
}
