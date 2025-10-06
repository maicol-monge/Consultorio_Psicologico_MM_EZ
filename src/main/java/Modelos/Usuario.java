package Modelos;

public class Usuario {
    private int id;
    private String nombre;
    private String email;
    private String passwordd;
    private String rol; // 'admin' | 'psicologo'
    private String estado; // 'activo' | 'inactivo'

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getNombre() { return nombre; }
    public void setNombre(String nombre) { this.nombre = nombre; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordd() { return passwordd; }
    public void setPasswordd(String passwordd) { this.passwordd = passwordd; }
    public String getRol() { return rol; }
    public void setRol(String rol) { this.rol = rol; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
