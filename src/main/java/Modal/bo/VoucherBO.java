// Path: src/main/java/Modal/bo/VoucherBO.java
package Modal.bo;

import Modal.bean.Voucher;
import Modal.dao.VoucherDAO;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class VoucherBO {
    private final VoucherDAO dao = new VoucherDAO();

    public Voucher getByCode(String code) throws Exception {
        return dao.getByCode(code);
    }
    public boolean consume(String code) throws Exception {
        return dao.decreaseQuantity(code);
    }

    public ArrayList<Voucher> getAllForAdmin() throws Exception {
        return dao.getAllForAdmin();
    }
    public Voucher getById(int id) throws Exception {
        return dao.getById(id);
    }

    // ✅ HARD DELETE
    public boolean delete(int id) throws Exception {
        return dao.delete(id);
    }

    // ✅ NEW: set active nhanh từ selection
    public boolean setActive(int id, boolean active) throws Exception {
        if (id <= 0) return false;
        return dao.updateActive(id, active);
    }

    public String validate(Voucher v, long subtotal) {
        if (v == null) return "Voucher không tồn tại.";
        if (!v.isActive()) return "Voucher đang bị tắt.";
        if (v.getQuantity() <= 0) return "Voucher đã hết lượt sử dụng.";
        if (subtotal < v.getMinSubtotal()) return "Đơn chưa đạt điều kiện tối thiểu.";

        Date now = new Date();
        if (v.getStartAt() != null && now.before(v.getStartAt())) return "Voucher chưa bắt đầu.";
        if (v.getEndAt() != null && now.after(v.getEndAt())) return "Voucher đã hết hạn.";

        String type = (v.getType() == null) ? "" : v.getType().toUpperCase();
        if (!type.equals("PERCENT") && !type.equals("AMOUNT") && !type.equals("FREESHIP"))
            return "Loại voucher không hợp lệ.";

        return null;
    }

    public long calcDiscount(Voucher v, long subtotal, long shipping) {
        if (v == null) return 0;
        String type = v.getType().toUpperCase();
        long discount = 0;

        if ("PERCENT".equals(type)) {
            discount = subtotal * v.getValue() / 100;
            if (v.getMaxDiscount() != null) discount = Math.min(discount, v.getMaxDiscount());
        } else if ("AMOUNT".equals(type)) {
            discount = v.getValue();
        } else if ("FREESHIP".equals(type)) {
            discount = Math.min(shipping, v.getValue());
            if (v.getMaxDiscount() != null) discount = Math.min(discount, v.getMaxDiscount());
        }

        if (discount < 0) discount = 0;
        return Math.min(discount, subtotal + shipping);
    }

    // ===== admin upsert =====
    public String upsert(Voucher v) throws Exception {
        if (v.getCode() == null || v.getCode().trim().isEmpty()) return "Code không được trống.";
        if (v.getType() == null || v.getType().trim().isEmpty()) return "Type không được trống.";
        String type = v.getType().trim().toUpperCase();
        if (!type.equals("PERCENT") && !type.equals("AMOUNT") && !type.equals("FREESHIP")) return "Type phải là PERCENT/AMOUNT/FREESHIP.";
        if (v.getValue() < 0) return "Value không hợp lệ.";
        if (v.getMinSubtotal() < 0) v.setMinSubtotal(0);
        if (v.getQuantity() < 0) return "Quantity không hợp lệ.";

        v.setCode(v.getCode().trim().toUpperCase());
        v.setType(type);

        if (v.getVoucherId() <= 0) {
            return dao.insert(v) ? null : "Thêm voucher thất bại.";
        } else {
            return dao.update(v) ? null : "Cập nhật voucher thất bại.";
        }
    }

    // helper parse datetime từ input type="datetime-local"
    public Date parseDT(String s) {
        try {
            if (s == null || s.trim().isEmpty()) return null;
            SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            return f.parse(s);
        } catch (Exception e) {
            return null;
        }
    }
}
