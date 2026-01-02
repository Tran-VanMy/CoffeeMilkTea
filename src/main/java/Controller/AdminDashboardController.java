// Path: src/main/java/Controller/AdminDashboardController.java
package Controller;

import Modal.bean.User;
import Modal.bo.OrderBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private boolean ensureAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User admin = (User) request.getSession().getAttribute("ADMIN");
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return false;
        }
        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            if (!ensureAdmin(request, response)) return;

            OrderBO obo = new OrderBO();
            request.setAttribute("revToday", obo.revenueToday());
            request.setAttribute("revMonth", obo.revenueThisMonth());
            request.setAttribute("topProducts", obo.topProducts(5));

            request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Dashboard Error: " + e.getMessage());
        }
    }
}