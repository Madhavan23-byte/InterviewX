package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.Product;
import com.interviewx.util.DBConnection;

public class ProductDAO {

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM products WHERE is_active=1 ORDER BY product_id")) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Product getProductById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM products WHERE product_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return mapRow(rs); }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean addToCart(int userId, int productId) {
        String sql = "INSERT INTO cart_items (user_id, product_id, quantity) VALUES (?,?,1) " +
                     "ON DUPLICATE KEY UPDATE quantity=quantity+1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId); ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Map<String,Object>> getCartItems(int userId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT ci.cart_id, ci.quantity, p.* FROM cart_items ci JOIN products p ON ci.product_id=p.product_id WHERE ci.user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new LinkedHashMap<>();
                    m.put("cartId", rs.getInt("cart_id"));
                    m.put("quantity", rs.getInt("quantity"));
                    m.put("productId", rs.getInt("product_id"));
                    m.put("name", rs.getString("name"));
                    m.put("price", rs.getDouble("price"));
                    m.put("category", rs.getString("category"));
                    m.put("description", rs.getString("description"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean removeFromCart(int userId, int productId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM cart_items WHERE user_id=? AND product_id=?")) {
            ps.setInt(1, userId); ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean placeOrder(int userId) {
        Connection c = null;
        try {
            c = DBConnection.getConnection();
            c.setAutoCommit(false);

            List<Map<String,Object>> cart = getCartItems(userId);
            if (cart.isEmpty()) return false;

            double total = cart.stream().mapToDouble(item -> (double)item.get("price") * (int)item.get("quantity")).sum();

            try (PreparedStatement ps = c.prepareStatement(
                "INSERT INTO orders (user_id, total_amount) VALUES (?,?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId); ps.setDouble(2, total);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        int orderId = rs.getInt(1);
                        for (Map<String,Object> item : cart) {
                            try (PreparedStatement ps2 = c.prepareStatement(
                                "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?,?,?,?)")) {
                                ps2.setInt(1, orderId);
                                ps2.setInt(2, (int)item.get("productId"));
                                ps2.setInt(3, (int)item.get("quantity"));
                                ps2.setDouble(4, (double)item.get("price"));
                                ps2.executeUpdate();
                            }
                        }
                    }
                }
            }

            try (PreparedStatement ps = c.prepareStatement("DELETE FROM cart_items WHERE user_id=?")) {
                ps.setInt(1, userId); ps.executeUpdate();
            }

            c.commit();
            return true;
        } catch (SQLException e) {
            try { if (c!=null) c.rollback(); } catch (SQLException ex) {}
            e.printStackTrace(); return false;
        } finally {
            try { if (c!=null) { c.setAutoCommit(true); c.close(); } } catch (SQLException e) {}
        }
    }

    public List<Map<String,Object>> getOrders(int userId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT o.order_id, o.total_amount, o.status, o.ordered_at FROM orders o WHERE o.user_id=? ORDER BY o.ordered_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new LinkedHashMap<>();
                    m.put("orderId", rs.getInt("order_id"));
                    m.put("totalAmount", rs.getDouble("total_amount"));
                    m.put("status", rs.getString("status"));
                    m.put("orderedAt", rs.getTimestamp("ordered_at"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Product mapRow(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setName(rs.getString("name"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setCategory(rs.getString("category"));
        p.setImageUrl(rs.getString("image_url"));
        p.setIsActive(rs.getInt("is_active"));
        return p;
    }
}
