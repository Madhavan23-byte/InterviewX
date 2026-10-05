package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.LearningTrack;
import com.interviewx.model.LearningModule;
import com.interviewx.util.DBConnection;

public class LearningTrackDAO {

    public int createTrack(LearningTrack track) {
        String sql = "INSERT INTO learning_tracks (profile_id, user_id, track_name, description, category, icon, status, progress_percentage) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, track.getProfileId());
            ps.setInt(2, track.getUserId());
            ps.setString(3, track.getTrackName());
            ps.setString(4, track.getDescription());
            ps.setString(5, track.getCategory() != null ? track.getCategory() : "Technical");
            ps.setString(6, track.getIcon() != null ? track.getIcon() : "book");
            ps.setString(7, track.getStatus() != null ? track.getStatus() : "IN_PROGRESS");
            ps.setDouble(8, track.getProgressPercentage());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<LearningTrack> getTracksByProfile(int profileId, int userId) {
        List<LearningTrack> list = new ArrayList<>();
        String sql = "SELECT * FROM learning_tracks WHERE profile_id=? AND user_id=? ORDER BY track_id ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profileId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LearningTrack track = mapTrack(rs);
                    enrichTrackMetrics(c, track);
                    list.add(track);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public LearningTrack getTrackById(int trackId, int profileId, int userId) {
        String sql = "SELECT * FROM learning_tracks WHERE track_id=? AND profile_id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            ps.setInt(2, profileId);
            ps.setInt(3, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LearningTrack track = mapTrack(rs);
                    enrichTrackMetrics(c, track);
                    return track;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public LearningTrack getTrackByIdOnly(int trackId) {
        String sql = "SELECT * FROM learning_tracks WHERE track_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LearningTrack track = mapTrack(rs);
                    enrichTrackMetrics(c, track);
                    return track;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateTrackStatus(int trackId, String status, int userId) {
        String sql = "UPDATE learning_tracks SET status=?, completed_at = CASE WHEN ?='COMPLETED' THEN NOW() ELSE NULL END WHERE track_id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, status);
            ps.setInt(3, trackId);
            ps.setInt(4, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteTrack(int trackId, int profileId, int userId) {
        String sql = "DELETE FROM learning_tracks WHERE track_id=? AND profile_id=? AND user_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            ps.setInt(2, profileId);
            ps.setInt(3, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<LearningModule> getModulesByTrack(int trackId) {
        List<LearningModule> list = new ArrayList<>();
        String sql = "SELECT * FROM learning_modules WHERE track_id=? ORDER BY module_order ASC, module_id ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    LearningModule m = new LearningModule();
                    m.setModuleId(rs.getInt("module_id"));
                    m.setTrackId(rs.getInt("track_id"));
                    m.setModuleName(rs.getString("module_name"));
                    m.setDescription(rs.getString("description"));
                    m.setModuleOrder(rs.getInt("module_order"));
                    m.setStatus(rs.getString("status"));
                    m.setCompletedAt(rs.getTimestamp("completed_at"));
                    list.add(m);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean createModule(LearningModule mod) {
        String sql = "INSERT INTO learning_modules (track_id, module_name, description, module_order, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, mod.getTrackId());
            ps.setString(2, mod.getModuleName());
            ps.setString(3, mod.getDescription());
            ps.setInt(4, mod.getModuleOrder());
            ps.setString(5, mod.getStatus() != null ? mod.getStatus() : "NOT_STARTED");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean completeModule(int moduleId, int trackId) {
        String sql = "UPDATE learning_modules SET status='COMPLETED', completed_at=NOW() WHERE module_id=? AND track_id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, moduleId);
            ps.setInt(2, trackId);
            boolean ok = ps.executeUpdate() > 0;
            if (ok) {
                updateTrackProgress(trackId);
            }
            return ok;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getTasksByTrack(int trackId, int profileId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.*, m.module_name FROM study_tasks t " +
                     "LEFT JOIN learning_modules m ON t.module_id = m.module_id " +
                     "WHERE t.learning_track_id=? AND (t.profile_id=? OR t.profile_id IS NULL) " +
                     "ORDER BY t.scheduled_date ASC, t.task_id ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTaskRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Map<String, Object>> getTodaysTasksByTrack(int trackId, int profileId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT t.*, m.module_name FROM study_tasks t " +
                     "LEFT JOIN learning_modules m ON t.module_id = m.module_id " +
                     "WHERE t.learning_track_id=? AND (t.profile_id=? OR t.profile_id IS NULL) AND t.scheduled_date=CURDATE() " +
                     "ORDER BY t.task_id ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTaskRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Map<String, List<Map<String, Object>>> getTodaysTasksGroupedByTrack(int profileId, int userId) {
        Map<String, List<Map<String, Object>>> grouped = new LinkedHashMap<>();
        String sql = "SELECT t.*, lt.track_name, lt.track_id as lt_id, m.module_name FROM study_tasks t " +
                     "JOIN learning_tracks lt ON t.learning_track_id = lt.track_id " +
                     "LEFT JOIN learning_modules m ON t.module_id = m.module_id " +
                     "WHERE lt.profile_id=? AND lt.user_id=? AND t.scheduled_date=CURDATE() " +
                     "ORDER BY lt.track_name ASC, t.task_id ASC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profileId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String trackName = rs.getString("track_name");
                    grouped.computeIfAbsent(trackName, k -> new ArrayList<>()).add(mapTaskRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return grouped;
    }

    public boolean completeTask(int taskId, int trackId, int profileId, int userId, int timeSpentMinutes) {
        String updateSql = "UPDATE study_tasks SET status='completed', completed_at=NOW() WHERE task_id=? AND user_id=?";
        String insertCompletion = "INSERT INTO task_completion (task_id, profile_id, track_id, user_id, time_spent_minutes, completed_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try (PreparedStatement psUpdate = c.prepareStatement(updateSql);
                 PreparedStatement psInsert = c.prepareStatement(insertCompletion)) {
                
                psUpdate.setInt(1, taskId);
                psUpdate.setInt(2, userId);
                int rows = psUpdate.executeUpdate();
                if (rows <= 0) {
                    c.rollback();
                    return false;
                }

                psInsert.setInt(1, taskId);
                psInsert.setInt(2, profileId);
                psInsert.setInt(3, trackId);
                psInsert.setInt(4, userId);
                psInsert.setInt(5, timeSpentMinutes > 0 ? timeSpentMinutes : 30);
                psInsert.executeUpdate();

                c.commit();
            } catch (SQLException ex) {
                c.rollback();
                throw ex;
            } finally {
                c.setAutoCommit(true);
            }

            if (trackId > 0) {
                updateTrackProgress(trackId);
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateTrackProgress(int trackId) {
        String sqlCounts = "SELECT " +
            "(SELECT COUNT(*) FROM learning_modules WHERE track_id=?) as total_mods, " +
            "(SELECT COUNT(*) FROM learning_modules WHERE track_id=? AND status='COMPLETED') as completed_mods, " +
            "(SELECT COUNT(*) FROM study_tasks WHERE learning_track_id=?) as total_tasks, " +
            "(SELECT COUNT(*) FROM study_tasks WHERE learning_track_id=? AND status='completed') as completed_tasks";

        double progress = 0.0;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sqlCounts)) {
            ps.setInt(1, trackId);
            ps.setInt(2, trackId);
            ps.setInt(3, trackId);
            ps.setInt(4, trackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int totalMods = rs.getInt("total_mods");
                    int completedMods = rs.getInt("completed_mods");
                    int totalTasks = rs.getInt("total_tasks");
                    int completedTasks = rs.getInt("completed_tasks");

                    double modPct = totalMods > 0 ? (completedMods * 100.0 / totalMods) : 0.0;
                    double taskPct = totalTasks > 0 ? (completedTasks * 100.0 / totalTasks) : 0.0;

                    if (totalMods > 0 && totalTasks > 0) {
                        progress = (modPct * 0.5) + (taskPct * 0.5);
                    } else if (totalMods > 0) {
                        progress = modPct;
                    } else if (totalTasks > 0) {
                        progress = taskPct;
                    }
                    progress = Math.round(progress * 10.0) / 10.0;
                }
            }

            String updateSql = "UPDATE learning_tracks SET progress_percentage=? WHERE track_id=?";
            try (PreparedStatement psUp = c.prepareStatement(updateSql)) {
                psUp.setDouble(1, progress);
                psUp.setInt(2, trackId);
                return psUp.executeUpdate() > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Map<String, Object>> getCompletedActivities(int trackId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sqlMod = "SELECT 'MODULE' as item_type, module_name as title, description, completed_at, 0 as time_spent " +
                        "FROM learning_modules WHERE track_id=? AND status='COMPLETED' AND completed_at IS NOT NULL";
        String sqlTask = "SELECT 'TASK' as item_type, t.title, t.description, tc.completed_at, tc.time_spent_minutes as time_spent " +
                         "FROM task_completion tc JOIN study_tasks t ON tc.task_id = t.task_id " +
                         "WHERE tc.track_id=? ORDER BY completed_at DESC";

        try (Connection c = DBConnection.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(sqlMod)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> m = new HashMap<>();
                        m.put("itemType", rs.getString("item_type"));
                        m.put("title", rs.getString("title"));
                        m.put("description", rs.getString("description"));
                        m.put("completedAt", rs.getTimestamp("completed_at"));
                        m.put("timeSpent", rs.getInt("time_spent"));
                        list.add(m);
                    }
                }
            }
            try (PreparedStatement ps = c.prepareStatement(sqlTask)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> m = new HashMap<>();
                        m.put("itemType", rs.getString("item_type"));
                        m.put("title", rs.getString("title"));
                        m.put("description", rs.getString("description"));
                        m.put("completedAt", rs.getTimestamp("completed_at"));
                        m.put("timeSpent", rs.getInt("time_spent"));
                        list.add(m);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        list.sort((a, b) -> {
            Timestamp t1 = (Timestamp) a.get("completedAt");
            Timestamp t2 = (Timestamp) b.get("completedAt");
            if (t1 == null && t2 == null) return 0;
            if (t1 == null) return 1;
            if (t2 == null) return -1;
            return t2.compareTo(t1);
        });
        return list;
    }

    public Map<String, Object> getTrackAnalytics(int trackId) {
        Map<String, Object> data = new HashMap<>();
        try (Connection c = DBConnection.getConnection()) {
            String sqlTypes = "SELECT task_type, COUNT(*) as cnt FROM study_tasks WHERE learning_track_id=? GROUP BY task_type";
            Map<String, Integer> types = new HashMap<>();
            try (PreparedStatement ps = c.prepareStatement(sqlTypes)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        types.put(rs.getString("task_type"), rs.getInt("cnt"));
                    }
                }
            }
            data.put("taskTypes", types);

            String sqlDays = "SELECT DATE(completed_at) as cdate, COUNT(*) as cnt, SUM(time_spent_minutes) as minutes " +
                             "FROM task_completion WHERE track_id=? AND completed_at >= DATE_SUB(CURDATE(), INTERVAL 7 DAY) " +
                             "GROUP BY DATE(completed_at) ORDER BY cdate ASC";
            List<String> dates = new ArrayList<>();
            List<Integer> taskCounts = new ArrayList<>();
            List<Integer> minutesList = new ArrayList<>();
            try (PreparedStatement ps = c.prepareStatement(sqlDays)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        dates.add(rs.getString("cdate"));
                        taskCounts.add(rs.getInt("cnt"));
                        minutesList.add(rs.getInt("minutes"));
                    }
                }
            }
            data.put("dates", dates);
            data.put("taskCounts", taskCounts);
            data.put("minutesList", minutesList);

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }

    private LearningTrack mapTrack(ResultSet rs) throws SQLException {
        LearningTrack t = new LearningTrack();
        t.setTrackId(rs.getInt("track_id"));
        t.setProfileId(rs.getInt("profile_id"));
        t.setUserId(rs.getInt("user_id"));
        t.setTrackName(rs.getString("track_name"));
        t.setDescription(rs.getString("description"));
        t.setCategory(rs.getString("category"));
        t.setIcon(rs.getString("icon"));
        t.setStatus(rs.getString("status"));
        t.setProgressPercentage(rs.getDouble("progress_percentage"));
        t.setStartedAt(rs.getTimestamp("started_at"));
        t.setCompletedAt(rs.getTimestamp("completed_at"));
        t.setLastAccessedAt(rs.getTimestamp("last_accessed_at"));
        return t;
    }

    private void enrichTrackMetrics(Connection c, LearningTrack track) {
        int trackId = track.getTrackId();
        try {
            String sqlMod = "SELECT COUNT(*) as total, SUM(CASE WHEN status='COMPLETED' THEN 1 ELSE 0 END) as completed FROM learning_modules WHERE track_id=?";
            try (PreparedStatement ps = c.prepareStatement(sqlMod)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int total = rs.getInt("total");
                        int completed = rs.getInt("completed");
                        track.setTotalModules(total);
                        track.setCompletedModules(completed);
                        double pct = total > 0 ? (completed * 100.0 / total) : 0.0;
                        track.setModuleProgressPercentage(Math.round(pct * 10.0) / 10.0);
                    }
                }
            }

            String sqlTasks = "SELECT COUNT(*) as total, SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) as completed FROM study_tasks WHERE learning_track_id=?";
            try (PreparedStatement ps = c.prepareStatement(sqlTasks)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int total = rs.getInt("total");
                        int completed = rs.getInt("completed");
                        track.setTotalTasks(total);
                        track.setCompletedTasks(completed);
                        double pct = total > 0 ? (completed * 100.0 / total) : 0.0;
                        track.setTaskProgressPercentage(Math.round(pct * 10.0) / 10.0);
                    }
                }
            }

            String sqlToday = "SELECT COUNT(*) FROM study_tasks WHERE learning_track_id=? AND scheduled_date=CURDATE()";
            try (PreparedStatement ps = c.prepareStatement(sqlToday)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) track.setTodaysTasksCount(rs.getInt(1));
                }
            }

            String sqlTime = "SELECT COALESCE(SUM(time_spent_minutes), 0) FROM task_completion WHERE track_id=?";
            try (PreparedStatement ps = c.prepareStatement(sqlTime)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) track.setTimeSpentMinutes(rs.getInt(1));
                }
            }

            String sqlCurr = "SELECT module_name FROM learning_modules WHERE track_id=? AND status != 'COMPLETED' ORDER BY module_order ASC, module_id ASC LIMIT 1";
            try (PreparedStatement ps = c.prepareStatement(sqlCurr)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) track.setCurrentModuleName(rs.getString("module_name"));
                    else track.setCurrentModuleName("All Modules Completed");
                }
            }

            String sqlNext = "SELECT title FROM study_tasks WHERE learning_track_id=? AND status='pending' ORDER BY scheduled_date ASC, task_id ASC LIMIT 1";
            try (PreparedStatement ps = c.prepareStatement(sqlNext)) {
                ps.setInt(1, trackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) track.setNextTaskTitle(rs.getString("title"));
                    else track.setNextTaskTitle("All Tasks Completed");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Map<String, Object> mapTaskRow(ResultSet rs) throws SQLException {
        Map<String, Object> m = new HashMap<>();
        m.put("taskId", rs.getInt("task_id"));
        m.put("userId", rs.getInt("user_id"));
        m.put("profileId", rs.getInt("profile_id"));
        m.put("learningTrackId", rs.getInt("learning_track_id"));
        m.put("moduleId", rs.getInt("module_id"));
        m.put("title", rs.getString("title"));
        m.put("description", rs.getString("description"));
        m.put("taskType", rs.getString("task_type"));
        m.put("scheduledDate", rs.getDate("scheduled_date"));
        m.put("estimatedMinutes", rs.getInt("estimated_minutes"));
        m.put("status", rs.getString("status"));
        m.put("completedAt", rs.getTimestamp("completed_at"));
        try {
            m.put("moduleName", rs.getString("module_name"));
        } catch (SQLException ignored) {}
        try {
            m.put("trackName", rs.getString("track_name"));
        } catch (SQLException ignored) {}
        return m;
    }
}
