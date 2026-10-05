package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.RoleRecommendation;
import com.interviewx.model.StudentResume;
import com.interviewx.util.DBConnection;

public class ResumeDAO {

    public int saveResume(StudentResume r) {
        String sql = "INSERT INTO student_resumes (user_id, file_name, file_type, raw_text, " +
                     "extracted_skills, extracted_technologies, extracted_projects, extracted_experience, " +
                     "extracted_education, analysis_summary) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, r.getUserId());
            ps.setString(2, r.getFileName());
            ps.setString(3, r.getFileType());
            ps.setString(4, r.getRawText());
            ps.setString(5, r.getExtractedSkills());
            ps.setString(6, r.getExtractedTechnologies());
            ps.setString(7, r.getExtractedProjects());
            ps.setString(8, r.getExtractedExperience());
            ps.setString(9, r.getExtractedEducation());
            ps.setString(10, r.getAnalysisSummary());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public StudentResume getLatestResume(int userId) {
        String sql = "SELECT * FROM student_resumes WHERE user_id = ? ORDER BY uploaded_at DESC LIMIT 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StudentResume r = new StudentResume();
                    r.setResumeId(rs.getInt("resume_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setFileName(rs.getString("file_name"));
                    r.setFileType(rs.getString("file_type"));
                    r.setRawText(rs.getString("raw_text"));
                    r.setExtractedSkills(rs.getString("extracted_skills"));
                    r.setExtractedTechnologies(rs.getString("extracted_technologies"));
                    r.setExtractedProjects(rs.getString("extracted_projects"));
                    r.setExtractedExperience(rs.getString("extracted_experience"));
                    r.setExtractedEducation(rs.getString("extracted_education"));
                    r.setAnalysisSummary(rs.getString("analysis_summary"));
                    r.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void saveRecommendations(int resumeId, int userId, List<RoleRecommendation> list) {
        // Clear previous recommendations for this user to avoid stale recommendations
        try (Connection c = DBConnection.getConnection()) {
            try (PreparedStatement psDel = c.prepareStatement("DELETE FROM resume_role_recommendations WHERE user_id=?")) {
                psDel.setInt(1, userId);
                psDel.executeUpdate();
            }

            String sql = "INSERT INTO resume_role_recommendations (resume_id, user_id, track_id, role_name, " +
                         "alignment_level, match_score, reasons, skill_matches, skill_gaps) VALUES (?,?,?,?,?,?,?,?,?)";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                for (RoleRecommendation rec : list) {
                    ps.setInt(1, resumeId);
                    ps.setInt(2, userId);
                    ps.setInt(3, rec.getTrackId());
                    ps.setString(4, rec.getRoleName());
                    ps.setString(5, rec.getAlignmentLevel());
                    ps.setInt(6, rec.getMatchScore());
                    ps.setString(7, rec.getReasons());
                    ps.setString(8, rec.getSkillMatches());
                    ps.setString(9, rec.getSkillGaps());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<RoleRecommendation> getRecommendations(int userId) {
        List<RoleRecommendation> list = new ArrayList<>();
        String sql = "SELECT rr.*, ct.icon as track_icon FROM resume_role_recommendations rr " +
                     "LEFT JOIN career_tracks ct ON rr.track_id = ct.track_id " +
                     "WHERE rr.user_id = ? ORDER BY rr.match_score DESC";
        ProfileDAO profileDao = new ProfileDAO();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoleRecommendation r = new RoleRecommendation();
                    r.setRecId(rs.getInt("rec_id"));
                    r.setResumeId(rs.getInt("resume_id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setTrackId(rs.getInt("track_id"));
                    r.setRoleName(rs.getString("role_name"));
                    r.setAlignmentLevel(rs.getString("alignment_level"));
                    r.setMatchScore(rs.getInt("match_score"));
                    r.setReasons(rs.getString("reasons"));
                    r.setSkillMatches(rs.getString("skill_matches"));
                    r.setSkillGaps(rs.getString("skill_gaps"));
                    r.setCreatedAt(rs.getTimestamp("created_at"));
                    r.setTrackIcon(rs.getString("track_icon"));

                    // Check if student already has a profile for this role
                    var existing = profileDao.getProfileByUserAndRole(userId, r.getRoleName());
                    if (existing != null) {
                        r.setProfileExists(true);
                        r.setExistingProfileId(existing.getProfileId());
                    } else {
                        r.setProfileExists(false);
                    }
                    list.add(r);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void saveAiAnalysis(int userId, int resumeId, String jsonResponse, String topRole, String summary) {
        String sql = "INSERT INTO resume_ai_analysis (user_id, resume_id, ai_response_json, top_role, overall_summary) VALUES (?,?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, resumeId);
            ps.setString(3, jsonResponse);
            ps.setString(4, topRole != null && topRole.length() > 100 ? topRole.substring(0, 100) : topRole);
            ps.setString(5, summary);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
