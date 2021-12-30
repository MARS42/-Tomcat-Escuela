<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*,java.util.*,java.time.*,java.time.format.*,java.text.SimpleDateFormat"%>
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

  boolean editando = request.getParameter("id") != null;
  Profesor profe = null;
	
  if(editando){
    Class.forName("org.postgresql.Driver");

    Connection conexion = DriverManager.getConnection("jdbc:postgresql://progweb.postgres.database.azure.com:5432/escuela?user=master@progweb&password=Password0&sslmode=require");

    Statement st = conexion.createStatement();
    ResultSet rs = st.executeQuery("select * from persona where id=" + request.getParameter("id"));
    rs.next();
    Persona persona = new Persona(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getDate(7), rs.getInt(8), rs.getFloat(9), rs.getFloat(10), rs.getString(11), rs.getInt(12));
    
    Statement st2 = conexion.createStatement();
    ResultSet rs2;
    rs2 = st2.executeQuery("select * from profesor where id_persona="+persona.id);
    rs2.next();
    profe = new Profesor(rs2.getString(1), rs2.getString(2), persona, rs2.getString(4), rs2.getDate(5));
    
    st2.close();
    st.close();
    conexion.close();
    SimpleDateFormat fm = new SimpleDateFormat("dd-MM-yyyy");
    java.sql.Date nueva_fechanac = java.sql.Date.valueOf(LocalDate.parse(fm.format(profe.persona.fechanac), DateTimeFormatter.ofPattern("dd-MM-uuuu")));
    
  }
%>
  <div class="principal">
    <div class="contenido">
      <div class="tabs">
        <div class="tab tab-active" data-tab-content="tab-profesores">Profesores</div>
      </div>
      <div class="tabs-content">
        <div id="tab-profesores" class="tab-content tab-content-active">
          <div class="contenido-formulario">
            <div class="titulo">
                <h2><%= editando ? "Actualizar Profesor" : "Registrar Profesor" %></h2>
            </div>
            <div class="formulario">
              <form name="form2" action='<%=editando ? request.getContextPath() + "/actualizarProfesor?id=" + profe.persona.id : request.getContextPath() + "/altaProfesor" %>' method="POST" onSubmit="return validar('form2')">
                <fieldset><legend>Información Personal</legend>
                  <div class="campos">
                    <div>
                      <label class="inputxt">Nombre</label>
                      <input type="text" id="Nombre" placeholder="Nombre(s)"  name="nombre" value='<%= editando ? profe.persona.nombre : "" %>'><br>
                      <label class="inputxt">Apellidos</label>
                      <input type="text" id="Apellidos" placeholder="Apellidos"  name="apellido" value='<%= editando ? profe.persona.apellidos : "" %>'><br>
                      <label class="inputxt">Telefono</label>
                      <input type="text" id="Telefono" placeholder="Teléfono" name="telefono" value='<%= editando ? profe.persona.telefono : "" %>'><br>
                      <label class="inputxt">Email</label>
                      <input type="text" id="Email" placeholder="Email personal" name="email" value='<%= editando ? profe.persona.email : "" %>'><br>
                      <label class="inputxt">Domicilio</label>
                      <input type="text" id="Domicilio" placeholder="Domicilio" name="domicilio" value='<%= editando ? profe.persona.domicilio : "" %>'><br>
                    </div>
                  <div>
                    <label class="inputxt">Fecha de nacimiento</label>
                    <input type="text" id="Fecha" placeholder="Fecha nacimiento" name="fechanac"  value='<%= editando ? (new SimpleDateFormat("dd-MM-yyyy")).format(profe.persona.fechanac) : "" %>'><br>
                    <label class="inputxt">Edad</label>
                    <input type="text"  id="Edad" placeholder="Edad"  name="edad" value='<%= editando ? profe.persona.edad : "" %>'><br>
                    <label class="inputxt">Altura</label>
                    <input type="text"  id="Altura" placeholder="Altura (cm)"  name="altura" value='<%= editando ? profe.persona.estatura : "" %>'><br>
                    <label class="inputxt">Peso</label>
                    <input type="text"  id="Peso" placeholder="Peso (kg)"  name="peso" value='<%= editando ? profe.persona.peso : "" %>'><br>
                    <label class="inputxt">Sexo</label>
                    <input type="radio" id="hombre" name="sexo" value="Hombre" <%= editando ? ( profe.persona.sexo.contentEquals("Hombre") ? "checked" : "") : "" %>>
                    <label for="hombre">Hombre</label>
                    <input type="radio" id="mujer" name="sexo" value="Mujer" <%= editando ? ( profe.persona.sexo.contentEquals("Mujer") ? "checked" : "") : "" %>>
                    <label for="mujer">Mujer</label><br>
                    </div>
                  </div>
                </fieldset>
                <fieldset><legend>Datos institucionales</legend>
                  <label class="inputxt">Especialidad</label>
                  <input type="text"  id="No. Control" placeholder="Especialidad"  name="especialidad" size="25" value='<%= editando ? profe.especialidad : "" %>'><br>
                  <label class="inputxt">Carrera</label>
                  <input type="text"  id="Carrera" placeholder="Carrera"  name="carrera" size="25" value='<%= editando ? profe.carrera : "" %>'><br>
                  <label class="inputxt">Tipo</label>
                  <select name="tipo" id="Semestre">
                    <option value="0">Tipo</option>
                    <option value="1" <%= editando ? ( profe.tipo.contentEquals("1") ? "selected" : "") : "" %>>Base</option>
                    <option value="2" <%= editando ? ( profe.tipo.contentEquals("2") ? "selected" : "") : "" %>>Contrato</option>
                  </select><br>
                  <label>Fecha de registro</label>
                  <input type="text" id="Fecha" placeholder="Fecha registro" name="fechareg" value='<%= editando ? (new SimpleDateFormat("dd-MM-yyyy")).format(profe.fechareg) : "" %>'>
                </fieldset> 
                <input class="btn" type="submit" name="submit2" value='<%= editando ? "Actualizar" : "Registrar" %>'>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <script language="JavaScript" src="javascript/design.js"></script>
</body>
</html>