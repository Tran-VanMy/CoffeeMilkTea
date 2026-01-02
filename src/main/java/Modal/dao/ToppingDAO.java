// Path: src/main/java/Modal/dao/ToppingDAO.java
package Modal.dao;

import Modal.bean.Topping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ToppingDAO {

    public ArrayList<Topping> getActiveAll() throws Exception {
        ArrayList<Topping> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT topping_id, name, price, is_active FROM Toppings WHERE is_active=1 ORDER BY name";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Topping> getAllForAdmin() throws Exception {
        ArrayList<Topping> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT topping_id, name, price, is_active FROM Toppings ORDER BY topping_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public ArrayList<Topping> getByIds(int[] ids) throws Exception {
        ArrayList<Topping> ds = new ArrayList<>();
        if (ids == null || ids.length == 0) return ds;

        StringBuilder in = new StringBuilder();
        for (int i = 0; i < ids.length; i++) {
            in.append("?");
            if (i < ids.length - 1) in.append(",");
        }

        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT topping_id, name, price, is_active FROM Toppings WHERE is_active=1 AND topping_id IN (" + in + ")";
            PreparedStatement ps = cn.prepareStatement(sql);
            for (int i = 0; i < ids.length; i++) ps.setInt(i + 1, ids[i]);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public Topping getById(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "SELECT topping_id, name, price, is_active FROM Toppings WHERE topping_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        }
    }

    public boolean insert(String name, long price, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "INSERT INTO Toppings(name, price, is_active) VALUES(?,?,?)";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setLong(2, price);
            ps.setBoolean(3, active);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(int id, String name, long price, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Toppings SET name=?, price=?, is_active=? WHERE topping_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setLong(2, price);
            ps.setBoolean(3, active);
            ps.setInt(4, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ HARD DELETE (xóa hẳn khỏi DB)
    public boolean deleteHard(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "DELETE FROM Toppings WHERE topping_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    private Topping map(ResultSet rs) throws Exception {
        return new Topping(
                rs.getInt("topping_id"),
                rs.getString("name"),
                rs.getLong("price"),
                rs.getBoolean("is_active")
        );
    }
}
