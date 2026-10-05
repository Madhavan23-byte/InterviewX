<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.interviewx.model.Notification" %>
<%
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp"); return;
    }
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    if (notifications == null) notifications = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><title>Notifications - InterviewX</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
    <style>
        .notif-item { display: flex; gap: 14px; padding: 16px 20px; border-bottom: 1px solid var(--border); align-items: flex-start; }
        .notif-icon { width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 18px; flex-shrink: 0; }
        .notif-icon.success { background: rgba(16,185,129,0.15); }
        .notif-icon.info { background: rgba(14,165,233,0.15); }
        .notif-icon.warning { background: rgba(245,158,11,0.15); }
        .notif-title { font-size: 14px; font-weight: 700; color: var(--text); }
        .notif-msg { font-size: 13px; color: var(--text-muted); margin-top: 3px; line-height: 1.5; }
        .notif-time { font-size: 11px; color: var(--text-muted); margin-top: 4px; }
    </style>
</head>
<body>
<div class="app-layout">
    <%@ include file="../sidebar.jsp" %>
    <header class="topbar"><div class="topbar-left"><span class="page-title">Notifications</span></div></header>
    <main class="main-content">
        <div class="page-header"><h1>&#128276; Notifications</h1></div>

        <div class="card">
            <% if (notifications.isEmpty()) { %>
            <div class="empty-state"><div class="empty-icon">&#128276;</div><h3>No Notifications</h3><p>You're all caught up!</p></div>
            <% } else {
                for (Notification n : notifications) {
                    String typeIcon = "success".equals(n.getType()) ? "&#9989;" : "info".equals(n.getType()) ? "&#128161;" : "&#9888;&#65039;";
            %>
            <div class="notif-item">
                <div class="notif-icon <%=n.getType()%>"><%=typeIcon%></div>
                <div style="flex:1;">
                    <div class="notif-title"><%=n.getTitle()%></div>
                    <div class="notif-msg"><%=n.getMessage()%></div>
                    <div class="notif-time"><%=n.getCreatedAt()%></div>
                </div>
                <span class="badge <%=n.getIsRead()==0?"badge-primary":""%>"><%=n.getIsRead()==0?"NEW":"READ"%></span>
            </div>
            <% }} %>
        </div>
    </main>
</div>
</body>
</html>
