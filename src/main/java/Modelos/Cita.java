package Modelos;

import java.util.Date;

public class Cita {
    private int id;
    private int idPaciente;
    private int idPsicologo;
    private Date fechaHora;
    private String estadoCita; // pendiente|realizada|cancelada
    private String motivoConsulta;
    private String qrCode;
    private String estado;
    private String observaciones;
    private Date fechaCreacion;
    
    // Campos adicionales para vistas
    private String pacienteNombre;
    private String psicologoNombre;
    
    // Alias para compatibilidad
    private String motivo;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdPaciente() { return idPaciente; }
    public void setIdPaciente(int idPaciente) { this.idPaciente = idPaciente; }
    public int getIdPsicologo() { return idPsicologo; }
    public void setIdPsicologo(int idPsicologo) { this.idPsicologo = idPsicologo; }
    public Date getFechaHora() { return fechaHora; }
    public void setFechaHora(Date fechaHora) { this.fechaHora = fechaHora; }
    public String getEstadoCita() { return estadoCita; }
    public void setEstadoCita(String estadoCita) { this.estadoCita = estadoCita; }
    public String getMotivoConsulta() { return motivoConsulta; }
    public void setMotivoConsulta(String motivoConsulta) { this.motivoConsulta = motivoConsulta; }
    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getObservaciones() { return observaciones; }
    public void setObservaciones(String observaciones) { this.observaciones = observaciones; }
    public Date getFechaCreacion() { return fechaCreacion; }
    public void setFechaCreacion(Date fechaCreacion) { this.fechaCreacion = fechaCreacion; }
    
    public String getPacienteNombre() { return pacienteNombre; }
    public void setPacienteNombre(String pacienteNombre) { this.pacienteNombre = pacienteNombre; }
    public String getPsicologoNombre() { return psicologoNombre; }
    public void setPsicologoNombre(String psicologoNombre) { this.psicologoNombre = psicologoNombre; }
    
    // Métodos alias para compatibilidad
    public String getMotivo() { return motivoConsulta; }
    public void setMotivo(String motivo) { this.motivoConsulta = motivo; }
}
