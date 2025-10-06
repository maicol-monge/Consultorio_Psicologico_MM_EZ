package ModelosDAO;

import DB.cn;
import Modelos.Psicologo;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PsicologoDAO {
    public Psicologo obtenerPorUsuarioId(int usuarioId) {
        String sql = "SELECT * FROM Psicologo WHERE id_usuario=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, usuarioId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Psicologo p = new Psicologo();
                    p.setId(rs.getInt("id"));
                    p.setIdUsuario(rs.getInt("id_usuario"));
                    p.setEspecialidad(rs.getString("especialidad"));
                    p.setExperiencia(rs.getString("experiencia"));
                    p.setHorario(rs.getString("horario"));
                    p.setEstado(rs.getString("estado"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Psicologo> listarTodos() {
        String sql = "SELECT p.*, u.nombre, u.email FROM Psicologo p JOIN Usuario u ON p.id_usuario = u.id ORDER BY u.nombre";
        List<Psicologo> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Psicologo p = new Psicologo();
                p.setId(rs.getInt("id"));
                p.setIdUsuario(rs.getInt("id_usuario"));
                p.setEspecialidad(rs.getString("especialidad"));
                p.setExperiencia(rs.getString("experiencia"));
                p.setHorario(rs.getString("horario"));
                p.setEstado(rs.getString("estado"));
                lista.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Psicologo obtenerPorId(int id) {
        String sql = "SELECT * FROM Psicologo WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Psicologo p = new Psicologo();
                    p.setId(rs.getInt("id"));
                    p.setIdUsuario(rs.getInt("id_usuario"));
                    p.setEspecialidad(rs.getString("especialidad"));
                    p.setExperiencia(rs.getString("experiencia"));
                    p.setHorario(rs.getString("horario"));
                    p.setEstado(rs.getString("estado"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(Psicologo p) {
        String sql = "INSERT INTO Psicologo (id_usuario, especialidad, experiencia, horario, estado) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getIdUsuario());
            ps.setString(2, p.getEspecialidad());
            ps.setString(3, p.getExperiencia());
            ps.setString(4, p.getHorario());
            ps.setString(5, p.getEstado());
            int result = ps.executeUpdate();
            if (result > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        p.setId(keys.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean actualizar(Psicologo p) {
        String sql = "UPDATE Psicologo SET especialidad=?, experiencia=?, horario=?, estado=? WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getEspecialidad());
            ps.setString(2, p.getExperiencia());
            ps.setString(3, p.getHorario());
            ps.setString(4, p.getEstado());
            ps.setInt(5, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
