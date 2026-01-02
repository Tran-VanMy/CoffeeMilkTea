package Modal.dao;

import Modal.bean.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public boolean usernameExists(String username) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT 1 FROM Users WHERE username=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public long register(String fullName, String phone, String email, String username, String rawPass) throws Exception {
        if (usernameExists(username)) return -1;

        String hash = BCrypt.hashpw(rawPass, BCrypt.gensalt(12));

        try (Connection cn = DB.getConnection()) {
            String sql = "INSERT INTO Users(full_name, phone, email, username, password_hash, role) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = cn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setString(3, email);
            ps.setString(4, username);
            ps.setString(5, hash);
            ps.setString(6, "CUSTOMER");

            int n = ps.executeUpdate();
            if (n <= 0) return -1;

            ResultSet keys = ps.getGeneratedKeys();
            if (keys.next()) return keys.getLong(1);
            return -1;
        }
    }

    public User login(String username, String rawPass) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT user_id, full_name, phone, email, username, password_hash, role FROM Users WHERE username=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) return null;

            String hash = rs.getString("password_hash");
            if (hash == null) return null;

            boolean ok = hash.startsWith("$2a$") || hash.startsWith("$2b$") || hash.startsWith("$2y$")
                    ? BCrypt.checkpw(rawPass, hash)
                    : rawPass.equals(hash);

            if (!ok) return null;

            return new User(
                    rs.getLong("user_id"),
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("email"),
                    rs.getString("username"),
                    hash,
                    rs.getString("role")
            );
        }
    }
}