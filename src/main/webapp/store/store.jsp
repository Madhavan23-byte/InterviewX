<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.Product" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Product> products = (List<Product>) request.getAttribute("products");
    if (products == null) products = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Prep Store - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .product-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
        .product-card { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; transition: var(--transition); }
        .product-card:hover { border-color: var(--primary); transform: translateY(-4px); box-shadow: 0 12px 32px rgba(99,102,241,0.15); }
        .product-header { padding: 24px 20px; background: linear-gradient(135deg, rgba(99,102,241,0.15), rgba(14,165,233,0.1)); text-align: center; }
        .product-icon { font-size: 36px; margin-bottom: 8px; display: block; }
        .product-body { padding: 20px; }
        .product-name { font-size: 16px; font-weight: 800; color: var(--text); margin-bottom: 6px; }
        .product-desc { font-size: 13px; color: var(--text-muted); line-height: 1.6; margin-bottom: 16px; }
        .product-price { font-size: 22px; font-weight: 800; color: var(--primary-light); margin-bottom: 14px; }
        .category-icons { "Coding":"&#128187;","Interview":"&#127908;","Database":"&#128190;","Resume":"&#128196;","Soft Skills":"&#128483;" }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar">
        <div class="topbar-left"><span class="page-title">Preparation Store</span></div>
        <div class="topbar-right">
            <a href="<%=request.getContextPath()%>/store/cart" class="btn btn-secondary btn-sm">&#128722; Cart</a>
            <a href="<%=request.getContextPath()%>/store/orders" class="btn btn-secondary btn-sm">&#128196; Orders</a>
        </div>
    </header>
    <main class="main-content">
        <div class="page-header">
            <h1>&#128722; Placement Preparation Store</h1>
            <p>Premium resources to accelerate your placement preparation</p>
        </div>

        <div class="product-grid">
            <% String[] icons = {"&#128187;","&#9749;","&#128190;","&#127908;","&#128196;","&#128483;"};
               int idx = 0;
               for (Product p : products) { %>
            <div class="product-card">
                <div class="product-header">
                    <span class="product-icon"><%=icons[idx % icons.length]%></span>
                    <span class="badge badge-primary"><%=p.getCategory()%></span>
                </div>
                <div class="product-body">
                    <div class="product-name"><%=p.getName()%></div>
                    <div class="product-desc"><%=p.getDescription()%></div>
                    <div class="product-price">&#8377;<%=String.format("%.0f", p.getPrice())%></div>
                    <form method="post" action="<%=request.getContextPath()%>/store/add-to-cart">
                        <input type="hidden" name="productId" value="<%=p.getProductId()%>">
                        <button type="submit" class="btn btn-primary btn-full">&#128722; Add to Cart</button>
                    </form>
                </div>
            </div>
            <% idx++; } %>
        </div>
    </main>
</div>
</body>
</html>
