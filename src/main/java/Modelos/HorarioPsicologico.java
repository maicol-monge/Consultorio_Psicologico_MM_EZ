package Modelos;

import java.sql.Time;

public class HorarioPsicologico {
    private int id;
    private int idPsicologo;
    private String diaSemana; // lunes, martes, miércoles, jueves, viernes, sábado, domingo
    private Time horaInicio;
    private Time horaFin;
    private String estado; // activo, inactivo

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getIdPsicologo() { return idPsicologo; }
    public void setIdPsicologo(int idPsicologo) { this.idPsicologo = idPsicologo; }

    public String getDiaSemana() { return diaSemana; }
    public void setDiaSemana(String diaSemana) { this.diaSemana = diaSemana; }

    public Time getHoraInicio() { return horaInicio; }
    public void setHoraInicio(Time horaInicio) { this.horaInicio = horaInicio; }

    public Time getHoraFin() { return horaFin; }
    public void setHoraFin(Time horaFin) { this.horaFin = horaFin; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
}
