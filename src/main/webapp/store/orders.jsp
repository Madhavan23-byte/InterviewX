<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Map<String,Object>> orders = (List<Map<String,Object>>) request.getAttribute("orders");
    if (orders == null) orders = new ArrayList<>();
    boolean justOrdered = "true".equals(request.getParameter("ordered"));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>My Orders - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">My Orders</span></div></header>
    <main class="main-content">
        <div class="page-header"><h1>&#128196; Purchase History</h1></div>
        <% if (justOrdered) { %><div class="alert alert-success">&#9989; Order placed successfully! Your purchase is confirmed.</div><% } %>
        <% if (orders.isEmpty()) { %>
        <div class="empty-state" style="padding:80px;background:var(--surface);border-radius:var(--radius);border:1px solid var(--border);">
            <div class="empty-icon">&#128196;</div>
            <h3>No Orders Yet</h3>
            <a href="<%=request.getContextPath()%>/store" class="btn btn-primary" style="margin-top:16px;">Browse Store</a>
        </div>
        <% } else { %>
        <div class="card">
            <div class="table-wrapper">
                <table class="table">
                    <thead><tr><th>Order ID</th><th>Amount</th><th>Status</th><th>Date</th></tr></thead>
                    <tbody>
                    <% for (Map<String,Object> o : orders) { %>
                    <tr>
                        <td style="font-weight:700;">#<%=o.get("orderId")%></td>
                        <td style="color:var(--primary-light);font-weight:700;">&#8377;<%=String.format("%.0f",(double)o.get("totalAmount"))%></td>
                        <td><span class="badge badge-success"><%=o.get("status")%></span></td>
                        <td style="color:var(--text-muted);"><%=o.get("orderedAt")%></td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
        <% } %>
    </main>
</div>
</body>
</html>
