package Modal.bo;

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
}