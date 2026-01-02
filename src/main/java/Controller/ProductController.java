package Controller;

import Modal.bo.CategoryBO;
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

            // ✅ FIX: Trang customer chỉ hiển thị category active=1
            request.setAttribute("categories", cbo.getAllActive());

            // topping chỉ lấy active
            request.setAttribute("toppings", tbo.getActiveAll());

            String idStr = request.getParameter("id");
            if (idStr != null && !idStr.trim().isEmpty()) {
                int id = Integer.parseInt(idStr);
                request.setAttribute("product", pbo.getById(id));
                request.getRequestDispatcher("/WEB-INF/views/site/product.jsp").forward(request, response);
                return;
            }

            // list theo category
            String cid = request.getParameter("cid");
            if (cid != null && !cid.trim().isEmpty()) {
                int categoryId = Integer.parseInt(cid);
                request.setAttribute("products", pbo.getActiveByCategory(categoryId));
                request.setAttribute("activeCategoryId", categoryId);
            } else {
                request.setAttribute("products", pbo.getActiveAll());
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
