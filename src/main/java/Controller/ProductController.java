package Controller;

import Modal.bean.User;
import Modal.bo.CategoryBO;
import Modal.bo.FavoriteBO;
import Modal.bo.ProductBO;
import Modal.bo.ToppingBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/product")
public class ProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            CategoryBO cbo = new CategoryBO();
            ProductBO pbo = new ProductBO();
            ToppingBO tbo = new ToppingBO();

            request.setAttribute("categories", cbo.getAllActive());
            request.setAttribute("toppings", tbo.getActiveAll());

            String sort = request.getParameter("sort");
            if (sort == null) sort = "";
            request.setAttribute("sort", sort);

            // ✅ favorites state for heart icon
            User u = (User) request.getSession().getAttribute("USER");
            if (u != null) {
                FavoriteBO fbo = new FavoriteBO();
                request.setAttribute("favoriteIds", fbo.getProductIdSet(u.getUserId()));
            }

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                request.setAttribute("product", pbo.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/site/product.jsp").forward(request, response);
                return;
            }

            String cid = request.getParameter("cid");
            if (cid != null && !cid.trim().isEmpty()) {
                int categoryId = Integer.parseInt(cid);
                request.setAttribute("products", pbo.getActiveByCategorySorted(categoryId, sort));
                request.setAttribute("activeCategoryId", categoryId);
            } else {
                request.setAttribute("products", pbo.getActiveAllSorted(sort));
            }

            request.getRequestDispatcher("/WEB-INF/views/site/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error Product: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}
