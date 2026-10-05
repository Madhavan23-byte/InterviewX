package com.interviewx.controller;

import java.io.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import com.interviewx.dao.NotificationDAO;
import com.interviewx.model.Notification;

@WebServlet(urlPatterns = {"/notifications", "/api/notifications"})
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private NotificationDAO notificationDAO;

    @Override
    public void init() { notificationDAO = new NotificationDAO(); }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        int userId = (int) session.getAttribute("userId");

        String path = req.getServletPath();
        if ("/api/notifications".equals(path)) {
            // AJAX endpoint - return JSON
            resp.setContentType("application/json");
            List<Notification> notifs = notificationDAO.getNotifications(userId);
            int unread = notificationDAO.getUnreadCount(userId);
            StringBuilder json = new StringBuilder("{\"unread\":" + unread + ",\"notifications\":[");
            for (int i = 0; i < notifs.size(); i++) {
                Notification n = notifs.get(i);
                if (i > 0) json.append(",");
                json.append("{\"id\":").append(n.getNotificationId())
                    .append(",\"title\":\"").append(escape(n.getTitle())).append("\"")
                    .append(",\"message\":\"").append(escape(n.getMessage())).append("\"")
                    .append(",\"type\":\"").append(n.getType()).append("\"")
                    .append(",\"isRead\":").append(n.getIsRead())
                    .append(",\"createdAt\":\"").append(n.getCreatedAt()).append("\"")
                    .append("}");
            }
            json.append("]}");
            resp.getWriter().write(json.toString());
        } else {
            notificationDAO.markAllRead(userId);
            List<Notification> notifs = notificationDAO.getNotifications(userId);
            req.setAttribute("notifications", notifs);
            req.getRequestDispatcher("/notifications/notifications.jsp").forward(req, resp);
        }
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n");
    }
}
