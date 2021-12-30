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

    boolean editando = request.getParameter("id") != null;
    Alumno alumno = null;

    if(editando){
      Class.forName("org.postgresql.Driver");

      Connection conexion = DriverManager.getConnection("jdbc:postgresql://progweb.postgres.database.azure.com:5432/escuela?user=master@progweb&password=Password0&sslmode=require");

      Statement st = conexion.createStatement();
      ResultSet rs = st.executeQuery("select * from persona where id=" + request.getParameter("id"));
      rs.next();
      Persona persona = new Persona(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6), rs.getDate(7), rs.getInt(8), rs.getFloat(9), rs.getFloat(10), rs.getString(11), rs.getInt(12));
      
      Statement st2 = conexion.createStatement();
      ResultSet rs2;
      rs2 = st2.executeQuery("select * from alumno where id_persona="+persona.id);
      rs2.next();
      alumno = new Alumno(rs2.getString(1), rs2.getString(2), persona, rs2.getDate(4), rs2.getString(5), rs2.getString(6));
      
      st2.close();
      st.close();
      conexion.close();
      SimpleDateFormat fm = new SimpleDateFormat("dd-MM-yyyy");
      java.sql.Date nueva_fechanac = java.sql.Date.valueOf(LocalDate.parse(fm.format(alumno.persona.fechanac), DateTimeFormatter.ofPattern("dd-MM-uuuu")));
      
    }
  %>
  <div class="principal">
    <div class="contenido">
      <div class="tabs">
        <div class="tab tab-active" data-tab-content="tab-alumnos">Alumnos</div>
      </div>
      <div class="tabs-content">
        <div id="tab-alumnos" class="tab-content tab-content-active">
          <div class="contenido-formulario">
            <div class="titulo">
                <h2><%= editando ? "Actualizar Alumno" : "Registrar Alumno" %></h2>
            </div>
            <div class="formulario">
              <form name="form1" action='<%=editando ? request.getContextPath() + "/actualizar?id=" + alumno.persona.id : request.getContextPath() + "/alta" %>' method="POST" onSubmit="return validar('form1')">
                <fieldset><legend>Información Personal</legend>
                  <div class="campos">
                    <div>
                      <label class="inputxt">Nombre</label>
                      <input type="text" id="Nombre" placeholder="Nombre(s)" name="nombre" value='<%= editando ? alumno.persona.nombre : "" %>'><br>
                      <label class="inputxt">Apellidos</label>
                      <input type="text" id="Apellidos" placeholder="Apellidos" name="apellido" value='<%= editando ? alumno.persona.apellidos : "" %>'><br>
                      <label class="inputxt">Telefono</label>
                      <input type="text" id="Telefono" placeholder="Teléfono" name="telefono" value='<%= editando ? alumno.persona.telefono : "" %>'><br>
                      <label class="inputxt">Email</label>
                      <input type="text" id="Email" placeholder="Email personal" name="email" value='<%= editando ? alumno.persona.email : "" %>'><br>
                      <label class="inputxt">Domicilio</label>
                      <input type="text" id="Domicilio" placeholder="Domicilio" name="domicilio" value='<%= editando ? alumno.persona.domicilio : "" %>'><br>
                      <label class="inputxt">Tutor</label>
                      <input type="text" id="novalid" placeholder="Tutor" name="tutor" value='<%= editando ? alumno.tutor : "" %>'><br>
                    </div>
                  <div>
                    <label class="inputxt">Fecha de nacimiento</label>
                    <input type="text" id="Fecha" placeholder="Fecha nacimiento" name="fechanac" value='<%= editando ? (new SimpleDateFormat("dd-MM-yyyy")).format(alumno.persona.fechanac) : "" %>'><br>
                    <label class="inputxt">Edad</label>
                    <input type="text"  id="Edad" placeholder="Edad"  name="edad" value='<%= editando ? alumno.persona.edad : "" %>'><br>
                    <label class="inputxt">Altura</label>
                    <input type="text"  id="Altura" placeholder="Altura (cm)"  name="altura" value='<%= editando ? alumno.persona.estatura : "" %>'><br>
                    <label class="inputxt">Peso</label>
                    <input type="text"  id="Peso" placeholder="Peso (kg)"  name="peso" value='<%= editando ? alumno.persona.peso : "" %>'><br>
                    <label class="inputxt">Sexo</label>
                    <input type="radio" id="hombre" name="sexo" value="Hombre" <%= editando ? ( alumno.persona.sexo.contentEquals("Hombre") ? "checked" : "") : "" %>>
                    <label for="hombre">Hombre</label>
                    <input type="radio" id="mujer" name="sexo" value="Mujer" <%= editando ? ( alumno.persona.sexo.contentEquals("Mujer") ? "checked" : "") : "" %>>
                    <label for="mujer">Mujer</label><br>
                    </div>
                  </div>
                </fieldset>
                <fieldset><legend>Datos institucionales</legend>
                  <label class="inputxt">No. de control</label>
                  <input type="text"  id="No. Control" placeholder="No. de control"  name="ncontrol" size="25" value='<%= editando ? alumno.ncontrol : "" %>'><br>
                  <label class="inputxt">Carrera</label>
                  <input type="text"  id="Carrera" placeholder="Carrera"  name="carrera" size="25" value='<%= editando ? alumno.carrera : "" %>'><br>
                  <label class="inputxt">Semestre</label>
                  <select name="semestre" id="Semestre">
                    <option value="0">Semestre</option>
                    <option value="1" <%= editando ? ( alumno.semestre.contentEquals("1") ? "selected" : "") : "" %>>Primero</option>
                    <option value="2" <%= editando ? ( alumno.semestre.contentEquals("2") ? "selected" : "") : "" %>>Segundo</option>
                    <option value="3" <%= editando ? ( alumno.semestre.contentEquals("3") ? "selected" : "") : "" %>>Tercero</option>
                    <option value="4" <%= editando ? ( alumno.semestre.contentEquals("4") ? "selected" : "") : "" %>>Cuarto</option>
                    <option value="5" <%= editando ? ( alumno.semestre.contentEquals("5") ? "selected" : "") : "" %>>Quinto</option>
                    <option value="6" <%= editando ? ( alumno.semestre.contentEquals("6") ? "selected" : "") : "" %>>Sexto</option>
                    <option value="7" <%= editando ? ( alumno.semestre.contentEquals("7") ? "selected" : "") : "" %>>Septimo</option>
                    <option value="8" <%= editando ? ( alumno.semestre.contentEquals("8") ? "selected" : "") : "" %>>Octavo</option>
                    <option value="9" <%= editando ? ( alumno.semestre.contentEquals("9") ? "selected" : "") : "" %>>Noveno</option>
                    <option value="10" <%= editando ? ( alumno.semestre.contentEquals("10") ? "selected" : "") : "" %>>Decimo</option>
                  </select><br>
                  <label>Fecha de registro</label>
                  <input type="text" id="Fecha" placeholder="Fecha registro" name="fechareg" value='<%= editando ? (new SimpleDateFormat("dd-MM-yyyy")).format(alumno.fechareg) : "" %>'>
                </fieldset> 
                <input class="btn" type="submit" name="submit1" value='<%= editando ? "Actualizar" : "Registrar" %>''>
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