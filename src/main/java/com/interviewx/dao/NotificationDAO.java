package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.Notification;
import com.interviewx.util.DBConnection;

public class NotificationDAO {

    public boolean addNotification(int userId, String title, String message, String type) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "INSERT INTO notifications (user_id, title, message, type) VALUES (?,?,?,?)")) {
            ps.setInt(1, userId); ps.setString(2, title);
            ps.setString(3, message); ps.setString(4, type);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Notification> getNotifications(int userId) {
        List<Notification> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 20")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    n.setUserId(rs.getInt("user_id"));
                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setType(rs.getString("type"));
                    n.setIsRead(rs.getInt("is_read"));
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getUnreadCount(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT COUNT(*) FROM notifications WHERE user_id=? AND is_read=0")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) { if (rs.next()) return rs.getInt(1); }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean markAllRead(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE notifications SET is_read=1 WHERE user_id=?")) {
            ps.setInt(1, userId);
            ps.executeUpdate(); return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
}
