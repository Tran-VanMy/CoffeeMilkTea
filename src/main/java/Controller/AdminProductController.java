package Controller;

import Modal.bean.User;
import Modal.bo.CategoryBO;
import Modal.bo.ProductBO;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet("/admin/products")
public class AdminProductController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private boolean ensureAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User admin = (User) request.getSession().getAttribute("ADMIN");
        if (admin == null || !admin.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            if (!ensureAdmin(request, response)) return;

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            ProductBO pbo = new ProductBO();
            CategoryBO cbo = new CategoryBO();

            String action = request.getParameter("action");
            if (action == null) action = "list";

            // ✅ DELETE: hard delete + xóa ảnh uploads nếu có
            if ("delete".equalsIgnoreCase(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                if (id <= 0) {
                    request.setAttribute("error", "ID sản phẩm không hợp lệ.");
                } else {
                    // lấy image_url trước khi xóa DB
                    String img = pbo.getImageUrlById(id);

                    // thử xóa DB trước (nếu DB đang bị FK chặn thì sẽ fail -> không xóa file)
                    boolean ok;
                    try {
                        ok = pbo.delete(id); // hard delete
                    } catch (Exception ex) {
                        ok = false;
                        request.setAttribute("error", "Xóa thất bại (có thể sản phẩm đang được Orders tham chiếu). " + ex.getMessage());
                    }

                    if (ok) {
                        // xóa file nếu ảnh là uploads/...
                        boolean fileDeletedMsg = false;
                        if (img != null) {
                            String path = img.trim().replace("\\", "/");
                            if (path.startsWith("uploads/")) {
                                String realFile = request.getServletContext().getRealPath("") +
                                        File.separator + path.replace("/", File.separator);
                                File f = new File(realFile);
                                if (f.exists()) {
                                    fileDeletedMsg = f.delete();
                                    request.setAttribute("msg",
                                            "Xóa sản phẩm thành công! " +
                                            (fileDeletedMsg
                                                    ? ("Đã xóa ảnh trên server ảo: " + realFile)
                                                    : ("Không thể xóa ảnh (hãy kiểm tra quyền): " + realFile)
                                            )
                                    );
                                } else {
                                    request.setAttribute("msg",
                                            "Xóa sản phẩm thành công! Ảnh uploads không tồn tại trên server: " + realFile
                                    );
                                }
                            } else {
                                request.setAttribute("msg", "Xóa sản phẩm thành công!");
                            }
                        } else {
                            request.setAttribute("msg", "Xóa sản phẩm thành công!");
                        }
                    } else {
                        if (request.getAttribute("error") == null) {
                            request.setAttribute("error", "Xóa thất bại.");
                        }
                    }
                }
            }

            request.setAttribute("categories", cbo.getAllForAdmin());
            request.setAttribute("products", pbo.getAllForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Products Error: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            if (!ensureAdmin(request, response)) return;

            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");

            ProductBO pbo = new ProductBO();
            CategoryBO cbo = new CategoryBO();

            // ====== CASE 1: multipart (Create có upload file) ======
            if (ServletFileUpload.isMultipartContent(request)) {
                handleMultipart(request, response, pbo, cbo);
                return;
            }

            // ====== CASE 2: normal form (Update...) ======
            String action = request.getParameter("action");
            if (action == null) action = "list";

            if ("update".equalsIgnoreCase(action)) {
                int id = parseIntSafe(request.getParameter("id"), 0);
                int categoryId = parseIntSafe(request.getParameter("categoryId"), 0);
                String name = request.getParameter("name");
                String desc = request.getParameter("description");
                long price = parseLongSafe(request.getParameter("basePrice"), 0);
                String img = request.getParameter("imageUrl");
                boolean active = request.getParameter("active") != null;

                String err = pbo.update(id, categoryId, name, desc, price, img, active);
                if (err != null) request.setAttribute("error", err);
                else request.setAttribute("msg", "Cập nhật sản phẩm thành công!");
            }

            request.setAttribute("categories", cbo.getAllForAdmin());
            request.setAttribute("products", pbo.getAllForAdmin());
            request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Admin Products Error: " + e.getMessage());
        }
    }

    private void handleMultipart(HttpServletRequest request, HttpServletResponse response,
                                 ProductBO pbo, CategoryBO cbo) throws Exception {

        // thư mục upload trong server ảo: <webapp>/uploads
        String uploadDir = request.getServletContext().getRealPath("") + File.separator + "uploads";
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        DiskFileItemFactory factory = new DiskFileItemFactory();
        ServletFileUpload upload = new ServletFileUpload(factory);

        ArrayList<FileItem> items = (ArrayList<FileItem>) upload.parseRequest(request);

        String action = "create";
        int categoryId = 0;
        String name = null;
        String desc = null;
        long price = 0;
        boolean active = false;

        String imageMode = "url";   // url | upload
        String imageUrl = null;     // nếu mode=url
        FileItem imageFile = null;  // nếu mode=upload

        for (FileItem it : items) {
            if (it.isFormField()) {
                String field = it.getFieldName();
                String value = it.getString("UTF-8");

                if ("action".equals(field)) action = value;
                if ("categoryId".equals(field)) categoryId = parseIntSafe(value, 0);
                if ("name".equals(field)) name = value;
                if ("description".equals(field)) desc = value;
                if ("basePrice".equals(field)) price = parseLongSafe(value, 0);
                if ("active".equals(field)) active = true;
                if ("imageMode".equals(field)) imageMode = (value == null ? "url" : value);
                if ("imageUrl".equals(field)) imageUrl = value;

            } else {
                if ("imageFile".equals(it.getFieldName())) imageFile = it;
            }
        }

        if (!"create".equalsIgnoreCase(action)) action = "create";

        String finalImageUrl = "";

        if ("upload".equalsIgnoreCase(imageMode)) {
            if (imageFile != null && imageFile.getSize() > 0) {
                String original = new File(imageFile.getName()).getName();
                String safeName = System.currentTimeMillis() + "_" + original.replaceAll("[^a-zA-Z0-9._-]", "_");
                String savePath = uploadDir + File.separator + safeName;

                File saved = new File(savePath);
                imageFile.write(saved);

                finalImageUrl = "uploads/" + safeName;

                request.setAttribute("msg",
                        "Upload ảnh thành công! Đường dẫn lưu trên server ảo: " + savePath
                                + " | Lưu DB = " + finalImageUrl
                );
            } else {
                request.setAttribute("error", "Bạn đã chọn chế độ Upload nhưng chưa chọn tệp ảnh.");
            }
        } else {
            finalImageUrl = (imageUrl == null) ? "" : imageUrl.trim();
        }

        if (request.getAttribute("error") == null) {
            String err = pbo.create(categoryId, name, desc, price, finalImageUrl, active);
            if (err != null) request.setAttribute("error", err);
            else {
                Object curMsg = request.getAttribute("msg");
                String baseMsg = (curMsg == null) ? "" : (curMsg.toString() + "<br/>");
                request.setAttribute("msg", baseMsg + "Thêm sản phẩm thành công!");
            }
        }

        request.setAttribute("categories", cbo.getAllForAdmin());
        request.setAttribute("products", pbo.getAllForAdmin());
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    private int parseIntSafe(String s, int def) {
        try {
            if (s == null) return def;
            String t = s.trim();
            if (t.isEmpty()) return def;
            return Integer.parseInt(t);
        } catch (Exception e) {
            return def;
        }
    }

    private long parseLongSafe(String s, long def) {
        try {
            if (s == null) return def;
            String t = s.trim();
            if (t.isEmpty()) return def;
            return Long.parseLong(t);
        } catch (Exception e) {
            return def;
        }
    }
}
