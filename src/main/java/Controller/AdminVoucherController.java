// Path: src/main/java/Controller/AdminVoucherController.java
package Controller;

import Modal.bean.User;
import Modal.bean.Voucher;
import Modal.bo.VoucherBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/vouchers")
public class AdminVoucherController extends HttpServlet {
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

            VoucherBO bo = new VoucherBO();
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("upsert".equalsIgnoreCase(action)) {
                Voucher v = new Voucher();
                String idStr = request.getParameter("id");
                if (idStr != null && !idStr.trim().isEmpty()) v.setVoucherId(Integer.parseInt(idStr));

                v.setCode(request.getParameter("code"));
                v.setType(request.getParameter("type"));
                v.setValue(Long.parseLong(request.getParameter("value")));
                v.setMinSubtotal(Long.parseLong(request.getParameter("minSubtotal")));

                String maxD = request.getParameter("maxDiscount");
                if (maxD == null || maxD.trim().isEmpty()) v.setMaxDiscount(null);
                else v.setMaxDiscount(Long.parseLong(maxD));

                v.setQuantity(Integer.parseInt(request.getParameter("quantity")));
                v.setStartAt(bo.parseDT(request.getParameter("startAt")));
                v.setEndAt(bo.parseDT(request.getParameter("endAt")));
                v.setActive(request.getParameter("active") != null);

                String err = bo.upsert(v);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Lưu voucher thành công!");
            }

            // ✅ NEW: đổi active nhanh từ selection trong danh sách
            if ("setActive".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String av = request.getParameter("activeVal"); // "1" | "0"
                boolean active = "1".equals(av);
                boolean ok = bo.setActive(id, active);
                request.setAttribute(ok ? "msg" : "error", ok ? "Cập nhật trạng thái thành công!" : "Cập nhật trạng thái thất bại.");
            }

            // ✅ HARD DELETE
            if ("delete".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean ok = bo.delete(id);
                request.setAttribute(ok ? "msg" : "error", ok ? "Xóa thành công!" : "Xóa thất bại.");
            }

            request.setAttribute("vouchers", bo.getAllForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/vouchers.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Vouchers Error: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}
