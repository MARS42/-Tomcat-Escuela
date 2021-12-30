<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="css/design.css">

    <script language="JavaScript" src="javascript/validar_campos.js"></script>
    <script language="JavaScript" src="javascript/validar_fecha.js"></script>
    
    <title>Escuela</title>
</head>
<body>
<%

  class Persona {
    public int id;
    public String nombre;
    public String apellidos;
    public String telefono;
    public String email;
    public String domicilio;
    public java.sql.Date fechanac;
    public int edad;
    public float estatura;
    public float peso;
    public String sexo;
    public int rol;

    public Persona(int id, String nombre, String apellidos, String telefono, String email, String domicilio, java.sql.Date fechanac, int edad, float estatura, float peso, String sexo, int rol){
      this.id = id;
      this.nombre = nombre;
      this.apellidos = apellidos;
      this.telefono = telefono;
      this.email = email;
      this.domicilio = domicilio;
      this.fechanac = fechanac;
      this.edad = edad;
      this.estatura = estatura;
      this.peso = peso;
      this.sexo = sexo;
      this.rol = rol;
    }

    public String NombreCompleto() { return nombre + " " + apellidos; }

    public String Rol() {  return rol == 1 ? "Alumno" : "Profesor"; }
  }

  class Alumno {
    public String ncontrol, carrera;
    public Persona persona;
    public java.sql.Date fechareg;
    public String semestre, tutor;

    public Alumno(String ncontrol, String carrera, Persona persona, java.sql.Date fechareg, String semestre, String tutor){
			this.ncontrol = ncontrol;
      this.carrera = carrera;
      this.persona = persona;
      this.fechareg = fechareg;
      this.semestre = semestre;
      this.tutor = tutor;
		}
  }

  class Profesor {
    public String especialidad, carrera;
    public Persona persona;
    public String tipo;
    public java.sql.Date fechareg;

    public Profesor(String especialidad, String carrera, Persona persona, String tipo, java.sql.Date fechareg){
			this.especialidad = especialidad;
      this.carrera = carrera;
      this.persona = persona;
      this.tipo = tipo;
      this.fechareg = fechareg;
		}
  }
	
	List<Persona> personas = new ArrayList<Persona>();
  List<Alumno> alumnos = new ArrayList<Alumno>();
  List<Profesor> profesores = new ArrayList<Profesor>();

	Class.forName("org.postgresql.Driver");

	Connection conexion = DriverManager.getConnection("jdbc:postgresql://progweb.postgres.database.azure.com:5432/escuela?user=master@progweb&password=Password0&sslmode=require");

	Statement st = conexion.createStatement();
	ResultSet rs = st.executeQuery("select * from persona order by id");

	while(rs.next()){
    Persona persona = new Persona(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getDate(7), rs.getInt(8), rs.getFloat(9), rs.getFloat(10), rs.getString(11), rs.getInt(12));
		personas.add(persona);
    Statement st2 = conexion.createStatement();
    ResultSet rs2;
    if(persona.rol == 1){
      rs2 = st2.executeQuery("select * from alumno where id_persona="+persona.id);
      rs2.next();
      Alumno alumno = new Alumno(rs2.getString(1), rs2.getString(2), persona, rs2.getDate(4), rs2.getString(5), rs2.getString(6));
      alumnos.add(alumno);
      st2.close();
    }
    else {
      rs2 = st2.executeQuery("select * from profesor where id_persona="+persona.id);
      rs2.next();
      Profesor profesor = new Profesor(rs2.getString(1), rs2.getString(2), persona, rs2.getString(4), rs2.getDate(5));
      profesores.add(profesor);
      st2.close();
    }
	}
	st.close();
	conexion.close();
%>
  <div class="principal">
    <div class="contenido">
      <div class="tabs">
        <div class="tab tab-active" data-tab-content="tab-alumnos">Alumnos</div>
        <div class="tab" data-tab-content="tab-profesores">Profesores</div>
        <%-- <div class="tab" data-tab-content="tab-lista">Registros</div> --%>
      </div>
      <div class="tabs-content">
        <div id="tab-alumnos" class="tab-content tab-content-active">
          <table>
            <tr>
              <th>X</th>
              <th>No. Control</th>
              <th>Nombre</th>
              <th>Carrera</th>
              <th>Semestre</th>
              <th>Tutor</th>
            </tr>
            <tr>
              <%for(int i=0; i<alumnos.size();i++){%>
                  <tr>
                    <td><input id="id-<%= alumnos.get(i).persona.id %>" type="checkbox" onClick="TogglePersona(<%= alumnos.get(i).persona.id %>)"></td>
                    <td><%= alumnos.get(i).ncontrol %></td>
                    <td><a href="registroAlumno.jsp?id=<%= alumnos.get(i).persona.id %>"><%= alumnos.get(i).persona.NombreCompleto() %><a/></td>
                    <td><%= alumnos.get(i).carrera %></td>
                    <td><%= alumnos.get(i).semestre %></td>
                    <td><%= alumnos.get(i).tutor %></td>  
                  </tr>
              <%}%>
            </tr>
          </table>
          <div class="acciones">
            <form name="eliminacion" action="<%=request.getContextPath()%>/eliminar" method="POST" onSubmit="return ConfirmarEliminacionAlumnos();">
              <input type="hidden" name="ids" value="">
              <input class="btn" type="submit" value="Eliminar alumnos">
            </form>
            <input class="btn" type="button" value="Nuevo alumno" onClick="document.location.href='registroAlumno.jsp'">
          </div>
        </div>
        <div id="tab-profesores" class="tab-content">
          <table>
            <tr>
              <th>X</th>
              <th>Especialidad</th>
              <th>Nombre</th>
              <th>Carrera</th>
              <th>Email</th>
              <th>Tipo</th>
            </tr>
            <tr>
              <%for(int i=0; i<profesores.size();i++){%>
                  <tr>
                    <td><input id="id-<%= profesores.get(i).persona.id %>" type="checkbox" onClick="ToggleProfe(<%= profesores.get(i).persona.id %>)"></td>
                    <td><%= profesores.get(i).especialidad %></td>
                    <td><a href="registroProfesores.jsp?id=<%= profesores.get(i).persona.id %>"><%= profesores.get(i).persona.NombreCompleto() %><a/></td>
                    <td><%= profesores.get(i).carrera %></td>
                    <td><%= profesores.get(i).persona.email %></td>
                    <td><%= profesores.get(i).tipo.contentEquals("1") ? "Base" : "Contrato" %></td>  
                  </tr>
              <%}%>
            </tr>
          </table>
          <div class="acciones">
            <form name="eliminacion2" action="<%=request.getContextPath()%>/eliminarProfesor" method="POST" onSubmit="return ConfirmarEliminacionProfes();">
              <input type="hidden" name="ids" value="">
              <input class="btn" type="submit" value="Eliminar profesores">
            </form>
            <input class="btn" type="button" value="Nuevo profesor" onClick="document.location.href='registroProfesores.jsp'">
          </div>
        </div>
        <%-- <div id="tab-lista" class="tab-content">
          <table>
            <tr>
              <th>Nombre</th>
              <th>Rol</th>
            </tr>
              <%for(int i=0; i<personas.size();i++){%>
                  <tr>
                      <td><%= personas.get(i).NombreCompleto() %></td>
                      <td><%= personas.get(i).Rol() %></td>  
                  </tr>
              <%}%>
          </table>
        </div> --%>
      </div>
    </div>
  </div>
  <script language="JavaScript" src="javascript/design.js"></script>
</body>
</html>