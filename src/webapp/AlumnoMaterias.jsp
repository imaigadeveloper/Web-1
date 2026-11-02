<%@ page import="org.gerdoc.service.AlumnoMateriaService" %>
<%@ page import="org.gerdoc.service.impl.AlumnoMateriaServiceImpl" %>
<%@ page import="org.gerdoc.model.AlumnoMateria" %>
<%@ page import="java.util.List" %>
<%@ page import="org.gerdoc.model.Alumno" %>
<%@ page import="org.gerdoc.service.AlumnoService" %>
<%@ page import="org.gerdoc.service.impl.AlumnoServiceImpl" %>
<%@ page import="org.gerdoc.service.impl.MateriaServiceImpl" %>
<%@ page import="org.gerdoc.service.MateriaService" %>
<%@ page import="org.gerdoc.model.Materia" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AlumnoMaterias</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB" crossorigin="anonymous">
</head>
<body>
<div class="container">
    <h1>AlumnoMaterias</h1>
    <%
        AlumnoMateriaService alumnoMateriaService = new AlumnoMateriaServiceImpl( );
        List<AlumnoMateria> alumnoMaterias = alumnoMateriaService.findAll( );
        AlumnoService alumnoService = new AlumnoServiceImpl( );
        List<Alumno> alumnos = alumnoService.findAll( );

        MateriaService materiaService = new MateriaServiceImpl( );
        List<Materia> materias = materiaService.findAll( );
    %>
    <button type="button" class="btn btn-success mb-3" data-bs-toggle="modal" data-bs-target="#alumnoMateriaModal" onclick="nuevoAlumnoMateria()" >
        Agregar alumnoMateria
    </button>
    <table class="table">
        <thead>
        <tr>
            <th scope="col">#</th>
            <th scope="col">Alumno</th>
            <th scope="col">Materia</th>
            <th scope="col">Calificación</th>
            <th scope="col">Acción</th>
        </tr>
        </thead>
        <%
            int i = 0;
            for (AlumnoMateria alumnoMateria : alumnoMaterias)
            {
        %>
                <tbody>
                    <tr>
                        <th scope="row"><%=++i%></th>
                        <td>
                            <a href="AlumnoMateria.jsp?id=<%= alumnoMateria.getId( ) %>" class="link-primary link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover">
                                <%= alumnoMateria.getAlumno( ).getNombre() %>
                            </a>
                        </td>
                        <td><%= alumnoMateria.getMateria( ).getNombre()%></td>
                        <td><%= (alumnoMateria.getCalificacion() != null) ? alumnoMateria.getCalificacion() : "N/A" %></td>
                        <td>
                            <!-- BOTÓN EDITAR -->
                            <button type="button" class="btn btn-warning btn-sm btn-editar" data-bs-toggle="modal" data-bs-target="#alumnoMateriaModal"
                                    data-id="<%= alumnoMateria.getId( ) %>"
                                    data-alumnoId="<%= alumnoMateria.getAlumno( ).getId() %>"
                                    data-materiaId="<%= alumnoMateria.getMateria( ).getId( ) %>"
                                    data-calificacion="<%= (alumnoMateria.getCalificacion() != null) ? alumnoMateria.getCalificacion() : "" %>"
                                    >
                                Editar
                            </button>
                            <!-- BOTÓN BORRAR -->
                            <form action="AlumnoMateriaServlet" method="post" style="display:inline;">
                                <input type="hidden" name="accion" value="delete">
                                <input type="hidden" name="id" value="<%= alumnoMateria.getId( ) %>">
                                <button type="submit" class="btn btn-danger btn-sm"
                                        onclick="return confirm('¿Seguro que deseas borrar este alumnoMateria?');">
                                    Borrar
                                </button>
                            </form>
                        </td>
                    </tr>
                </tbody>
        <%
            }
        %>
    </table>
    <a href="index.jsp" class="btn btn-secondary">Home</a>
</div>

<!-- Popup / Modal con formulario -->
<div class="modal fade" id="alumnoMateriaModal" tabindex="-1" aria-labelledby="alumnoMateriaModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-header">
                <h5 class="modal-title" id="alumnoMateriaModalLabel">Formulario de Alumno Materia</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
            </div>

            <form action="AlumnoMateriaServlet" method="post" id="formAlumnoMateria">
                <input type="hidden" id="accion" name="accion" value="save" />
                <input type="hidden" id="id" name="id" value="">
                <div class="modal-body">

                    <div class="mb-3">
                        <label for="alumnoId" class="form-label">Alumno</label>
                        <select class="form-select" id="alumnoId" name="alumnoId" required>
                            <option value="">Selecciona un alumno</option>
                            <%
                                for (Alumno alumno : alumnos)
                                {
                            %>
                            <option value="<%= alumno.getId( ) %>">
                                <%= alumno.getNombre( ) %>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="materiaId" class="form-label">Materia</label>
                        <select class="form-select" id="materiaId" name="materiaId" required>
                            <option value="">Selecciona una materia</option>
                            <%
                                for (Materia materia : materias)
                                {
                            %>
                            <option value="<%= materia.getId( ) %>">
                                <%= materia.getNombre( ) %>
                            </option>
                            <%
                                }
                            %>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label for="calificacion" class="form-label">Calificación</label>
                        <input type="number" step="0.01" min="0" max="10" class="form-control" id="calificacion" name="calificacion" placeholder="ej. 9.50">
                    </div>

                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Cerrar
                    </button>
                    <button type="submit" class="btn btn-primary" id="btnGuardar">
                        Guardar Alumno Materia
                    </button>
                </div>
            </form>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js" integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI" crossorigin="anonymous"></script>

<!-- JAVASCRIPT -->
<script>
    function nuevoAlumnoMateria()
    {
        document.getElementById("formAlumnoMateria").reset();
        document.getElementById("id").value = "0";
        document.getElementById("accion").value = "save";
        document.getElementById("alumnoMateriaModalLabel").textContent = "Agregar Alumno Materia";
        document.getElementById("btnGuardar").textContent = "Guardar Alumno Materia";
    }

    const modalAlumnoMateria = document.getElementById("alumnoMateriaModal");
    modalAlumnoMateria.addEventListener("show.bs.modal",
        function(event)
        {
            const boton = event.relatedTarget;
            if (!boton || !boton.classList.contains("btn-editar"))
            {
                return;
            }
            const id = boton.getAttribute( "data-id" );
            const alumnoId = boton.getAttribute( "data-alumnoId" );
            const materiaId = boton.getAttribute( "data-materiaId" );
            const calificacion = boton.getAttribute( "data-calificacion" );

            document.getElementById( "id" ).value = id;
            document.getElementById( "alumnoId" ).value = alumnoId;
            document.getElementById( "materiaId" ).value = materiaId;
            document.getElementById( "calificacion" ).value = calificacion;
            document.getElementById( "accion" ).value = "update";
            document.getElementById( "alumnoMateriaModalLabel" ).textContent = "Editar Alumno Materia";
            document.getElementById( "btnGuardar" ).textContent = "Actualizar Alumno Materia";
        }
    );
</script>
</body>
</html>