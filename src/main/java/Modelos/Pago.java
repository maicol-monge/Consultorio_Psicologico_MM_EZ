package Modelos;

import java.util.Date;
import java.math.BigDecimal;

public class Pago {
    private int id;
    private Integer idCita;
    private BigDecimal montoBase;
    private BigDecimal montoTotal;
    private Date fecha;
    private String estadoPago; // 'pendiente' | 'pagado'
    private String estado; // 'activo' | 'inactivo'

    // Auxiliares para vistas
    private String pacienteNombre;
    private String psicologoNombre;
    private Date citaFechaHora;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public Integer getIdCita() { return idCita; }
    public void setIdCita(Integer idCita) { this.idCita = idCita; }
    public BigDecimal getMontoBase() { return montoBase; }
    public void setMontoBase(BigDecimal montoBase) { this.montoBase = montoBase; }
    public BigDecimal getMontoTotal() { return montoTotal; }
    public void setMontoTotal(BigDecimal montoTotal) { this.montoTotal = montoTotal; }
    public Date getFecha() { return fecha; }
    public void setFecha(Date fecha) { this.fecha = fecha; }
    public String getEstadoPago() { return estadoPago; }
    public void setEstadoPago(String estadoPago) { this.estadoPago = estadoPago; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getPacienteNombre() { return pacienteNombre; }
    public void setPacienteNombre(String pacienteNombre) { this.pacienteNombre = pacienteNombre; }
    public String getPsicologoNombre() { return psicologoNombre; }
    public void setPsicologoNombre(String psicologoNombre) { this.psicologoNombre = psicologoNombre; }
    public Date getCitaFechaHora() { return citaFechaHora; }
    public void setCitaFechaHora(Date citaFechaHora) { this.citaFechaHora = citaFechaHora; }
}
