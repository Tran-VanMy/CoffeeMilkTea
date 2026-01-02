package Modal.bean;

public class Product {
    private int productId;
    private int categoryId;
    private String categoryName;

    private String name;
    private String description;
    private long basePrice;      // size S
    private String imageUrl;
    private boolean active;
	public Product() {
		super();
	}
	public Product(int productId, int categoryId, String categoryName, String name, String description, long basePrice,
			String imageUrl, boolean active) {
		super();
		this.productId = productId;
		this.categoryId = categoryId;
		this.categoryName = categoryName;
		this.name = name;
		this.description = description;
		this.basePrice = basePrice;
		this.imageUrl = imageUrl;
		this.active = active;
	}
	public Product(int productId, int categoryId, String name, String description, long basePrice,
			String imageUrl, boolean active) {
		super();
		this.productId = productId;
		this.categoryId = categoryId;
		this.name = name;
		this.description = description;
		this.basePrice = basePrice;
		this.imageUrl = imageUrl;
		this.active = active;
	}
	public int getProductId() {
		return productId;
	}
	public void setProductId(int productId) {
		this.productId = productId;
	}
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getBasePrice() {
		return basePrice;
	}
	public void setBasePrice(long basePrice) {
		this.basePrice = basePrice;
	}
	public String getImageUrl() {
		return imageUrl;
	}
	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}
	public boolean isActive() {
		return active;
	}
	public void setActive(boolean active) {
		this.active = active;
	}
    
    
}
