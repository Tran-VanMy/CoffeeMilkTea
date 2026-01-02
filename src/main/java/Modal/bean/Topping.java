package Modal.bean;

public class Topping {
    private int toppingId;
    private String name;
    private long price;
    private boolean active;
	public Topping() {
		super();
	}
	public Topping(int toppingId, String name, long price, boolean active) {
		super();
		this.toppingId = toppingId;
		this.name = name;
		this.price = price;
		this.active = active;
	}
	public int getToppingId() {
		return toppingId;
	}
	public void setToppingId(int toppingId) {
		this.toppingId = toppingId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public long getPrice() {
		return price;
	}
	public void setPrice(long price) {
		this.price = price;
	}
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
    
    
}
