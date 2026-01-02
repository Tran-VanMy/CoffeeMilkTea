package Modal.dao;

import Modal.bean.User;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
    
    // getById (dùng để chặn xóa ADMIN)
    public User getById(long userId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT user_id, full_name, phone, email, username, password_hash, role, created_at FROM Users WHERE user_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return null;

            User u = new User(
                    rs.getLong("user_id"),
                    rs.getString("full_name"),
                    rs.getString("phone"),
                    rs.getString("email"),
                    rs.getString("username"),
                    rs.getString("password_hash"),
                    rs.getString("role")
            );
            u.setCreatedAt(rs.getTimestamp("created_at"));
            return u;
        }
    }

    // admin list users
    public ArrayList<User> getAllUsersForAdmin() throws Exception {
        ArrayList<User> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT user_id, full_name, phone, email, username, password_hash, role, created_at FROM Users ORDER BY user_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User u = new User(
                        rs.getLong("user_id"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("username"),
                        rs.getString("password_hash"),
                        rs.getString("role")
                );
                u.setCreatedAt(rs.getTimestamp("created_at"));
                ds.add(u);
            }
        }
        return ds;
    }

    // hard delete (chặn xóa ADMIN bằng điều kiện SQL)
    public boolean deleteHardUser(long userId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "DELETE FROM Users WHERE user_id=? AND role <> 'ADMIN'";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            return ps.executeUpdate() > 0;
        }
    }
}