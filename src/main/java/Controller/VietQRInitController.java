// Path: src/main/java/Controller/VietQRInitController.java
package Controller;

import Config.VietQRConfig;
import Modal.bean.Cart;
import Modal.bean.User;
import Modal.bean.Voucher;
import Modal.bo.VoucherBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/vietqr/init")
public class VietQRInitController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Cart getCart(HttpSession session) {
        return (Cart) session.getAttribute("CART");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("USER");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Cart cart = getCart(session);
            if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // Lấy thông tin nhận hàng từ form checkout (không đổi logic, chỉ lưu tạm cho luồng QR)
            String receiverName = request.getParameter("receiverName");
            String receiverPhone = request.getParameter("receiverPhone");
            String receiverAddress = request.getParameter("receiverAddress");
            String note = request.getParameter("note");

            if (receiverName == null || receiverName.trim().isEmpty() ||
                receiverPhone == null || receiverPhone.trim().isEmpty() ||
                receiverAddress == null || receiverAddress.trim().isEmpty()) {

                request.setAttribute("error", "Vui lòng nhập đủ thông tin nhận hàng trước khi thanh toán QR.");
                request.getRequestDispatcher("/WEB-INF/views/site/checkout.jsp").forward(request, response);
                return;
            }

            // Tính discount giống CheckoutController (giữ rule y hệt)
            VoucherBO vbo = new VoucherBO();
            Voucher v = vbo.getByCode(cart.getVoucherCode());
            String err = vbo.validate(v, cart.getSubtotal());
            long discount = (err == null) ? vbo.calcDiscount(v, cart.getSubtotal(), cart.getShipping()) : 0;

            long total = cart.getSubtotal() + cart.getShipping() - discount;
            if (total < 0) total = 0;

            // Nội dung chuyển khoản (<= 50, không kí tự đặc biệt theo VietQR quick link)
            String addInfoRaw = "MILKTEASHOP_" + user.getUserId() + "_" + System.currentTimeMillis();
            String addInfo = addInfoRaw.replaceAll("[^a-zA-Z0-9_]", "_");
            if (addInfo.length() > 50) addInfo = addInfo.substring(0, 50);

            // Quick Link VietQR (official format)
            // https://img.vietqr.io/image/<BANK_ID>-<ACCOUNT_NO>-<TEMPLATE>.png?amount=<AMOUNT>&addInfo=<DESCRIPTION>&accountName=<ACCOUNT_NAME>
            String bankId = VietQRConfig.BANK_ID;
            String accountNo = VietQRConfig.ACCOUNT_NO;
            String template = VietQRConfig.TEMPLATE;

            String encAddInfo = URLEncoder.encode(addInfo, StandardCharsets.UTF_8.toString());
            String encAccName = URLEncoder.encode(VietQRConfig.ACCOUNT_NAME, StandardCharsets.UTF_8.toString());

            String qrUrl =
                "https://img.vietqr.io/image/" + bankId + "-" + accountNo + "-" + template + ".png" +
                "?amount=" + total +
                "&addInfo=" + encAddInfo +
                "&accountName=" + encAccName;

            // Lưu tạm thông tin để trang QR bấm "Đã thanh toán" -> POST lại /checkout (logic cũ)
            session.setAttribute("VIETQR_receiverName", receiverName.trim());
            session.setAttribute("VIETQR_receiverPhone", receiverPhone.trim());
            session.setAttribute("VIETQR_receiverAddress", receiverAddress.trim());
            session.setAttribute("VIETQR_note", (note == null) ? "" : note);

            request.setAttribute("qrUrl", qrUrl);
            request.setAttribute("total", total);
            request.setAttribute("addInfo", addInfo);

            request.getRequestDispatcher("/WEB-INF/views/site/vietqrPay.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("VietQR Init Error: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // không cho truy cập GET trực tiếp (an toàn hơn)
        response.sendRedirect(request.getContextPath() + "/checkout");
    }
}
