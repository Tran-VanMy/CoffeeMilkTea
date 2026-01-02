package Modal.bean;

public class Category {
    private int categoryId;
    private String name;
    private String slug;
    private boolean active; // is_active

    public Category() {
        super();
    }

    public Category(int categoryId, String name, String slug, boolean active) {
        super();
        this.categoryId = categoryId;
        this.name = name;
        this.slug = slug;
        this.active = active;
    }

    public int getCategoryId() {
        return categoryId;
    }
    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }
    public void setSlug(String slug) {
        this.slug = slug;
    }

    public boolean isActive() {
        return active;
    }
    public void setActive(boolean active) {
        this.active = active;
    }
}
