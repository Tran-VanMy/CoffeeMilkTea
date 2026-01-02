// src/main/java/Controller/LogoutController.java

package Controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doGet(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("USER");
        response.sendRedirect(request.getContextPath() + "/home");
    }
}