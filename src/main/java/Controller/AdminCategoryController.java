package Controller;

import Modal.bean.User;
import Modal.bo.CategoryBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/categories")
public class AdminCategoryController extends HttpServlet {
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

            CategoryBO bo = new CategoryBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("create".equalsIgnoreCase(action)) {
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                String err = bo.create(name, slug);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Thêm danh mục thành công!");
            }

            if ("update".equalsIgnoreCase(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                String name = request.getParameter("name");
                String slug = request.getParameter("slug");
                String activeStr = request.getParameter("active"); // "1" or "0"
                boolean active = "1".equals(activeStr);

                String err = bo.update(id, name, slug, active);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Cập nhật danh mục thành công!");
            }

            if ("delete".equalsIgnoreCase(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                String err = bo.deleteHard(id);
                if (err != null) request.setAttribute("error", err + " (Nếu category đang được Products tham chiếu thì DB sẽ chặn xóa.)");
                else request.setAttribute("msg", "Xóa danh mục khỏi CSDL thành công!");
            }

            request.setAttribute("categories", bo.getAllForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/categories.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Categories Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    private int parseIntSafe(String s, int def) {
        try {
            if (s == null) return def;
            s = s.trim();
            if (s.isEmpty()) return def;
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
