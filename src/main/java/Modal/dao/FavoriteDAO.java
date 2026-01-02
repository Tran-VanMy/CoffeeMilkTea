package Modal.dao;

import Modal.bean.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Set;

public class FavoriteDAO {

    // toggle: nếu đã có => xóa, chưa có => thêm
    // return true nếu sau toggle là "đã thêm", false nếu "đã bỏ"
    public boolean toggle(long userId, int productId) throws Exception {
        if (userId <= 0 || productId <= 0) return false;

        try (Connection cn = DB.getConnection()) {
            // check exists
            String chk = "SELECT 1 FROM Favorites WHERE user_id=? AND product_id=?";
            try (PreparedStatement ps = cn.prepareStatement(chk)) {
                ps.setLong(1, userId);
                ps.setInt(2, productId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // delete
                        String del = "DELETE FROM Favorites WHERE user_id=? AND product_id=?";
                        try (PreparedStatement pd = cn.prepareStatement(del)) {
                            pd.setLong(1, userId);
                            pd.setInt(2, productId);
                            pd.executeUpdate();
                        }
                        return false;
                    }
                }
            }

            // insert
            String ins = "INSERT INTO Favorites(user_id, product_id) VALUES(?,?)";
            try (PreparedStatement pi = cn.prepareStatement(ins)) {
                pi.setLong(1, userId);
                pi.setInt(2, productId);
                pi.executeUpdate();
            }
            return true;
        }
    }

    public boolean remove(long userId, int productId) throws Exception {
        if (userId <= 0 || productId <= 0) return false;
        try (Connection cn = DB.getConnection()) {
            String del = "DELETE FROM Favorites WHERE user_id=? AND product_id=?";
            PreparedStatement ps = cn.prepareStatement(del);
            ps.setLong(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countByUser(long userId) throws Exception {
        if (userId <= 0) return 0;
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT COUNT(*) FROM Favorites WHERE user_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
            return 0;
        }
    }

    public Set<Integer> getProductIdSet(long userId) throws Exception {
        Set<Integer> set = new HashSet<>();
        if (userId <= 0) return set;

        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT product_id FROM Favorites WHERE user_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) set.add(rs.getInt(1));
        }
        return set;
    }

    public ArrayList<Product> getFavoriteProducts(long userId) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        if (userId <= 0) return ds;

        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Favorites f " +
                "JOIN Products p ON f.product_id = p.product_id " +
                "JOIN Categories c ON p.category_id = c.category_id " +
                "WHERE f.user_id=? " +
                "ORDER BY f.created_at DESC";

            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("product_id"),
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getLong("base_price"),
                        rs.getString("image_url"),
                        rs.getBoolean("is_active")
                );
                p.setCategoryName(rs.getString("category_name"));
                ds.add(p);
            }
        }
        return ds;
    }
}
