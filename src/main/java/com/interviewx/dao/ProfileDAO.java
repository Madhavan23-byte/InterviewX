package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.PreparationProfile;
import com.interviewx.util.DBConnection;

public class ProfileDAO {

    public List<PreparationProfile> getProfilesByUserId(int userId) {
        List<PreparationProfile> list = new ArrayList<>();
        String sql = "SELECT p.*, ct.icon as track_icon FROM preparation_profiles p " +
                     "LEFT JOIN career_tracks ct ON p.track_id = ct.track_id " +
                     "WHERE p.user_id = ? ORDER BY p.last_active_at DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    PreparationProfile p = mapRow(rs);
                    p.setTrackIcon(rs.getString("track_icon"));
                    populateProfileStats(c, p);
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public PreparationProfile getProfileById(int profileId) {
        String sql = "SELECT p.*, ct.icon as track_icon FROM preparation_profiles p " +
                     "LEFT JOIN career_tracks ct ON p.track_id = ct.track_id " +
                     "WHERE p.profile_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PreparationProfile p = mapRow(rs);
                    p.setTrackIcon(rs.getString("track_icon"));
                    populateProfileStats(c, p);
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public PreparationProfile getProfileByUserAndRole(int userId, String targetRole) {
        String sql = "SELECT p.*, ct.icon as track_icon FROM preparation_profiles p " +
                     "LEFT JOIN career_tracks ct ON p.track_id = ct.track_id " +
                     "WHERE p.user_id = ? AND LOWER(p.target_role) = LOWER(?) LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, targetRole.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PreparationProfile p = mapRow(rs);
                    p.setTrackIcon(rs.getString("track_icon"));
                    populateProfileStats(c, p);
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public PreparationProfile getProfileByUserAndTrack(int userId, int trackId) {
        String sql = "SELECT p.*, ct.icon as track_icon FROM preparation_profiles p " +
                     "LEFT JOIN career_tracks ct ON p.track_id = ct.track_id " +
                     "WHERE p.user_id = ? AND p.track_id = ? LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, trackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    PreparationProfile p = mapRow(rs);
                    p.setTrackIcon(rs.getString("track_icon"));
                    populateProfileStats(c, p);
                    return p;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int createProfile(int userId, int studentId, int trackId, String targetRole, String profileName) {
        // Check if duplicate already exists
        PreparationProfile existing = getProfileByUserAndRole(userId, targetRole);
        if (existing != null) {
            updateLastActive(existing.getProfileId());
            return existing.getProfileId();
        }

        String sql = "INSERT INTO preparation_profiles (user_id, student_id, track_id, target_role, profile_name, status, readiness_score) " +
                     "VALUES (?,?,?,?,?,'active', 20.00)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, studentId > 0 ? studentId : userId);
            ps.setInt(3, trackId);
            ps.setString(4, targetRole);
            ps.setString(5, profileName != null && !profileName.isEmpty() ? profileName : (targetRole + " Prep"));
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int newId = rs.getInt(1);
                    // Initialize first day study tasks for this profile
                    TaskDAO taskDao = new TaskDAO();
                    taskDao.generateDailyTasks(userId, newId, trackId, targetRole);
                    return newId;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateLastActive(int profileId) {
        String sql = "UPDATE preparation_profiles SET last_active_at = NOW() WHERE profile_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, profileId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateReadinessScore(int profileId, double score) {
        String sql = "UPDATE preparation_profiles SET readiness_score = ? WHERE profile_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setDouble(1, score);
            ps.setInt(2, profileId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public PreparationProfile getActiveProfile(int userId) {
        List<PreparationProfile> list = getProfilesByUserId(userId);
        if (!list.isEmpty()) {
            return list.get(0); // Top profile ordered by last_active_at DESC
        }
        // If no profile exists yet, create default based on students.target_role or Backend Developer
        String targetRole = "Backend Developer";
        int trackId = 2;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement("SELECT target_role FROM students WHERE user_id=?")) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getString("target_role") != null && !rs.getString("target_role").isEmpty()) {
                    targetRole = rs.getString("target_role");
                }
            }
        } catch (SQLException e) {}

        int newId = createProfile(userId, userId, trackId, targetRole, targetRole + " Profile");
        if (newId > 0) return getProfileById(newId);
        return null;
    }

    private void populateProfileStats(Connection c, PreparationProfile p) {
        try {
            // 1. Modules progress
            String modSql = "SELECT COUNT(rm.module_id) as total, " +
                "COUNT(smp.progress_id) as completed " +
                "FROM roadmap_modules rm " +
                "JOIN roadmaps r ON rm.roadmap_id = r.roadmap_id " +
                "LEFT JOIN student_module_progress smp ON smp.module_id = rm.module_id AND smp.profile_id = ? AND smp.status = 'completed' " +
                "WHERE r.track_id = ?";
            try (PreparedStatement ps = c.prepareStatement(modSql)) {
                ps.setInt(1, p.getProfileId());
                ps.setInt(2, p.getTrackId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p.setTotalModules(rs.getInt("total"));
                        p.setModulesCompleted(rs.getInt("completed"));
                    }
                }
            }

            // 2. Study tasks
            String taskSql = "SELECT COUNT(*) as total, " +
                "SUM(CASE WHEN status='completed' THEN 1 ELSE 0 END) as done " +
                "FROM study_tasks WHERE profile_id = ?";
            try (PreparedStatement ps = c.prepareStatement(taskSql)) {
                ps.setInt(1, p.getProfileId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p.setTotalTasks(rs.getInt("total"));
                        p.setTasksCompleted(rs.getInt("done"));
                    }
                }
            }

            // 3. Coding solved
            String codeSql = "SELECT COUNT(DISTINCT problem_id) FROM coding_submissions WHERE profile_id = ? AND verdict = 'Accepted'";
            try (PreparedStatement ps = c.prepareStatement(codeSql)) {
                ps.setInt(1, p.getProfileId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p.setProblemsSolved(rs.getInt(1));
                    }
                }
            }

            // 4. Interviews
            String intSql = "SELECT COUNT(*), COALESCE(AVG(overall_score), 0) FROM mock_interviews WHERE profile_id = ?";
            try (PreparedStatement ps = c.prepareStatement(intSql)) {
                ps.setInt(1, p.getProfileId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        p.setInterviewAttempts(rs.getInt(1));
                        p.setAvgInterviewScore(rs.getDouble(2));
                    }
                }
            }

            // Compute dynamic readiness score based on multi-factor progress:
            // 25% from roadmap modules + 25% from tasks + 25% from coding + 25% from interviews
            double modPct = p.getTotalModules() > 0 ? (p.getModulesCompleted() * 100.0 / p.getTotalModules()) : 0;
            double taskPct = p.getTotalTasks() > 0 ? (p.getTasksCompleted() * 100.0 / p.getTotalTasks()) : 0;
            double codePct = Math.min(100.0, p.getProblemsSolved() * 20.0);
            double intPct = p.getInterviewAttempts() > 0 ? p.getAvgInterviewScore() : 0.0;

            double computedReadiness = (modPct * 0.30) + (taskPct * 0.30) + (codePct * 0.20) + (intPct * 0.20);
            if (computedReadiness > 0) {
                p.setReadinessScore(Math.min(100.0, computedReadiness));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private PreparationProfile mapRow(ResultSet rs) throws SQLException {
        PreparationProfile p = new PreparationProfile();
        p.setProfileId(rs.getInt("profile_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setStudentId(rs.getInt("student_id"));
        p.setTrackId(rs.getInt("track_id"));
        p.setTargetRole(rs.getString("target_role"));
        p.setProfileName(rs.getString("profile_name"));
        p.setStatus(rs.getString("status"));
        p.setReadinessScore(rs.getDouble("readiness_score"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setLastActiveAt(rs.getTimestamp("last_active_at"));
        return p;
    }
}