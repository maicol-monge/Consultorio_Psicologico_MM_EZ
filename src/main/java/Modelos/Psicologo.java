package Modelos;

public class Psicologo {
    private int id;
    private int idUsuario;
    private String especialidad;
    private String experiencia;
    private String horario;
    private String estado;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdUsuario() { return idUsuario; }
    public void setIdUsuario(int idUsuario) { this.idUsuario = idUsuario; }
    public String getEspecialidad() { return especialidad; }
    public void setEspecialidad(String especialidad) { this.especialidad = especialidad; }
    public String getExperiencia() { return experiencia; }
    public void setExperiencia(String experiencia) { this.experiencia = experiencia; }
    public String getHorario() { return horario; }
    public void setHorario(String horario) { this.horario = horario; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
