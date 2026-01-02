package Modal.bean;

import java.util.ArrayList;
import java.util.Date;

public class Order {
    private long orderId;
    private long userId;

    private String receiverName;
    private String receiverPhone;
    private String receiverAddress;
    private String note;

    private String status; // CHO_XAC_NHAN / DANG_PHA / DANG_GIAO / HOAN_TAT / HUY

    private long subtotal;
    private long discount;
    private long shipping;
    private long total;

    private String voucherCode;

    private Date createdAt;
    private Date updatedAt;

    private ArrayList<OrderItem> items = new ArrayList<>();

	public Order() {
		super();
	}

	public Order(long orderId, long userId, String receiverName, String receiverPhone, String receiverAddress,
			String note, String status, long subtotal, long discount, long shipping, long total, String voucherCode,
			Date createdAt, Date updatedAt, ArrayList<OrderItem> items) {
		super();
		this.orderId = orderId;
		this.userId = userId;
		this.receiverName = receiverName;
		this.receiverPhone = receiverPhone;
		this.receiverAddress = receiverAddress;
		this.note = note;
		this.status = status;
		this.subtotal = subtotal;
		this.discount = discount;
		this.shipping = shipping;
		this.total = total;
		this.voucherCode = voucherCode;
		this.createdAt = createdAt;
		this.updatedAt = updatedAt;
		this.items = items;
	}

	public long getOrderId() {
		return orderId;
	}

	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public String getReceiverName() {
		return receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	public String getReceiverPhone() {
		return receiverPhone;
	}

	public void setReceiverPhone(String receiverPhone) {
		this.receiverPhone = receiverPhone;
	}

	public String getReceiverAddress() {
		return receiverAddress;
	}

	public void setReceiverAddress(String receiverAddress) {
		this.receiverAddress = receiverAddress;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getSubtotal() {
		return subtotal;
	}

	public void setSubtotal(long subtotal) {
		this.subtotal = subtotal;
	}

	public long getDiscount() {
		return discount;
	}

	public void setDiscount(long discount) {
		this.discount = discount;
	}

	public long getShipping() {
		return shipping;
	}

	public void setShipping(long shipping) {
		this.shipping = shipping;
	}

	public long getTotal() {
		return total;
	}

	public void setTotal(long total) {
		this.total = total;
	}

	public String getVoucherCode() {
		return voucherCode;
	}

	public void setVoucherCode(String voucherCode) {
		this.voucherCode = voucherCode;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	public ArrayList<OrderItem> getItems() {
		return items;
	}
    
    public void setItems(ArrayList<OrderItem> items) {
        this.items = (items == null) ? new ArrayList<>() : items;
    }
}
