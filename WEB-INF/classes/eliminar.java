import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.rmi.*;
import java.sql.*;
import java.time.*;
import java.time.format.*;

public class eliminar extends HttpServlet
{

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		PrintWriter out = response.getWriter();
		try
		{
			response.setContentType("text/html");
			request.setCharacterEncoding("UTF-8");
			HttpSession sesion = request.getSession(true);

      String[] ids = request.getParameter("ids").split(",");
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
      
      String idsConditions = "";
      for(int i = 0; i < ids.length; i++){ idsConditions += "id_persona = " + ids[i] + (i == ids.length - 1 ? "" : " or "); }
      Statement st = conexion.createStatement();
      st.executeUpdate("delete from alumno where " + idsConditions);
      st.close();
      out.println("Update: delete from alumno where " + idsConditions +"<br>");

      idsConditions = "";
      for(int i = 0; i < ids.length; i++){ idsConditions += "id = " + ids[i] + (i == ids.length - 1 ? "" : " or "); }
      st = conexion.createStatement();
      st.executeUpdate("delete from persona where " + idsConditions);
      st.close();
			conexion.close();
      out.println("Update: delete from persona where " + idsConditions +"<br>");

      out.println("Se borraron los ids: "+ String.join(", ", ids) +"<br>");
			out.println("<br><a href="+ request.getContextPath() +">Volver</a>");
			response.sendRedirect(request.getContextPath());
		}
		catch(SQLException e)
		{
			out.println("Ocurrio un error en la eliminación de alumno: " + e);
		}
		catch (Exception ex) {
			out.println("Se ha lanzado una excepción que no es una SQLException: "+ ex.getMessage());
		}
	}
}
