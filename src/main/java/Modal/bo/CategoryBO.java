package Modal.bo;

import Modal.bean.Category;
import Modal.dao.CategoryDAO;

import java.util.ArrayList;

public class CategoryBO {
    private final CategoryDAO dao = new CategoryDAO();

    public ArrayList<Category> getAllActive() throws Exception {
        return dao.getAllActive();
    }

    public ArrayList<Category> getAllForAdmin() throws Exception {
        return dao.getAllForAdmin();
    }

    public Category getById(int id) throws Exception {
        return dao.getById(id);
    }

    public String create(String name, String slug) throws Exception {
        if (name == null || name.trim().isEmpty()) return "Tên danh mục không được trống.";
        if (slug == null || slug.trim().isEmpty()) return "Slug không được trống.";
        slug = slug.trim().toLowerCase();
        if (dao.slugExists(slug, null)) return "Slug đã tồn tại.";
        return dao.insert(name.trim(), slug) ? null : "Thêm thất bại.";
    }

    public String update(int id, String name, String slug, boolean active) throws Exception {
        if (id <= 0) return "ID không hợp lệ.";
        if (name == null || name.trim().isEmpty()) return "Tên danh mục không được trống.";
        if (slug == null || slug.trim().isEmpty()) return "Slug không được trống.";
        slug = slug.trim().toLowerCase();
        if (dao.slugExists(slug, id)) return "Slug đã tồn tại.";
        return dao.update(id, name.trim(), slug, active) ? null : "Cập nhật thất bại.";
    }

    // Delete thật
    public String deleteHard(int id) throws Exception {
        if (id <= 0) return "ID không hợp lệ.";
        boolean ok = dao.deleteHard(id);
        if (ok) return null;
        return "Xóa thất bại.";
    }
}
