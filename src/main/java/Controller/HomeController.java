package Controller;

import Modal.bo.CategoryBO;
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

            // ✅ FIX: Trang customer chỉ lấy category active=1
            request.setAttribute("categories", cbo.getAllActive());

            String q = request.getParameter("q");
            if (q != null && !q.trim().isEmpty()) {
                request.setAttribute("products", pbo.searchActive(q));
                request.setAttribute("q", q.trim());
            } else {
                request.setAttribute("products", pbo.getActiveAll());
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
