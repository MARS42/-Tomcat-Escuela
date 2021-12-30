import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.rmi.*;
import java.sql.*;
import java.time.*;
import java.time.format.*;

public class alta extends HttpServlet
{
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		PrintWriter out = response.getWriter();

		try
		{
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			HttpSession sesion = request.getSession(true);

			String ncontrol = request.getParameter("ncontrol");
			String nombre = request.getParameter("nombre");
			String apellidos = request.getParameter("apellido");
			String domicilio = request.getParameter("domicilio");
			String email = request.getParameter("email");
			int edad = Integer.parseInt(request.getParameter("edad"));
			String telefono = request.getParameter("telefono");
			String tuto = request.getParameter("tutor");
			String carrera = request.getParameter("carrera");
			String semestre = request.getParameter("semestre");
			String sexo = request.getParameter("sexo");
			String fechareg = request.getParameter("fechareg");
			String fechanac = request.getParameter("fechanac");
			float estatura = Float.parseFloat(request.getParameter("altura"));
			float peso = Float.parseFloat(request.getParameter("peso"));

			out.println("inicio<br>");
			Class.forName("org.postgresql.Driver");
			out.println("Driver registrado<br>");

			//String url = "jdbc:postgresql://127.0.0.1/escuela";
			String url = "jdbc:postgresql://progweb.postgres.database.azure.com:5432/escuela?user=master@progweb&password=Password0&sslmode=require";

			//String user = "robert";
			//String pass = "robert";
			out.println("Conectando a... " + url);

			//Connection conexion = DriverManager.getConnection(url, user, pass);
			Connection conexion = DriverManager.getConnection(url);
			out.println("<br>Conexión lista<br>");

			PreparedStatement pst = conexion.prepareStatement("insert into persona values (default,?,?,?,?,?,?,?,?,?,?,1)", PreparedStatement.RETURN_GENERATED_KEYS);
			pst.setString(1, nombre);
			pst.setString(2, apellidos);
			pst.setString(3, telefono);
			pst.setString(4, email);
			pst.setString(5, domicilio);
			
			if(fechanac.contains("-"))
				pst.setDate(6, Date.valueOf(LocalDate.parse(fechanac, DateTimeFormatter.ofPattern("dd-MM-uuuu"))));
			else
				pst.setDate(6, Date.valueOf(LocalDate.parse(fechanac, DateTimeFormatter.ofPattern("dd/MM/uuuu"))));

			pst.setInt(7, edad);
			pst.setFloat(8, estatura);
			pst.setFloat(9, peso);
			pst.setString(10, sexo);
			pst.executeUpdate();
			out.println("Inserción de persona exitosa<br>");

			ResultSet rs = pst.getGeneratedKeys();
			rs.next();
			int id_persona = rs.getInt(1);

			pst.close();

			pst = conexion.prepareStatement("insert into alumno values (?,?,?,?,?,?)");
			pst.setString(1, ncontrol);
			pst.setString(2, carrera);
			pst.setInt(3, id_persona);

			if(fechareg.contains("-"))
				pst.setDate(4, Date.valueOf(LocalDate.parse(fechareg, DateTimeFormatter.ofPattern("dd-MM-uuuu"))));
			else
				pst.setDate(4, Date.valueOf(LocalDate.parse(fechareg, DateTimeFormatter.ofPattern("dd/MM/uuuu"))));

			pst.setString(5, semestre);
			pst.setString(6, tuto);
			pst.executeUpdate();
			out.println("Inserción de alumno exitosa");

			pst.close();
			conexion.close();
			out.println("<br><a href="+ request.getContextPath() +">Volver</a>");
			response.sendRedirect(request.getContextPath());
		}
		catch(SQLException e)
		{
			out.println("Ocurrio un error en alta de alumno: " + e);
		}
		catch (Exception ex) {
			out.println("Se ha lanzado una excepción que no es una SQLException: "+ ex.getMessage());
		}
	}
}
