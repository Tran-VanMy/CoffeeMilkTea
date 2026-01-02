// Path: src/main/java/Modal/dao/OrderDAO.java (UPDATE FULL: admin list + status + stats)

package Modal.dao;

import Modal.bean.Order;
import Modal.bean.OrderItem;

import java.sql.*;
import java.util.ArrayList;

public class OrderDAO {

    // ===== CUSTOMER: create =====
    public long createOrder(Order order) throws Exception {
        if (order == null || order.getItems() == null || order.getItems().isEmpty()) return -1;

        Connection cn = DB.getConnection();
        try {
            cn.setAutoCommit(false);

            String sql =
                "INSERT INTO Orders(user_id, receiver_name, receiver_phone, receiver_address, note, status, subtotal, discount, shipping, total, voucher_code) " +
                "VALUES(?,?,?,?,?,'CHO_XAC_NHAN',?,?,?,?,?)";
            PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, order.getUserId());
            ps.setString(2, order.getReceiverName());
            ps.setString(3, order.getReceiverPhone());
            ps.setString(4, order.getReceiverAddress());
            ps.setString(5, order.getNote());
            ps.setLong(6, order.getSubtotal());
            ps.setLong(7, order.getDiscount());
            ps.setLong(8, order.getShipping());
            ps.setLong(9, order.getTotal());
            ps.setString(10, order.getVoucherCode());

            int n = ps.executeUpdate();
            if (n <= 0) { cn.rollback(); return -1; }

            ResultSet keys = ps.getGeneratedKeys();
            if (!keys.next()) { cn.rollback(); return -1; }
            long orderId = keys.getLong(1);

            String sqlItem =
                "INSERT INTO OrderItems(order_id, product_id, product_name, size, sugar, ice, topping_json, unit_price, quantity, line_total) " +
                "VALUES(?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement psi = cn.prepareStatement(sqlItem);

            for (OrderItem it : order.getItems()) {
                psi.setLong(1, orderId);
                psi.setInt(2, it.getProductId());
                psi.setString(3, it.getProductName());
                psi.setString(4, it.getSize());
                psi.setInt(5, it.getSugar());
                psi.setInt(6, it.getIce());
                psi.setString(7, it.getToppingJson());
                psi.setLong(8, it.getUnitPrice());
                psi.setInt(9, it.getQuantity());
                psi.setLong(10, it.getLineTotal());
                psi.addBatch();
            }
            psi.executeBatch();

            cn.commit();
            return orderId;
        } catch (Exception e) {
            try { cn.rollback(); } catch (Exception ignored) {}
            throw e;
        } finally {
            try { cn.setAutoCommit(true); } catch (Exception ignored) {}
            try { cn.close(); } catch (Exception ignored) {}
        }
    }

    // ===== CUSTOMER: list =====
    public ArrayList<Order> getOrdersByUser(long userId) throws Exception {
        ArrayList<Order> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT order_id, user_id, receiver_name, receiver_phone, receiver_address, note, status, subtotal, discount, shipping, total, voucher_code, created_at, updated_at " +
                "FROM Orders WHERE user_id=? ORDER BY order_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(mapOrder(rs));
        }
        return ds;
    }

    // ===== CUSTOMER: detail =====
    public Order getOrderDetail(long orderId, long userId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT order_id, user_id, receiver_name, receiver_phone, receiver_address, note, status, subtotal, discount, shipping, total, voucher_code, created_at, updated_at " +
                "FROM Orders WHERE order_id=? AND user_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, orderId);
            ps.setLong(2, userId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return null;

            Order o = mapOrder(rs);
            o.setItems(getItems(cn, orderId));
            return o;
        }
    }

    public boolean cancelOrder(long orderId, long userId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "UPDATE Orders SET status='HUY', updated_at=GETDATE() " +
                "WHERE order_id=? AND user_id=? AND status='CHO_XAC_NHAN'";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, orderId);
            ps.setLong(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // ===== ADMIN: list all orders =====
    public ArrayList<Order> getAllOrders(String status) throws Exception {
        ArrayList<Order> ds = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT order_id, user_id, receiver_name, receiver_phone, receiver_address, note, status, subtotal, discount, shipping, total, voucher_code, created_at, updated_at " +
                "FROM Orders " +
                (status != null && !status.trim().isEmpty() ? "WHERE status=? " : "") +
                "ORDER BY order_id DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            if (status != null && !status.trim().isEmpty()) ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) ds.add(mapOrder(rs));
        }
        return ds;
    }

    // ===== ADMIN: order detail (no user constraint) =====
    public Order getOrderDetailAdmin(long orderId) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT order_id, user_id, receiver_name, receiver_phone, receiver_address, note, status, subtotal, discount, shipping, total, voucher_code, created_at, updated_at " +
                "FROM Orders WHERE order_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setLong(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (!rs.next()) return null;

            Order o = mapOrder(rs);
            o.setItems(getItems(cn, orderId));
            return o;
        }
    }

    // ===== ADMIN: update status =====
    public boolean updateStatus(long orderId, String status) throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql = "UPDATE Orders SET status=?, updated_at=GETDATE() WHERE order_id=?";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        }
    }

    // ===== ADMIN: stats =====
    public long revenueToday() throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT ISNULL(SUM(total),0) AS rev " +
                "FROM Orders WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE) AND status <> 'HUY'";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong("rev");
            return 0;
        }
    }

    public long revenueThisMonth() throws Exception {
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT ISNULL(SUM(total),0) AS rev " +
                "FROM Orders " +
                "WHERE YEAR(created_at)=YEAR(GETDATE()) AND MONTH(created_at)=MONTH(GETDATE()) AND status <> 'HUY'";
            PreparedStatement ps = cn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getLong("rev");
            return 0;
        }
    }

    public ArrayList<String[]> topProducts(int limit) throws Exception {
        ArrayList<String[]> out = new ArrayList<>();
        try (Connection cn = DB.getConnection()) {
            String sql =
                "SELECT TOP (?) product_name, SUM(quantity) AS qty " +
                "FROM OrderItems GROUP BY product_name ORDER BY qty DESC";
            PreparedStatement ps = cn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                out.add(new String[]{ rs.getString("product_name"), String.valueOf(rs.getLong("qty")) });
            }
        }
        return out;
    }

    // ===== helpers =====
    private ArrayList<OrderItem> getItems(Connection cn, long orderId) throws Exception {
        String sqlItems =
            "SELECT order_item_id, order_id, product_id, product_name, size, sugar, ice, topping_json, unit_price, quantity, line_total " +
            "FROM OrderItems WHERE order_id=? ORDER BY order_item_id";
        PreparedStatement psi = cn.prepareStatement(sqlItems);
        psi.setLong(1, orderId);
        ResultSet rsi = psi.executeQuery();

        ArrayList<OrderItem> items = new ArrayList<>();
        while (rsi.next()) {
            OrderItem it = new OrderItem();
            it.setOrderItemId(rsi.getLong("order_item_id"));
            it.setOrderId(rsi.getLong("order_id"));
            it.setProductId(rsi.getInt("product_id"));
            it.setProductName(rsi.getString("product_name"));
            it.setSize(rsi.getString("size"));
            it.setSugar(rsi.getInt("sugar"));
            it.setIce(rsi.getInt("ice"));
            it.setToppingJson(rsi.getString("topping_json"));
            it.setUnitPrice(rsi.getLong("unit_price"));
            it.setQuantity(rsi.getInt("quantity"));
            it.setLineTotal(rsi.getLong("line_total"));
            items.add(it);
        }
        return items;
    }

    private Order mapOrder(ResultSet rs) throws Exception {
        Order o = new Order();
        o.setOrderId(rs.getLong("order_id"));
        o.setUserId(rs.getLong("user_id"));
        o.setReceiverName(rs.getString("receiver_name"));
        o.setReceiverPhone(rs.getString("receiver_phone"));
        o.setReceiverAddress(rs.getString("receiver_address"));
        o.setNote(rs.getString("note"));
        o.setStatus(rs.getString("status"));
        o.setSubtotal(rs.getLong("subtotal"));
        o.setDiscount(rs.getLong("discount"));
        o.setShipping(rs.getLong("shipping"));
        o.setTotal(rs.getLong("total"));
        o.setVoucherCode(rs.getString("voucher_code"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        o.setUpdatedAt(rs.getTimestamp("updated_at"));
        return o;
    }
}