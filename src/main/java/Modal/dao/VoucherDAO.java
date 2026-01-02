// Path: src/main/java/Modal/dao/VoucherDAO.java
package Modal.dao;

import Modal.bean.Voucher;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class VoucherDAO {

    public Voucher getByCode(String code) throws Exception {
        if (code == null || code.trim().isEmpty()) return null;

        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT voucher_id, code, type, value, min_subtotal, max_discount, quantity, start_at, end_at, is_active " +
                "FROM Vouchers WHERE code=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, code.trim().toUpperCase());
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return null;
            return map(rs);
        }
    }

    public ArrayList<Voucher> getAllForAdmin() throws Exception {
        ArrayList<Voucher> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT voucher_id, code, type, value, min_subtotal, max_discount, quantity, start_at, end_at, is_active " +
                "FROM Vouchers ORDER BY voucher_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(map(rs));
        }
        return ds;
    }

    public Voucher getById(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT voucher_id, code, type, value, min_subtotal, max_discount, quantity, start_at, end_at, is_active " +
                "FROM Vouchers WHERE voucher_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return map(rs);
            return null;
        }
    }

    public boolean insert(Voucher v) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "INSERT INTO Vouchers(code, type, value, min_subtotal, max_discount, quantity, start_at, end_at, is_active) " +
                "VALUES(?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, v.getCode().trim().toUpperCase());
            ps.setString(2, v.getType());
            ps.setLong(3, v.getValue());
            ps.setLong(4, v.getMinSubtotal());
            if (v.getMaxDiscount() == null) ps.setNull(5, java.sql.Types.BIGINT);
            else ps.setLong(5, v.getMaxDiscount());
            ps.setInt(6, v.getQuantity());
            if (v.getStartAt() == null) ps.setNull(7, java.sql.Types.TIMESTAMP);
            else ps.setTimestamp(7, new java.sql.Timestamp(v.getStartAt().getTime()));
            if (v.getEndAt() == null) ps.setNull(8, java.sql.Types.TIMESTAMP);
            else ps.setTimestamp(8, new java.sql.Timestamp(v.getEndAt().getTime()));
            ps.setBoolean(9, v.isActive());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(Voucher v) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "UPDATE Vouchers SET code=?, type=?, value=?, min_subtotal=?, max_discount=?, quantity=?, start_at=?, end_at=?, is_active=? " +
                "WHERE voucher_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, v.getCode().trim().toUpperCase());
            ps.setString(2, v.getType());
            ps.setLong(3, v.getValue());
            ps.setLong(4, v.getMinSubtotal());
            if (v.getMaxDiscount() == null) ps.setNull(5, java.sql.Types.BIGINT);
            else ps.setLong(5, v.getMaxDiscount());
            ps.setInt(6, v.getQuantity());
            if (v.getStartAt() == null) ps.setNull(7, java.sql.Types.TIMESTAMP);
            else ps.setTimestamp(7, new java.sql.Timestamp(v.getStartAt().getTime()));
            if (v.getEndAt() == null) ps.setNull(8, java.sql.Types.TIMESTAMP);
            else ps.setTimestamp(8, new java.sql.Timestamp(v.getEndAt().getTime()));
            ps.setBoolean(9, v.isActive());
            ps.setInt(10, v.getVoucherId());
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ NEW: update riêng trạng thái active
    public boolean updateActive(int id, boolean active) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Vouchers SET is_active=? WHERE voucher_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ✅ HARD DELETE (xóa khỏi CSDL)
    public boolean delete(int id) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "DELETE FROM Vouchers WHERE voucher_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean decreaseQuantity(String code) throws Exception {
        if (code == null || code.trim().isEmpty()) return false;
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Vouchers SET quantity = quantity - 1 WHERE code=? AND quantity > 0";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, code.trim().toUpperCase());
            return ps.executeUpdate() > 0;
        }
    }

    private Voucher map(ResultSet rs) throws Exception {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucher_id"));
        v.setCode(rs.getString("code"));
        v.setType(rs.getString("type"));
        v.setValue(rs.getLong("value"));
        v.setMinSubtotal(rs.getLong("min_subtotal"));

        long md = rs.getLong("max_discount");
        v.setMaxDiscount(rs.wasNull() ? null : md);

        v.setQuantity(rs.getInt("quantity"));
        v.setStartAt(rs.getTimestamp("start_at"));
        v.setEndAt(rs.getTimestamp("end_at"));
        v.setActive(rs.getBoolean("is_active"));
        return v;
    }
}
