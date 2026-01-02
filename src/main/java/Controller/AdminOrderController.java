// Path: src/main/java/Controller/AdminOrderController.java

package Controller;

import Modal.bean.Order;
import Modal.bean.User;
import Modal.bo.OrderBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/orders")
public class AdminOrderController extends HttpServlet {
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

            OrderBO bo = new OrderBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("detail".equalsIgnoreCase(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                Order o = bo.getOrderDetailAdmin(id);
                if (o == null) {
                    response.sendRedirect(request.getContextPath() + "/admin/orders");
                    return;
                }
                request.setAttribute("order", o);
                request.getRequestDispatcher("/WEB-INF/views/admin/orderDetail.jsp").forward(request, response);
                return;
            }

            if ("status".equalsIgnoreCase(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                String status = request.getParameter("status");
                boolean ok = bo.updateStatus(id, status);
                request.setAttribute(ok ? "msg" : "error", ok ? "Cập nhật trạng thái thành công!" : "Cập nhật thất bại.");
            }

            String statusFilter = request.getParameter("filter");
            request.setAttribute("filter", statusFilter);
            request.setAttribute("orders", bo.getAllOrders(statusFilter));
            request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Orders Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}