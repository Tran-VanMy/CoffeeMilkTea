// Path: src/main/java/Modal/dao/ProductDAO.java
package Modal.dao;

import Modal.bean.Product;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ProductDAO {

    public ArrayList<Product> getActiveAll() throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                "WHERE p.is_active=1 ORDER BY p.product_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Product> getAllForAdmin() throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                "ORDER BY p.product_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Product> getActiveByCategory(int categoryId) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                "WHERE p.is_active=1 AND p.category_id=? ORDER BY p.product_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public Product getById(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Products p JOIN Categories c ON p.category_id=c.category_id WHERE p.product_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        }
    }

    public String getImageUrlById(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT image_url FROM Products WHERE product_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString(1);
            return null;
        }
    }

    public ArrayList<Product> searchActive(String keyword) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                "WHERE p.is_active=1 AND (p.name LIKE ? OR p.description LIKE ?) ORDER BY p.product_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            String k = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            ps.setString(1, k);
            ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }
    
    // =========================
    // ✅ NEW: Sorted queries
    // sort: popular | priceAsc | priceDesc | newest | default
    // =========================
    public ArrayList<Product> getActiveAllSorted(String sort) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String order = buildOrderBy(sort);

            String sql;
            if ("popular".equalsIgnoreCase(sort)) {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p " +
                    "JOIN Categories c ON p.category_id=c.category_id " +
                    "LEFT JOIN (SELECT product_id, SUM(quantity) qty FROM OrderItems GROUP BY product_id) oi " +
                    "ON p.product_id = oi.product_id " +
                    "WHERE p.is_active=1 " +
                    "ORDER BY ISNULL(oi.qty,0) DESC, p.product_id DESC";
            } else {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                    "WHERE p.is_active=1 " + order;
            }

            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Product> getActiveByCategorySorted(int categoryId, String sort) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String order = buildOrderBy(sort);

            String sql;
            if ("popular".equalsIgnoreCase(sort)) {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p " +
                    "JOIN Categories c ON p.category_id=c.category_id " +
                    "LEFT JOIN (SELECT product_id, SUM(quantity) qty FROM OrderItems GROUP BY product_id) oi " +
                    "ON p.product_id = oi.product_id " +
                    "WHERE p.is_active=1 AND p.category_id=? " +
                    "ORDER BY ISNULL(oi.qty,0) DESC, p.product_id DESC";
            } else {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                    "WHERE p.is_active=1 AND p.category_id=? " + order;
            }

            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Product> searchActiveSorted(String keyword, String sort) throws Exception {
        ArrayList<Product> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String k = "%" + (keyword == null ? "" : keyword.trim()) + "%";
            String order = buildOrderBy(sort);

            String sql;
            if ("popular".equalsIgnoreCase(sort)) {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p " +
                    "JOIN Categories c ON p.category_id=c.category_id " +
                    "LEFT JOIN (SELECT product_id, SUM(quantity) qty FROM OrderItems GROUP BY product_id) oi " +
                    "ON p.product_id = oi.product_id " +
                    "WHERE p.is_active=1 AND (p.name LIKE ? OR p.description LIKE ?) " +
                    "ORDER BY ISNULL(oi.qty,0) DESC, p.product_id DESC";
            } else {
                sql =
                    "SELECT p.product_id, p.category_id, c.name AS category_name, p.name, p.description, p.base_price, p.image_url, p.is_active " +
                    "FROM Products p JOIN Categories c ON p.category_id=c.category_id " +
                    "WHERE p.is_active=1 AND (p.name LIKE ? OR p.description LIKE ?) " + order;
            }

            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, k);
            ps.setString(2, k);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    private String buildOrderBy(String sort) {
        if (sort == null) sort = "";
        switch (sort) {
            case "priceAsc":
                return "ORDER BY p.base_price ASC, p.product_id DESC";
            case "priceDesc":
                return "ORDER BY p.base_price DESC, p.product_id DESC";
            case "newest":
                return "ORDER BY p.product_id DESC";
            default:
                // default như cũ: newest
                return "ORDER BY p.product_id DESC";
        }
    }

    public boolean insert(int categoryId, String name, String description, long basePrice, String imageUrl, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "INSERT INTO Products(category_id, name, description, base_price, image_url, is_active) VALUES(?,?,?,?,?,?)";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setString(2, name);
            ps.setString(3, description);
            ps.setLong(4, basePrice);
            ps.setString(5, imageUrl);
            ps.setBoolean(6, active);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(int productId, int categoryId, String name, String description, long basePrice, String imageUrl, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Products SET category_id=?, name=?, description=?, base_price=?, image_url=?, is_active=? WHERE product_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ps.setString(2, name);
            ps.setString(3, description);
            ps.setLong(4, basePrice);
            ps.setString(5, imageUrl);
            ps.setBoolean(6, active);
            ps.setInt(7, productId);
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ HARD DELETE (xóa hẳn khỏi DB)
    public boolean deleteHard(int productId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "DELETE FROM Products WHERE product_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        }
    }

    private Product map(ResultSet rs) throws Exception {
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
        return p;
    }
}
