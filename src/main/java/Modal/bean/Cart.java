package Modal.bean;

import java.util.ArrayList;

public class Cart {
    private final ArrayList<CartItem> items = new ArrayList<>();
    private String voucherCode; // user apply
    private long shipping = 15000; // mặc định (có thể đổi rule)

    public ArrayList<CartItem> getItems() {
        return items;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public long getShipping() {
        return shipping;
    }

    public void setShipping(long shipping) {
        this.shipping = shipping;
    }

    public void add(CartItem newItem) {
        if (newItem == null || newItem.getQuantity() <= 0) return;
        String key = newItem.getKey();
        for (CartItem it : items) {
            if (it.getKey().equals(key)) {
                it.setQuantity(it.getQuantity() + newItem.getQuantity());
                return;
            }
        }
        items.add(newItem);
    }

    // ===== FIX: update/remove theo KEY (đúng với cart.jsp hiện tại) =====
    public void updateQtyByKey(String key, int qty) {
        if (key == null) return;
        for (int i = 0; i < items.size(); i++) {
            CartItem it = items.get(i);
            if (key.equals(it.getKey())) {
                if (qty <= 0) items.remove(i);
                else it.setQuantity(qty);
                return;
            }
        }
    }

    public void removeByKey(String key) {
        if (key == null) return;
        for (int i = 0; i < items.size(); i++) {
            if (key.equals(items.get(i).getKey())) {
                items.remove(i);
                return;
            }
        }
    }

    public void clear() {
        items.clear();
        voucherCode = null;
    }

    public long getSubtotal() {
        long sum = 0;
        for (CartItem it : items) sum += it.getLineTotal();
        return sum;
    }

    // Voucher tính ở BO/Checkout, Cart chỉ giữ code
}
