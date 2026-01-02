package Controller;

import Modal.bean.User;
import Modal.bo.CategoryBO;
import Modal.bo.FavoriteBO;
import Modal.bo.ProductBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/home")
public class HomeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            CategoryBO cbo = new CategoryBO();
            ProductBO pbo = new ProductBO();

            request.setAttribute("categories", cbo.getAllActive());

            String sort = request.getParameter("sort");
            if (sort == null) sort = "";
            request.setAttribute("sort", sort);

            String q = request.getParameter("q");
            if (q != null && !q.trim().isEmpty()) {
                request.setAttribute("products", pbo.searchActiveSorted(q, sort));
                request.setAttribute("q", q.trim());
            } else {
                request.setAttribute("products", pbo.getActiveAllSorted(sort));
            }

            // ✅ favorites state for heart icon
            User u = (User) request.getSession().getAttribute("USER");
            if (u != null) {
                FavoriteBO fbo = new FavoriteBO();
                request.setAttribute("favoriteIds", fbo.getProductIdSet(u.getUserId()));
            }

            request.getRequestDispatcher("/WEB-INF/views/site/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Home: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}
