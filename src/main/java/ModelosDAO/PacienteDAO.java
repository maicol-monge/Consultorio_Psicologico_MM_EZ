package ModelosDAO;

import DB.cn;
import Modelos.Paciente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PacienteDAO {
    public List<Paciente> listarTodos() {
        String sql = "SELECT * FROM Paciente ORDER BY nombre";
        List<Paciente> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); Statement st = c.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Paciente p = new Paciente();
                p.setId(rs.getInt("id"));
                p.setNombre(rs.getString("nombre"));
                p.setEmail(rs.getString("email"));
                p.setTelefono(rs.getString("telefono"));
                p.setDireccion(rs.getString("direccion"));
                p.setEstado(rs.getString("estado"));
                p.setDui(rs.getString("dui"));
                p.setCodigoAcceso(rs.getString("codigo_acceso"));
                p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                p.setGenero(rs.getString("genero"));
                p.setHistorialClinico(rs.getString("historial_clinico"));
                lista.add(p);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public Paciente obtenerPorId(int id) {
        String sql = "SELECT * FROM Paciente WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Paciente p = new Paciente();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setEmail(rs.getString("email"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setEstado(rs.getString("estado"));
                    p.setDui(rs.getString("dui"));
                    p.setCodigoAcceso(rs.getString("codigo_acceso"));
                    p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    p.setGenero(rs.getString("genero"));
                    p.setHistorialClinico(rs.getString("historial_clinico"));
                    return p;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertar(Paciente p) {
        String sql = "INSERT INTO Paciente (nombre, email, telefono, direccion, estado, dui, codigo_acceso, fecha_nacimiento, genero, historial_clinico) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getDireccion());
            ps.setString(5, p.getEstado());
            ps.setString(6, p.getDui());
            ps.setString(7, p.getCodigoAcceso());
            ps.setDate(8, p.getFechaNacimiento() != null ? new java.sql.Date(p.getFechaNacimiento().getTime()) : null);
            ps.setString(9, p.getGenero());
            ps.setString(10, p.getHistorialClinico());
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

    public boolean actualizar(Paciente p) {
        String sql = "UPDATE Paciente SET nombre=?, email=?, telefono=?, direccion=?, estado=?, dui=?, fecha_nacimiento=?, genero=?, historial_clinico=? WHERE id=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getNombre());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getTelefono());
            ps.setString(4, p.getDireccion());
            ps.setString(5, p.getEstado());
            ps.setString(6, p.getDui());
            ps.setDate(7, p.getFechaNacimiento() != null ? new java.sql.Date(p.getFechaNacimiento().getTime()) : null);
            ps.setString(8, p.getGenero());
            ps.setString(9, p.getHistorialClinico());
            ps.setInt(10, p.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Paciente> buscar(String termino) {
        String sql = "SELECT * FROM Paciente WHERE nombre LIKE ? OR email LIKE ? OR dui LIKE ? ORDER BY nombre";
        List<Paciente> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            String busqueda = "%" + termino + "%";
            ps.setString(1, busqueda);
            ps.setString(2, busqueda);
            ps.setString(3, busqueda);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Paciente p = new Paciente();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setEmail(rs.getString("email"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setEstado(rs.getString("estado"));
                    p.setDui(rs.getString("dui"));
                    p.setCodigoAcceso(rs.getString("codigo_acceso"));
                    p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    p.setGenero(rs.getString("genero"));
                    p.setHistorialClinico(rs.getString("historial_clinico"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public int contarPorEstado(String estado) {
        String sql = "SELECT COUNT(*) FROM Paciente WHERE estado=?";
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, estado);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // Lista pacientes que tienen al menos una cita con el psicólogo indicado
    public List<Paciente> listarPorPsicologo(int idPsicologo) {
        String sql = "SELECT DISTINCT p.* FROM Paciente p " +
                "INNER JOIN Cita c ON c.id_paciente = p.id " +
                "WHERE c.id_psicologo = ? ORDER BY p.nombre";
        List<Paciente> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Paciente p = new Paciente();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setEmail(rs.getString("email"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setEstado(rs.getString("estado"));
                    p.setDui(rs.getString("dui"));
                    p.setCodigoAcceso(rs.getString("codigo_acceso"));
                    p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    p.setGenero(rs.getString("genero"));
                    p.setHistorialClinico(rs.getString("historial_clinico"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }

    public List<Paciente> buscarPorPsicologo(String termino, int idPsicologo) {
        String sql = "SELECT DISTINCT p.* FROM Paciente p " +
                "INNER JOIN Cita c ON c.id_paciente = p.id " +
                "WHERE c.id_psicologo = ? AND (p.nombre LIKE ? OR p.email LIKE ? OR p.dui LIKE ?) " +
                "ORDER BY p.nombre";
        List<Paciente> lista = new ArrayList<>();
        try (Connection c = cn.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, idPsicologo);
            String busqueda = "%" + termino + "%";
            ps.setString(2, busqueda);
            ps.setString(3, busqueda);
            ps.setString(4, busqueda);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Paciente p = new Paciente();
                    p.setId(rs.getInt("id"));
                    p.setNombre(rs.getString("nombre"));
                    p.setEmail(rs.getString("email"));
                    p.setTelefono(rs.getString("telefono"));
                    p.setDireccion(rs.getString("direccion"));
                    p.setEstado(rs.getString("estado"));
                    p.setDui(rs.getString("dui"));
                    p.setCodigoAcceso(rs.getString("codigo_acceso"));
                    p.setFechaNacimiento(rs.getDate("fecha_nacimiento"));
                    p.setGenero(rs.getString("genero"));
                    p.setHistorialClinico(rs.getString("historial_clinico"));
                    lista.add(p);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return lista;
    }
}