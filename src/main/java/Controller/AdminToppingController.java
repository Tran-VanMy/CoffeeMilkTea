// Path: src/main/java/Controller/AdminToppingController.java

package Controller;

import Modal.bean.User;
import Modal.bo.ToppingBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/toppings")
public class AdminToppingController extends HttpServlet {
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

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            ToppingBO bo = new ToppingBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("create".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                long price = Long.parseLong(request.getParameter("price"));
                boolean active = request.getParameter("active") != null;
                String err = bo.create(name, price, active);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Thêm topping thành công!");
            }

            if ("update".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                long price = Long.parseLong(request.getParameter("price"));
                boolean active = request.getParameter("active") != null;
                String err = bo.update(id, name, price, active);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Cập nhật topping thành công!");
            }

            if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = bo.delete(id);
                request.setAttribute(ok ? "msg" : "error", ok ? "Xóa thành công!" : "Xóa thất bại.");
            }

            request.setAttribute("toppings", bo.getAllForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/toppings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Toppings Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}