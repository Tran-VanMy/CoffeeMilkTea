package Controller;

import Modal.bean.User;
import Modal.bo.UserBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean ensureAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User admin = (User) request.getSession().getAttribute("ADMIN");
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            if (!ensureAdmin(request, response)) return;

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            UserBO bo = new UserBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("delete".equalsIgnoreCase(action)) {
                long id = parseLongSafe(request.getParameter("id"), 0);

                User admin = (User) request.getSession().getAttribute("ADMIN");
                if (id <= 0) {
                    request.setAttribute("error", "ID user không hợp lệ.");
                } else if (admin != null && admin.getUserId() == id) {
                    request.setAttribute("error", "Bạn không thể xóa chính tài khoản admin đang đăng nhập.");
                } else {
                    String err = bo.deleteUserHard(id);
                    if (err != null) request.setAttribute("error", err);
                    else request.setAttribute("msg", "Xóa tài khoản thành công!");
                }
            }

            request.setAttribute("users", bo.getAllUsersForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Users Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    private long parseLongSafe(String s, long def) {
        try {
            if (s == null) return def;
            s = s.trim();
            if (s.isEmpty()) return def;
            return Long.parseLong(s);
        } catch (Exception e) {
            return def;
        }
    }
}
