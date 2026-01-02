package Modal.dao;

import Modal.bean.Category;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CategoryDAO {

    // dùng cho site (chỉ active)
    public ArrayList<Category> getAllActive() throws Exception {
        ArrayList<Category> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT category_id, name, slug, is_active FROM Categories WHERE is_active=1 ORDER BY name";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ds.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("slug"),
                        rs.getBoolean("is_active")
                ));
            }
        }
        return ds;
    }

    // dùng cho admin (xem cả active/inactive)
    public ArrayList<Category> getAllForAdmin() throws Exception {
        ArrayList<Category> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT category_id, name, slug, is_active FROM Categories ORDER BY category_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ds.add(new Category(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("slug"),
                        rs.getBoolean("is_active")
                ));
            }
        }
        return ds;
    }

    public Category getById(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT category_id, name, slug, is_active FROM Categories WHERE category_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Category(
                        rs.getInt("category_id"),
                        rs.getString("name"),
                        rs.getString("slug"),
                        rs.getBoolean("is_active")
                );
            }
            return null;
        }
    }

    public boolean insert(String name, String slug) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "INSERT INTO Categories(name, slug, is_active) VALUES(?,?,1)";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, slug);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(int id, String name, String slug, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Categories SET name=?, slug=?, is_active=? WHERE category_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, slug);
            ps.setBoolean(3, active);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        }
    }

    // DELETE THẬT (hard delete)
    public boolean deleteHard(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "DELETE FROM Categories WHERE category_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean slugExists(String slug, Integer ignoreId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT 1 FROM Categories WHERE slug=? " + (ignoreId != null ? "AND category_id<>?" : "");
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, slug);
            if (ignoreId != null) ps.setInt(2, ignoreId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }
}
