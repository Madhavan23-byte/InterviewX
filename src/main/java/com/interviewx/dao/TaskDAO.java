package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.util.DBConnection;

public class TaskDAO {

    public List<Map<String,Object>> getTasksForToday(int userId) {
        return getTasksForToday(userId, 0);
    }

    public List<Map<String,Object>> getTasksForToday(int userId, int profileId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql;
        if (profileId > 0) {
            sql = "SELECT * FROM study_tasks WHERE user_id=? AND profile_id=? AND scheduled_date=CURDATE() ORDER BY task_id";
        } else {
            sql = "SELECT * FROM study_tasks WHERE user_id=? AND scheduled_date=CURDATE() ORDER BY task_id";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) { list.add(mapTask(rs)); }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Map<String,Object>> getAllTasks(int userId) {
        return getAllTasks(userId, 0);
    }

    public List<Map<String,Object>> getAllTasks(int userId, int profileId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql;
        if (profileId > 0) {
            sql = "SELECT * FROM study_tasks WHERE user_id=? AND profile_id=? ORDER BY scheduled_date DESC, task_id DESC LIMIT 30";
        } else {
            sql = "SELECT * FROM study_tasks WHERE user_id=? ORDER BY scheduled_date DESC, task_id DESC LIMIT 30";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapTask(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean completeTask(int taskId, int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE study_tasks SET status='completed', completed_at=NOW() WHERE task_id=? AND user_id=?")) {
            ps.setInt(1, taskId); ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean generateDailyTasks(int userId, int trackId, String trackName) {
        return generateDailyTasks(userId, 0, trackId, trackName);
    }

    public boolean generateDailyTasks(int userId, int profileId, int trackId, String trackName) {
        List<Map<String,Object>> existing = getTasksForToday(userId, profileId);
        if (!existing.isEmpty()) return true;

        List<String[]> tasks = new ArrayList<>();
        tasks.add(new String[]{"Study: " + trackName + " Core Concepts", "Review today's learning material for 45 minutes", "LEARN"});
        tasks.add(new String[]{"Practice 2 Coding Problems", "Solve 2 problems from CodeLab in your target topic area", "CODE"});
        tasks.add(new String[]{"Technical Interview Q&A", "Practice 3 technical interview questions for " + trackName, "INTERVIEW"});
        tasks.add(new String[]{"HR & Behavioral Preparation", "Practice 2 HR interview questions and refine responses", "HR"});

        try (Connection c = DBConnection.getConnection()) {
            for (String[] t : tasks) {
                String sql;
                if (profileId > 0) {
                    sql = "INSERT INTO study_tasks (user_id, profile_id, title, description, task_type, scheduled_date, estimated_minutes) VALUES (?,?,?,?,?,CURDATE(),45)";
                } else {
                    sql = "INSERT INTO study_tasks (user_id, title, description, task_type, scheduled_date, estimated_minutes) VALUES (?,?,?,?,CURDATE(),45)";
                }
                try (PreparedStatement ps = c.prepareStatement(sql)) {
                    ps.setInt(1, userId);
                    if (profileId > 0) {
                        ps.setInt(2, profileId);
                        ps.setString(3, t[0]);
                        ps.setString(4, t[1]);
                        ps.setString(5, t[2]);
                    } else {
                        ps.setString(2, t[0]);
                        ps.setString(3, t[1]);
                        ps.setString(4, t[2]);
                    }
                    ps.executeUpdate();
                }
            }
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int getTodayCompletedCount(int userId) {
        return getTodayCompletedCount(userId, 0);
    }

    public int getTodayCompletedCount(int userId, int profileId) {
        String sql;
        if (profileId > 0) {
            sql = "SELECT COUNT(*) FROM study_tasks WHERE user_id=? AND profile_id=? AND scheduled_date=CURDATE() AND status='completed'";
        } else {
            sql = "SELECT COUNT(*) FROM study_tasks WHERE user_id=? AND scheduled_date=CURDATE() AND status='completed'";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTodayTotalCount(int userId) {
        return getTodayTotalCount(userId, 0);
    }

    public int getTodayTotalCount(int userId, int profileId) {
        String sql;
        if (profileId > 0) {
            sql = "SELECT COUNT(*) FROM study_tasks WHERE user_id=? AND profile_id=? AND scheduled_date=CURDATE()";
        } else {
            sql = "SELECT COUNT(*) FROM study_tasks WHERE user_id=? AND scheduled_date=CURDATE()";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Map<String,Object> mapTask(ResultSet rs) throws SQLException {
        Map<String,Object> m = new LinkedHashMap<>();
        m.put("taskId", rs.getInt("task_id"));
        m.put("userId", rs.getInt("user_id"));
        m.put("title", rs.getString("title"));
        m.put("description", rs.getString("description"));
        m.put("taskType", rs.getString("task_type"));
        m.put("scheduledDate", rs.getDate("scheduled_date"));
        m.put("estimatedMinutes", rs.getInt("estimated_minutes"));
        m.put("status", rs.getString("status"));
        m.put("completedAt", rs.getTimestamp("completed_at"));
        return m;
    }
}