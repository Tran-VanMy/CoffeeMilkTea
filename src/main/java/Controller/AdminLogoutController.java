// Path: src/main/java/Controller/AdminLogoutController.java
package Controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/logout")
public class AdminLogoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        session.removeAttribute("ADMIN");
        response.sendRedirect(request.getContextPath() + "/admin/login");
    }
}