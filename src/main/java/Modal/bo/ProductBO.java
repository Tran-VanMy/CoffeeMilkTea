// Path: src/main/java/Modal/bo/ProductBO.java
package Modal.bo;

import Modal.bean.Product;
import Modal.dao.ProductDAO;

import java.util.ArrayList;

public class ProductBO {
    private final ProductDAO dao = new ProductDAO();

    public ArrayList<Product> getActiveAll() throws Exception {
        return dao.getActiveAll();
    }

    public ArrayList<Product> getAllForAdmin() throws Exception {
        return dao.getAllForAdmin();
    }

    public ArrayList<Product> getActiveByCategory(int categoryId) throws Exception {
        return dao.getActiveByCategory(categoryId);
    }

    public Product getById(int id) throws Exception {
        return dao.getById(id);
    }

    public String getImageUrlById(int id) throws Exception {
        return dao.getImageUrlById(id);
    }

    public ArrayList<Product> searchActive(String keyword) throws Exception {
        return dao.searchActive(keyword);
    }
    
    // ✅ NEW: sort logic
    public ArrayList<Product> getActiveAllSorted(String sort) throws Exception {
        return dao.getActiveAllSorted(sort);
    }

    public ArrayList<Product> getActiveByCategorySorted(int categoryId, String sort) throws Exception {
        return dao.getActiveByCategorySorted(categoryId, sort);
    }

    public ArrayList<Product> searchActiveSorted(String keyword, String sort) throws Exception {
        return dao.searchActiveSorted(keyword, sort);
    }

    public String create(int categoryId, String name, String desc, long basePrice, String imageUrl, boolean active) throws Exception {
        if (categoryId <= 0) return "Chưa chọn danh mục.";
        if (name == null || name.trim().isEmpty()) return "Tên sản phẩm không được trống.";
        if (basePrice < 0) return "Giá không hợp lệ.";
        return dao.insert(categoryId, name.trim(), desc, basePrice, imageUrl, active) ? null : "Thêm thất bại.";
    }

    public String update(int productId, int categoryId, String name, String desc, long basePrice, String imageUrl, boolean active) throws Exception {
        if (productId <= 0) return "ID sản phẩm không hợp lệ.";
        if (categoryId <= 0) return "Chưa chọn danh mục.";
        if (name == null || name.trim().isEmpty()) return "Tên sản phẩm không được trống.";
        if (basePrice < 0) return "Giá không hợp lệ.";
        return dao.update(productId, categoryId, name.trim(), desc, basePrice, imageUrl, active) ? null : "Cập nhật thất bại.";
    }

    // ✅ HARD DELETE
    public boolean delete(int id) throws Exception {
        return dao.deleteHard(id);
    }
}
