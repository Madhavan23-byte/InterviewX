package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.util.DBConnection;

public class ReadinessDAO {

    public Map<String,Object> getReadiness(int userId) {
        return getReadiness(userId, 0);
    }

    public Map<String,Object> getReadiness(int userId, int profileId) {
        Map<String,Object> r = new LinkedHashMap<>();
        String sql;
        if (profileId > 0) {
            sql = "SELECT * FROM placement_readiness WHERE user_id=? AND profile_id=?";
        } else {
            sql = "SELECT * FROM placement_readiness WHERE user_id=? ORDER BY readiness_id DESC LIMIT 1";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    r.put("overall", rs.getDouble("overall_score"));
                    r.put("technical", rs.getDouble("technical_score"));
                    r.put("coding", rs.getDouble("coding_score"));
                    r.put("communication", rs.getDouble("communication_score"));
                    r.put("interview", rs.getDouble("interview_score"));
                    r.put("roleSkills", rs.getDouble("role_skills_score"));
                    r.put("consistency", rs.getDouble("consistency_score"));
                    return r;
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }

        // Default initial score
        r.put("overall", 25.0);
        r.put("technical", 30.0);
        r.put("coding", 20.0);
        r.put("communication", 30.0);
        r.put("interview", 0.0);
        r.put("roleSkills", 25.0);
        r.put("consistency", 20.0);
        return r;
    }

    public void computeAndSave(int userId) {
        computeAndSave(userId, 0, 0);
    }

    public void computeAndSave(int userId, int profileId, int trackId) {
        double codingScore = getCodingScore(userId, profileId);
        double interviewScore = getInterviewScore(userId, profileId);
        double taskScore = getTaskScore(userId, profileId);

        double overall = Math.max(15.0, (codingScore * 0.35 + interviewScore * 0.35 + taskScore * 0.30));
        double technical = Math.max(20.0, (codingScore + interviewScore * 0.7) / 1.7);
        double communication = Math.max(20.0, interviewScore > 0 ? interviewScore * 0.9 : 35.0);
        double consistency = Math.max(10.0, taskScore);
        double roleSkills = Math.max(20.0, (codingScore + technical) / 2.0);

        String sql = "INSERT INTO placement_readiness (user_id, profile_id, overall_score, technical_score, coding_score, " +
            "communication_score, interview_score, role_skills_score, consistency_score) " +
            "VALUES (?,?,?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE overall_score=VALUES(overall_score), " +
            "technical_score=VALUES(technical_score), coding_score=VALUES(coding_score), " +
            "communication_score=VALUES(communication_score), interview_score=VALUES(interview_score), " +
            "role_skills_score=VALUES(role_skills_score), consistency_score=VALUES(consistency_score)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId); else ps.setNull(2, Types.INTEGER);
            ps.setDouble(3, Math.min(100, overall));
            ps.setDouble(4, Math.min(100, technical));
            ps.setDouble(5, Math.min(100, codingScore));
            ps.setDouble(6, Math.min(100, communication));
            ps.setDouble(7, Math.min(100, interviewScore));
            ps.setDouble(8, Math.min(100, roleSkills));
            ps.setDouble(9, Math.min(100, consistency));
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }

        // Also update preparation_profiles.readiness_score
        if (profileId > 0) {
            ProfileDAO pDao = new ProfileDAO();
            pDao.updateReadinessScore(profileId, overall);
        }
    }

    private double getCodingScore(int userId, int profileId) {
        String sql;
        if (profileId > 0) {
            sql = "SELECT COUNT(DISTINCT problem_id) FROM coding_submissions WHERE user_id=? AND profile_id=? AND verdict='Accepted'";
        } else {
            sql = "SELECT COUNT(DISTINCT problem_id) FROM coding_submissions WHERE user_id=? AND verdict='Accepted'";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return Math.min(100, rs.getInt(1) * 20.0);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private double getInterviewScore(int userId, int profileId) {
        String sql;
        if (profileId > 0) {
            sql = "SELECT AVG(overall_score) FROM mock_interviews WHERE user_id=? AND profile_id=? AND status='completed'";
        } else {
            sql = "SELECT AVG(overall_score) FROM mock_interviews WHERE user_id=? AND status='completed'";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getObject(1) != null) return rs.getDouble(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private double getTaskScore(int userId, int profileId) {
        String sql;
        if (profileId > 0) {
            sql = "SELECT COUNT(*), SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) FROM study_tasks WHERE user_id=? AND profile_id=?";
        } else {
            sql = "SELECT COUNT(*), SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) FROM study_tasks WHERE user_id=?";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int total = rs.getInt(1);
                    int done = rs.getInt(2);
                    if (total > 0) return Math.min(100, (done * 100.0) / total);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}