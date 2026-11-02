package org.gerdoc.servlet;

import org.gerdoc.model.Alumno;
import org.gerdoc.model.AlumnoMateria;
import org.gerdoc.model.Materia;
import org.gerdoc.service.AlumnoMateriaService;
import org.gerdoc.service.AlumnoService;
import org.gerdoc.service.MateriaService;
import org.gerdoc.service.impl.AlumnoMateriaServiceImpl;
import org.gerdoc.service.impl.AlumnoServiceImpl;
import org.gerdoc.service.impl.MateriaServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serial;
import java.math.BigDecimal;

@WebServlet("/AlumnoMateriaServlet")
public class AlumnoMateriaServlet extends HttpServlet
{
    @Serial
    private static final long serialVersionUID = 1L;
    private final AlumnoMateriaService alumnoMateriaService = new AlumnoMateriaServiceImpl( );
    private final AlumnoService alumnoService = new AlumnoServiceImpl( );
    private final MateriaService materiaService = new MateriaServiceImpl( );

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {
        String accion = req.getParameter("accion");

        if ("delete".equals(accion))
        {
            Long id = Long.parseLong( req.getParameter("id" ) );
            alumnoMateriaService.deleteById( id );
            resp.sendRedirect("AlumnoMaterias.jsp" );
            return;
        }

        try {
            Long alumnoId = Long.parseLong( req.getParameter("alumnoId" ) );
            Long materiaId = Long.parseLong( req.getParameter("materiaId" ) );

            String idStr = req.getParameter("id");
            Long id = (idStr != null && !idStr.isEmpty() && !"0".equals(idStr)) ? Long.parseLong(idStr) : null;

            String calificacionParam = req.getParameter("calificacion");
            BigDecimal calificacion = (calificacionParam != null && !calificacionParam.trim().isEmpty())
                    ? new BigDecimal(calificacionParam)
                    : null;

            Alumno alumno = alumnoService.findById( alumnoId );
            Materia materia = materiaService.findById( materiaId );

            if (alumno != null && materia != null) {
                AlumnoMateria alumnoMateria = AlumnoMateria.builder( )
                        .materia(materia)
                        .alumno(alumno)
                        .calificacion(calificacion)
                        .build();

                if ("update".equals(accion) && id != null)
                {
                    alumnoMateria.setId( id );
                    alumnoMateriaService.update( alumnoMateria );
                }
                else
                {
                    alumnoMateriaService.save( alumnoMateria );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        resp.sendRedirect("AlumnoMaterias.jsp");
    }
}