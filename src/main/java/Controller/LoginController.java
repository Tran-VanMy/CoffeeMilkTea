// src/main/java/Controller/LoginController.java
package Controller;

import Modal.bean.User;
import Modal.bo.UserBO;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            HttpSession session = request.getSession();
            Integer attempts = (Integer) session.getAttribute("loginAttempts");
            if (attempts == null) attempts = 0;

            String un = request.getParameter("username");
            String pass = request.getParameter("pass");
            String captchaInput = request.getParameter("captcha");

            if (un == null && pass == null) {
                request.setAttribute("attempts", attempts);
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp");
                try { rd.forward(request, response); } catch (Exception ignored) {}
                return;
            }

            if (attempts >= 3) {
                String expected = (String) session.getAttribute("CAPTCHA");
                if (expected == null || captchaInput == null || !expected.equalsIgnoreCase(captchaInput.trim())) {
                    request.setAttribute("attempts", attempts);
                    request.setAttribute("showCaptcha", true);
                    request.setAttribute("error", "Bạn phải nhập đúng CAPTCHA (do đã nhập sai 3 lần).");
                    request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                    return;
                }
            }

            if (un == null || un.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
                request.setAttribute("attempts", attempts);
                request.setAttribute("error", "Vui lòng nhập đủ username & mật khẩu.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                return;
            }

            UserBO bo = new UserBO();
            User user = bo.login(un.trim(), pass);

            if (user != null) {
                session.setAttribute("USER", user);
                session.setAttribute("loginAttempts", 0);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                attempts++;
                session.setAttribute("loginAttempts", attempts);
                request.setAttribute("attempts", attempts);
                if (attempts >= 3) request.setAttribute("showCaptcha", true);
                request.setAttribute("error", "Sai tài khoản hoặc mật khẩu. Lần thử: " + attempts);
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } catch (Exception ignored) {}
        }
    }

    protected void doPost(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}