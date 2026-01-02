// Path: src/main/java/Modal/bo/ToppingBO.java
package Modal.bo;

import Modal.bean.Topping;
import Modal.dao.ToppingDAO;

import java.util.ArrayList;

public class ToppingBO {
    private final ToppingDAO dao = new ToppingDAO();

    public ArrayList<Topping> getActiveAll() throws Exception {
        return dao.getActiveAll();
    }

    public ArrayList<Topping> getAllForAdmin() throws Exception {
        return dao.getAllForAdmin();
    }

    public ArrayList<Topping> getByIds(int[] ids) throws Exception {
        return dao.getByIds(ids);
    }

    public Topping getById(int id) throws Exception {
        return dao.getById(id);
    }

    public String create(String name, long price, boolean active) throws Exception {
        if (name == null || name.trim().isEmpty()) return "Tên topping không được trống.";
        if (price < 0) return "Giá topping không hợp lệ.";
        return dao.insert(name.trim(), price, active) ? null : "Thêm thất bại.";
    }

    public String update(int id, String name, long price, boolean active) throws Exception {
        if (id <= 0) return "ID không hợp lệ.";
        if (name == null || name.trim().isEmpty()) return "Tên topping không được trống.";
        if (price < 0) return "Giá topping không hợp lệ.";
        return dao.update(id, name.trim(), price, active) ? null : "Cập nhật thất bại.";
    }

    // ✅ HARD DELETE
    public boolean delete(int id) throws Exception {
        return dao.deleteHard(id);
    }
}
