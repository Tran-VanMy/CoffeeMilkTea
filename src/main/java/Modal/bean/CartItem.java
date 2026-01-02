package Modal.bean;

import java.util.ArrayList;

public class CartItem {
    private int productId;
    private String productName;
    private String imageUrl;

    private long basePrice;    // size S
    private String size;       // S/M/L
    private int sugar;         // 0-100
    private int ice;           // 0-100

    private ArrayList<Topping> toppings = new ArrayList<>();
    private int quantity;

    public CartItem() {
        super();
    }

    public CartItem(int productId, String productName, String imageUrl, long basePrice,
                    String size, int sugar, int ice,
                    ArrayList<Topping> toppings, int quantity) {
        this.productId = productId;
        this.productName = productName;
        this.imageUrl = imageUrl;
        this.basePrice = basePrice;
        this.size = size;
        this.sugar = sugar;
        this.ice = ice;
        this.toppings = (toppings == null) ? new ArrayList<>() : toppings;
        this.quantity = quantity;
    }

    // ===== Getter =====
    public int getProductId() {
        return productId;
    }

    public String getProductName() {
        return productName;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public long getBasePrice() {
        return basePrice;
    }

    public String getSize() {
        return size;
    }

    public int getSugar() {
        return sugar;
    }

    public int getIce() {
        return ice;
    }

    public ArrayList<Topping> getToppings() {
        return toppings;
    }

    public int getQuantity() {
        return quantity;
    }

    // ===== Setter (FIX LỖI CartController) =====
    public void setProductId(int productId) {
        this.productId = productId;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setBasePrice(long basePrice) {
        this.basePrice = basePrice;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public void setSugar(int sugar) {
        this.sugar = sugar;
    }

    public void setIce(int ice) {
        this.ice = ice;
    }

    public void setToppings(ArrayList<Topping> toppings) {
        this.toppings = (toppings == null) ? new ArrayList<>() : toppings;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    // ===== Pricing =====
    public long getSizeExtra() {
        if (size == null) return 0;
        switch (size.toUpperCase()) {
            case "M": return 5000;
            case "L": return 10000;
            default: return 0; // S
        }
    }

    public long getToppingTotal() {
        long sum = 0;
        if (toppings == null) return 0;
        for (Topping t : toppings) {
            if (t != null) sum += t.getPrice();
        }
        return sum;
    }

    public long getUnitPrice() {
        return basePrice + getSizeExtra() + getToppingTotal();
    }

    public long getLineTotal() {
        return getUnitPrice() * quantity;
    }

    // key để gộp item nếu cùng cấu hình
    public String getKey() {
        StringBuilder sb = new StringBuilder();
        sb.append(productId)
          .append("|").append(size)
          .append("|").append(sugar)
          .append("|").append(ice)
          .append("|");

        ArrayList<Integer> ids = new ArrayList<>();
        if (toppings != null) {
            for (Topping t : toppings) {
                if (t != null) ids.add(t.getToppingId());
            }
        }
        ids.sort(Integer::compareTo);

        for (Integer id : ids) sb.append(id).append(",");
        return sb.toString();
    }

    public String toppingsToJsonLike() {
        StringBuilder sb = new StringBuilder();
        if (toppings == null) return "";
        for (int i = 0; i < toppings.size(); i++) {
            Topping t = toppings.get(i);
            if (t == null) continue;
            sb.append(t.getToppingId()).append(":")
              .append(t.getName() == null ? "" : t.getName().replace(",", " ")).append(":")
              .append(t.getPrice());
            if (i < toppings.size() - 1) sb.append(",");
        }
        return sb.toString();
    }

    // JSP gọi method này
    public ArrayList<String> getToppingNames() {
        ArrayList<String> names = new ArrayList<>();
        if (toppings == null) return names;

        for (Topping t : toppings) {
            if (t != null && t.getName() != null) {
                names.add(t.getName());
            }
        }
        return names;
    }
}
