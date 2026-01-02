// src/main/java/Controller/RegisterController.java
package Controller;

import Modal.bo.UserBO;

import javax.servlet.RequestDispatcher;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
	private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            if (request.getParameter("username") == null) {
                RequestDispatcher rd = request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp");
                try { rd.forward(request, response); } catch (Exception ignored) {}
                return;
            }

            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String username = request.getParameter("username");
            String pass = request.getParameter("pass");
            String repass = request.getParameter("repass");

            if (fullName == null || fullName.trim().isEmpty() ||
                    username == null || username.trim().isEmpty() ||
                    pass == null || pass.trim().isEmpty() ||
                    repass == null || repass.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập đầy đủ các trường bắt buộc (*).");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            if (!pass.equals(repass)) {
                request.setAttribute("error", "Mật khẩu nhập lại không khớp.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                return;
            }

            UserBO bo = new UserBO();
            long id = bo.register(fullName, phone, email, username, pass);

            if (id <= 0) {
                request.setAttribute("error", "Username đã tồn tại.");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            } else {
                request.setAttribute("msg", "Đăng ký thành công! Hãy đăng nhập.");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            try {
                request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
            } catch (Exception ignored) {}
        }
    }

    protected void doPost(HttpServletRequest request, javax.servlet.http.HttpServletResponse response) throws IOException {
        doGet(request, response);
    }
}