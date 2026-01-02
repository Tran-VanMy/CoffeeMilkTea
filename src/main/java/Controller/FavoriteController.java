package Controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/favorite")
public class FavoriteController extends HttpServlet {

    @SuppressWarnings("unchecked")
    private Set<Integer> getFavSet(HttpSession session) {
        Set<Integer> fav = (Set<Integer>) session.getAttribute("FAV");
        if (fav == null) {
            fav = new HashSet<>();
            session.setAttribute("FAV", fav);
        }
        return fav;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        HttpSession session = request.getSession();
        Set<Integer> fav = getFavSet(session);

        if ("toggle".equalsIgnoreCase(action)) {
            String idRaw = request.getParameter("id");
            int id = 0;
            try { id = Integer.parseInt(idRaw); } catch (Exception ignored) {}

            if (id > 0) {
                if (fav.contains(id)) fav.remove(id);
                else fav.add(id);
            }

            String back = request.getParameter("back");
            if (back == null || back.trim().isEmpty()) back = request.getContextPath() + "/home";
            response.sendRedirect(back);
            return;
        }

        // list
        request.getRequestDispatcher("/WEB-INF/views/site/favorites.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // cho tiện, POST cũng xử lý toggle
        doGet(request, response);
    }
}
