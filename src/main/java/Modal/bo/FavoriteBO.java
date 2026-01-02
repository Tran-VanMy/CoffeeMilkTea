package Modal.bo;

import Modal.bean.Product;
import Modal.dao.FavoriteDAO;

import java.util.ArrayList;
import java.util.Set;

public class FavoriteBO {
    private final FavoriteDAO dao = new FavoriteDAO();

    public boolean toggle(long userId, int productId) throws Exception {
        return dao.toggle(userId, productId);
    }

    public boolean remove(long userId, int productId) throws Exception {
        return dao.remove(userId, productId);
    }

    public int countByUser(long userId) throws Exception {
        return dao.countByUser(userId);
    }

    public Set<Integer> getProductIdSet(long userId) throws Exception {
        return dao.getProductIdSet(userId);
    }

    public ArrayList<Product> getFavoriteProducts(long userId) throws Exception {
        return dao.getFavoriteProducts(userId);
    }
}
