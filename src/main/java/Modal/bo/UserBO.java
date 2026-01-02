package Modal.bo;

import java.util.ArrayList;

import Modal.bean.User;
import Modal.dao.UserDAO;

public class UserBO {
    private final UserDAO dao = new UserDAO();

    public long register(String fullName, String phone, String email, String username, String pass) throws Exception {
        return dao.register(fullName, phone, email, username, pass);
    }

    public User login(String username, String pass) throws Exception {
        return dao.login(username, pass);
    }
    
    // admin list users
    public ArrayList<User> getAllUsersForAdmin() throws Exception {
        return dao.getAllUsersForAdmin();
    }

    // admin hard delete user (không xóa ADMIN)
    public String deleteUserHard(long userId) throws Exception {
        if (userId <= 0) return "ID user không hợp lệ.";

        // không xóa ADMIN
        User u = dao.getById(userId);
        if (u == null) return "User không tồn tại.";
        if (u.isAdmin()) return "Không được xóa tài khoản ADMIN.";

        try {
            boolean ok = dao.deleteHardUser(userId);
            if (!ok) return "Xóa thất bại (có thể user đang được Orders tham chiếu).";
            return null;
        } catch (Exception ex) {
            // thường sẽ dính FK Orders
            return "Xóa thất bại (có thể user đang được Orders tham chiếu). " + ex.getMessage();
        }
    }
}