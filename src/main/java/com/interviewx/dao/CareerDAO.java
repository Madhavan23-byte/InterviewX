package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.CareerTrack;
import com.interviewx.util.DBConnection;

public class CareerDAO {

    public List<CareerTrack> getAllTracks() {
        List<CareerTrack> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             Statement st = c.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM career_tracks ORDER BY track_id")) {
            while (rs.next()) {
                list.add(new CareerTrack(rs.getInt("track_id"), rs.getString("track_name"),
                    rs.getString("description"), rs.getString("icon")));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public CareerTrack getTrackById(int id) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT * FROM career_tracks WHERE track_id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return new CareerTrack(rs.getInt("track_id"), rs.getString("track_name"),
                    rs.getString("description"), rs.getString("icon"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean saveAssessment(int userId, Map<String,Integer> scores, int recommendedTrackId) {
        String sql = "INSERT INTO student_assessments (user_id, interest_frontend, interest_backend, " +
            "interest_fullstack, interest_data, interest_ai, interest_cloud, interest_devops, " +
            "interest_mobile, interest_security, interest_blockchain, interest_qa, " +
            "problem_solving_score, recommended_track_id) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?) " +
            "ON DUPLICATE KEY UPDATE interest_frontend=VALUES(interest_frontend), " +
            "interest_backend=VALUES(interest_backend), recommended_track_id=VALUES(recommended_track_id)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, scores.getOrDefault("frontend", 0));
            ps.setInt(3, scores.getOrDefault("backend", 0));
            ps.setInt(4, scores.getOrDefault("fullstack", 0));
            ps.setInt(5, scores.getOrDefault("data", 0));
            ps.setInt(6, scores.getOrDefault("ai", 0));
            ps.setInt(7, scores.getOrDefault("cloud", 0));
            ps.setInt(8, scores.getOrDefault("devops", 0));
            ps.setInt(9, scores.getOrDefault("mobile", 0));
            ps.setInt(10, scores.getOrDefault("security", 0));
            ps.setInt(11, scores.getOrDefault("blockchain", 0));
            ps.setInt(12, scores.getOrDefault("qa", 0));
            ps.setInt(13, scores.getOrDefault("problemSolving", 0));
            ps.setInt(14, recommendedTrackId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean setChosenTrack(int userId, int chosenTrackId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE student_assessments SET chosen_track_id=? WHERE user_id=? ORDER BY assessment_id DESC LIMIT 1")) {
            ps.setInt(1, chosenTrackId); ps.setInt(2, userId);
            int r = ps.executeUpdate();
            if (r == 0) {
                try (PreparedStatement ps2 = c.prepareStatement(
                    "INSERT INTO student_assessments (user_id, chosen_track_id) VALUES (?,?)")) {
                    ps2.setInt(1, userId); ps2.setInt(2, chosenTrackId);
                    ps2.executeUpdate();
                }
            }
            CareerTrack t = getTrackById(chosenTrackId);
            if (t != null) {
                try (PreparedStatement ps3 = c.prepareStatement(
                    "UPDATE students SET target_role=? WHERE user_id=?")) {
                    ps3.setString(1, t.getTrackName()); ps3.setInt(2, userId);
                    ps3.executeUpdate();
                }
            }
            return true;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public int getChosenTrackId(int userId) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT chosen_track_id FROM student_assessments WHERE user_id=? ORDER BY assessment_id DESC LIMIT 1")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("chosen_track_id");
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Map<String,Object>> getRoadmapModules(int trackId) {
        List<Map<String,Object>> list = new ArrayList<>();
        String sql = "SELECT rm.* FROM roadmap_modules rm JOIN roadmaps r ON rm.roadmap_id=r.roadmap_id " +
                     "WHERE r.track_id=? ORDER BY rm.order_index";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, trackId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String,Object> m = new LinkedHashMap<>();
                    m.put("moduleId", rs.getInt("module_id"));
                    m.put("moduleName", rs.getString("module_name"));
                    m.put("description", rs.getString("description"));
                    m.put("orderIndex", rs.getInt("order_index"));
                    m.put("estimatedDays", rs.getInt("estimated_days"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean markModuleComplete(int userId, int moduleId) {
        return markModuleComplete(userId, 0, moduleId);
    }

    public boolean markModuleComplete(int userId, int profileId, int moduleId) {
        String sql;
        if (profileId > 0) {
            sql = "INSERT INTO student_module_progress (user_id, profile_id, module_id, status, completed_at) " +
                  "VALUES (?,?,?,'completed',NOW()) ON DUPLICATE KEY UPDATE status='completed', completed_at=NOW()";
        } else {
            sql = "INSERT INTO student_module_progress (user_id, module_id, status, completed_at) " +
                  "VALUES (?,?,'completed',NOW()) ON DUPLICATE KEY UPDATE status='completed', completed_at=NOW()";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) {
                ps.setInt(2, profileId);
                ps.setInt(3, moduleId);
            } else {
                ps.setInt(2, moduleId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public Set<Integer> getCompletedModules(int userId) {
        return getCompletedModules(userId, 0);
    }

    public Set<Integer> getCompletedModules(int userId, int profileId) {
        Set<Integer> set = new HashSet<>();
        String sql;
        if (profileId > 0) {
            sql = "SELECT module_id FROM student_module_progress WHERE user_id=? AND profile_id=? AND status='completed'";
        } else {
            sql = "SELECT module_id FROM student_module_progress WHERE user_id=? AND status='completed'";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) set.add(rs.getInt("module_id"));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return set;
    }
}