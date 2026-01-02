// Path: src/main/java/Controller/OrderController.java
package Controller;

import Modal.bean.Order;
import Modal.bean.User;
import Modal.bo.OrderBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/orders")
public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("USER");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            OrderBO obo = new OrderBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("detail".equalsIgnoreCase(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                Order o = obo.getOrderDetail(id, user.getUserId());
                if (o == null) {
                    response.sendRedirect(request.getContextPath() + "/orders");
                    return;
                }
                request.setAttribute("order", o);
                request.getRequestDispatcher("/WEB-INF/views/site/orderDetail.jsp").forward(request, response);
                return;
            }

            if ("cancel".equalsIgnoreCase(action)) {
                long id = Long.parseLong(request.getParameter("id"));
                boolean ok = obo.cancelOrder(id, user.getUserId());
                if (!ok) {
                    request.setAttribute("msg", "Không thể hủy (chỉ hủy khi CHỜ XÁC NHẬN).");
                } else {
                    request.setAttribute("msg", "Đã hủy đơn #" + id);
                }
            }

            request.setAttribute("orders", obo.getOrdersByUser(user.getUserId()));
            request.getRequestDispatcher("/WEB-INF/views/site/orders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Orders: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}