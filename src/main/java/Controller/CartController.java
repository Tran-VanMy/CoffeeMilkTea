package Controller;

import Modal.bean.Cart;
import Modal.bean.CartItem;
import Modal.bean.Product;
import Modal.bean.Topping;
import Modal.bo.ProductBO;
import Modal.bo.ToppingBO;
import Modal.bo.VoucherBO;
import Modal.bean.Voucher;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/cart")
public class CartController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private Cart getCart(HttpSession session) {
        Cart cart = (Cart) session.getAttribute("CART");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("CART", cart);
        }
        return cart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            Cart cart = getCart(session);

            String action = request.getParameter("action");
            if (action == null) action = "view";

            if ("add".equalsIgnoreCase(action)) {
                // add từ product.jsp
                int productId = parseIntSafe(request.getParameter("productId"), -1);
                if (productId <= 0) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                String size = request.getParameter("size"); // S/M/L
                int sugar = parseIntSafe(request.getParameter("sugar"), 100);
                int ice = parseIntSafe(request.getParameter("ice"), 100);
                int qty = parseIntSafe(request.getParameter("qty"), 1);
                if (qty <= 0) qty = 1;

                String[] toppingIds = request.getParameterValues("toppingId"); // checkbox list

                ProductBO pbo = new ProductBO();
                ToppingBO tbo = new ToppingBO();

                Product p = pbo.getById(productId);
                if (p == null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }

                int[] ids = parseIds(toppingIds);
                ArrayList<Topping> tops = tbo.getByIds(ids);

                CartItem it = new CartItem();
                it.setProductId(p.getProductId());
                it.setProductName(p.getName());
                it.setImageUrl(p.getImageUrl());
                it.setBasePrice(p.getBasePrice());
                it.setSize(size == null ? "S" : size);
                it.setSugar(sugar);
                it.setIce(ice);
                it.setToppings(tops);
                it.setQuantity(qty);

                cart.add(it);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("update".equalsIgnoreCase(action)) {
                // JSP đang gửi: action=update, key=..., qty=...
                String key = request.getParameter("key");
                int qty = parseIntSafe(request.getParameter("qty"), 1);
                if (qty <= 0) qty = 1;

                cart.updateQtyByKey(key, qty);

                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("remove".equalsIgnoreCase(action)) {
                // JSP đang gửi: action=remove, key=...
                String key = request.getParameter("key");
                cart.removeByKey(key);

                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            if ("applyVoucher".equalsIgnoreCase(action)) {
                String code = request.getParameter("code");
                cart.setVoucherCode(code == null ? null : code.trim().toUpperCase());

                VoucherBO vbo = new VoucherBO();
                Voucher v = vbo.getByCode(cart.getVoucherCode());
                String err = vbo.validate(v, cart.getSubtotal());
                if (err != null) {
                    request.setAttribute("voucherError", err);
                } else {
                    request.setAttribute("voucherMsg", "Áp dụng voucher thành công!");
                }
                // vẫn forward về cart view
            }

            // view cart
            request.setAttribute("cart", cart);
            request.getRequestDispatcher("/WEB-INF/views/site/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Cart: " + e.getMessage());
        }
    }

    @Override
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

    private int[] parseIds(String[] arr) {
        if (arr == null || arr.length == 0) return new int[0];
        int[] ids = new int[arr.length];
        int n = 0;
        for (String x : arr) {
            try { ids[n++] = Integer.parseInt(x); } catch (Exception ignored) {}
        }
        int[] out = new int[n];
        System.arraycopy(ids, 0, out, 0, n);
        return out;
    }
}
