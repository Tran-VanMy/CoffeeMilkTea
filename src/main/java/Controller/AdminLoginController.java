// Path: src/main/java/Controller/AdminLoginController.java

package Controller;

import Modal.bean.User;
import Modal.bo.UserBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            if (request.getParameter("username") == null) {
                request.getRequestDispatcher("/WEB-INF/views/auth/adminLogin.jsp").forward(request, response);
                return;
            }

            String un = request.getParameter("username");
            String pass = request.getParameter("pass");

            UserBO bo = new UserBO();
            User u = bo.login(un, pass);

            if (u != null && u.isAdmin()) {
                request.getSession().setAttribute("ADMIN", u);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                request.setAttribute("error", "Sai tài khoản hoặc bạn không có quyền Admin.");
                request.getRequestDispatcher("/WEB-INF/views/auth/adminLogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("error", "Lỗi admin login: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/auth/adminLogin.jsp").forward(request, response);
            } catch (Exception ignored) {}
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}