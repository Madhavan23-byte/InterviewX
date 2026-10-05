package com.interviewx.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.ProductDAO;
import com.interviewx.model.Product;

@WebServlet(urlPatterns = {"/store", "/store/cart", "/store/checkout", "/store/orders", "/store/add-to-cart", "/store/remove-from-cart"})
public class StoreServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ProductDAO productDAO;

    @Override
    public void init() { productDAO = new ProductDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        int userId = (session != null && session.getAttribute("userId") != null) ? (int) session.getAttribute("userId") : 0;

        switch (path) {
            case "/store/cart":
                List<Map<String,Object>> cartItems = productDAO.getCartItems(userId);
                double total = cartItems.stream().mapToDouble(i -> (double)i.get("price") * (int)i.get("quantity")).sum();
                req.setAttribute("cartItems", cartItems);
                req.setAttribute("cartTotal", total);
                req.getRequestDispatcher("/store/cart.jsp").forward(req, resp);
                break;
            case "/store/orders":
                req.setAttribute("orders", productDAO.getOrders(userId));
                req.getRequestDispatcher("/store/orders.jsp").forward(req, resp);
                break;
            default:
                List<Product> products = productDAO.getAllProducts();
                req.setAttribute("products", products);
                req.getRequestDispatcher("/store/store.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        int userId = (int) session.getAttribute("userId");

        String path = req.getServletPath();
        switch (path) {
            case "/store/add-to-cart":
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    productDAO.addToCart(userId, productId);
                    resp.sendRedirect(req.getContextPath() + "/store/cart");
                } catch (NumberFormatException e) {
                    resp.sendRedirect(req.getContextPath() + "/store");
                }
                break;
            case "/store/remove-from-cart":
                try {
                    int productId = Integer.parseInt(req.getParameter("productId"));
                    productDAO.removeFromCart(userId, productId);
                } catch (NumberFormatException e) {}
                resp.sendRedirect(req.getContextPath() + "/store/cart");
                break;
            case "/store/checkout":
                boolean success = productDAO.placeOrder(userId);
                if (success) {
                    resp.sendRedirect(req.getContextPath() + "/store/orders?ordered=true");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/store/cart?error=checkout");
                }
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/store");
        }
    }
}
