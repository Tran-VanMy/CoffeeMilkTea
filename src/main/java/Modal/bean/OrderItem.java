package Modal.bean;

public class OrderItem {
    private long orderItemId;
    private long orderId;

    private int productId;
    private String productName;

    private String size;   // S/M/L
    private int sugar;     // 0-100
    private int ice;       // 0-100

    private String toppingJson; // "id:name:price,id:name:price"
    private long unitPrice;
    private int quantity;
    private long lineTotal;
    
	public OrderItem() {
		super();
	}

	public OrderItem(long orderItemId, long orderId, int productId, String productName, String size, int sugar, int ice,
			String toppingJson, long unitPrice, int quantity, long lineTotal) {
		super();
		this.orderItemId = orderItemId;
		this.orderId = orderId;
		this.productId = productId;
		this.productName = productName;
		this.size = size;
		this.sugar = sugar;
		this.ice = ice;
		this.toppingJson = toppingJson;
		this.unitPrice = unitPrice;
		this.quantity = quantity;
		this.lineTotal = lineTotal;
	}

	public long getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(long orderItemId) {
		this.orderItemId = orderItemId;
	}

	public long getOrderId() {
		return orderId;
	}

	public void setOrderId(long orderId) {
		this.orderId = orderId;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public int getSugar() {
		return sugar;
	}

	public void setSugar(int sugar) {
		this.sugar = sugar;
	}

	public int getIce() {
		return ice;
	}

	public void setIce(int ice) {
		this.ice = ice;
	}

	public String getToppingJson() {
		return toppingJson;
	}

	public void setToppingJson(String toppingJson) {
		this.toppingJson = toppingJson;
	}

	public long getUnitPrice() {
		return unitPrice;
	}

	public void setUnitPrice(long unitPrice) {
		this.unitPrice = unitPrice;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public long getLineTotal() {
		return lineTotal;
	}

	public void setLineTotal(long lineTotal) {
		this.lineTotal = lineTotal;
	}
    
    
}
