package Modelos;

import java.util.Date;

public class TicketPago {
    private int id;
    private int idPago;
    private String codigo;
    private Date fechaEmision;
    private String numeroTicket;
    private String qrCode;
    private String estado;
    
    // Campos adicionales para vistas
    private double monto;
    private String pacienteNombre;
    private String conceptoPago;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getIdPago() { return idPago; }
    public void setIdPago(int idPago) { this.idPago = idPago; }
    public String getCodigo() { return codigo; }
    public void setCodigo(String codigo) { this.codigo = codigo; }
    public Date getFechaEmision() { return fechaEmision; }
    public void setFechaEmision(Date fechaEmision) { this.fechaEmision = fechaEmision; }
    public String getNumeroTicket() { return numeroTicket; }
    public void setNumeroTicket(String numeroTicket) { this.numeroTicket = numeroTicket; }
    public String getQrCode() { return qrCode; }
    public void setQrCode(String qrCode) { this.qrCode = qrCode; }
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public double getMonto() { return monto; }
    public void setMonto(double monto) { this.monto = monto; }
    public String getPacienteNombre() { return pacienteNombre; }
    public void setPacienteNombre(String pacienteNombre) { this.pacienteNombre = pacienteNombre; }
    public String getConceptoPago() { return conceptoPago; }
    public void setConceptoPago(String conceptoPago) { this.conceptoPago = conceptoPago; }
}
