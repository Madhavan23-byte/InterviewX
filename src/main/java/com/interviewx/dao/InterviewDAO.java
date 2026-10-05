package com.interviewx.dao;

import java.sql.*;
import java.util.*;
import com.interviewx.model.InterviewQuestion;
import com.interviewx.util.DBConnection;

public class InterviewDAO {

    public List<InterviewQuestion> getQuestionsByType(String type) {
        List<InterviewQuestion> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "SELECT * FROM interview_questions WHERE interview_type=? ORDER BY RAND() LIMIT 5")) {
            ps.setString(1, type);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapQuestion(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Fetch questions filtered by type AND target role (or fall back to generic).
     */
    public List<InterviewQuestion> getQuestionsByTypeAndRole(String type, String targetRole) {
        List<InterviewQuestion> list = new ArrayList<>();
        if (targetRole == null || targetRole.isBlank()) {
            return getQuestionsByType(type);
        }
        try (Connection c = DBConnection.getConnection()) {
            // Try role-specific first
            String sql = "SELECT * FROM interview_questions WHERE interview_type=? " +
                         "AND (target_roles IS NULL OR target_roles LIKE ? OR target_roles LIKE ? OR target_roles LIKE ?) " +
                         "ORDER BY RAND() LIMIT 7";
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setString(1, type);
                ps.setString(2, targetRole + "%");
                ps.setString(3, "%" + targetRole + ",%");
                ps.setString(4, "%" + targetRole);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(mapQuestion(rs));
                }
            }
            // If fewer than 3, supplement with generic questions
            if (list.size() < 3) {
                Set<Integer> ids = new HashSet<>();
                for (InterviewQuestion q : list) ids.add(q.getQuestionId());
                try (PreparedStatement ps2 = c.prepareStatement(
                        "SELECT * FROM interview_questions WHERE interview_type=? AND target_roles IS NULL ORDER BY RAND() LIMIT 5")) {
                    ps2.setString(1, type);
                    try (ResultSet rs = ps2.executeQuery()) {
                        while (rs.next()) {
                            InterviewQuestion q = mapQuestion(rs);
                            if (!ids.contains(q.getQuestionId())) {
                                list.add(q);
                                ids.add(q.getQuestionId());
                            }
                        }
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list.isEmpty() ? getQuestionsByType(type) : list;
    }

    public int startInterview(int userId, String type) {
        return startInterview(userId, 0, type, null);
    }

    public int startInterview(int userId, int profileId, String type) {
        return startInterview(userId, profileId, type, null);
    }

    public int startInterview(int userId, int profileId, String type, String targetRole) {
        String sql = "INSERT INTO mock_interviews (user_id, profile_id, interview_type, target_role) VALUES (?,?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, profileId);
            ps.setString(3, type);
            ps.setString(4, targetRole);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return -1;
    }

    public boolean saveAnswer(int interviewId, int questionId, String answerText, String aiFeedback, double score) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "INSERT INTO interview_answers (interview_id, question_id, answer_text, ai_feedback, score) VALUES (?,?,?,?,?)")) {
            ps.setInt(1, interviewId); ps.setInt(2, questionId);
            ps.setString(3, answerText); ps.setString(4, aiFeedback); ps.setDouble(5, score);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean completeInterview(int interviewId, double overallScore) {
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(
                "UPDATE mock_interviews SET status='completed', completed_at=NOW(), overall_score=? WHERE interview_id=?")) {
            ps.setDouble(1, overallScore); ps.setInt(2, interviewId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Map<String, Object>> getInterviewHistory(int userId) {
        return getInterviewHistory(userId, 0);
    }

    public List<Map<String, Object>> getInterviewHistory(int userId, int profileId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql;
        if (profileId > 0) {
            sql = "SELECT mi.interview_id, mi.interview_type, mi.overall_score, mi.status, mi.started_at, mi.completed_at, mi.target_role " +
                  "FROM mock_interviews mi WHERE mi.user_id=? AND mi.profile_id=? ORDER BY mi.started_at DESC LIMIT 20";
        } else {
            sql = "SELECT mi.interview_id, mi.interview_type, mi.overall_score, mi.status, mi.started_at, mi.completed_at, mi.target_role " +
                  "FROM mock_interviews mi WHERE mi.user_id=? ORDER BY mi.started_at DESC LIMIT 20";
        }
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            if (profileId > 0) ps.setInt(2, profileId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("interviewId", rs.getInt("interview_id"));
                    m.put("interviewType", rs.getString("interview_type"));
                    m.put("overallScore", rs.getDouble("overall_score"));
                    m.put("status", rs.getString("status"));
                    m.put("startedAt", rs.getTimestamp("started_at"));
                    m.put("completedAt", rs.getTimestamp("completed_at"));
                    m.put("targetRole", rs.getString("target_role"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    /**
     * Get detailed answers with AI feedback for the interview report page.
     */
    public List<Map<String, Object>> getAnswersWithFeedback(int interviewId, int userId) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT ia.answer_id, ia.question_id, ia.answer_text, ia.ai_feedback, " +
                     "ia.score, ia.ai_feedback_json, iq.question_text, iq.topic, iq.difficulty " +
                     "FROM interview_answers ia " +
                     "JOIN interview_questions iq ON ia.question_id = iq.question_id " +
                     "JOIN mock_interviews mi ON ia.interview_id = mi.interview_id " +
                     "WHERE ia.interview_id=? AND mi.user_id=? ORDER BY ia.answer_id";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, interviewId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new LinkedHashMap<>();
                    m.put("answerId", rs.getInt("answer_id"));
                    m.put("questionId", rs.getInt("question_id"));
                    m.put("questionText", rs.getString("question_text"));
                    m.put("topic", rs.getString("topic"));
                    m.put("difficulty", rs.getString("difficulty"));
                    m.put("answerText", rs.getString("answer_text"));
                    m.put("aiFeedback", rs.getString("ai_feedback"));
                    m.put("aiFeedbackJson", rs.getString("ai_feedback_json"));
                    m.put("score", rs.getDouble("score"));
                    list.add(m);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private InterviewQuestion mapQuestion(ResultSet rs) throws SQLException {
        InterviewQuestion q = new InterviewQuestion();
        q.setQuestionId(rs.getInt("question_id"));
        q.setInterviewType(rs.getString("interview_type"));
        q.setQuestionText(rs.getString("question_text"));
        q.setTopic(rs.getString("topic"));
        q.setDifficulty(rs.getString("difficulty"));
        return q;
    }
}
