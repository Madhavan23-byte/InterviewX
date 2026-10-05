<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> cartItems = (List<Map<String,Object>>) request.getAttribute("cartItems");
    double cartTotal = request.getAttribute("cartTotal") != null ? (double) request.getAttribute("cartTotal") : 0;
    if (cartItems == null) cartItems = new ArrayList<>();
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Cart - InterviewX Store</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left"><span class="page-title">Shopping Cart</span></div>
        <div class="topbar-right"><a href="<%=request.getContextPath()%>/store" class="btn btn-secondary btn-sm">&#8592; Back to Store</a></div>
    </header>
    <main class="main-content">
        <div class="page-header"><h1>&#128722; Your Cart</h1></div>

        <% if ("checkout".equals(error)) { %><div class="alert alert-danger">Checkout failed. Please try again.</div><% } %>

        <% if (cartItems.isEmpty()) { %>
        <div class="empty-state" style="padding:80px;background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);">
            <div class="empty-icon">&#128722;</div>
            <h3>Your cart is empty</h3>
            <a href="<%=request.getContextPath()%>/store" class="btn btn-primary" style="margin-top:16px;">&#128722; Browse Store</a>
        </div>
        <% } else { %>
        <div class="grid-2">
            <div class="card">
                <% for (Map<String,Object> item : cartItems) { %>
                <div style="display:flex;align-items:center;gap:16px;padding:16px 0;border-bottom:1px solid var(--border);">
                    <div style="font-size:28px;">&#128187;</div>
                    <div style="flex:1;">
                        <div style="font-size:15px;font-weight:700;color:var(--text);"><%=item.get("name")%></div>
                        <div style="font-size:12px;color:var(--text-muted);"><%=item.get("category")%></div>
                    </div>
                    <div style="font-size:18px;font-weight:800;color:var(--primary-light);">&#8377;<%=String.format("%.0f",(double)item.get("price"))%></div>
                    <form method="post" action="<%=request.getContextPath()%>/store/remove-from-cart">
                        <input type="hidden" name="productId" value="<%=item.get("productId")%>">
                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                    </form>
                </div>
                <% } %>
            </div>
            <div class="card">
                <div class="card-title" style="margin-bottom:20px;">Order Summary</div>
                <div style="display:flex;justify-content:space-between;font-size:18px;font-weight:800;color:var(--text);padding:16px 0;border-top:1px solid var(--border);">
                    <span>Total</span>
                    <span style="color:var(--primary-light);">&#8377;<%=String.format("%.0f", cartTotal)%></span>
                </div>
                <div class="alert alert-info" style="font-size:12px;">&#128161; This is a simulated payment for academic purposes. No real payment is processed.</div>
                <form method="post" action="<%=request.getContextPath()%>/store/checkout">
                    <button type="submit" class="btn btn-primary btn-lg btn-full">&#9989; Confirm Order (Simulated)</button>
                </form>
            </div>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>
