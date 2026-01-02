package Controller;

import Modal.bean.User;
import Modal.bo.OrderBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/admin/stats")
public class AdminStatsController extends HttpServlet {
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

            OrderBO obo = new OrderBO();

            // KPI nhanh (tái dùng logic có sẵn)
            request.setAttribute("revToday", obo.revenueToday());
            request.setAttribute("revMonth", obo.revenueThisMonth());

            // ✅ NEW: doanh thu 7 ngày gần nhất (line chart)
            ArrayList<String[]> rev7 = obo.revenueLastNDays(7); // mỗi phần tử: [yyyy-MM-dd, revenue]
            request.setAttribute("rev7", rev7);

            // ✅ NEW: phân bố trạng thái đơn (doughnut)
            LinkedHashMap<String, Integer> statusMap = obo.countOrdersByStatus();
            request.setAttribute("statusMap", statusMap);

            // Top products (đã có)
            request.setAttribute("topProducts", obo.topProducts(8));

            request.getRequestDispatcher("/WEB-INF/views/admin/stats.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Stats Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}
