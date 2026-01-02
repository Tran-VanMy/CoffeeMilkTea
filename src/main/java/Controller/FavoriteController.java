package Controller;

import Modal.bean.User;
import Modal.bo.FavoriteBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/favorites")
public class FavoriteController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private User ensureUser(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User u = (User) request.getSession().getAttribute("USER");
        if (u == null) {
            String back = request.getParameter("redirect");
            if (back == null || back.trim().isEmpty()) back = request.getHeader("Referer");

            if (back != null && !back.trim().isEmpty()) {
                response.sendRedirect(back);
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return null;
        }
        return u;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            User u = ensureUser(request, response);
            if (u == null) return;

            FavoriteBO fbo = new FavoriteBO();

            String action = request.getParameter("action");
            if (action == null) action = "view";

            if ("toggle".equalsIgnoreCase(action)) {
                int productId = parseIntSafe(request.getParameter("productId"), 0);
                if (productId > 0) {
                    boolean added = fbo.toggle(u.getUserId(), productId);
                    request.getSession().setAttribute("FAV_MSG",
                            added ? "Đã thêm vào Yêu thích!" : "Đã bỏ khỏi Yêu thích!");
                }

                String target = request.getParameter("redirect");
                if (target == null || target.trim().isEmpty()) {
                    target = request.getHeader("Referer");
                }

                response.sendRedirect(safeRedirect(request, target));
                return;
            }

            if ("remove".equalsIgnoreCase(action)) {
                int productId = parseIntSafe(request.getParameter("productId"), 0);
                if (productId > 0) fbo.remove(u.getUserId(), productId);
                response.sendRedirect(request.getContextPath() + "/favorites");
                return;
            }

            Object msg = request.getSession().getAttribute("FAV_MSG");
            if (msg != null) {
                request.setAttribute("msg", String.valueOf(msg));
                request.getSession().removeAttribute("FAV_MSG");
            }

            request.setAttribute("favorites", fbo.getFavoriteProducts(u.getUserId()));
            request.getRequestDispatcher("/WEB-INF/views/site/favorites.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Favorites Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }

    private String safeRedirect(HttpServletRequest request, String target) {
        String ctx = request.getContextPath();
        if (ctx == null) ctx = "";

        if (target == null || target.trim().isEmpty()) {
            return ctx + "/home";
        }

        target = target.trim();

        // ✅ chặn redirect tới WEB-INF (không bao giờ cho)
        if (target.contains("/WEB-INF/") || target.contains("\\WEB-INF\\")) {
            return ctx + "/home";
        }

        // absolute URL: vẫn cho (thường từ Referer)
        if (target.startsWith("http://") || target.startsWith("https://")) {
            // nhưng vẫn chặn nếu lỡ có WEB-INF
            if (target.contains("/WEB-INF/") || target.contains("\\WEB-INF\\")) return ctx + "/home";
            return target;
        }

        if (!target.startsWith("/")) target = "/" + target;

        // nếu chưa có ctx thì prepend
        if (!ctx.isEmpty() && !target.startsWith(ctx + "/") && !target.equals(ctx)) {
            target = ctx + target;
        }

        return target;
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
