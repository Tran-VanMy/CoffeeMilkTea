package Controller;

import Modal.bean.*;
import Modal.bo.OrderBO;
import Modal.bo.VoucherBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    private Cart getCart(HttpSession session) {
        return (Cart) session.getAttribute("CART");
    }

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

            Cart cart = getCart(session);
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // tính discount để hiển thị
            VoucherBO vbo = new VoucherBO();
            Voucher v = vbo.getByCode(cart.getVoucherCode());
            String err = vbo.validate(v, cart.getSubtotal());
            long discount = (err == null) ? vbo.calcDiscount(v, cart.getSubtotal(), cart.getShipping()) : 0;

            request.setAttribute("cart", cart);
            request.setAttribute("voucher", v);
            request.setAttribute("voucherError", err);
            request.setAttribute("discount", discount);

            request.getRequestDispatcher("/WEB-INF/views/site/checkout.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Checkout: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // submit đặt hàng
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
            if (cart == null || cart.getItems().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            String name = request.getParameter("receiverName");
            String phone = request.getParameter("receiverPhone");
            String address = request.getParameter("receiverAddress");
            String note = request.getParameter("note");

            if (name == null || name.trim().isEmpty() ||
                phone == null || phone.trim().isEmpty() ||
                address == null || address.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đủ thông tin nhận hàng.");
                doGet(request, response);
                return;
            }

            long subtotal = cart.getSubtotal();
            long shipping = cart.getShipping();

            VoucherBO vbo = new VoucherBO();
            Voucher v = vbo.getByCode(cart.getVoucherCode());
            String vErr = vbo.validate(v, subtotal);
            long discount = (vErr == null) ? vbo.calcDiscount(v, subtotal, shipping) : 0;

            long total = subtotal + shipping - discount;
            if (total < 0) total = 0;

            Order order = new Order();
            order.setUserId(user.getUserId());
            order.setReceiverName(name.trim());
            order.setReceiverPhone(phone.trim());
            order.setReceiverAddress(address.trim());
            order.setNote(note);

            order.setSubtotal(subtotal);
            order.setShipping(shipping);
            order.setDiscount(discount);
            order.setTotal(total);
            order.setVoucherCode((vErr == null) ? cart.getVoucherCode() : null);

            ArrayList<OrderItem> items = new ArrayList<>();
            for (CartItem ci : cart.getItems()) {
                OrderItem oi = new OrderItem();
                oi.setProductId(ci.getProductId());
                oi.setProductName(ci.getProductName());
                oi.setSize(ci.getSize());
                oi.setSugar(ci.getSugar());
                oi.setIce(ci.getIce());
                oi.setToppingJson(ci.toppingsToJsonLike());
                oi.setUnitPrice(ci.getUnitPrice());
                oi.setQuantity(ci.getQuantity());
                oi.setLineTotal(ci.getLineTotal());
                items.add(oi);
            }
            order.setItems(items);

            OrderBO obo = new OrderBO();
            long orderId = obo.createOrder(order);

            if (orderId <= 0) {
                request.setAttribute("error", "Đặt hàng thất bại. Vui lòng thử lại.");
                doGet(request, response);
                return;
            }

            // consume voucher nếu dùng
            if (vErr == null && order.getVoucherCode() != null) {
                vbo.consume(order.getVoucherCode());
            }

            // clear cart
            cart.clear();
            session.setAttribute("CART", cart);

            response.sendRedirect(request.getContextPath() + "/orders?action=detail&id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Checkout Submit: " + e.getMessage());
        }
    }
}