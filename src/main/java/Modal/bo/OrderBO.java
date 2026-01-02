// Path: src/main/java/Modal/bo/OrderBO.java

package Modal.bo;

import Modal.bean.Order;
import Modal.dao.OrderDAO;

import java.util.ArrayList;

public class OrderBO {
    private final OrderDAO dao = new OrderDAO();

    public long createOrder(Order order) throws Exception {
    	return dao.createOrder(order);
    }
    public ArrayList<Order> getOrdersByUser(long userId) throws Exception {
    	return dao.getOrdersByUser(userId);
    }
    public Order getOrderDetail(long orderId, long userId) throws Exception {
    	return dao.getOrderDetail(orderId, userId);
    }
    public boolean cancelOrder(long orderId, long userId) throws Exception {
    	return dao.cancelOrder(orderId, userId);
    }

    // admin
    public ArrayList<Order> getAllOrders(String status) throws Exception {
    	return dao.getAllOrders(status);
    }
    public Order getOrderDetailAdmin(long orderId) throws Exception {
    	return dao.getOrderDetailAdmin(orderId);
    }
    public boolean updateStatus(long orderId, String status) throws Exception {
    	return dao.updateStatus(orderId, status);
    }

    public long revenueToday() throws Exception {
    	return dao.revenueToday();
    }
    public long revenueThisMonth() throws Exception {
    	return dao.revenueThisMonth();
    }
    public ArrayList<String[]> topProducts(int limit) throws Exception {
    	return dao.topProducts(limit);
    }
}