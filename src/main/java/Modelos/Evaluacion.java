package Modelos;

public class Evaluacion {
    private int id;
    private int idCita;
    private int estadoEmocional; // 1..10
    private String comentarios;
    private String estado;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdCita() { return idCita; }
    public void setIdCita(int idCita) { this.idCita = idCita; }
    public int getEstadoEmocional() { return estadoEmocional; }
    public void setEstadoEmocional(int estadoEmocional) { this.estadoEmocional = estadoEmocional; }
    public String getComentarios() { return comentarios; }
    public void setComentarios(String comentarios) { this.comentarios = comentarios; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
